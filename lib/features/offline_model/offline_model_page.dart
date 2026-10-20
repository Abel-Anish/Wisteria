import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../core/services/ollama_service.dart';
import '../../core/theme/wisteria_theme.dart';
import 'wischat_storage.dart';

/// Single conversation message model.
class _ChatMessage {
  final String role;
  String content;

  _ChatMessage({required this.role, required this.content});

  Map<String, String> toMap() => {'role': role, 'content': content};
}

/// Enum for switching sidebar sections between Saved Memories and Conversation History.
enum _SidebarTab { memories, history }

/// A ChatGPT-inspired chatbot interface for conversing with a locally
/// running Gemma 3 4B model via Ollama with multi-turn support,
/// real HTTP response streaming, Markdown rendering, persistent multi-conversation
/// history with New Chat, unsent drafts, and a persistent collapsible Memory sidebar.
class WisChatPage extends StatefulWidget {
  const WisChatPage({super.key});

  @override
  State<WisChatPage> createState() => _WisChatPageState();
}

class _WisChatPageState extends State<WisChatPage>
    with AutomaticKeepAliveClientMixin {
  final OllamaService _ollama = OllamaService();
  final WisChatStorage _storage = WisChatStorage();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();

  StreamSubscription<String>? _streamSubscription;

  /// Active conversation history (single source of truth).
  final List<_ChatMessage> _messages = [];

  /// Persistent saved memories.
  List<WisChatMemory> _memories = [];

  /// Persistent conversations list.
  List<WisChatConversation> _conversations = [];
  WisChatConversation? _activeConversation;

  bool _isGenerating = false;
  String? _errorMessage;
  bool _isMemorySidebarOpen = true;
  _SidebarTab _activeSidebarTab = _SidebarTab.memories;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onDraftChanged);
    _loadPersistedData();

    // Intercept Enter (without Shift) to send message, Shift+Enter for newline
    _inputFocusNode.onKeyEvent = (node, event) {
      if (event is KeyDownEvent &&
          event.logicalKey == LogicalKeyboardKey.enter &&
          !HardwareKeyboard.instance.isShiftPressed) {
        _sendMessage();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    };
  }

  @override
  void dispose() {
    _controller.removeListener(_onDraftChanged);
    _streamSubscription?.cancel();
    _streamSubscription = null;
    _controller.dispose();
    _scrollController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  void _onDraftChanged() {
    _storage.saveDraft(_controller.text);
  }

  Future<void> _loadPersistedData() async {
    final memories = await _storage.loadMemories();
    final conversations = await _storage.loadConversations();
    final activeId = await _storage.loadActiveConversationId();
    final savedDraft = await _storage.loadDraft();
    final sidebarOpen = await _storage.loadSidebarOpen();

    if (!mounted) return;
    setState(() {
      _memories = memories;
      _conversations = conversations;
      _isMemorySidebarOpen = sidebarOpen;

      if (_conversations.isEmpty) {
        final initialConv = WisChatConversation(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: 'New Chat',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          messages: [],
        );
        _conversations.add(initialConv);
        _activeConversation = initialConv;
      } else {
        _activeConversation = _conversations.firstWhere(
          (c) => c.id == activeId,
          orElse: () => _conversations.first,
        );
      }

      _messages.clear();
      if (_activeConversation != null) {
        _messages.addAll(
          _activeConversation!.messages.map(
            (m) => _ChatMessage(role: m['role']!, content: m['content']!),
          ),
        );
      }

      if (savedDraft.isNotEmpty && _controller.text.isEmpty) {
        _controller.text = savedDraft;
      }
    });

    if (_messages.isNotEmpty) {
      _scrollToBottom();
    }
  }

  // ── Conversation Management ──────────────────────────────────────

  void _newChat() {
    // If current conversation is already empty, reuse it
    if (_messages.isEmpty && _activeConversation != null) {
      _inputFocusNode.requestFocus();
      return;
    }

    _streamSubscription?.cancel();
    _streamSubscription = null;

    final newConv = WisChatConversation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'New Chat',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      messages: [],
    );

    setState(() {
      _conversations.insert(0, newConv);
      _activeConversation = newConv;
      _messages.clear();
      _controller.clear();
      _isGenerating = false;
      _errorMessage = null;
    });

    _storage.saveActiveConversationId(newConv.id);
    _storage.saveConversations(_conversations);
    _storage.saveDraft('');
    _inputFocusNode.requestFocus();
  }

  void _switchConversation(WisChatConversation conversation) {
    if (_activeConversation?.id == conversation.id) return;

    _streamSubscription?.cancel();
    _streamSubscription = null;

    setState(() {
      _activeConversation = conversation;
      _messages.clear();
      _messages.addAll(
        conversation.messages.map(
          (m) => _ChatMessage(role: m['role']!, content: m['content']!),
        ),
      );
      _isGenerating = false;
      _errorMessage = null;
    });

    _storage.saveActiveConversationId(conversation.id);
    _scrollToBottom();
    _inputFocusNode.requestFocus();
  }

  Future<void> _deleteConversation(WisChatConversation conversation) async {
    final colors = WisteriaColors.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.surfaceContainer,
        title: Text(
          'Delete Conversation?',
          style: TextStyle(
            color: colors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${conversation.title}"? This conversation history cannot be recovered.',
          style: TextStyle(color: colors.textSecondary, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colors.error,
              foregroundColor: colors.textOnPrimary,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _conversations.remove(conversation);
        if (_conversations.isEmpty) {
          final newConv = WisChatConversation(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: 'New Chat',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            messages: [],
          );
          _conversations.add(newConv);
          _activeConversation = newConv;
          _messages.clear();
        } else if (_activeConversation?.id == conversation.id) {
          _activeConversation = _conversations.first;
          _messages.clear();
          _messages.addAll(
            _activeConversation!.messages.map(
              (m) => _ChatMessage(role: m['role']!, content: m['content']!),
            ),
          );
        }
      });
      await _storage.saveActiveConversationId(_activeConversation!.id);
      await _storage.saveConversations(_conversations);
    }
  }

  // ── Actions ──────────────────────────────────────────────────────

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isGenerating) return;

    // Cancel any dangling subscription
    await _streamSubscription?.cancel();
    _streamSubscription = null;

    // 1. Add user message once
    final userMessage = _ChatMessage(role: 'user', content: text);
    _messages.add(userMessage);

    // Update active conversation title if it was default
    if (_activeConversation != null) {
      if (_activeConversation!.title == 'New Chat' ||
          _activeConversation!.messages.isEmpty) {
        _activeConversation!.title =
            text.length > 28 ? '${text.substring(0, 28)}…' : text;
      }
      _activeConversation!.updatedAt = DateTime.now();
      _activeConversation!.messages =
          _messages.map((m) => m.toMap()).toList();
      _storage.saveConversations(_conversations);
    }

    // 2. Build request payload from saved memories + conversation history
    final payload = <Map<String, String>>[];
    if (_memories.isNotEmpty) {
      final memoryContext = _memories.map((m) => '- ${m.text}').join('\n');
      payload.add({
        'role': 'system',
        'content':
            'You are WisChat, an offline clinical AI assistant. Here is your memory of saved user facts, patient guidelines, and preferences:\n$memoryContext\nUse these memories when relevant to assist the user.',
      });
    }
    payload.addAll(_messages.map((m) => m.toMap()));

    // 3. Add placeholder assistant message to stream chunks into
    final assistantMessage = _ChatMessage(role: 'assistant', content: '');
    _messages.add(assistantMessage);

    _controller.clear();
    _storage.saveDraft(''); // Clear unsent draft upon send

    setState(() {
      _isGenerating = true;
      _errorMessage = null;
    });
    _saveCurrentConversation();
    _scrollToBottom(animated: true);

    final completer = Completer<void>();

    try {
      final stream = _ollama.chatStream(payload);
      _streamSubscription = stream.listen(
        (chunk) {
          if (!mounted) return;
          setState(() {
            assistantMessage.content += chunk;
          });
          _scrollToBottom(animated: false);
        },
        onError: (error) {
          if (!mounted) return;
          setState(() {
            // Remove empty placeholder on early failure
            if (assistantMessage.content.isEmpty) {
              _messages.remove(assistantMessage);
            }
            _errorMessage = _friendlyError(error);
          });
          _saveCurrentConversation();
          if (!completer.isCompleted) completer.complete();
        },
        onDone: () {
          _saveCurrentConversation();
          if (!completer.isCompleted) completer.complete();
        },
        cancelOnError: true,
      );

      await completer.future;
    } catch (e) {
      if (!mounted) return;
      setState(() {
        if (assistantMessage.content.isEmpty) {
          _messages.remove(assistantMessage);
        }
        _errorMessage = _friendlyError(e);
      });
      _saveCurrentConversation();
    } finally {
      _streamSubscription = null;
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
        _saveCurrentConversation();
        _scrollToBottom(animated: true);
        _inputFocusNode.requestFocus();
      }
    }
  }

  void _saveCurrentConversation() {
    if (_activeConversation != null) {
      _activeConversation!.messages =
          _messages.map((m) => m.toMap()).toList();
      _activeConversation!.updatedAt = DateTime.now();
      _storage.saveConversations(_conversations);
    }
  }

  void _scrollToBottom({bool animated = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        if (animated) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
          );
        } else {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      }
    });
  }

  String _friendlyError(Object e) {
    if (e is OllamaException) {
      switch (e.type) {
        case OllamaErrorType.connectionFailed:
          return 'Could not connect to Ollama. Make sure Ollama is running on localhost:11434.';
        case OllamaErrorType.timeout:
          return 'The model took too long to respond. Try a shorter prompt or check system resources.';
        case OllamaErrorType.serverError:
          return 'Ollama server error: ${e.message}';
        case OllamaErrorType.malformedResponse:
          return 'Received an unexpected response from Ollama.';
        case OllamaErrorType.unknown:
          return 'Error: ${e.message}';
      }
    }
    return 'An unexpected error occurred. Please try again.';
  }

  // ── Memory Management ────────────────────────────────────────────

  void _toggleSidebar() {
    setState(() {
      _isMemorySidebarOpen = !_isMemorySidebarOpen;
    });
    _storage.saveSidebarOpen(_isMemorySidebarOpen);
  }

  Future<void> _addMemory() async {
    final text = await _showMemoryDialog(title: 'Add Memory');
    if (text != null && text.trim().isNotEmpty) {
      final newMemory = WisChatMemory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text.trim(),
        createdAt: DateTime.now(),
      );
      setState(() {
        _memories.insert(0, newMemory);
      });
      await _storage.saveMemories(_memories);
    }
  }

  Future<void> _editMemory(WisChatMemory memory) async {
    final text = await _showMemoryDialog(
      title: 'Edit Memory',
      initialText: memory.text,
    );
    if (text != null && text.trim().isNotEmpty) {
      setState(() {
        memory.text = text.trim();
      });
      await _storage.saveMemories(_memories);
    }
  }

  Future<void> _deleteMemory(WisChatMemory memory) async {
    final colors = WisteriaColors.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.surfaceContainer,
        title: Text(
          'Delete Memory?',
          style: TextStyle(
            color: colors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this memory? WisChat will no longer remember this context.',
          style: TextStyle(color: colors.textSecondary, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colors.error,
              foregroundColor: colors.textOnPrimary,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _memories.remove(memory);
      });
      await _storage.saveMemories(_memories);
    }
  }

  Future<String?> _showMemoryDialog({
    required String title,
    String? initialText,
  }) async {
    final colors = WisteriaColors.of(context);
    final textController = TextEditingController(text: initialText ?? '');

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.surfaceContainer,
        title: Text(
          title,
          style: TextStyle(
            color: colors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480, minWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'WisChat will use this context in local Gemma conversations.',
                style: TextStyle(
                  fontSize: 13,
                  color: colors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: textController,
                maxLines: 4,
                minLines: 2,
                autofocus: true,
                style: TextStyle(fontSize: 14, color: colors.textPrimary),
                decoration: InputDecoration(
                  hintText:
                      'Enter clinical fact, guideline, or user preference…',
                  hintStyle: TextStyle(color: colors.textMuted),
                  filled: true,
                  fillColor: colors.surfaceLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                    borderSide: BorderSide(color: colors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                    borderSide: BorderSide(color: colors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                    borderSide: BorderSide(color: colors.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.textOnPrimary,
            ),
            onPressed: () => Navigator.pop(context, textController.text),
            child: const Text('Save Memory'),
          ),
        ],
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final colors = WisteriaColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(68, 16, 68, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Memory & Chats sidebar ──
                    if (_isMemorySidebarOpen)
                      _buildSidebar(colors)
                    else
                      _buildCollapsedSidebarToggle(colors),

                    // ── Main Chat Area ──
                    Expanded(
                      child: _messages.isEmpty
                          ? _buildWelcomeScreen(colors)
                          : _buildConversation(colors),
                    ),
                  ],
                ),
              ),
            ),
            if (_errorMessage != null) _buildErrorBanner(colors),
            _buildComposer(colors),
          ],
        ),
      ),
    );
  }

  // ── Collapsed Sidebar Toggle ──

  Widget _buildCollapsedSidebarToggle(WisteriaColorPalette colors) {
    return Container(
      margin: const EdgeInsets.only(right: 16, top: 4),
      child: Tooltip(
        message: 'Expand sidebar (New Chat / Memory)',
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _toggleSidebar,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colors.surfaceContainer,
                borderRadius: BorderRadius.circular(WisteriaRadius.md),
                border: Border.all(color: colors.border),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                    color: Colors.black.withValues(alpha: 0.18),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.psychology_rounded,
                    size: 18,
                    color: colors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Memory',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                  if (_memories.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1.5,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(WisteriaRadius.full),
                      ),
                      child: Text(
                        '${_memories.length}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: colors.primary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Expanded Sidebar (New Chat + Memories / History) ──

  Widget _buildSidebar(WisteriaColorPalette colors) {
    return Container(
      width: 275,
      margin: const EdgeInsets.only(right: 18, bottom: 8),
      decoration: BoxDecoration(
        color: colors.surfaceLow.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(WisteriaRadius.lg),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar header with title and collapse button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                        border: Border.all(
                          color: colors.primary.withValues(alpha: 0.28),
                        ),
                      ),
                      child: Icon(
                        Icons.psychology_rounded,
                        size: 17,
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Memory',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const Spacer(),
                    Tooltip(
                      message: 'Collapse sidebar',
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: _toggleSidebar,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: colors.surfaceHigh,
                              borderRadius: BorderRadius.circular(
                                WisteriaRadius.sm,
                              ),
                              border: Border.all(color: colors.border),
                            ),
                            child: Icon(
                              Icons.chevron_left_rounded,
                              size: 17,
                              color: colors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // ── + New Chat Button ──
                _ActionButton(
                  icon: Icons.add_rounded,
                  label: 'New Chat',
                  accentColor: colors.primary,
                  isPrimary: true,
                  onTap: _newChat,
                ),

                const SizedBox(height: 12),

                // ── Segmented Tab Selector (Memories vs History) ──
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainer,
                    borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                    border: Border.all(color: colors.border),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _SidebarTabButton(
                          label: 'Memories',
                          badgeCount: _memories.length,
                          isActive: _activeSidebarTab == _SidebarTab.memories,
                          colors: colors,
                          onTap: () {
                            setState(() {
                              _activeSidebarTab = _SidebarTab.memories;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: _SidebarTabButton(
                          label: 'History',
                          badgeCount: _conversations.length,
                          isActive: _activeSidebarTab == _SidebarTab.history,
                          colors: colors,
                          onTap: () {
                            setState(() {
                              _activeSidebarTab = _SidebarTab.history;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // ── Tab Content: Memories or Conversation History ──
          Expanded(
            child: _activeSidebarTab == _SidebarTab.memories
                ? _buildMemoriesSection(colors)
                : _buildHistorySection(colors),
          ),
        ],
      ),
    );
  }

  // ── Memories Tab Content ──

  Widget _buildMemoriesSection(WisteriaColorPalette colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
          child: _ActionButton(
            icon: Icons.bookmark_add_outlined,
            label: 'Add Memory',
            accentColor: colors.primary,
            isPrimary: false,
            onTap: _addMemory,
          ),
        ),
        Expanded(
          child: _memories.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.memory_rounded,
                          size: 30,
                          color: colors.textMuted.withValues(alpha: 0.45),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'No memories saved yet',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: colors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Click "+ Add Memory" to store facts, patient preferences, or clinical notes.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: colors.textMuted,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: _memories.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final memory = _memories[index];
                    return _MemoryItemCard(
                      memory: memory,
                      colors: colors,
                      onEdit: () => _editMemory(memory),
                      onDelete: () => _deleteMemory(memory),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ── Conversation History Tab Content ──

  Widget _buildHistorySection(WisteriaColorPalette colors) {
    if (_conversations.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'No conversations yet',
            style: TextStyle(fontSize: 12.5, color: colors.textMuted),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(10),
      itemCount: _conversations.length,
      separatorBuilder: (context, index) => const SizedBox(height: 6),
      itemBuilder: (context, index) {
        final conv = _conversations[index];
        final isActive = _activeConversation?.id == conv.id;

        return _ConversationHistoryTile(
          conversation: conv,
          isActive: isActive,
          colors: colors,
          onTap: () => _switchConversation(conv),
          onDelete: () => _deleteConversation(conv),
        );
      },
    );
  }

  // ── Welcome screen ──

  Widget _buildWelcomeScreen(WisteriaColorPalette colors) {
    return Center(
      child: Text(
        'WisChat',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: colors.textPrimary,
          letterSpacing: -0.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // ── Conversation area ──

  Widget _buildConversation(WisteriaColorPalette colors) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];
        final isUser = msg.role == 'user';
        final isLast = index == _messages.length - 1;
        final isStreamingThis = !isUser && isLast && _isGenerating;
        return _MessageBubble(
          text: msg.content,
          isUser: isUser,
          isStreaming: isStreamingThis,
          colors: colors,
        );
      },
    );
  }

  // ── Error banner ──

  Widget _buildErrorBanner(WisteriaColorPalette colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: colors.error.withValues(alpha: 0.08),
        border: Border(
          top: BorderSide(color: colors.error.withValues(alpha: 0.25)),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, size: 18, color: colors.error),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: colors.error,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(width: 8),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => setState(() => _errorMessage = null),
              child: Icon(
                Icons.close_rounded,
                size: 18,
                color: colors.error.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Message composer ──

  Widget _buildComposer(WisteriaColorPalette colors) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 74),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Container(
            decoration: BoxDecoration(
              color: colors.surfaceLow,
              borderRadius: BorderRadius.circular(WisteriaRadius.lg),
              border: Border.all(color: colors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Text field
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _inputFocusNode,
                    maxLines: 5,
                    minLines: 1,
                    style: TextStyle(
                      fontSize: 14,
                      color: colors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Message Gemma…',
                      hintStyle: TextStyle(color: colors.textMuted),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
                      filled: false,
                    ),
                  ),
                ),

                // Send button
                Padding(
                  padding: const EdgeInsets.only(right: 8, bottom: 6),
                  child: _SendButton(
                    isGenerating: _isGenerating,
                    colors: colors,
                    onTap: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  Private helper widgets
// ═══════════════════════════════════════════════════════════════════

/// Reusable full-width action button.
class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color accentColor;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.accentColor,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8.5, horizontal: 12),
          decoration: BoxDecoration(
            color: widget.isPrimary
                ? (_isHovered
                    ? widget.accentColor.withValues(alpha: 0.24)
                    : widget.accentColor.withValues(alpha: 0.14))
                : (_isHovered
                    ? widget.accentColor.withValues(alpha: 0.16)
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(WisteriaRadius.sm),
            border: Border.all(
              color: widget.isPrimary
                  ? (_isHovered
                      ? widget.accentColor.withValues(alpha: 0.7)
                      : widget.accentColor.withValues(alpha: 0.35))
                  : (_isHovered
                      ? widget.accentColor.withValues(alpha: 0.4)
                      : widget.accentColor.withValues(alpha: 0.2)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 16, color: widget.accentColor),
              const SizedBox(width: 7),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: widget.accentColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tab selector button inside the sidebar (Memories vs History).
class _SidebarTabButton extends StatelessWidget {
  final String label;
  final int badgeCount;
  final bool isActive;
  final WisteriaColorPalette colors;
  final VoidCallback onTap;

  const _SidebarTabButton({
    required this.label,
    required this.badgeCount,
    required this.isActive,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? colors.surfaceHigh : Colors.transparent,
            borderRadius: BorderRadius.circular(WisteriaRadius.sm),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive ? colors.textPrimary : colors.textMuted,
                ),
              ),
              if (badgeCount > 0) ...[
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: isActive
                        ? colors.primary.withValues(alpha: 0.2)
                        : colors.surfaceHighest,
                    borderRadius: BorderRadius.circular(WisteriaRadius.full),
                  ),
                  child: Text(
                    '$badgeCount',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isActive ? colors.primary : colors.textMuted,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Tile in the conversation history list.
class _ConversationHistoryTile extends StatefulWidget {
  final WisChatConversation conversation;
  final bool isActive;
  final WisteriaColorPalette colors;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ConversationHistoryTile({
    required this.conversation,
    required this.isActive,
    required this.colors,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<_ConversationHistoryTile> createState() =>
      _ConversationHistoryTileState();
}

class _ConversationHistoryTileState extends State<_ConversationHistoryTile> {
  bool _isHovered = false;

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.month}/${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.colors;
    final isActive = widget.isActive;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? c.primary.withValues(alpha: 0.12)
                : (_isHovered ? c.surfaceHigh : Colors.transparent),
            borderRadius: BorderRadius.circular(WisteriaRadius.sm),
            border: Border.all(
              color: isActive
                  ? c.primary.withValues(alpha: 0.35)
                  : (_isHovered
                      ? c.border
                      : Colors.transparent),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.chat_bubble_outline_rounded,
                size: 14,
                color: isActive ? c.primary : c.textMuted,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.conversation.title,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.w400,
                        color: isActive ? c.primary : c.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(widget.conversation.updatedAt),
                      style: TextStyle(
                        fontSize: 10.5,
                        color: c.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (_isHovered)
                GestureDetector(
                  onTap: widget.onDelete,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                    ),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      size: 14,
                      color: c.error.withValues(alpha: 0.8),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Single card representing one saved memory item.
class _MemoryItemCard extends StatefulWidget {
  final WisChatMemory memory;
  final WisteriaColorPalette colors;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MemoryItemCard({
    required this.memory,
    required this.colors,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_MemoryItemCard> createState() => _MemoryItemCardState();
}

class _MemoryItemCardState extends State<_MemoryItemCard> {
  bool _isHovered = false;

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.colors;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: _isHovered
              ? c.surfaceHigh.withValues(alpha: 0.7)
              : c.surfaceContainer,
          borderRadius: BorderRadius.circular(WisteriaRadius.sm),
          border: Border.all(
            color: _isHovered
                ? c.primary.withValues(alpha: 0.35)
                : c.border.withValues(alpha: 0.7),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              widget.memory.text,
              style: TextStyle(
                fontSize: 12.5,
                color: c.textPrimary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  _formatDate(widget.memory.createdAt),
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w400,
                    color: c.textMuted,
                  ),
                ),
                const Spacer(),
                _CardActionIcon(
                  icon: Icons.edit_outlined,
                  tooltip: 'Edit memory',
                  colors: c,
                  onTap: widget.onEdit,
                ),
                const SizedBox(width: 4),
                _CardActionIcon(
                  icon: Icons.delete_outline_rounded,
                  tooltip: 'Delete memory',
                  colors: c,
                  hoverColor: c.error,
                  onTap: widget.onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact action icon button for memory cards.
class _CardActionIcon extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final WisteriaColorPalette colors;
  final Color? hoverColor;
  final VoidCallback onTap;

  const _CardActionIcon({
    required this.icon,
    required this.tooltip,
    required this.colors,
    this.hoverColor,
    required this.onTap,
  });

  @override
  State<_CardActionIcon> createState() => _CardActionIconState();
}

class _CardActionIconState extends State<_CardActionIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.colors;
    final activeColor = widget.hoverColor ?? c.primary;

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _isHovered
                  ? activeColor.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(WisteriaRadius.sm),
            ),
            child: Icon(
              widget.icon,
              size: 15,
              color: _isHovered ? activeColor : c.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}

/// Single message bubble with rich Markdown rendering for assistant messages.
class _MessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final bool isStreaming;
  final WisteriaColorPalette colors;

  const _MessageBubble({
    required this.text,
    required this.isUser,
    required this.isStreaming,
    required this.colors,
  });

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        width: 220,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: isUser ? 80 : 0,
          right: isUser ? 0 : 80,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        constraints: const BoxConstraints(maxWidth: 720),
        decoration: BoxDecoration(
          color: isUser
              ? colors.primary.withValues(alpha: 0.12)
              : colors.surfaceLow,
          borderRadius: BorderRadius.circular(WisteriaRadius.lg),
          border: Border.all(
            color: isUser
                ? colors.primary.withValues(alpha: 0.22)
                : colors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Role label + Copy button
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isUser ? 'You' : 'WisChat',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isUser ? colors.primary : colors.tertiary,
                    letterSpacing: 0.5,
                  ),
                ),
                if (!isUser && text.isNotEmpty) ...[
                  const SizedBox(width: 10),
                  Tooltip(
                    message: 'Copy message',
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => _copyToClipboard(context),
                        child: Icon(
                          Icons.copy_rounded,
                          size: 13,
                          color: colors.textMuted.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 6),

            // Content or loading indicator
            if (text.isEmpty && isStreaming)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(colors.primary),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Generating response…',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: colors.textMuted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              )
            else ...[
              // ── Markdown Body ──
              MarkdownBody(
                data: text,
                selectable: true,
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(
                    fontSize: 14,
                    color: colors.textPrimary,
                    height: 1.55,
                  ),
                  strong: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                  em: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: colors.textPrimary,
                  ),
                  h1: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                    height: 1.4,
                  ),
                  h2: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                    height: 1.4,
                  ),
                  h3: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                    height: 1.4,
                  ),
                  h4: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                  listBullet: TextStyle(
                    fontSize: 14,
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  listBulletPadding: const EdgeInsets.only(right: 6),
                  code: TextStyle(
                    fontSize: 12.5,
                    fontFamily: 'monospace',
                    color: colors.primary,
                    backgroundColor:
                        colors.surfaceContainer.withValues(alpha: 0.6),
                  ),
                  codeblockDecoration: BoxDecoration(
                    color: colors.surfaceContainer,
                    borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                    border: Border.all(color: colors.border),
                  ),
                  codeblockPadding: const EdgeInsets.all(12),
                  horizontalRuleDecoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: colors.border, width: 1),
                    ),
                  ),
                  blockquote: TextStyle(
                    fontSize: 13.5,
                    fontStyle: FontStyle.italic,
                    color: colors.textSecondary,
                  ),
                  blockquoteDecoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: colors.primary, width: 3),
                    ),
                  ),
                  blockquotePadding:
                      const EdgeInsets.only(left: 12, top: 2, bottom: 2),
                ),
              ),

              if (isStreaming) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 10,
                      height: 10,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        valueColor: AlwaysStoppedAnimation(colors.primary),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Generating…',
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.textMuted,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

/// Animated send button.
class _SendButton extends StatefulWidget {
  final bool isGenerating;
  final WisteriaColorPalette colors;
  final VoidCallback onTap;

  const _SendButton({
    required this.isGenerating,
    required this.colors,
    required this.onTap,
  });

  @override
  State<_SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<_SendButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.colors;
    return MouseRegion(
      cursor: widget.isGenerating
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.isGenerating ? null : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: widget.isGenerating
                ? c.surfaceHigh
                : _isHovered
                    ? c.primary
                    : c.primaryMuted,
            borderRadius: BorderRadius.circular(WisteriaRadius.md),
          ),
          child: Icon(
            Icons.arrow_upward_rounded,
            size: 18,
            color: widget.isGenerating
                ? c.textMuted
                : c.textOnPrimary,
          ),
        ),
      ),
    );
  }
}

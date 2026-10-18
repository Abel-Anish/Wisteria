import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/services/ollama_service.dart';
import '../../core/theme/wisteria_theme.dart';
import '../shared/wisteria_back_button.dart';

/// Single conversation message model.
class _ChatMessage {
  final String role;
  String content;

  _ChatMessage({required this.role, required this.content});

  Map<String, String> toMap() => {'role': role, 'content': content};
}

/// A ChatGPT-inspired chatbot interface for conversing with a locally
/// running Gemma 3 4B model via Ollama with multi-turn support and
/// real HTTP response streaming.
class OfflineModelPage extends StatefulWidget {
  const OfflineModelPage({super.key});

  @override
  State<OfflineModelPage> createState() => _OfflineModelPageState();
}

class _OfflineModelPageState extends State<OfflineModelPage> {
  final OllamaService _ollama = OllamaService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();

  StreamSubscription<String>? _streamSubscription;

  /// Active conversation history (single source of truth).
  final List<_ChatMessage> _messages = [];

  bool _isGenerating = false;
  String? _errorMessage;

  // ── Example prompts for the welcome screen ──
  static const _examplePrompts = [
    'Explain how a neural network learns in simple terms.',
    'What are the key differences between CT and MRI scans?',
    'Write a Python function to calculate BMI.',
    'Summarize the benefits of local AI inference.',
  ];

  @override
  void initState() {
    super.initState();
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
    _streamSubscription?.cancel();
    _streamSubscription = null;
    _controller.dispose();
    _scrollController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
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

    // 2. Build request payload from actual active conversation history
    final payload = _messages.map((m) => m.toMap()).toList();

    // 3. Add placeholder assistant message to stream chunks into
    final assistantMessage = _ChatMessage(role: 'assistant', content: '');
    _messages.add(assistantMessage);

    _controller.clear();
    setState(() {
      _isGenerating = true;
      _errorMessage = null;
    });
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
          if (!completer.isCompleted) completer.complete();
        },
        onDone: () {
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
    } finally {
      _streamSubscription = null;
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
        _scrollToBottom(animated: true);
        _inputFocusNode.requestFocus();
      }
    }
  }

  void _newChat() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
    setState(() {
      _messages.clear();
      _controller.clear();
      _errorMessage = null;
      _isGenerating = false;
    });
    _inputFocusNode.requestFocus();
  }

  void _useExamplePrompt(String prompt) {
    if (_isGenerating) return;
    _controller.text = prompt;
    _sendMessage();
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

  // ── Build ────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context, colors),
            Expanded(
              child: _messages.isEmpty
                  ? _buildWelcomeScreen(colors)
                  : _buildConversation(colors),
            ),
            if (_errorMessage != null) _buildErrorBanner(colors),
            _buildComposer(colors),
          ],
        ),
      ),
    );
  }

  // ── Top bar ──

  Widget _buildTopBar(BuildContext context, WisteriaColorPalette colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: Row(
        children: [
          const WisteriaBackButton(label: 'Back'),
          const Spacer(),

          // Title
          Text(
            'Offline Model',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
              letterSpacing: -0.2,
            ),
          ),

          const SizedBox(width: 16),

          // Model status pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colors.surfaceLow,
              borderRadius: BorderRadius.circular(WisteriaRadius.full),
              border: Border.all(color: colors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, size: 7, color: colors.success),
                const SizedBox(width: 6),
                Text(
                  'Gemma 3 4B · Local Ollama',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // New Chat button
          _HoverActionButton(
            icon: Icons.add_rounded,
            label: 'New Chat',
            accentColor: colors.primary,
            onTap: _newChat,
          ),
        ],
      ),
    );
  }

  // ── Welcome screen ──

  Widget _buildWelcomeScreen(WisteriaColorPalette colors) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(48),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Brain icon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: colors.tertiary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(WisteriaRadius.xl),
                  border: Border.all(
                    color: colors.tertiary.withValues(alpha: 0.20),
                  ),
                ),
                child: Icon(
                  Icons.psychology_rounded,
                  size: 36,
                  color: colors.tertiary.withValues(alpha: 0.8),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Offline Model',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Chat with a locally running Gemma 3 4B model.\n'
                'All inference happens on your machine — nothing leaves this workstation.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: colors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 36),

              // Example prompts
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: _examplePrompts
                    .map((p) => _ExamplePromptChip(
                          text: p,
                          colors: colors,
                          onTap: () => _useExamplePrompt(p),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Conversation area ──

  Widget _buildConversation(WisteriaColorPalette colors) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
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

/// Single message bubble (user or assistant) with streaming support.
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
        constraints: const BoxConstraints(maxWidth: 680),
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
            // Role label
            Text(
              isUser ? 'You' : 'Gemma 3 4B',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isUser ? colors.primary : colors.tertiary,
                letterSpacing: 0.5,
              ),
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
              SelectableText(
                text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: colors.textPrimary,
                  height: 1.55,
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

/// Example prompt chip for the welcome screen.
class _ExamplePromptChip extends StatefulWidget {
  final String text;
  final WisteriaColorPalette colors;
  final VoidCallback onTap;

  const _ExamplePromptChip({
    required this.text,
    required this.colors,
    required this.onTap,
  });

  @override
  State<_ExamplePromptChip> createState() => _ExamplePromptChipState();
}

class _ExamplePromptChipState extends State<_ExamplePromptChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.colors;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          constraints: const BoxConstraints(maxWidth: 320),
          decoration: BoxDecoration(
            color: _isHovered
                ? c.primary.withValues(alpha: 0.08)
                : c.surfaceLow,
            borderRadius: BorderRadius.circular(WisteriaRadius.lg),
            border: Border.all(
              color: _isHovered
                  ? c.primary.withValues(alpha: 0.3)
                  : c.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.chat_bubble_outline_rounded,
                size: 14,
                color: _isHovered ? c.primary : c.textMuted,
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: _isHovered ? c.textPrimary : c.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small action button with icon + label and hover effect.
class _HoverActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color accentColor;
  final VoidCallback onTap;

  const _HoverActionButton({
    required this.icon,
    required this.label,
    required this.accentColor,
    required this.onTap,
  });

  @override
  State<_HoverActionButton> createState() => _HoverActionButtonState();
}

class _HoverActionButtonState extends State<_HoverActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.accentColor.withValues(alpha: 0.10)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(WisteriaRadius.md),
            border: Border.all(
              color: _isHovered
                  ? widget.accentColor.withValues(alpha: 0.3)
                  : colors.border.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 16,
                color: _isHovered
                    ? widget.accentColor
                    : colors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _isHovered
                      ? widget.accentColor
                      : colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

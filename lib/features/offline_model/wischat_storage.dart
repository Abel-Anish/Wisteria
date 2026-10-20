import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Single persistent memory item for WisChat.
class WisChatMemory {
  final String id;
  String text;
  final DateTime createdAt;

  WisChatMemory({
    required this.id,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'createdAt': createdAt.toIso8601String(),
  };

  factory WisChatMemory.fromJson(Map<String, dynamic> json) {
    return WisChatMemory(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      text: json['text'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

/// Single multi-turn conversation session with a unique ID and title.
class WisChatConversation {
  final String id;
  String title;
  final DateTime createdAt;
  DateTime updatedAt;
  List<Map<String, String>> messages;

  WisChatConversation({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.messages,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'messages': messages,
  };

  factory WisChatConversation.fromJson(Map<String, dynamic> json) {
    return WisChatConversation(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] as String? ?? 'New Chat',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      messages: (json['messages'] as List<dynamic>? ?? [])
          .map((item) {
            final map = item as Map<String, dynamic>;
            return {
              'role': map['role']?.toString() ?? 'user',
              'content': map['content']?.toString() ?? '',
            };
          })
          .toList(),
    );
  }
}

/// Service handling local disk persistence for WisChat conversations,
/// unsent drafts, and saved memories.
class WisChatStorage {
  static const String _memoriesFileName = 'wischat_memories.json';
  static const String _conversationsFileName = 'wischat_conversations.json';
  static const String _activeConvIdFileName = 'wischat_active_conv_id.txt';
  static const String _legacyHistoryFileName = 'wischat_history.json';
  static const String _draftFileName = 'wischat_draft.txt';
  static const String _sidebarStateFileName = 'wischat_sidebar_state.txt';

  Future<File> _getFile(String fileName) async {
    final dir = await getApplicationSupportDirectory();
    return File(p.join(dir.path, fileName));
  }

  // ── Memories Persistence ─────────────────────────────────────────

  Future<List<WisChatMemory>> loadMemories() async {
    try {
      final file = await _getFile(_memoriesFileName);
      if (!await file.exists()) return [];
      final content = await file.readAsString();
      if (content.trim().isEmpty) return [];
      final List<dynamic> decoded = jsonDecode(content) as List<dynamic>;
      return decoded
          .map((item) => WisChatMemory.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveMemories(List<WisChatMemory> memories) async {
    try {
      final file = await _getFile(_memoriesFileName);
      final jsonString = jsonEncode(memories.map((m) => m.toJson()).toList());
      await file.writeAsString(jsonString);
    } catch (_) {
      // Graceful fallback
    }
  }

  // ── Multiple Conversations Persistence ───────────────────────────

  Future<List<WisChatConversation>> loadConversations() async {
    try {
      final file = await _getFile(_conversationsFileName);
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.trim().isNotEmpty) {
          final List<dynamic> decoded = jsonDecode(content) as List<dynamic>;
          final list = decoded
              .map((item) =>
                  WisChatConversation.fromJson(item as Map<String, dynamic>))
              .toList();
          if (list.isNotEmpty) return list;
        }
      }

      // Backward compatibility: migrate legacy single history file if present
      final legacyFile = await _getFile(_legacyHistoryFileName);
      if (await legacyFile.exists()) {
        final legacyContent = await legacyFile.readAsString();
        if (legacyContent.trim().isNotEmpty) {
          final List<dynamic> decoded = jsonDecode(legacyContent) as List<dynamic>;
          final messages = decoded.map((item) {
            final map = item as Map<String, dynamic>;
            return {
              'role': map['role']?.toString() ?? 'user',
              'content': map['content']?.toString() ?? '',
            };
          }).toList();

          if (messages.isNotEmpty) {
            final initialConv = WisChatConversation(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              title: _generateTitleFromMessages(messages),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              messages: messages,
            );
            await saveConversations([initialConv]);
            return [initialConv];
          }
        }
      }

      return [];
    } catch (_) {
      return [];
    }
  }

  Future<void> saveConversations(List<WisChatConversation> conversations) async {
    try {
      final file = await _getFile(_conversationsFileName);
      final jsonString =
          jsonEncode(conversations.map((c) => c.toJson()).toList());
      await file.writeAsString(jsonString);
    } catch (_) {
      // Graceful fallback
    }
  }

  Future<String?> loadActiveConversationId() async {
    try {
      final file = await _getFile(_activeConvIdFileName);
      if (!await file.exists()) return null;
      final id = (await file.readAsString()).trim();
      return id.isNotEmpty ? id : null;
    } catch (_) {
      return null;
    }
  }

  Future<void> saveActiveConversationId(String id) async {
    try {
      final file = await _getFile(_activeConvIdFileName);
      await file.writeAsString(id);
    } catch (_) {
      // Graceful fallback
    }
  }

  static String _generateTitleFromMessages(List<Map<String, String>> messages) {
    for (final m in messages) {
      if (m['role'] == 'user') {
        final text = (m['content'] ?? '').trim();
        if (text.isNotEmpty) {
          return text.length > 28 ? '${text.substring(0, 28)}…' : text;
        }
      }
    }
    return 'Chat';
  }

  // ── Unsent Draft Persistence ─────────────────────────────────────

  Future<String> loadDraft() async {
    try {
      final file = await _getFile(_draftFileName);
      if (!await file.exists()) return '';
      return await file.readAsString();
    } catch (_) {
      return '';
    }
  }

  Future<void> saveDraft(String draft) async {
    try {
      final file = await _getFile(_draftFileName);
      await file.writeAsString(draft);
    } catch (_) {
      // Graceful fallback
    }
  }

  // ── Sidebar Open State ───────────────────────────────────────────

  Future<bool> loadSidebarOpen() async {
    try {
      final file = await _getFile(_sidebarStateFileName);
      if (!await file.exists()) return true;
      final content = (await file.readAsString()).trim();
      return content != 'false';
    } catch (_) {
      return true;
    }
  }

  Future<void> saveSidebarOpen(bool isOpen) async {
    try {
      final file = await _getFile(_sidebarStateFileName);
      await file.writeAsString(isOpen ? 'true' : 'false');
    } catch (_) {
      // Graceful fallback
    }
  }
}

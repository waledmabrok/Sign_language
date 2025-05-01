import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'constant.dart';

class ApiAI {
  static String meetingId = "";
  static Timer? _messageTimer;

  // ======== HTTP Methods ========
  static Future<dynamic> get(String endpoint) async {
    final response = await http.get(Uri.parse("$apiBase/$endpoint"));
    return _handleResponse(response);
  }

  static Future<dynamic> post(String endpoint,
      {Map<String, dynamic>? body}) async {
    final response = await http.post(
      Uri.parse("$apiBase/$endpoint"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body ?? {}),
    );
    return _handleResponse(response);
  }

  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("API Error: ${response.statusCode}");
    }
  }

  // ======== API Logic ========

  static Future<String> fetchTranslation() async {
    if (meetingId.isEmpty) return "";
    try {
      final data = await get("latest_translation");
      return data["text"] ?? "";
    } catch (e) {
      print("❌ Error fetching translation: $e");
      return "";
    }
  }

  static Future<List<Map<String, String>>> fetchMessages() async {
    if (meetingId.isEmpty) return [];
    try {
      final data = await get("chat/$meetingId");
      return (data as List)
          .map<Map<String, String>>((msg) => {
                "user": msg["user"] ?? "",
                "message": msg["message"] ?? "",
              })
          .toList();
    } catch (e) {
      print("❌ Error fetching messages: $e");
      return [];
    }
  }

  static Future<void> sendMessage(String msg, {String user = "waled"}) async {
    if (meetingId.isEmpty || msg.trim().isEmpty) return;
    try {
      await post("chat/$meetingId", body: {
        "user": user,
        "message": msg.trim(),
      });
    } catch (e) {
      print("❌ Error sending message: $e");
    }
  }

  static Future<void> startMeeting({
    required Function(String meetingId) onMeetingStarted,
    required Function(List<Map<String, String>> messages) onMessagesUpdated,
    Function(String translation)? onTranslationUpdated,
    Duration interval = const Duration(seconds: 3),
  }) async {
    try {
      await post("start_meeting_all");

      final data = await get("last_used_meeting");
      meetingId = data['meeting_id'];
      print("✅ Meeting ID: $meetingId");

      final messages = await fetchMessages();
      onMeetingStarted(meetingId);
      onMessagesUpdated(messages);

      if (onTranslationUpdated != null) {
        final trans = await fetchTranslation();
        onTranslationUpdated(trans);
      }

      _messageTimer?.cancel();
      _messageTimer = Timer.periodic(interval, (_) async {
        final updatedMessages = await fetchMessages();
        onMessagesUpdated(updatedMessages);

        if (onTranslationUpdated != null) {
          final trans = await fetchTranslation();
          onTranslationUpdated(trans);
        }
      });
    } catch (e) {
      print("❌ Error starting meeting: $e");
    }
  }

  static void stopUpdates() {
    _messageTimer?.cancel();
    _messageTimer = null;
  }
}

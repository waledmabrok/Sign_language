import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/constant.dart';

class LocalCameraWithChatPage extends StatefulWidget {
  const LocalCameraWithChatPage({super.key});

  @override
  State<LocalCameraWithChatPage> createState() =>
      _LocalCameraWithChatPageState();
}

class _LocalCameraWithChatPageState extends State<LocalCameraWithChatPage> {
  late RtcEngine _engine;
  bool localUserJoined = false;
  String meetingId = "";
  List<Map<String, dynamic>> messages = [];
  final TextEditingController messageController = TextEditingController();
  String translatedText = "";
  final screenshotController = ScreenshotController();
  String? userAvatar;

  @override
  void initState() {
    super.initState();
    loadUserAvatar();
    initAgora();
    startMeetingAndFetchChat();
  }

  Future<void> loadUserAvatar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userAvatar = prefs.getString('user_avatar');
    });
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  Future<void> initAgora() async {
    await [Permission.microphone, Permission.camera].request();

    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      const RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );

    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: token,
      channelId: channel,
      options: const ChannelMediaOptions(
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
      uid: 0,
    );

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          setState(() {
            localUserJoined = true;
          });
        },
      ),
    );
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  Future<void> captureAndSend() async {
    screenshotController.capture().then((Uint8List? capturedImage) {
      if (capturedImage != null) {
        sendImageToServer(capturedImage);
      }
    }).catchError((e) {
      print("Error capturing screenshot: $e");
    });
  }

  Future<void> sendImageToServer(Uint8List image) async {
    final uri = Uri.parse('$apiBase/predict');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(http.MultipartFile.fromBytes('image', image,
          filename: 'screenshot.jpg'));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final result = await response.stream.bytesToString();
        final jsonResponse = json.decode(result);
        setState(() {
          translatedText = jsonResponse['result'] ?? "No translation available";
        });
      } else {
        print("❌ Failed to send image: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending image: $e");
    }
  }

  Future<void> startMeetingAndFetchChat() async {
    try {
      final startResponse =
          await http.post(Uri.parse("$apiBase/start_meeting_all"));

      if (startResponse.statusCode == 200) {
        final response =
            await http.get(Uri.parse("$apiBase/last_used_meeting"));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            meetingId = data['meeting_id'];
          });
          fetchMessages();
          fetchTranslation();
          Timer.periodic(const Duration(seconds: 3), (_) {
            fetchMessages();
            fetchTranslation();
            captureAndSend();
          });
        } else {
          print("❌ Failed to get meeting ID: ${response.statusCode}");
        }
      } else {
        print("❌ Failed to start meeting: ${startResponse.statusCode}");
      }
    } catch (e) {
      print("❌ Error during startMeetingAndFetchChat: $e");
    }
  }

  Future<void> fetchMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userAvatar = prefs.getString('user_avatar');
    if (meetingId.isEmpty) return;
    final response = await http.get(Uri.parse("$apiBase/chat/$meetingId"));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        messages = data
            .map(
              (msg) => {
                "user": msg["user"] ?? "",
                "message": msg["message"] ?? "",
              },
            )
            .toList();
      });
    }
  }

  Future<void> fetchTranslation() async {
    if (meetingId.isEmpty) return;
    final response = await http.get(Uri.parse("$apiBase/translate/$meetingId"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        translatedText = data['text'] ?? "";
      });
    }
  }

  Future<void> sendMessage() async {
    final msg = messageController.text.trim();
    if (msg.isEmpty) return;
    await http.post(
      Uri.parse("$apiBase/chat/$meetingId"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"user": "waled", "message": msg}),
    );
    messageController.clear();
    fetchMessages();
  }

  @override
  Widget build(BuildContext context) {
    String imagePath = '';

    if (translatedText.isNotEmpty) {
      String lastChar = translatedText[translatedText.length - 1].toLowerCase();
      if (lastChar.compareTo('a') >= 0 && lastChar.compareTo('z') <= 0) {
        imagePath = 'assets/images/image${lastChar}.png';
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFF0051FF),
          ),

          // الكاميرا المحلية
          Positioned(
            top: 48,
            left: 16,
            right: 16,
            child: Container(
              height: 223,
              decoration: BoxDecoration(
                color: const Color(0xFF6797FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: localUserJoined
                    ? AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: _engine,
                          canvas: const VideoCanvas(uid: 0),
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator(color: Colors.white)),
              ),
            ),
          ),

          // الترجمة
          Positioned(
            top: 285,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        translatedText.isNotEmpty
                            ? translatedText
                            : "Waiting for translation...",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // الشات
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            top: 390,
            child: Container(
              padding: const EdgeInsets.only(
                left: 12,
                right: 12,
              ),
              decoration: BoxDecoration(
                color: Color(0xffD9D9D9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 45.0),
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (_, index) {
                    final msg = messages[messages.length - index - 1];
                    final isMe = msg['user'] ==
                        "هو"; // إذا كانت الرسالة من المستخدم الحالي
                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: isMe
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: isMe
                            ? [
                                // الرسالة
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE7E7E7),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "${msg['message']}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // الصورة من SharedPreferences
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: const Color(0xFF6797FF),
                                  backgroundImage: userAvatar != null &&
                                          userAvatar!.isNotEmpty
                                      ? NetworkImage(
                                          userAvatar!) // استخدم الصورة المخزنة
                                      : null, // أو صورة افتراضية لو الصورة مش موجودة
                                ),
                              ]
                            : [
                                // الصورة من SharedPreferences
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: const Color(0xFF6797FF),
                                  backgroundImage: userAvatar != null &&
                                          userAvatar!.isNotEmpty
                                      ? NetworkImage(
                                          userAvatar!) // استخدم الصورة المخزنة
                                      : null, // أو صورة افتراضية لو الصورة مش موجودة
                                ),
                                const SizedBox(width: 8),
                                // الرسالة
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "${msg['message']}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

// صندوق كتابة الشات
          Positioned(
            bottom: 30,
            left: 24,
            right: 24,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffD9D9D9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                          // تحديد الحدود العادية
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                                color: Colors
                                    .white), // اللون الأبيض للحدود العادية
                          ),
                          // تحديد الحدود عند التركيز
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                                color:
                                    Colors.white), // اللون الأبيض عند التركيز
                          ),
                          // تحديد الحدود عند فقدان التركيز
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                                color: Colors
                                    .white), // اللون الأبيض عند فقدان التركيز
                          ),
                          // تحديد الحدود عند ظهور الخطأ
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                                color: Colors.white), // اللون الأبيض عند الخطأ
                          ),
                          // تحديد الحدود عند التركيز مع وجود خطأ
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                                color: Colors
                                    .white), // اللون الأبيض عند التركيز مع خطأ
                          ),
                          hintText: "Type a message...",
                          hintStyle: TextStyle(
                            color: Color(0xFF939393),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    height: 40,
                    width: 49,
                    decoration: BoxDecoration(
                      color: Color(0xFF0051FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon:
                          const Icon(Icons.send, color: Colors.white, size: 24),
                      onPressed: sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

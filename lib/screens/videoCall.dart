import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:screenshot/screenshot.dart';
import '../constant/constant.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late RtcEngine _engine;
  int? _remoteUid;
  bool localUserJoined = false;
  String meetingId = "";
  List<Map<String, dynamic>> messages = [];
  final TextEditingController messageController = TextEditingController();
  String translatedText = "a";
  final screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    initAgora();

    startMeetingAndFetchChat();
    print("meeting id=======$meetingId");
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  Future<void> captureAndSend() async {
    screenshotController.capture().then((Uint8List? capturedImage) {
      if (capturedImage != null) {
        sendImageToServer(capturedImage); // إرسال الصورة إلى السيرفر
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

  Future<void> fetchTranslation() async {
    if (meetingId.isEmpty) return;
    final response = await http.get(Uri.parse("$apiBase/translate/$meetingId"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        translatedText = data['text'] ?? "";
      });
    } else {
      print("❌ Failed to fetch translation: ${response.statusCode}");
    }
  }

  Future<void> startMeetingAndFetchChat() async {
    try {
      final startResponse = await http.post(
        Uri.parse("$apiBase/start_meeting_all"),
      );

      if (startResponse.statusCode == 200) {
        final response = await http.get(
          Uri.parse("$apiBase/last_used_meeting"),
        );
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            meetingId = data['meeting_id'];
          });
          print("✅ meeting id from server: $meetingId");
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
        autoSubscribeVideo: true,
        autoSubscribeAudio: true,
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
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (
          RtcConnection connection,
          int remoteUid,
          UserOfflineReasonType reason,
        ) {
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  @override
  Widget build(BuildContext context) {
    String imagePath = '';
    // تحقق من أن النص ليس فارغًا

// تحقق من أن النص ليس فارغًا
    if (translatedText.isNotEmpty) {
      // الحصول على آخر حرف من النص المترجم (أو الحرف الأخير المدخل)
      String lastChar = translatedText[translatedText.length - 1].toLowerCase();

      // التأكد من أن الحرف في النطاق من 'a' إلى 'z'
      if (lastChar.compareTo('a') >= 0 && lastChar.compareTo('z') <= 0) {
        // بناء مسار الصورة بناءً على الحرف الأخير
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
          Positioned(
            top: 48,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ), // المسافة من اليمين والشمال
              child: Row(
                children: [
                  Expanded(
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
                                child: CircularProgressIndicator(
                                  color: Color(0xff0051FF),
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 9), // المسافة بين الفيديوهين
                  Expanded(
                    child: Container(
                      height: 223,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6797FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _remoteUid != null
                            ? AgoraVideoView(
                                controller: VideoViewController.remote(
                                  rtcEngine: _engine,
                                  canvas: VideoCanvas(uid: _remoteUid),
                                  connection: const RtcConnection(
                                    channelId: channel,
                                  ),
                                ),
                              )
                            : const Center(
                                child: Text("Waiting for user..."),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 285,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Container(
                  width: 69,
                  height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFF003AB6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: imagePath.isNotEmpty
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(12), // تعيين الزوايا لتكون دائرية
                      child: Image.asset(
                        imagePath,
                        width: double.infinity, // تعيين العرض ليتناسب مع الكونتينر
                        height: double.infinity, // تعيين الارتفاع ليتناسب مع الكونتينر
                        fit: BoxFit.contain, // لتصغير الصورة داخل الـ Container بدون تشويه
                      ),
                    )
                        : const Icon(
                      Icons.volume_up,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),


                const SizedBox(width: 8),
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

          // ✅ Chat messages
          Positioned(
            bottom: 70,
            left: 16,
            right: 16,
            top: 390,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (_, index) {
                  final msg = messages[messages.length - index - 1];
                  final isMe = msg['user'] == "أنا";
                  return Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7E7E7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text("${msg['user']}: ${msg['message']}"),
                    ),
                  );
                },
              ),
            ),
          ),

          // ✅ Text input
          Positioned(
            bottom: 10,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "send message...",
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

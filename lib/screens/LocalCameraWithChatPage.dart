import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import '../constant/SnacBar.dart';
import '../constant/constant.dart';
import '../constant/translation_notifier.dart';

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
  bool isCapturing = false;
  Timer? _periodicTimer;
  bool isDeleting = false;
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
    _periodicTimer?.cancel();
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
    if (!localUserJoined || isCapturing) {
      print("⏳ Waiting for user to join before capturing...");
      return;
    }
    isCapturing = true;
    try {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/snapshot.jpg';
      print("Temporary directory: ${tempDir.path}");

      await _engine.takeSnapshot(
        uid: 0,
        filePath: filePath,
      );

      final bytes = await File(filePath).readAsBytes();
      final translation = await sendImageToServer(bytes);

      if (translation != null && translation.isNotEmpty) {
        print("📥 Translation received: $translation");
        /*   setState(() {
          translatedText += "$translation";
        });*/
        globalTranslation.value += "$translation";
      }
    } catch (e) {
      print("❌ Failed to capture snapshot: $e");
    } finally {
      isCapturing = false;
    }
  }

  Future<String?> sendImageToServer(Uint8List image) async {
    final uri = Uri.parse('$apiBase/upload_frame');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(
          http.MultipartFile.fromBytes('frame', image, filename: 'frame.jpg'));

    try {
      print("📤 Sending frame to server...");
      final response = await request.send();
      final result = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        print("✔️ Image sent successfully: $result");
        final decoded = jsonDecode(result);
        return decoded['translation'];
      } else {
        print("❌ Failed to send image: ${response.statusCode}");
        print("Error details: $result");
        return null;
      }
    } catch (e) {
      print("❌ Error sending image: $e");
      return null;
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
          _periodicTimer = Timer.periodic(const Duration(seconds: 5), (_) {
            if (!mounted) return; // تأكد إن الصفحة لسه شغالة
            fetchMessages();
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
    final response = await http.get(Uri.parse("$apiBase/latest_translation"));
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
      body: json.encode({"user": "ahmed", "message": msg}),
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
          Stack(
            children: [
              // Positioned بتاع الفيديو
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
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          ),
                  ),
                ),
              ),

              // الزر السفلي يمين
              Positioned(
                top: 220,
                right: 16,
                child: FloatingActionButton.small(
                  backgroundColor: Colors.red,
                  onPressed: () {
                    // إيقاف تشغيل الفيديو من Agora (اختياري)
                    _engine.leaveChannel();

                    // الانتقال إلى الصفحة الرئيسية ومسح كل الصفحات السابقة
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const HomePage()), // غير HomePage بالصفحة الرئيسية
                      (route) => false,
                    );
                  },
                  child: const Icon(Icons.call_end, color: Colors.white),
                ),
              ),
            ],
          ),

          // الترجمة
          Positioned(
            top: 285,
            left: 16,
            right: 16,
            child: Container(
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(8),
              child: Stack(
                children: [
                  // النص في المنتصف
                  Center(
                    child: ValueListenableBuilder<String>(
                      valueListenable: globalTranslation,
                      builder: (context, value, _) {
                        return Text(
                          value.isNotEmpty
                              ? value
                              : "Waiting for translation...",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                  ),

                  // زرار الحذف في أسفل اليمين
                  /*  Positioned(
                    bottom: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: isDeleting
                          ? null
                          : () async {
                              setState(() {
                                isDeleting = true;
                              });

                              try {
                                final response = await http.post(
                                  Uri.parse('$apiBase/delete_char'),
                                );
                                final jsonResponse = json.decode(response.body);
                                if (jsonResponse['success'] == 'Done') {
                                  if (globalTranslation.value.isNotEmpty) {
                                    globalTranslation.value =
                                        globalTranslation.value.substring(0,
                                            globalTranslation.value.length - 1);
                                  }
                                  showCustomSnackBar(
                                    context,
                                    message: 'Delete Succ',
                                    backgroundColor: Colors.green,
                                  );
                                } else {
                                  showCustomSnackBar(
                                    context,
                                    message: 'Delete Failed',
                                    backgroundColor: Colors.red,
                                  );
                                }
                              } catch (e) {
                                showCustomSnackBar(
                                  context,
                                  message: 'Internet error',
                                  backgroundColor: Colors.red,
                                );
                              } finally {
                                setState(() {
                                  isDeleting = false;
                                });
                              }
                            },
                      child: isDeleting
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(
                              Icons.backspace_outlined,
                              color: Colors.black,
                              size: 24,
                            ),
                    ),
                  ),*/
                ],
              ),
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
                        "waled"; // إذا كانت الرسالة من المستخدم الحالي
                    return Align(
                      alignment:
                          isMe ? Alignment.centerLeft : Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: isMe
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.end,
                        children: isMe
                            ? [
                                // الصورة من SharedPreferences
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: const Color(0xFF6797FF),
                                  backgroundImage:
                                      AssetImage("assets/images/emagechat.png"),
                                ),
                                // الرسالة
                                const SizedBox(width: 8),
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
                              ]
                            : [
                                // الصورة من SharedPreferences

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
                                const SizedBox(width: 8),
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: const Color(0xFF6797FF),
                                  backgroundImage:
                                      AssetImage("assets/images/emagechat.png"),
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

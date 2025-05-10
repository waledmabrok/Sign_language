import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:screenshot/screenshot.dart';
import '../constant/api_Ai.dart';
import '../constant/constant.dart';
import '../constant/translation_notifier.dart';
import 'home_page.dart';

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
  String translatedText = "";
  //String get displayedText => translationWords.join(" ");
  final ValueNotifier<List<String>> translationWordsNotifier =
      ValueNotifier([]);

  final screenshotController = ScreenshotController();
  String? userAvatar;
  Timer? _pollingTimer;
  @override
  void initState() {
    print("meetingId==========================================${meetingId}");
    super.initState();
    initAgora();
/*    _startPollingDeleteChar();*/
    ApiAI.startMeeting(onMeetingStarted: (id) {
      setState(() => meetingId = id);
    }, onMessagesUpdated: (msgs) {
      setState(() => messages = msgs);
    }, onTranslationUpdated: (text) {
      print("Received translation: $text");
      /*    if (text.isNotEmpty) {
        // إضافة الترجمة الجديدة مباشرة
        WidgetsBinding.instance.addPostFrameCallback((_) {
          translationWordsNotifier.value = [
            ...translationWordsNotifier.value,
            text,
          ];
        });
      }*/
    });
    print("meeting id=======$meetingId");
  }

/*  void _startPollingDeleteChar() {
    _pollingTimer = Timer.periodic(Duration(seconds: 5), (_) async {
      try {
        final response = await http.get(Uri.parse('$apiBase/delete_last_char'));
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == 'Done') {
          if (translationWords.isNotEmpty) {
            setState(() {
              translationWords.removeLast();
            });
          }
        }
      } catch (e) {
        print("Error in polling delete: $e");
      }
    });
  }*/
/*  void _startPollingDeleteChar() {
    _pollingTimer = Timer.periodic(Duration(seconds: 5), (_) async {
      try {
        final response = await http.get(Uri.parse('$apiBase/delete_last_char'));
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == 'Done') {
          final currentList = translationWordsNotifier.value;
          if (currentList.isNotEmpty) {
            // إزالة آخر حرف بشكل فوري
            WidgetsBinding.instance.addPostFrameCallback((_) {
              translationWordsNotifier.value = List.from(currentList)
                ..removeLast();
            });
          }
        }
      } catch (e) {
        print("Error in polling delete: $e");
      }
    });
  }*/

  @override
  void dispose() {
    _dispose();
    translationWordsNotifier.dispose();
    /*  _pollingTimer?.cancel();*/
    ApiAI.stopUpdates();
    messageController.dispose();
    super.dispose();
  }

  Future<void> sendMessage() async {
    final msg = messageController.text.trim();
    if (msg.isEmpty) return;
    await ApiAI.sendMessage(msg);
    messageController.clear();
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
    if (translationWordsNotifier.value.isNotEmpty) {
      String lastWord = translationWordsNotifier.value.last;
      if (lastWord.isNotEmpty) {
        String lastChar = lastWord[lastWord.length - 1].toLowerCase();
        if (lastChar.compareTo('a') >= 0 && lastChar.compareTo('z') <= 0) {
          imagePath = 'assets/images/image${lastChar}.png';
        }
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
          Stack(
            children: [
              // الفيديوهين جنب بعض
              Positioned(
                top: 48,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      // الفيديو المحلي
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
                      const SizedBox(width: 9),
                      // فيديو المستخدم الآخر
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

              // زر إنهاء المكالمة بأسفل يمين الشاشة
              Positioned(
                top: 220,
                right: 8,
                child: FloatingActionButton.small(
                  backgroundColor: Colors.red,
                  onPressed: () {
                    _engine.leaveChannel(); // مغادرة القناة

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const HomePage()), // عدل الصفحة حسب مشروعك
                      (route) => false,
                    );
                  },
                  child: const Icon(Icons.call_end, color: Colors.white),
                ),
              ),
            ],
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
                        ? Container(
                            width: double.infinity,
                            height: 90,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  12), // تعيين الزوايا لتكون دائرية
                              child: Image.asset(
                                imagePath,

                                width: double
                                    .infinity, // تعيين العرض ليتناسب مع الكونتينر
                                height: double
                                    .infinity, // تعيين الارتفاع ليتناسب مع الكونتينر
                                fit: BoxFit.cover,
                                // لتصغير الصورة داخل الـ Container بدون تشويه
                              ),
                            ),
                          )
                        : Container(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: ValueListenableBuilder<List<String>>(
                        valueListenable: translationWordsNotifier,
                        builder: (context, words, _) {
                          final text = words.join(" ");
                          return Text(
                            text.isNotEmpty
                                ? text
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
                  ),
                ),
              ],
            ),
          ),

          // ✅ Chat messages
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
                  padding: EdgeInsets.only(top: 16, bottom: 16),
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

          // ✅ Text input
          Positioned(
            bottom: 30,
            left: 24,
            right: 24,
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
                const SizedBox(width: 16),
                Container(
                  height: 40,
                  width: 49,
                  decoration: BoxDecoration(
                    color: Color(0xFF0051FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 24),
                    onPressed: sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

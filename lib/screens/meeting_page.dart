import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

const String appId = '73515717463e48ca8b401c7586bd6f5a';
const String channelName = 'testchannel';
const int uid = 0; // Let Agora assign UID
const String token = ''; // Leave empty for testing with appId only

class MeetingPage extends StatefulWidget {
  const MeetingPage({super.key});

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  late RtcEngine agoraEngine;
  bool isJoined = false;
  int? remoteUid;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    await _handlePermissions();

    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(appId: appId));

    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          print(" Joined channel");
          setState(() => isJoined = true);
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          print(" Remote user joined: $remoteUid");
          setState(() => this.remoteUid = remoteUid);
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          print(" Remote user left: $remoteUid");
          setState(() => this.remoteUid = null);
        },
        onError: (code, msg) {
          print(" Agora error: $code - $msg");
        },
      ),
    );

    await agoraEngine.enableVideo();
    await agoraEngine.startPreview();
    await agoraEngine.joinChannel(
      token: token,
      channelId: channelName,
      uid: uid,
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> _handlePermissions() async {
    final statuses = await [Permission.camera, Permission.microphone].request();

    if (statuses[Permission.camera]!.isPermanentlyDenied ||
        statuses[Permission.microphone]!.isPermanentlyDenied) {
      await openAppSettings();
      return;
    }

    if (!statuses[Permission.camera]!.isGranted ||
        !statuses[Permission.microphone]!.isGranted) {
      final retry = await [Permission.camera, Permission.microphone].request();

      if (!retry[Permission.camera]!.isGranted ||
          !retry[Permission.microphone]!.isGranted) {
        print(" Permissions denied");
        return;
      }
    }
  }

  @override
  void dispose() {
    agoraEngine.leaveChannel();
    agoraEngine.release();
    super.dispose();
  }

  Widget _renderLocalPreview() {
    if (isJoined) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: agoraEngine,
          canvas: const VideoCanvas(uid: 0),
          useAndroidSurfaceView: true,
        ),
      );
    } else {
      return const Center(child: Text('Joining channel, please wait...'));
    }
  }

  Widget _renderRemoteVideo() {
    if (remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: remoteUid!),
          connection: const RtcConnection(channelId: channelName),
          useAndroidSurfaceView: true,
        ),
      );
    } else {
      return const Center(child: Text('Waiting for remote user to join...'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Meeting'),
        backgroundColor: const Color(0xff0051FF),
      ),
      body: Column(
        children: [
          Expanded(child: _renderLocalPreview()),
          Expanded(child: _renderRemoteVideo()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          agoraEngine.leaveChannel();
          setState(() {
            isJoined = false;
            remoteUid = null;
          });
        },
        backgroundColor: const Color(0xff0051FF),
        child: const Icon(Icons.call_end),
      ),
    );
  }
}

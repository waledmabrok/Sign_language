import 'package:flutter/material.dart';
import 'package:flutter_application/screens/videoCall.dart';
import 'package:flutter_application/widgets/header_meeting.dart';
import 'package:flutter_application/widgets/video.dart';

import '../constant/SnacBar.dart';
import 'LocalCameraWithChatPage.dart';

class JoinMeeting extends StatefulWidget {
  final String title;

  const JoinMeeting({super.key, required this.title});

  @override
  _JoinMeetingState createState() => _JoinMeetingState();
}

class _JoinMeetingState extends State<JoinMeeting> {
  TextEditingController meetingIdController = TextEditingController();

  void _startMeeting() {
    if (meetingIdController.text.isEmpty) {
      showCustomSnackBar(
        context,
        icon: Icons.error_outline,
        message: 'Please enter a Meeting ID',
        backgroundColor: Colors.red,
      );
    } else if (meetingIdController.text.trim() != "7e4fbc40") {
      showCustomSnackBar(
        context,
        icon: Icons.error_outline,
        message: 'Invalid Meeting ID',
        backgroundColor: Colors.red,
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LocalCameraWithChatPage(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xff0051FF),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Spacer(),
                  Text(widget.title,
                      style: const TextStyle(
                        color: Color(0xff0051FF),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  const Spacer(),
                  const Spacer(),
                ],
              ),
              const Divider(
                color: Color(0xffCDCDCD),
                thickness: 2,
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: HeaderMeeting(
                  needDescription: true,
                  controller: meetingIdController,
                  title: 'Join Meeting',
                  nameTextField: 'Meeting ID ',
                  hintTextField: 'Enter Meeting ID (Optional)',
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: const VideoOnlySelector(),
              ),
              const SizedBox(height: 24),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffE9E9E9),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: Colors.black),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'CANCEL',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Inter"),
                        ),
                      ),
                    ),
                    const SizedBox(width: 23),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          backgroundColor: const Color(0xff0051FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: _startMeeting, // استخدام الدالة هنا
                        child: const Text(
                          'Start Meeting',
                          style: TextStyle(
                              fontFamily: "Inter",
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

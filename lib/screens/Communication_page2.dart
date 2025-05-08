import 'package:flutter/material.dart';
import 'package:flutter_application/screens/videoCall.dart';
import '../constant/SnacBar.dart';
import '../widgets/custom_text_field.dart';

class Comunucation2 extends StatefulWidget {
  const Comunucation2({super.key});

  @override
  State<Comunucation2> createState() => _Comunucation2State();
}

TextEditingController controllerMeeting = TextEditingController();
TextEditingController controllerAgoraChannel = TextEditingController();
TextEditingController controllerChatId = TextEditingController();

class _Comunucation2State extends State<Comunucation2> {
  // دالة للتحقق إذا كانت جميع الحقول مكتوبة
  bool isFormValid() {
    return controllerMeeting.text.isNotEmpty &&
        controllerAgoraChannel.text.isNotEmpty &&
        controllerChatId.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    controllerChatId.text = "7e4fbc40";
    controllerMeeting..text = "7e4fbc40";
    controllerAgoraChannel..text = "Signal";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
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
                  Spacer(),
                  Text(
                    "Communication with hand signal",
                    style: const TextStyle(
                      fontFamily: "Inter",
                      color: Color(0xff0051FF),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Spacer(),
                ],
              ),
              const Divider(
                color: Color(0xffCDCDCD),
                thickness: 2,
              ),
              SizedBox(height: 24),
              Padding(
                padding: EdgeInsetsDirectional.only(start: 16.0, end: 16),
                child: Text(
                  "  Meeting ID",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: EdgeInsetsDirectional.only(start: 16.0, end: 16),
                child: CustomTextField(
                  showCopyIcon: true,
                  hintText: "7e4fbc40",
                  borderRadius: 20,
                  controller: controllerMeeting,
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: EdgeInsetsDirectional.only(start: 16.0, end: 16),
                child: Text(
                  "  Agora Channel ID",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: EdgeInsetsDirectional.only(start: 16.0, end: 16),
                child: CustomTextField(
                  hintText: "7e4fbc40",
                  borderRadius: 20,
                  controller: controllerAgoraChannel,
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: EdgeInsetsDirectional.only(start: 16.0, end: 16),
                child: Text(
                  "  Chat ID",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: EdgeInsetsDirectional.only(start: 16.0, end: 16),
                child: CustomTextField(
                  hintText: "7e4fbc40",
                  borderRadius: 20,
                  controller: controllerChatId,
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
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
                    onPressed: () {
                      if (isFormValid()) {
                        print('START MEETING CLICKED');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyHomePage(
                              title: "t",
                            ), // الانتقال إلى صفحة الاجتماع
                          ),
                        );
                      } else {
                        showCustomSnackBar(context,
                            icon: Icons.error_outline,
                            message: 'Please fill all fields',
                            backgroundColor: Colors.red);
                        // عرض رسالة تحذيرية إذا لم يتم ملء الحقول
                      }
                    },
                    child: const Text(
                      'START MEETING',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
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

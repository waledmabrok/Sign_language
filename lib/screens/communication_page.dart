import 'package:flutter/material.dart';
import 'package:flutter_application/screens/meeting_page.dart';
import 'package:flutter_application/widgets/custom_text_field.dart';
import 'package:flutter_application/widgets/date&time.dart';
import 'package:flutter_application/widgets/header_meeting.dart';
import 'package:flutter_application/widgets/video.dart';
import 'package:intl/intl.dart';
import '../constant/SnacBar.dart';
import 'Communication_page2.dart';

class CommunicationPage extends StatefulWidget {
  final String title;
  const CommunicationPage({super.key, required this.title});

  @override
  _CommunicationPageState createState() => _CommunicationPageState();
}

class _CommunicationPageState extends State<CommunicationPage> {
  List<String> timeZones = [
    'GMT',
    'UTC',
    'CET',
    'EET',
    'AST',
    'EST',
    'CST',
    'MST',
    'PST',
    'AKST',
    'HST',
  ];
  String? selectedTimeZone;
  TextEditingController controllerDescription = TextEditingController();
  TextEditingController controllerMeetingTitle =
      TextEditingController(); // لمقابلة عنوان الاجتماع
  bool isSwitched = false;

  // دالة للتحقق من صحة البيانات المدخلة
  bool isFormValid() {
    return // تحقق من عنوان الاجتماع
        controllerDescription.text.isNotEmpty && // تحقق من الوصف
            selectedTimeZone !=
                null; // تحقق من حالة التبديل إذا كانت ضرورية في التطبيق
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
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
                    Spacer(),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontFamily: "Inter",
                        color: Color(0xff0051FF),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                const Divider(
                  color: Color(0xffCDCDCD),
                  thickness: 2,
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 16, end: 16),
                  child: HeaderMeeting(
                    title: 'Start New Meeting',
                    nameTextField: 'Meeting Title',
                    hintTextField: 'Enter meeting title (Optional)',
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 16, end: 16),
                  child: Row(
                    children: [
                      const Text(
                        'Schedule for later ?',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'No', // يتغير النص عند التبديل
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Switch(
                        value: isSwitched,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                          });
                        },
                        activeColor: const Color(0xffD9D9D9),
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: const Color(0xffE9E9E9),
                        activeTrackColor: const Color(0xff0051FF),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        isSwitched ? 'Yes' : "", // يتغير النص عند التبديل
                        style: const TextStyle(
                          color: Color(0xff0051FF),
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 27),
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 16, end: 16),
                  child: const Text(
                    'Description',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 16, end: 16),
                  child: CustomTextField(
                    hintText: 'Describe here',
                    borderRadius: 20,
                    controller: controllerDescription,
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 16, end: 16),
                  child: const DateAndTime(),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 16, end: 16),
                  child: const Text(
                    'Time Zone ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 16, end: 16),
                  child: CustomTextField(
                      isReadOnly: true,
                      hintText: 'Enter time zone',
                      borderRadius: 20,
                      controller: TextEditingController(text: selectedTimeZone),
                      icon: PopupMenuButton<String>(
                        icon: const Icon(
                          size: 28,
                          Icons.keyboard_arrow_down_rounded,
                          color: Color(0xff939393),
                        ),
                        onSelected: (String value) {
                          setState(() {
                            selectedTimeZone = value;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.white,
                        itemBuilder: (BuildContext context) {
                          return timeZones.map((String value) {
                            return PopupMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList();
                        },
                      )),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 16, end: 16),
                  child: const VideoOnlySelector(),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 16, end: 16),
                  child: Center(
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
                              print('CANCEL MEETING CLICKED');
                            },
                            child: const Text(
                              'CANCEL',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
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
                            onPressed: () {
                              if (isFormValid()) {
                                print('START MEETING CLICKED');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Comunucation2(),
                                  ),
                                );
                              } else {
                                // عرض رسالة تحذير إذا كانت الحقول فارغة
                                showCustomSnackBar(context,
                                    icon: Icons.error_outline,
                                    message: 'Please fill all fields',
                                    backgroundColor: Colors.red);
                              }
                            },
                            child: const Text(
                              'Next',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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

import 'package:flutter/material.dart';
import 'package:flutter_application/widgets/custom_text_field.dart';
import 'package:flutter_application/widgets/date&time.dart';
import 'package:flutter_application/widgets/header_meeting.dart';
import 'package:flutter_application/widgets/video.dart';
import 'package:intl/intl.dart';

class ScheduleMeeting extends StatefulWidget {
  final String title;
  const ScheduleMeeting({super.key, required this.title});

  @override
  _ScheduleMeetingState createState() => _ScheduleMeetingState();
}

class _ScheduleMeetingState extends State<ScheduleMeeting> {
  List<String> Rooms = [
    'Room 1',
    'Room 2',
    'Room 3',
    'Room 4',
    'Room 5',
    'Room 6',
    'Room 7',
    'Room 8',
    'Room 9',
    'Room 10',
  ];
  String? selectRoom;
  TextEditingController controllerDescription = TextEditingController();
// حالة التبديل

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
                    needDescription: false,
                    title: 'Schedule Your Meeting',
                    nameTextField: 'Meeting Name',
                    hintTextField: 'Enter Meeting Name Here',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: const Text(
                    'Meeting Room',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: CustomTextField(
                      isReadOnly: true,
                      hintText: 'Select the meeting room',
                      borderRadius: 20,
                      controller: TextEditingController(text: selectRoom),
                      icon: PopupMenuButton<String>(
                        onSelected: (value) {
                          setState(() {
                            selectRoom = value;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12), // حواف دائرية
                        ),
                        color: Colors.white,
                        icon: const Icon(
                          size: 28,
                          Icons.keyboard_arrow_down_rounded,
                          color: Color(0xff939393),
                        ),
                        itemBuilder: (BuildContext context) =>
                            Rooms.map((String value) {
                          return PopupMenuItem<String>(
                              value: value, child: Text(value));
                        }).toList(),
                      )),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
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
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: CustomTextField(
                    hintText: 'Describe here',
                    borderRadius: 20,
                    controller: controllerDescription,
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: const DateAndTime(),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: const Text('Meeting Link',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: CustomTextField(
                    hintText: 'Enter URL',
                    borderRadius: 20,
                    controller: controllerDescription,
                    icon: const Icon(Icons.link),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: const VideoOnlySelector(),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
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
                                fontSize: 14,
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
                              print('START MEETING CLICKED');
                            },
                            child: const Text(
                              'Start Meeting',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
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

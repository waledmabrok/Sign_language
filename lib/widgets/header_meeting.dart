import 'package:flutter/material.dart';
import 'package:flutter_application/widgets/custom_text_field.dart';

class HeaderMeeting extends StatefulWidget {
  final String title;
  final String nameTextField;
  final String hintTextField;
  final bool? needDescription;
  final TextEditingController? controller; // تخصيص الـ controller
  const HeaderMeeting(
      {super.key,
      required this.title,
      required this.nameTextField,
      required this.hintTextField,
      this.needDescription = true,
      this.controller});

  @override
  State<HeaderMeeting> createState() => _HeaderMeetingState();
}

class _HeaderMeetingState extends State<HeaderMeeting> {
  TextEditingController controllerMeeting = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 7),
        // إذا كان needDescription مفعّل، يتم عرض النص
        widget.needDescription == true
            ? const Text('Safe and secure video & audio conference',
                style: TextStyle(
                  color: Color(0xff939393),
                  fontSize: 12,
                ))
            : const SizedBox(),
        const SizedBox(height: 16),
        Text(
          widget.nameTextField,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        // استخدام الـ controller الممرر في الـ Widget إذا كان موجودًا
        CustomTextField(
          hintText: widget.hintTextField,
          borderRadius: 20,
          controller: widget.controller ??
              controllerMeeting, // التحقق من وجود الـ controller
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

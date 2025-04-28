import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // استدعاء مكتبة svg

class CustomContainerHome extends StatelessWidget {
  final String iconPath; // بدل IconData خليناها String (مسار الصورة)
  final String text;
  final Function() onPressed;

  const CustomContainerHome({
    super.key,
    required this.iconPath,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 94,
          height: 85,
          decoration: BoxDecoration(
            color: const Color(0xff0051FF),
            borderRadius: BorderRadius.circular(15),
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: SvgPicture.asset(
              iconPath,
              color: Colors.white,
              width: 48,
              height: 48,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 30,
          width: 100,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

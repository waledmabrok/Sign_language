import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final String text;
  final String value;
  const InfoRow({super.key, required this.text, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 17,
            color: Colors.grey,
            fontWeight: FontWeight.w400,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 17,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class CustomRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;
  const CustomRow(
      {super.key, required this.icon, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(icon, color: Colors.black, size: 24),
              const SizedBox(width: 24),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: onTap,
                icon: const Icon(Icons.arrow_forward_ios,
                    size: 18, color: Colors.black),
              )
            ],
          ),
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.5,
          height: 24,
        )
      ],
    );
  }
}

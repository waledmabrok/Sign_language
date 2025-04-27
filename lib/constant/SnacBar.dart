import 'package:flutter/material.dart';

void showCustomSnackBar(
  BuildContext context, {
  required String message,
  required Color backgroundColor,
  IconData? icon, // Make icon optional by using IconData?
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          if (icon != null) // Check if the icon is provided
            Icon(icon, color: Colors.white),
          if (icon != null) // Add spacing only if the icon exists
            const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style:
                  TextStyle(fontFamily: 'BalooBhaijaan2', color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 150), // 0.05seconds
    ),
  );
}

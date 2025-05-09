import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant/SnacBar.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? icon;
  final double borderRadius;
  final Function()? onTap;
  final bool? isReadOnly;
  final bool isPassword;
  final bool showCopyIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.icon,
    required this.borderRadius,
    this.onTap,
    this.isReadOnly,
    this.isPassword = false,
    this.showCopyIcon = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: widget.isReadOnly ?? false,
      onTap: widget.onTap,
      controller: widget.controller,
      obscureText: widget.isPassword ? _isObscure : false,
      decoration: InputDecoration(
        suffixIcon: widget.showCopyIcon
            ? IconButton(
                icon: Icon(Icons.copy, color: Colors.black),
                onPressed: () {
                  Clipboard.setData(
                      ClipboardData(text: widget.controller.text));
                  showCustomSnackBar(context,
                      message: "تم النسخ", backgroundColor: Colors.green);
                  /*   ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("تم النسخ")),
                  );*/
                },
              )
            : widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                      color: Color(0xff939393),
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  )
                : (widget.icon),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Color(0xff939393),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

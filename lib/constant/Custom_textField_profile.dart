import 'package:flutter/material.dart';

import 'MainColors.dart';

class CustomText extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool isRequired;
  final bool iconLeft;
  final IconData? prefixIcon;
  final bool isDropdown;
  final List<String>? items;
  final ValueChanged<String?>? onChanged;

  CustomText({
    this.controller,
    this.hintText = 'الاسم',
    this.validator,
    this.isRequired = false,
    this.iconLeft = false,
    this.prefixIcon,
    this.isDropdown = false,
    this.items,
    this.onChanged,
  });

  @override
  _CustomTextState createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  late FocusNode _focusNode;
  Color _iconColor = Colorss.icons;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
        _iconColor = _focusNode.hasFocus ? Colorss.mainColor : Colorss.icons;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveValidator = widget.validator ??
        (value) {
          return null;
        };

    if (widget.isDropdown) {
      return Container(
        height: 65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isFocused ? Colorss.mainColor : Colors.grey,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Center(
            child: DropdownButtonFormField<String>(
              value: widget.controller?.text.isEmpty ?? true
                  ? null
                  : widget.controller?.text,
              // قيمة مبدئية صحيحة
              decoration: InputDecoration(
                labelText: widget.hintText,
                labelStyle: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 18,
                  color: _isFocused ? Colorss.mainColor : Colorss.SecondText,
                ),
                hintStyle: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 15,
                  color: Colorss.SecondText,
                ),
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                filled: true,
                fillColor: Colors.transparent,
                prefixIcon: widget.isRequired
                    ? Icon(
                        widget.prefixIcon ?? Icons.person,
                        color: _iconColor,
                        size: 25,
                      )
                    : null,
                suffixIcon: widget.iconLeft
                    ? Icon(
                        Icons.person,
                        color: _iconColor,
                        size: 25,
                      )
                    : null,
              ),
              items: widget.items?.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: widget.onChanged,
              validator: effectiveValidator,
            ),
          ),
        ),
      );
    }

    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: Color(0xFFF6F8FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _isFocused ? Colorss.mainColor : Colors.grey,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Center(
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              labelText: widget.hintText,
              labelStyle: TextStyle(
                fontFamily: "Roboto",
                fontSize: 18,
                color: _isFocused ? Colorss.mainColor : Colorss.SecondText,
              ),
              hintStyle: TextStyle(
                fontFamily: "Roboto",
                fontSize: 15,
                color: Colorss.SecondText,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              border: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              filled: true,
              fillColor: Colors.transparent,
              prefixIcon: widget.isRequired
                  ? Icon(
                      widget.prefixIcon ?? Icons.person,
                      color: _iconColor,
                      size: 25,
                    )
                  : null,
              suffixIcon: widget.iconLeft
                  ? Icon(
                      Icons.person,
                      color: _iconColor,
                      size: 25,
                    )
                  : null,
            ),
            validator: effectiveValidator,
            textAlignVertical: TextAlignVertical.center,
          ),
        ),
      ),
    );
  }
}

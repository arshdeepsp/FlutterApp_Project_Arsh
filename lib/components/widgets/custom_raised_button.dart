// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  CustomRaisedButton(
      {Key? key,
      required this.child,
      required this.color,
      required this.borderColor,
      this.borderRadius = 6,
      required this.onPressed,
      this.height = 50,
      this.width,
      this.textColor = Colors.black,
      required this.isDisabled})
      : super(key: key);
  final Color borderColor;
  final Widget child;
  final Color color;
  final Color textColor;
  final double borderRadius;
  final VoidCallback onPressed;
  final double height;
  final double? width;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    var button = MaterialButton(
      textColor: textColor,
      disabledColor: Colors.deepPurple.shade300,
      elevation: 5,
      child: child,
      color: color,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor, width: 1),
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius),
        ),
      ),
      onPressed: isDisabled ? null : onPressed,
    );
    return width == null
        ? SizedBox(
            child: button,
            height: height,
          )
        : SizedBox(
            child: button,
            height: height,
            width: width,
          );
  }
}

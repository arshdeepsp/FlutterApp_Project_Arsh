// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  CustomElevatedButton({
    Key? key,
    required this.label,
    required this.color,
    required this.textColor,
    required this.onPressed,
    required this.icon,
    this.borderRadius = 6,
    this.height = 40,
  }) : super(key: key);
  final Widget label;
  final Widget icon;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;
  final double borderRadius;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton.icon(
        label: label,
        icon: icon,
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            primary: color,
            onPrimary: textColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(borderRadius),
              ),
            )),
      ),
      height: height,
    );
  }
}

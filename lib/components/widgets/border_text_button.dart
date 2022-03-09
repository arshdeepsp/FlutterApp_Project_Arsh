import 'package:flutter/material.dart';

import 'century_gothic_text.dart';

class BorderTextButton extends StatelessWidget {
  const BorderTextButton(
      {Key? key,
      required this.data,
      required this.borderColor,
      required this.borderRadius,
      required this.fontSize,
      required this.onPressed,
      required this.textColor,
      required this.overlayColor})
      : super(key: key);
  final String data;
  final Color textColor;
  final Color borderColor;
  final double fontSize;
  final double borderRadius;
  final VoidCallback onPressed;
  final Color overlayColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: CenturyGothicText(
          data: data,
          fontSize: fontSize,
          textColor: textColor,
          textAlign: TextAlign.center),
      onPressed: onPressed,
      style: ButtonStyle(
          splashFactory: InkRipple.splashFactory,
          overlayColor: MaterialStateProperty.all(overlayColor),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius))),
          side: MaterialStateProperty.all(
              BorderSide(width: 0.5, color: borderColor))),
    );
  }
}

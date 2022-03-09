import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText(
      {Key? key,
      required this.data,
      required this.fontFamily,
      required this.fontSize,
      required this.textColor,
      required this.textAlign,
      this.fontWeight})
      : super(key: key);
  final String data;
  final dynamic fontFamily;
  final double fontSize;
  final Color textColor;
  final TextAlign textAlign;
  final FontWeight? fontWeight;
  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      textAlign: textAlign,
      style: TextStyle(
          overflow: TextOverflow.ellipsis,
          fontFamily: fontFamily,
          fontSize: fontSize,
          color: textColor,
          fontWeight: fontWeight),
    );
  }
}

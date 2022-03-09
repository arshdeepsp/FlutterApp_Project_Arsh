import 'package:flutter/material.dart';

class CenturyGothicText extends StatelessWidget {
  const CenturyGothicText(
      {Key? key,
      required this.data,
      required this.fontSize,
      this.textColor,
      this.textAlign,
      this.fontWeight,
      this.textOverflow,
      this.fontStyle})
      : super(key: key);
  final String data;
  final double fontSize;
  final Color? textColor;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final TextOverflow? textOverflow;
  final FontStyle? fontStyle;
  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      textAlign: textAlign,
      overflow: textOverflow,
      style: TextStyle(
        fontFamily: 'CenturyGothic',
        fontSize: fontSize,
        color: textColor,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
      ),
    );
  }
}

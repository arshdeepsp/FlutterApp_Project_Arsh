import 'package:flutter/material.dart';

class LeftIconButton extends StatelessWidget {
  const LeftIconButton(
      {Key? key,
      required this.text,
      required this.iconData,
      required this.iconColor,
      required this.iconSize,
      required this.onPressed})
      : super(key: key);
  final String text;
  final IconData iconData;
  final Color iconColor;
  final double iconSize;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.grey.shade100)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            size: iconSize,
            color: iconColor,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: TextStyle(fontFamily: 'CenturyGothic', color: Colors.black),
          ),
        ],
      ),
    );
  }
}

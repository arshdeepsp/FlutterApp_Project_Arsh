// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors, duplicate_ignore

import 'package:flutter/material.dart';

class ToastedTextField extends StatelessWidget {
  ToastedTextField(
      {Key? key,
      required this.controller,
      required this.focusNode,
      required this.decoration,
      required this.obscureText,
      required this.offstage,
      required this.child})
      : super(key: key);
  final TextEditingController controller;
  final FocusNode focusNode;
  final InputDecoration decoration;
  final bool obscureText;
  final bool offstage;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          TextField(
            controller: controller,
            focusNode: focusNode,
            // ignore: prefer_const_constructors
            decoration: decoration,
            obscureText: obscureText,
          ),
          Offstage(offstage: offstage, child: child),
        ],
      ),
    );
  }
}

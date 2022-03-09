// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:tripd_travel_app/components/widgets/custom_raised_button.dart';
import 'package:tripd_travel_app/components/widgets/custom_text.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton(
      {Key? key,
      required String text,
      required bool isDisabled,
      required Color color,
      required Color textColor,
      required VoidCallback onPressed,
      required double height,
      required Color borderColor,
      required dynamic fontFamily,
      required double fontSize,
      double borderRadius=10})
      : assert(text != null),
        super(
            key: key,
            child: CustomText(
                data: text,
                textColor: textColor,
                fontFamily: fontFamily,
                fontSize: fontSize,
                textAlign: TextAlign.center),
            color: color,
            onPressed: onPressed,
            isDisabled: isDisabled,
            height: height,
            borderColor: borderColor,
            borderRadius: borderRadius);
}

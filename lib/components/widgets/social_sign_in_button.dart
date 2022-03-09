// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:tripd_travel_app/components/widgets/custom_elevated_button.dart';
import 'package:tripd_travel_app/components/widgets/custom_text.dart';

class SocialSignInButton extends CustomElevatedButton {
  SocialSignInButton({
    Key? key,
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
    required String logo,
    required dynamic fontFamily,
    required double fontSize,
  })  : assert(text != null),
        assert(logo != null),
        super(
          key: key,
          label: CustomText(
            data: text,
            fontFamily: fontFamily,
            fontSize: fontSize,
            textColor: textColor,
            textAlign: TextAlign.center,
          ),
          icon: Image.asset(logo),
          onPressed: onPressed,
          textColor: textColor,
          color: color,
        );
}

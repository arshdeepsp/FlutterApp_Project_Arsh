import 'package:flutter/material.dart';
import 'package:tripd_travel_app/theme/resources/colors.dart';

import 'custom_text.dart';

class StretchedTextButton extends StatelessWidget {
  const StretchedTextButton(
      {Key? key,
      required this.onPressed,
      required this.splashColor,
      this.textColor = Colors.black,
      this.child,
      this.data,
      this.borderColor,
      this.borderWidth,
      this.borderRadius})
      : super(key: key);
  final Widget? child;
  final void Function() onPressed;
  final Color splashColor;
  final Color textColor;
  final String? data;
  final Color? borderColor;
  final double? borderWidth;
  final double? borderRadius;

  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(borderRadius ?? 0))),
                    side: MaterialStateProperty.all(BorderSide(
                        width: borderWidth ?? 0.2,
                        color: borderColor ?? color1)),
                    overlayColor: MaterialStateProperty.all(splashColor)),
                onPressed: onPressed,
                child: child ??
                    CustomText(
                        data: data!,
                        fontFamily: 'CenturyGothic',
                        fontSize: 20,
                        textColor: textColor,
                        textAlign: TextAlign.center)))
      ],
    );
  }
}

import 'package:another_flushbar/flushbar.dart';

import 'package:flutter/material.dart';
import 'package:tripd_travel_app/components/widgets/century_gothic_text.dart';
import 'package:tripd_travel_app/theme/resources/colors.dart';

enum toastTypes { Success, Error }

showToast(
    {required String msg,
    required BuildContext context,
    // Color? color,
    toastTypes type = toastTypes.Error,
    int? duration}) {
  return Flushbar(
    borderRadius: BorderRadius.circular(20),
    backgroundColor: Colors.white,
    messageColor: color1,
    messageText: CenturyGothicText(
      data: msg,
      fontSize: 14,
      textColor: color1,
    ),
    flushbarPosition: FlushbarPosition.TOP,
    icon: Icon(
      type == toastTypes.Success ? Icons.check : Icons.info_outline,
      size: 28.0,
      color: type == toastTypes.Error ? Colors.red[600] : Colors.green[600],
    ),
    duration: Duration(seconds: duration ?? 2),
  )..show(context);
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tripd_travel_app/components/widgets/century_gothic_text.dart';
import 'package:tripd_travel_app/theme/resources/border_preset.dart';
import 'package:tripd_travel_app/theme/resources/color_code.dart';

class AuthExceptionDialog extends StatefulWidget {
  const AuthExceptionDialog({Key? key, required this.exception})
      : super(key: key);
  final Exception exception;
  @override
  _AuthExceptionDialogState createState() => _AuthExceptionDialogState();
}

class _AuthExceptionDialogState extends State<AuthExceptionDialog> {
  Color color1 = HexColor('6700E3');

  String _errorMessage() {
    Exception e = widget.exception;
    if (e is FirebaseAuthException) {
      return e.message!;
    } else {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderPresets.borderSide()),
      insetPadding: EdgeInsets.all(30),
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
        height: 220,
        width: double.infinity,
        child: Column(
          children: [
            CenturyGothicText(
                data: 'Authentication failed',
                fontSize: 17,
                textColor: Colors.black,
                textAlign: TextAlign.center),
            const Divider(
              thickness: 1.5,
              height: 20,
              indent: 10,
              endIndent: 10,
            ),
            Expanded(child: SizedBox()),
            CenturyGothicText(
                data: _errorMessage(),
                fontSize: 15,
                textColor: Colors.black,
                textAlign: TextAlign.center),
            Expanded(child: SizedBox()),
            Row(
              children: [
                Expanded(child: SizedBox()),
                TextButton(
                    style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(
                            Colors.deepPurple.shade400),
                        backgroundColor: MaterialStateProperty.all(color1),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)))),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: CenturyGothicText(
                        data: 'OK',
                        fontSize: 15,
                        textColor: Colors.white,
                        textAlign: TextAlign.center)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

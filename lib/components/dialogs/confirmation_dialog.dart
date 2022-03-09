import 'package:flutter/material.dart';
import 'package:tripd_travel_app/components/widgets/century_gothic_text.dart';
import 'package:tripd_travel_app/theme/resources/border_preset.dart';

class ConfirmationDialog extends StatefulWidget {
  const ConfirmationDialog({Key? key, required this.deletePlan})
      : super(key: key);
  final VoidCallback deletePlan;
  @override
  _ConfirmationDialogState createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  Color? get color1 => null;

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
        width: 200,
        child: Column(
          children: [
            CenturyGothicText(
                data: 'Confirm deletion',
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
              data: 'Are you sure you want to delete this plan?',
              fontSize: 15,
              textColor: Colors.black,
              textAlign: TextAlign.center,
              textOverflow: TextOverflow.clip,
            ),
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
                      widget.deletePlan();
                      Navigator.pop(context);
                    },
                    child: CenturyGothicText(
                        data: 'Yes',
                        fontSize: 15,
                        textColor: Colors.black,
                        textAlign: TextAlign.center)),
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
                        data: 'No',
                        fontSize: 15,
                        textColor: Colors.black,
                        textAlign: TextAlign.center)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

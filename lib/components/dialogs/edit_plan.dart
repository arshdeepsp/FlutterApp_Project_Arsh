import 'package:flutter/material.dart';
import 'package:tripd_travel_app/components/dialogs/confirmation_dialog.dart';
import 'package:tripd_travel_app/components/widgets/century_gothic_text.dart';
import 'package:tripd_travel_app/theme/resources/border_preset.dart';
import 'package:tripd_travel_app/theme/resources/colors.dart';

class EditPlan extends StatefulWidget {
  const EditPlan({Key? key, this.deletePlan}) : super(key: key);
  final VoidCallback? deletePlan;
  @override
  _EditPlanState createState() => _EditPlanState();
}

class _EditPlanState extends State<EditPlan> {
  bool? canInvite;
  bool? privateGroup;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderPresets.borderSide()),
      child: SingleChildScrollView(
        child: Container(
            height: 320,
            width: double.infinity,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Row(
                          children: [
                            Expanded(child: SizedBox()),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.close),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {},
                              child: CenturyGothicText(
                                  textColor: Colors.black,
                                  data: 'Add Someone',
                                  fontSize: 15),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {},
                              child: CenturyGothicText(
                                  textColor: Colors.black,
                                  data: 'Remove Someone',
                                  fontSize: 15),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          children: [
                            CenturyGothicText(
                                data: 'Can people invite others?',
                                fontSize: 15,
                                textColor: Colors.black,
                                textAlign: TextAlign.left),
                            Transform.scale(
                              scale: 0.75,
                              child: Switch.adaptive(
                                  activeTrackColor: Colors.deepPurple.shade300,
                                  activeColor: color1,
                                  value: canInvite ?? true,
                                  onChanged: (isOn) {
                                    setState(() {
                                      canInvite = isOn;
                                    });
                                  }),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          children: [
                            CenturyGothicText(
                                data: 'This plan is private',
                                fontSize: 15,
                                textColor: Colors.black,
                                textAlign: TextAlign.left),
                            Transform.scale(
                              scale: 0.75,
                              child: Switch.adaptive(
                                  activeTrackColor: Colors.deepPurple.shade300,
                                  activeColor: color1,
                                  value: privateGroup ?? true,
                                  onChanged: (isOn) {
                                    setState(() {
                                      privateGroup = isOn;
                                    });
                                  }),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                        child: CenturyGothicText(
                            textOverflow: TextOverflow.clip,
                            data:
                                'Private plans won\'t be shown in the feed. Only you and invitees can see these plans.',
                            fontSize: 11,
                            textColor: Colors.grey.shade500,
                            textAlign: TextAlign.left),
                      ),
                      Expanded(child: SizedBox()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.grey.shade100),
                              ),
                              onPressed: () async {
                                await showDialog(
                                    context: context,
                                    builder: (BuildContext context2) =>
                                        ConfirmationDialog(
                                          deletePlan: () {
                                            widget.deletePlan!();
                                          },
                                        ),
                                    barrierDismissible: false);
                              },
                              child: CenturyGothicText(
                                  data: 'Delete',
                                  fontSize: 14,
                                  textColor: Colors.red,
                                  textAlign: TextAlign.center)),
                          Expanded(child: SizedBox()),
                          TextButton(
                              style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.deepPurple.shade400),
                                  backgroundColor:
                                      MaterialStateProperty.all(color1)),
                              onPressed: () {},
                              child: CenturyGothicText(
                                  data: 'Save',
                                  fontSize: 13,
                                  textColor: Colors.white,
                                  textAlign: TextAlign.center))
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

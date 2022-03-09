import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/dialogs/add_friends.dart';
import 'package:tripd_travel_app/components/widgets/century_gothic_text.dart';
import 'package:tripd_travel_app/components/widgets/custom_daterange.dart';
import 'package:tripd_travel_app/components/widgets/custom_toast.dart';
import 'package:tripd_travel_app/components/widgets/left_icon_button.dart';
import 'package:tripd_travel_app/models/date.dart';
import 'package:tripd_travel_app/services/auth_service.dart';
import 'package:tripd_travel_app/services/plan_service.dart';
import 'package:tripd_travel_app/theme/resources/border_preset.dart';
import 'package:tripd_travel_app/theme/resources/color_code.dart';
import '../widgets/custom_text.dart';

class PlanDialog extends StatefulWidget {
  const PlanDialog(
      {Key? key, required this.id, required this.groupId, this.callback})
      : super(key: key);
  @override
  _PlanDialogState createState() => _PlanDialogState();

  final String id;
  final String groupId;
  final VoidCallback? callback;
}

class _PlanDialogState extends State<PlanDialog> {
  Color color1 = HexColor('6700E3');

  bool privateGroup = false;
  bool canInvite = false;
  bool fillDetails = true;

  TextEditingController planController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  FocusNode planFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();

  String? description;
  String imageHintText = 'Add image';

  DateTimeRange? dateRange;
  Date date = Date('', '');

  ImagePicker imagePicker = ImagePicker();
  var file;
  var currentFile;

  Future pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
        start: DateTime.now(), end: DateTime.now().add(Duration(days: 3)));
    final newDateRange = /*await showDateRangePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year + 2),
        initialDateRange: dateRange ?? initialDateRange);*/
        await showCustomDateRange(
            context: context,
            initialDateRange: initialDateRange,
            dateRange: dateRange);

    if (newDateRange == null) {
      return;
    }
    setState(() {
      dateRange = newDateRange;
    });
    date.fromDate = formatDate(dateRange!.start, [yyyy, "-", mm, "-", dd]);
    date.toDate = formatDate(dateRange!.end, [yyyy, "-", mm, "-", dd]);
  }

  String state = "";

  String fromDate() {
    return formatDate(dateRange!.start, [dd, " ", M, " ", "'", yy]);
  }

  String toDate() {
    return formatDate(dateRange!.end, [dd, " ", M, " ", "'", yy]);
  }

  void refreshImageHint() {
    if (currentFile == null) {
      setState(() {
        imageHintText = 'Add image';
      });
    } else {
      setState(() {
        imageHintText = 'Change image';
      });
    }
  }

  Future<void> _completePlan() async {
    if (date.fromDate.isEmpty || date.toDate.isEmpty) {
      showToast(msg: "Please select date range for the plan", context: context);
      return;
    }
    if (planController.text.isEmpty) {
      showToast(msg: "Please Enter Plan Name", context: context);
      return;
    }
    final planService = Provider.of<PlanService>(context, listen: false);
    final auth = Provider.of<AuthService>(context, listen: false);
    final idToken = await auth.currentUser!.getIdToken();

    await planService.completePlan(
        token: idToken,
        id: widget.id,
        canInvite: canInvite,
        privateGroup: privateGroup,
        name: planController.text,
        description: description,
        fromDate: date.fromDate,
        toDate: date.toDate,
        file: currentFile,
        context: context,
        callback: widget.callback);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderPresets.borderSide()),
      child: SingleChildScrollView(
        child: Container(
            height: (description == null || description!.isEmpty)
                ? 580
                : 580 + ((description!.length / 35).ceilToDouble()) * 18,
            width: double.infinity,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                  child: Column(
                    children: [
                      Text(
                        'Create a plan',
                        style: TextStyle(
                            fontFamily: 'CenturyGothic',
                            fontSize: 16,
                            color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      const Divider(
                        height: 25,
                        thickness: 1,
                        indent: 30,
                        endIndent: 30,
                      ),
                      Expanded(child: SizedBox()),
                      CustomText(
                          data:
                              'You can add more stuff to this plan once it\'s created',
                          fontFamily: 'CenturyGothic',
                          fontSize: 12,
                          textColor: Colors.black,
                          textAlign: TextAlign.left),
                      LeftIconButton(
                        text: 'Add friends',
                        iconData: Icons.person_add_alt_1,
                        iconColor: color1,
                        iconSize: 30,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AddFriends(
                                  groupId: widget.groupId,
                                );
                              });
                        },
                      ),
                      TextButton(
                        onPressed: () {
                          pickDateRange(context);
                        },
                        child: Text(
                          (date.fromDate.isEmpty || date.toDate.isEmpty)
                              ? 'Dates'
                              : fromDate() + '  -  ' + toDate(),
                          style: TextStyle(
                              fontFamily: 'CenturyGothic',
                              color: Colors.black,
                              fontSize: 14),
                        ),
                        style: ButtonStyle(
                            side: MaterialStateProperty.all(
                                BorderSide(width: 1, color: color1)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            overlayColor: MaterialStateProperty.all(
                                Colors.grey.shade100)),
                      ),
                      Expanded(child: SizedBox()),
                      Row(
                        children: [
                          Expanded(child: SizedBox()),
                          TextField(
                            controller: planController,
                            cursorColor: color1,
                            maxLength: 35,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: planController.clear,
                                icon: Icon(
                                  Icons.close,
                                  size: 20,
                                ),
                              ),
                              constraints:
                                  BoxConstraints(maxHeight: 65, maxWidth: 300),
                              hintText: 'Name your plan',
                              hintStyle: TextStyle(fontFamily: 'CenturyGothic'),
                              contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: color1, width: 0.5),
                              ),
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Expanded(child: SizedBox()),
                        ],
                      ),
                      Expanded(child: SizedBox()),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          children: [
                            CenturyGothicText(
                                data: 'This plan is private',
                                fontSize: 13,
                                textColor: Colors.black,
                                textAlign: TextAlign.left),
                            Transform.scale(
                              scale: 0.75,
                              child: Switch.adaptive(
                                  activeTrackColor: Colors.deepPurple.shade300,
                                  activeColor: color1,
                                  value: privateGroup,
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
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          children: [
                            CenturyGothicText(
                                data:
                                    'Private plans won\'t be shown in the feed.\nOnly you and invitees can see these plans.',
                                fontSize: 12,
                                textColor: Colors.grey.shade500,
                                textAlign: TextAlign.left),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          children: [
                            CenturyGothicText(
                                data: 'Can people invite others?',
                                fontSize: 13,
                                textColor: Colors.black,
                                textAlign: TextAlign.left),
                            Transform.scale(
                              scale: 0.75,
                              child: Switch.adaptive(
                                  activeTrackColor: Colors.deepPurple.shade300,
                                  activeColor: color1,
                                  value: canInvite,
                                  onChanged: (isOn) {
                                    setState(() {
                                      canInvite = isOn;
                                    });
                                  }),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LeftIconButton(
                            text: imageHintText,
                            iconData: Icons.image,
                            iconColor: color1,
                            iconSize: 30,
                            onPressed: () async {
                              file = await imagePicker.pickImage(
                                  source: ImageSource.gallery);
                              if (file != null)
                                setState(() {
                                  currentFile = file;
                                });
                              refreshImageHint();
                            },
                          ),
                          if (currentFile != null)
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border:
                                        Border.all(width: 1, color: color1)),
                                child: IconButton(
                                    padding: EdgeInsets.all(0),
                                    iconSize: 20,
                                    color: color1,
                                    tooltip: 'Remove image',
                                    splashColor: color1,
                                    splashRadius: 30,
                                    onPressed: () {
                                      setState(() {
                                        file = null;
                                        currentFile = null;
                                      });
                                      refreshImageHint();
                                    },
                                    icon: Icon(Icons.close)),
                              ),
                            ),
                        ],
                      ),
                      if (description != null && description!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                fillDetails = false;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(width: 0.5, color: color1),
                                  borderRadius: BorderRadius.circular(5)),
                              width: 500,
                              child: Text.rich(
                                TextSpan(
                                    text: description!.replaceAll('\n', ' '),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'CenturyGothic',
                                        fontSize: 13)),
                                textAlign: TextAlign.left,
                              ),
                              padding: EdgeInsets.all(10),
                            ),
                          ),
                        ),
                      Expanded(child: SizedBox()),
                      TextButton(
                          style: ButtonStyle(
                              side: MaterialStateProperty.all(
                                  BorderSide(width: 1, color: color1)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              overlayColor: MaterialStateProperty.all(
                                  Colors.deepPurple.shade200)),
                          onPressed: () {
                            setState(() {
                              fillDetails = false;
                            });
                          },
                          child: CenturyGothicText(
                              textOverflow: TextOverflow.clip,
                              data:
                                  (description == null || description!.isEmpty)
                                      ? 'Add description'
                                      : 'Edit description',
                              fontSize: 13,
                              textColor: Colors.black,
                              textAlign: TextAlign.center)),
                      Expanded(child: SizedBox()),
                      const Divider(
                        height: 25,
                        thickness: 1,
                        indent: 30,
                        endIndent: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.grey.shade100),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: CenturyGothicText(
                                  data: 'Cancel',
                                  fontSize: 14,
                                  textColor: Colors.black,
                                  textAlign: TextAlign.center)),
                          Expanded(child: SizedBox()),
                          TextButton(
                              style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.deepPurple.shade400),
                                  backgroundColor:
                                      MaterialStateProperty.all(color1)),
                              onPressed: () async {
                                await _completePlan();
                              },
                              child: CenturyGothicText(
                                  data: 'Create',
                                  fontSize: 13,
                                  textColor: Colors.white,
                                  textAlign: TextAlign.center))
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(0),
                  child: Offstage(
                    offstage: fillDetails,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      height: double.infinity,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          CenturyGothicText(
                              data: 'Plan descripton',
                              fontSize: 20,
                              textColor: Colors.black,
                              textAlign: TextAlign.center),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(child: SizedBox()),
                              TextField(
                                controller: descriptionController,
                                focusNode: descriptionFocusNode,
                                cursorColor: color1,
                                maxLines: 8,
                                maxLength: 200,
                                maxLengthEnforcement:
                                    MaxLengthEnforcement.enforced,
                                decoration: InputDecoration(
                                  suffixIcon: Padding(
                                    padding: EdgeInsets.all(1),
                                    child: Container(
                                        color: Colors.white,
                                        height: 170,
                                        child: Column(
                                          children: [
                                            Expanded(child: SizedBox()),
                                            IconButton(
                                              onPressed:
                                                  descriptionController.clear,
                                              icon: Icon(
                                                Icons.close,
                                                size: 20,
                                                color: color1,
                                              ),
                                            ),
                                            Expanded(child: SizedBox())
                                          ],
                                        )),
                                  ),
                                  constraints: BoxConstraints(
                                      maxHeight: 500, maxWidth: 320),
                                  hintText:
                                      'Provide a short description of your plan',
                                  hintStyle: TextStyle(
                                      fontFamily: 'CenturyGothic',
                                      fontSize: 12),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 20, 20, 20),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: color1, width: 0.5),
                                  ),
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Expanded(child: SizedBox()),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(12),
                            child: Row(
                              children: [
                                TextButton(
                                    style: ButtonStyle(
                                        overlayColor: MaterialStateProperty.all(
                                            Colors.deepPurple.shade400),
                                        backgroundColor:
                                            MaterialStateProperty.all(color1)),
                                    onPressed: () {
                                      descriptionFocusNode.unfocus();
                                      setState(() {
                                        fillDetails = true;
                                      });
                                    },
                                    child: CenturyGothicText(
                                        data: 'Cancel',
                                        fontSize: 13,
                                        textColor: Colors.white,
                                        textAlign: TextAlign.center)),
                                Expanded(child: SizedBox()),
                                TextButton(
                                    style: ButtonStyle(
                                        overlayColor: MaterialStateProperty.all(
                                            Colors.deepPurple.shade400),
                                        backgroundColor:
                                            MaterialStateProperty.all(color1)),
                                    onPressed: () {
                                      descriptionFocusNode.unfocus();
                                      setState(() {
                                        description =
                                            descriptionController.text;
                                        fillDetails = true;
                                      });
                                    },
                                    child: CenturyGothicText(
                                        data: 'Save and go back',
                                        fontSize: 13,
                                        textColor: Colors.white,
                                        textAlign: TextAlign.center)),
                              ],
                            ),
                          ),
                          Expanded(child: SizedBox()),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

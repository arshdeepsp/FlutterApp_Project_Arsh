import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/widgets/custom_toast.dart';
import 'package:tripd_travel_app/components/widgets/left_icon_button.dart';
import 'package:tripd_travel_app/services/auth_service.dart';
import 'package:tripd_travel_app/services/group_service.dart';
import 'package:tripd_travel_app/theme/resources/border_preset.dart';
import 'package:tripd_travel_app/theme/resources/color_code.dart';
import 'add_friends.dart';
import '../widgets/century_gothic_text.dart';

class GroupDialog extends StatefulWidget {
  const GroupDialog({Key? key, required this.groupId}) : super(key: key);

  final String groupId;
  @override
  _GroupDialogState createState() => _GroupDialogState();
}

class _GroupDialogState extends State<GroupDialog> {
  TextEditingController groupNameController = TextEditingController();

  Color color1 = HexColor('6700E3');

  Future<void> _completeGroup() async {
    if (groupNameController.text.isEmpty) {
      showToast(msg: "Please Enter Group Name", context: context);
      return;
    }
    final groupService = Provider.of<GroupService>(context, listen: false);
    final auth = Provider.of<AuthService>(context, listen: false);
    final idToken = await auth.currentUser!.getIdToken();

    await groupService.createGroup(
        token: idToken,
        id: widget.groupId,
        name: groupNameController.text,
        context: context);
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
            height: 260,
            width: double.infinity,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Column(
                    children: [
                      Text(
                        'Create a Group',
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
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(50)),
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: groupNameController,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              fontSize: 15,
                              fontFamily: 'CenturyGothic',
                            ),
                            hintText: 'Name your group',
                            contentPadding: EdgeInsets.all(10),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(color: color1)),
                          ),
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      LeftIconButton(
                        text: 'Invite people',
                        iconData: Icons.person_add_alt_1,
                        iconColor: color1,
                        iconSize: 40,
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
                      CenturyGothicText(
                          data: 'You can invite others now or later',
                          fontSize: 11,
                          textColor: Colors.black,
                          textAlign: TextAlign.center),
                      Expanded(child: SizedBox()),
                      Row(
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
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50))),
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.deepPurple.shade400),
                                  backgroundColor:
                                      MaterialStateProperty.all(color1)),
                              onPressed: () {
                                _completeGroup();
                              },
                              child: CenturyGothicText(
                                  data: 'Create',
                                  fontSize: 15,
                                  textColor: Colors.white,
                                  textAlign: TextAlign.center))
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

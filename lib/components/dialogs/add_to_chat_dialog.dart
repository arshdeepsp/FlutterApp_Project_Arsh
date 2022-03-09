import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/widgets/century_gothic_text.dart';
import 'package:tripd_travel_app/components/widgets/custom_checkbox.dart';
import 'package:tripd_travel_app/services/auth_service.dart';
import 'package:tripd_travel_app/services/group_service.dart';
import 'package:tripd_travel_app/services/socket_service.dart';
import 'package:tripd_travel_app/theme/resources/border_preset.dart';
import 'package:tripd_travel_app/theme/resources/colors.dart';
import 'package:tripd_travel_app/theme/resources/custom_scroll_behaviour.dart';

class AddToChatDialog extends StatefulWidget {
  const AddToChatDialog(
      {Key? key, required this.type, required this.typeId, required this.image})
      : super(key: key);

  final String type;
  final String typeId;
  final String image;

  @override
  _AddToChatDialogState createState() => _AddToChatDialogState();
}

class _AddToChatDialogState extends State<AddToChatDialog> {
  List? groupsList;
  // String? selectedGroupId;
  // List? selectedGroupMembers;
  List<String?> selectedGroupIds = [];

  @override
  void initState() {
    getUserGroups();
    super.initState();
  }

  void getUserGroups() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    var idToken = await auth.currentUser!.getIdToken();
    // print(idToken);

    final groupService = Provider.of<GroupService>(context, listen: false);
    var allGroups = await groupService.getUserGroups(token: idToken);
    print(allGroups);

    setState(() {
      groupsList = allGroups;
    });
  }

  void shareInChats() async {
    if (selectedGroupIds.isEmpty) {
      return;
    } else {
      final socket = Provider.of<SocketService>(context, listen: false);
      final auth = Provider.of<AuthService>(context, listen: false);
      var idToken = await auth.currentUser!.getIdToken();
      selectedGroupIds.forEach((groupId) {
        socket.sendContentMessage(
            type: widget.type,
            groupId: groupId!,
            typeId: widget.typeId,
            token: idToken,
            image: widget.image);
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: EdgeInsets.all(30),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderPresets.borderSide()),
        child: Container(
            height: 400,
            // height: MediaQuery.of(context).size.height / 6,

            child: groupsList == null
                ? Container(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Container(
                    padding: EdgeInsets.all(30),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: ScrollConfiguration(
                              behavior: MyBehavior(),
                              child: SingleChildScrollView(
                                child: Column(
                                    children: [
                                  CenturyGothicText(
                                      textOverflow: TextOverflow.ellipsis,
                                      data: "Share in a chat",
                                      fontSize: 18),
                                  ...groupsList!.map((group) => Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // InkWell(
                                            //     borderRadius: BorderRadius.circular(20),
                                            //     child: Image.network(group["profilePic"],
                                            //         height: 50, width: 50)),
                                            // SizedBox(width: 8),
                                            Expanded(
                                              child: CenturyGothicText(
                                                  textOverflow:
                                                      TextOverflow.ellipsis,
                                                  data: group['name'],
                                                  fontSize: 15),
                                            ),

                                            CustomCheckbox(
                                                key: UniqueKey(),
                                                isChecked: selectedGroupIds
                                                    .contains(group["id"]),
                                                onToggle: (bool? isChecked) => {
                                                      if (isChecked != null &&
                                                          isChecked)
                                                        {
                                                          selectedGroupIds
                                                              .add(group["id"])
                                                        }
                                                      else
                                                        {
                                                          selectedGroupIds
                                                              .remove(
                                                                  group["id"])
                                                        },
                                                      // print(selectedInvitees)
                                                    }),
                                          ]))
                                ].toList()),
                              ),
                            ),
                          ),
                          TextButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.deepPurple.shade400),
                                  backgroundColor:
                                      MaterialStateProperty.all(color1)),
                              onPressed: () {
                                shareInChats();
                              },
                              child: CenturyGothicText(
                                  data: 'Share',
                                  fontSize: 15,
                                  textColor: Colors.white,
                                  textAlign: TextAlign.center))
                        ]),
                  )));
  }
}

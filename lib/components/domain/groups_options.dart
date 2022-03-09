import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/widgets/century_gothic_text.dart';
import 'package:tripd_travel_app/components/widgets/custom_checkbox.dart';
import 'package:tripd_travel_app/services/auth_service.dart';
// ignore: unused_import
import 'package:tripd_travel_app/services/collection_service.dart';
import 'package:tripd_travel_app/services/group_service.dart';
import 'package:tripd_travel_app/theme/resources/color_code.dart';

class GroupsOptions extends StatefulWidget {
  GroupsOptions({Key? key, this.groupId}) : super(key: key);
  final groupId;
  @override
  _GroupsOptionsState createState() => _GroupsOptionsState();
}

class _GroupsOptionsState extends State<GroupsOptions> {
  List? groupsList;
  String? selectedGroupId;
  List? selectedGroupMembers;
  List<String?> selectedInvitees = [];
  final _groupService = GroupService();
  Color color1 = HexColor('6700E3');

  void getUserGroups() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    var idToken = await auth.currentUser!.getIdToken();
    // print(idToken);

    final groupService = Provider.of<GroupService>(context, listen: false);
    var allGroups = await groupService.getUserGroups(token: idToken);

    setState(() {
      groupsList = allGroups;
    });
  }

  Future<void> inviteMembers() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    var idToken = await auth.currentUser!.getIdToken();
    await _groupService.inviteMembers(
        token: idToken,
        groupdId: widget.groupId,
        members: selectedInvitees,
        context: context,
        invitationType: "planInvitation",
        isEmail: false);

    // print(response.toString());
  }

  void selectGroup(value) {
    // print(selectedInvitees);
    setState(() {
      selectedGroupId = value;
      selectedGroupMembers =
          groupsList!.firstWhere((group) => group["id"] == value)!["members"];
      // print(
      //     groupsList!.firstWhere((group) => group["id"] == value)!["members"]);
    });
  }

  @override
  void initState() {
    super.initState();
    getUserGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Column(
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                    child: Column(
                        children: groupsList == null
                            ? []
                            : groupsList!
                                .map((item) => RadioListTile<String>(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 0),
                                      title: Text(item["name"]),
                                      value: item["id"],
                                      groupValue: selectedGroupId,
                                      onChanged: selectGroup,
                                    ))
                                .toList()),
                  ),
                ]),
                const Divider(
                  thickness: 1,
                ),
                selectedGroupMembers == null
                    ? Container()
                    : Column(
                        children: selectedGroupMembers!
                            .map((member) => Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Row(children: [
                                    CustomCheckbox(
                                        key: UniqueKey(),
                                        isChecked: selectedInvitees
                                            .contains(member["userId"]),
                                        onToggle: (bool? isChecked) => {
                                              if (isChecked != null &&
                                                  isChecked)
                                                {
                                                  selectedInvitees
                                                      .add(member["userId"])
                                                }
                                              else
                                                {
                                                  selectedInvitees
                                                      .remove(member["userId"])
                                                },
                                              // print(selectedInvitees)
                                            }),
                                    ClipOval(
                                      child: Image.network(
                                        member["profilePic"],
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Container(
                                      width: 200,
                                      child: CenturyGothicText(
                                        data: member['username'],
                                        fontSize: 13,
                                        textOverflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ]),
                                ))
                            .toList())
              ],
            ),
          )),
          const Divider(
            height: 0,
            thickness: 2,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                    overlayColor:
                        MaterialStateProperty.all(Colors.deepPurple.shade400),
                    backgroundColor: MaterialStateProperty.all(color1)),
                onPressed: () {
                  inviteMembers();
                },
                child: CenturyGothicText(
                    data: 'Add',
                    fontSize: 15,
                    textColor: Colors.white,
                    textAlign: TextAlign.center)),
          )
        ],
      ),
    );
    // .toList()))
    // ));
  }
}

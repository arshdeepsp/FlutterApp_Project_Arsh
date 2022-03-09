import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/widgets/century_gothic_text.dart';
import 'package:tripd_travel_app/components/widgets/custom_checkbox.dart';
import 'package:tripd_travel_app/services/auth_service.dart';
import 'package:tripd_travel_app/services/group_service.dart';
import 'package:tripd_travel_app/services/profile_service.dart';
import 'package:tripd_travel_app/theme/resources/color_code.dart';

class FollowersOptions extends StatefulWidget {
  FollowersOptions({Key? key, this.groupId}) : super(key: key);
  final groupId;
  @override
  _FollowersOptionsState createState() => _FollowersOptionsState();
}

class _FollowersOptionsState extends State<FollowersOptions> {
  final profile = Profile();
  List<String?> selectedInvitees = [];
  List? followers = [];
  final _groupService = GroupService();

  Color color1 = HexColor('6700E3');

  void getAllFollowers() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    var idToken = await auth.currentUser!.getIdToken();
    var followersResp = await profile.getFollowers(token: idToken);
    if (followersResp["status"]) {
      setState(() {
        followers = followersResp["data"];
      });
    }
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

  @override
  void initState() {
    super.initState();
    getAllFollowers();
  }

  @override
  Widget build(BuildContext context) {
    return followers == null
        ? Container()
        : Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Column(
                    children: followers!.map((member) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Row(children: [
                          CustomCheckbox(
                              key: UniqueKey(),
                              isChecked:
                                  selectedInvitees.contains(member["userId"]),
                              onToggle: (bool? isChecked) => {
                                    if (isChecked != null && isChecked)
                                      {selectedInvitees.add(member["userId"])}
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
                          SizedBox(width: 10),
                          Text(member["username"]),
                        ]),
                      );
                    }).toList(),
                  ),
                ),
              ),
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
                        overlayColor: MaterialStateProperty.all(
                            Colors.deepPurple.shade400),
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
            ]),
          );
  }
}

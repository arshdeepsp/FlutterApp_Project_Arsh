import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/domain/followers_options.dart';
import 'package:tripd_travel_app/components/domain/groups_options.dart';
import 'package:tripd_travel_app/components/widgets/century_gothic_text.dart';
import 'package:tripd_travel_app/services/auth_service.dart';
import 'package:tripd_travel_app/services/group_service.dart';
import 'package:tripd_travel_app/theme/resources/border_preset.dart';
import 'package:tripd_travel_app/theme/resources/color_code.dart';

enum AddFriendsOptions { Groups, Followers, Facebook, Email, Contacts }

class AddFriends extends StatefulWidget {
  const AddFriends({
    Key? key,
    required this.groupId,
  }) : super(key: key);
  final String groupId;

  @override
  _AddFriendsState createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  Color color1 = HexColor('6700E3');

  TextEditingController _emailController = TextEditingController();
  String get _invitee => _emailController.text;

  AddFriendsOptions? selectedOption = AddFriendsOptions.Groups;
  List<String> members = [];

  final _groupService = GroupService();

  Future<void> inviteMembers(
      {isEmail = false, invitationType, inviteeIds}) async {
    final auth = Provider.of<AuthService>(context, listen: false);
    var idToken = await auth.currentUser!.getIdToken();

    await _groupService.inviteMembers(
        token: idToken,
        groupdId: widget.groupId,
        members: inviteeIds != null ? inviteeIds : members,
        context: context,
        invitationType: "groupInvitation",
        isEmail: isEmail);

    // print(response.toString());
  }

  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderPresets.borderSide()),
        child: Container(
            padding: EdgeInsets.fromLTRB(2, 15, 2, 5),
            height: 600,
            width: double.infinity,
            child: Column(children: [
              CenturyGothicText(
                  data: 'Invite Others',
                  fontSize: 16,
                  textColor: Colors.black,
                  textAlign: TextAlign.center),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: DefaultTabController(
                  length: 5,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: TabBar(
                          labelPadding: EdgeInsets.all(0),
                          tabs: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border:
                                          Border.all(width: 1, color: color1)),
                                  alignment: Alignment.center,
                                  height: 30,
                                  child: Text(
                                    'Groups',
                                    style: TextStyle(
                                      fontFamily: 'CenturyGothic',
                                      fontSize: 10,
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border:
                                          Border.all(width: 1, color: color1)),
                                  alignment: Alignment.center,
                                  height: 30,
                                  child: Text(
                                    'Followers',
                                    style: TextStyle(
                                      fontFamily: 'CenturyGothic',
                                      fontSize: 10,
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border:
                                          Border.all(width: 1, color: color1)),
                                  alignment: Alignment.center,
                                  height: 30,
                                  child: Text(
                                    'Facebook',
                                    style: TextStyle(
                                      fontFamily: 'CenturyGothic',
                                      fontSize: 10,
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border:
                                          Border.all(width: 1, color: color1)),
                                  alignment: Alignment.center,
                                  height: 30,
                                  child: Text(
                                    'Email',
                                    style: TextStyle(
                                      fontFamily: 'CenturyGothic',
                                      fontSize: 10,
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border:
                                          Border.all(width: 1, color: color1)),
                                  alignment: Alignment.center,
                                  height: 30,
                                  child: Text(
                                    'Contacts',
                                    style: TextStyle(
                                      fontFamily: 'CenturyGothic',
                                      fontSize: 10,
                                    ),
                                  )),
                            ),
                          ],
                          unselectedLabelColor: color1,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: color1),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Expanded(
                          child: TabBarView(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            height: 400,
                            color: Colors.white,
                            child: Column(
                              children: [
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextField(
                                    textAlignVertical: TextAlignVertical.top,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'CenturyGothic',
                                      ),
                                      hintText: 'Search among your groups',
                                      suffixIcon: Icon(
                                        Icons.search,
                                        color: color1,
                                      ),
                                      contentPadding: EdgeInsets.all(10),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide:
                                              BorderSide(color: color1)),
                                    ),
                                  ),
                                ),
                                GroupsOptions(groupId: widget.groupId)
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            height: 400,
                            color: Colors.white,
                            child: Column(
                              children: [
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextField(
                                    textAlignVertical: TextAlignVertical.top,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'CenturyGothic',
                                      ),
                                      hintText: 'Search your followers',
                                      suffixIcon: Icon(
                                        Icons.search,
                                        color: color1,
                                      ),
                                      contentPadding: EdgeInsets.all(10),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide:
                                              BorderSide(color: color1)),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                FollowersOptions(groupId: widget.groupId)
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            height: 100,
                            color: Colors.white,
                            child: Column(
                              children: [
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextField(
                                    textAlignVertical: TextAlignVertical.top,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'CenturyGothic',
                                      ),
                                      hintText: 'Search Facebook friends',
                                      suffixIcon: Icon(
                                        Icons.search,
                                        color: color1,
                                      ),
                                      contentPadding: EdgeInsets.all(10),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide:
                                              BorderSide(color: color1)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              height: 100,
                              color: Colors.white,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextField(
                                        controller: _emailController,
                                        textAlignVertical:
                                            TextAlignVertical.top,
                                        decoration: InputDecoration(
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'CenturyGothic',
                                          ),
                                          hintText: 'Add email',
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                if (_invitee.isNotEmpty)
                                                  members.add(_invitee.trim());
                                              });
                                            },
                                            icon: Icon(
                                              Icons.add,
                                              color: color1,
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.all(10),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide.none),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide:
                                                  BorderSide(color: color1)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                        child: SingleChildScrollView(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 10, 0, 20),
                                      child: Wrap(
                                        spacing: 5,
                                        children: members
                                            .map((item) => TextButton(
                                                style: ButtonStyle(
                                                    splashFactory:
                                                        InkRipple.splashFactory,
                                                    overlayColor:
                                                        MaterialStateProperty.all(
                                                            Colors.deepPurple
                                                                .shade300),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(color1),
                                                    shape: MaterialStateProperty.all(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100)))),
                                                onPressed: () {
                                                  setState(() {
                                                    members.remove(item);
                                                  });
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: CenturyGothicText(
                                                      data: item,
                                                      fontSize: 15,
                                                      textColor: Colors.white,
                                                      textAlign:
                                                          TextAlign.left),
                                                )))
                                            .toList(),
                                      ),
                                    )),
                                    const Divider(
                                      height: 0,
                                      thickness: 2,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextButton(
                                              style: ButtonStyle(
                                                  shape: MaterialStateProperty.all(
                                                      RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(
                                                              10))),
                                                  overlayColor:
                                                      MaterialStateProperty.all(Colors
                                                          .deepPurple.shade400),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          color1)),
                                              onPressed: () =>
                                                  inviteMembers(isEmail: true),
                                              child: CenturyGothicText(
                                                  data: 'Add',
                                                  fontSize: 15,
                                                  textColor: Colors.white,
                                                  textAlign: TextAlign.center)),
                                        ),
                                      ],
                                    )
                                  ])),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            height: 100,
                            color: Colors.white,
                            child: Column(
                              children: [
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextField(
                                    textAlignVertical: TextAlignVertical.top,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'CenturyGothic',
                                      ),
                                      hintText: 'Search contacts',
                                      suffixIcon: Icon(
                                        Icons.search,
                                        color: color1,
                                      ),
                                      contentPadding: EdgeInsets.all(10),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide:
                                              BorderSide(color: color1)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ))
                    ],
                  ),
                ),
              )
            ])));
  }
}

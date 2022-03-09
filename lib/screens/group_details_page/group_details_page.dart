import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/domain/chat_view.dart';
import 'package:tripd_travel_app/components/domain/group_saves_view.dart';
import 'package:tripd_travel_app/components/widgets/century_gothic_text.dart';
import 'package:tripd_travel_app/screens/chat_page/chat_page.dart';
import 'package:tripd_travel_app/services/auth_service.dart';
import 'package:tripd_travel_app/services/group_service.dart';
import 'package:tripd_travel_app/theme/resources/colors.dart';

class GroupDetails extends StatefulWidget {
  const GroupDetails({Key? key, required this.groupId, required this.group})
      : super(key: key);
  final String groupId;
  final group;
  @override
  _GroupDetailsState createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  var group;
  var members;
  var admin;
  getGroup() async {
    final groupService = Provider.of<GroupService>(context, listen: false);
    final auth = Provider.of<AuthService>(context, listen: false);
    final idToken = await auth.currentUser!.getIdToken();
    group = await groupService.getGroup(
      token: idToken,
      groupId: widget.groupId,
    );
  }

  void setValues() {
    setState(() => {
          admin = widget.group["members"].firstWhere(
              (member) => member["userId"] == widget.group["admin"]),
          members = widget.group["members"]
              .where((member) => member["userId"] != widget.group["admin"]),
        });

    // print(admin);
  }

  @override
  void initState() {
    // getGroup();
    print(widget.group);
    print(widget.groupId);
    setValues();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
        child: Column(
          children: [
            Row(children: [
              Expanded(
                  child: Container(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                alignment: Alignment.centerLeft,
                child: IconButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, a, b) {
                              return ChatPage();
                            },
                            transitionDuration: Duration(microseconds: 0),
                            reverseTransitionDuration:
                                Duration(microseconds: 0),
                          ),
                          ModalRoute.withName('/'));
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 35,
                    )),
              )),
              Container(
                color: Colors.white,
                child: CenturyGothicText(
                    textOverflow: TextOverflow.clip,
                    data: widget.group["name"],
                    fontSize: 20,
                    textColor: Colors.black,
                    textAlign: TextAlign.center),
                width: 200,
              ),
              Expanded(child: SizedBox()),
            ]),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: Container(
              width: double.infinity,
              child: DefaultTabController(
                  length: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Column(
                      children: [
                        TabBar(
                          tabs: [
                            Container(
                                height: 40,
                                alignment: Alignment.center,
                                child: CenturyGothicText(
                                    data: 'Chat',
                                    fontSize: 15,
                                    textColor: Colors.black,
                                    textAlign: TextAlign.center)),
                            Container(
                              height: 40,
                              alignment: Alignment.center,
                              child: CenturyGothicText(
                                  data: 'Details',
                                  fontSize: 15,
                                  textColor: Colors.black,
                                  textAlign: TextAlign.center),
                            ),
                            Container(
                              height: 40,
                              alignment: Alignment.center,
                              child: CenturyGothicText(
                                  data: 'Saves',
                                  fontSize: 15,
                                  textColor: Colors.black,
                                  textAlign: TextAlign.center),
                            )
                          ],
                          indicator: UnderlineTabIndicator(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black),
                              insets: EdgeInsets.all(0)),
                        ),
                        SizedBox(
                          height: 0,
                        ),
                        Expanded(
                            child: TabBarView(children: [
                          ChatView(groupId: widget.groupId),
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            child: Row(children: [
                                              CenturyGothicText(
                                                data: 'Edit Plan',
                                                fontSize: 15,
                                              ),
                                              SizedBox(width: 10),
                                              Icon(Icons.edit),
                                            ]),
                                            onTap: () {
                                              print('object');
                                            },
                                            splashFactory:
                                                InkRipple.splashFactory,
                                          ),
                                          Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  color: color1,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              child: GestureDetector(
                                                  onTap: () {
                                                    print('Hi');
                                                  },
                                                  child: Icon(
                                                    Icons.person_add,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ))),
                                        ]),
                                  ),
                                  SizedBox(height: 5),
                                  admin == null
                                      ? LinearProgressIndicator(
                                          color: color1,
                                          backgroundColor:
                                              Colors.deepPurple.shade200,
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                ClipOval(
                                                  child: Image.network(
                                                    admin["profilePic"],
                                                    fit: BoxFit.cover,
                                                    width: 45,
                                                    height: 45,
                                                  ),
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  admin["username"],
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                )
                                              ],
                                            ),
                                            Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 2),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: color1)),
                                                child: Center(
                                                    child: Text("Creator",
                                                        style: TextStyle(
                                                            color: color1))))
                                          ],
                                        ),
                                  SizedBox(height: 20),
                                  Divider(),
                                  Column(
                                      children: members == null
                                          ? Container()
                                          : members
                                              .map<Widget>((member) => Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            ClipOval(
                                                              child:
                                                                  Image.network(
                                                                member[
                                                                    "profilePic"],
                                                                fit: BoxFit
                                                                    .cover,
                                                                width: 45,
                                                                height: 45,
                                                              ),
                                                            ),
                                                            SizedBox(width: 5),
                                                            Text(
                                                              member[
                                                                  "username"],
                                                              style: TextStyle(
                                                                  fontSize: 15),
                                                            ),
                                                          ],
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .remove_circle_outline,
                                                          size: 35,
                                                          color: Colors.grey,
                                                        )
                                                      ]))
                                              .toList())
                                ],
                              ),
                            ),
                          ),
                          GroupSavesView(groupId: widget.groupId),
                        ]))
                      ],
                    ),
                  )),
            ))
          ],
        ),
      ),
    );
  }
}

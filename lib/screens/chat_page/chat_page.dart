import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/domain/top_bar.dart';
import 'package:tripd_travel_app/components/widgets/century_gothic_text.dart';
import 'package:tripd_travel_app/components/widgets/chat_row.dart';
import 'package:tripd_travel_app/services/auth_service.dart';
import 'package:tripd_travel_app/services/group_service.dart';
import 'package:tripd_travel_app/theme/resources/colors.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List? groupsList;
  List? plansList;
  List? allList;

  void getUserGroups() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    var idToken = await auth.currentUser!.getIdToken();
    final groupService = Provider.of<GroupService>(context, listen: false);
    var allGroups = await groupService.getUserGroups(token: idToken);
    print("allGroups.................");
    print(allGroups);
    var plans = allGroups.where((item) => item["type"] == "plan");
    var grps = allGroups.where((item) => item["type"] != "plan");

    setState(() {
      allList = allGroups;
      groupsList = grps.toList();
      plansList = plans.toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getUserGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            TopBar(),
            SizedBox(
              height: 5,
            ),
            Expanded(
                child: Container(
              width: double.infinity,
              child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: TabBar(
                          tabs: [
                            Container(
                                height: 40,
                                alignment: Alignment.center,
                                child: CenturyGothicText(
                                    data: 'All',
                                    fontSize: 15,
                                    textColor: Colors.black,
                                    textAlign: TextAlign.center)),
                            Container(
                              height: 40,
                              alignment: Alignment.center,
                              child: CenturyGothicText(
                                  data: 'Plans',
                                  fontSize: 15,
                                  textColor: Colors.black,
                                  textAlign: TextAlign.center),
                            ),
                            Container(
                              height: 40,
                              alignment: Alignment.center,
                              child: CenturyGothicText(
                                  data: 'Group Chats',
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
                      ),
                      plansList != null
                          ? Expanded(
                              child: Padding(
                              child: TabBarView(children: [
                                ChatRow(items: allList!),
                                ChatRow(items: plansList!),
                                ChatRow(items: groupsList!),
                              ]),
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            ))
                          : Expanded(
                              child: Container(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                color: color1,
                                backgroundColor: color1.withOpacity(0.5),
                              ),
                            ))
                    ],
                  )),
            ))
          ],
        ),
        floatingActionButton: Container());
  }
}

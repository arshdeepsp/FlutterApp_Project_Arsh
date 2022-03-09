import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/widgets/century_gothic_text.dart';
import 'package:tripd_travel_app/components/streams/streams.dart';
import 'package:tripd_travel_app/models/user_profile.dart';
import 'package:tripd_travel_app/screens/notifications_page/notifications_page.dart';
import 'package:tripd_travel_app/screens/top_bar_profile/top_bar_profile.dart';
import 'package:tripd_travel_app/screens/view_plans/view_plans.dart';
import 'package:tripd_travel_app/services/auth_service.dart';
import 'package:tripd_travel_app/services/profile_service.dart';
import 'package:tripd_travel_app/services/socket_service.dart';
import 'package:tripd_travel_app/theme/resources/color_code.dart';

class TopBar extends StatefulWidget {
  const TopBar({Key? key, this.child}) : super(key: key);
  // final VoidCallback? menu;
  final Widget? child;
  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  final Color color1 = HexColor("6700E3");

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  bool _notifications = true;
  bool _invites = true;

  UserProfile? userProfile;

  void _getProfile() async {
    final profileService = Provider.of<Profile>(context, listen: false);
    final auth = Provider.of<AuthService>(context, listen: false);
    var token = await auth.currentUser!.getIdToken();
    var data = await profileService.getProfile(token: token);
    //print(data['data']);
    setState(() {
      userProfile = data;
    });
  }

  void _showPlans(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, a, b) {
          return ViewPlans();
        },
        transitionDuration: Duration(seconds: 0),
        reverseTransitionDuration: Duration(seconds: 0),
        maintainState: true,
      ),
    );
  }

  // ignore: unused_element
  void _showProfile(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, a, b) {
          return TopBarProfile();
        },
        transitionDuration: Duration(seconds: 0),
        reverseTransitionDuration: Duration(seconds: 0),
        maintainState: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).size.height * 0.035;
    return Padding(
      padding: EdgeInsets.fromLTRB(10, topPadding, 10, 0),
      child: Container(
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                color: Colors.white,
                alignment: Alignment.centerLeft,
                height: 70,
                child: Row(
                  children: [
                    Container(
                      height: 55,
                      width: 55,
                      child: Material(
                          color: Colors.white,
                          child: Consumer<SocketService>(
                            builder: (_, socketNotifier, __) => GestureDetector(
                              onTap: () {
                                drawerController.sink.add('drawer');
                              },
                              child: ClipOval(
                                child: Material(
                                  color: Colors.transparent,
                                  child: userProfile == null
                                      ? Container(
                                          alignment: Alignment.center,
                                          child: CircularProgressIndicator(
                                            color: color1,
                                          ),
                                        )
                                      : Image.network(
                                          userProfile!.profilePic,
                                          fit: BoxFit.cover,
                                        ),

                                  // child: InkWell(onTap: onClicked),
                                ),
                              ),
                            ),
                          )),
                    )
                  ],
                ),
              ),
            ),
            Container(
                alignment: Alignment.center,
                color: Colors.white,
                height: 50,
                child: Text(
                  'tripd',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Eurofurence', fontSize: 38, color: color1),
                )),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Stack(
                    children: [
                      Container(
                        color: Colors.white,
                        alignment: Alignment.centerRight,
                        height: 70,
                        width: 50,
                        child: Material(
                          color: Colors.white,
                          child: InkWell(
                            splashFactory: NoSplash.splashFactory,
                            highlightColor: Colors.deepPurple.shade300,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      transitionDuration:
                                          Duration(microseconds: 0),
                                      reverseTransitionDuration:
                                          Duration(microseconds: 0),
                                      pageBuilder: (context, a, b) {
                                        return NotificationsPage();
                                      }));
                            },
                            child: Image.asset('images/notifications.png',
                                height: 30,
                                color: Colors.black.withOpacity(0.7)),
                          ),
                        ),
                      ),
                      Positioned(
                        child: Offstage(
                          offstage: _notifications,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                            alignment: Alignment.center,
                            child: CenturyGothicText(
                              data: '3',
                              fontSize: 13,
                              textColor: Colors.white,
                            ),
                          ),
                        ),
                        top: 10,
                        right: 22.5,
                      )
                    ],
                  ),
                  Stack(
                    children: [
                      Container(
                        color: Colors.white,
                        alignment: Alignment.centerRight,
                        height: 70,
                        width: 50,
                        child: Material(
                          color: Colors.white,
                          child: InkWell(
                            splashFactory: NoSplash.splashFactory,
                            highlightColor: Colors.deepPurple.shade300,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            onTap: () {
                              _showPlans(context);
                            },
                            child: Image.asset('images/plans.png',
                                height: 30,
                                color: Colors.black.withOpacity(0.7)),
                          ),
                        ),
                      ),
                      Positioned(
                        child: Offstage(
                          offstage: _invites,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                            alignment: Alignment.center,
                            child: CenturyGothicText(
                              data: '5+',
                              fontSize: 13,
                              textColor: Colors.white,
                            ),
                          ),
                        ),
                        top: 10,
                        right: 22.5,
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

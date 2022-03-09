import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/screens/profile_page/profile_page.dart';
import 'package:tripd_travel_app/services/auth_service.dart';
import 'package:tripd_travel_app/services/socket_service.dart';
import 'package:tripd_travel_app/theme/resources/color_code.dart';

class ChatPageBar extends StatelessWidget {
  ChatPageBar({Key? key}) : super(key: key);

  final Color color1 = HexColor("6700E3");

  void _logout(BuildContext context) async {
    final auth = Provider.of<AuthService>(context, listen: false);
    await auth.signOut();
    final socket = Provider.of<SocketService>(context, listen: false);
    socket.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
      child: Row(
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
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, a, b) {
                                  return ProfilePage();
                                },
                                transitionDuration: Duration(seconds: 0),
                                reverseTransitionDuration: Duration(seconds: 0),
                                maintainState: true,
                              ),
                            );
                          },
                          onLongPress: () {
                            _logout(context);
                          },
                          child: Image.network(
                            "https://tripd-ms.s3.us-west-1.amazonaws.com/default/default%20image.png",
                          )),
                    ),
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
          Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}

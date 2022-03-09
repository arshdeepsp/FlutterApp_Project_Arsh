import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/widgets/century_gothic_text.dart';
import 'package:tripd_travel_app/components/streams/streams.dart';
import 'package:tripd_travel_app/models/user_profile.dart';
import 'package:tripd_travel_app/services/auth_service.dart';
import 'package:tripd_travel_app/services/profile_service.dart';
import 'package:tripd_travel_app/services/socket_service.dart';
import 'package:tripd_travel_app/theme/resources/colors.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  UserProfile? userProfile;

  @override
  void initState() {
    _getProfile();
    super.initState();
  }

  void _logout(BuildContext context) async {
    final auth = Provider.of<AuthService>(context, listen: false);
    await auth.signOut();
  }

  void _getProfile() async {
    final profileService = Provider.of<Profile>(context, listen: false);
    final auth = Provider.of<AuthService>(context, listen: false);
    var token = await auth.currentUser!.getIdToken();
    var data = await profileService.getProfile(token: token);

    setState(() {
      userProfile = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    var max = MediaQuery.of(context).size.height;
    return Container(
      height: 700,
      child: Drawer(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        backgroundColor: Colors.grey.shade200,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CenturyGothicText(data: 'Settings', fontSize: 22.5),
                ],
              ),
              SizedBox(
                height: max * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    child: GestureDetector(
                        onTap: () {},
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
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: max * 0.015,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  userProfile == null
                      ? CenturyGothicText(data: '@username', fontSize: 16)
                      : CenturyGothicText(
                          data: '@${userProfile!.username}', fontSize: 16),
                ],
              ),
              SizedBox(
                height: max * 0.05,
              ),
              TextButton(
                style: ButtonStyle(
                    overlayColor:
                        MaterialStateProperty.all(Colors.grey.shade300)),
                onPressed: () {
                  drawerController.sink.add('settings');
                },
                child: CenturyGothicText(
                    data: 'Profile Settings',
                    fontSize: 18,
                    textAlign: TextAlign.start,
                    textColor: Colors.black),
              ),
              SizedBox(
                height: max * 0.01,
              ),
              TextButton(
                style: ButtonStyle(
                    overlayColor:
                        MaterialStateProperty.all(Colors.grey.shade300)),
                onPressed: () {
                  drawerController.sink.add('invite');
                },
                child: CenturyGothicText(
                    data: 'Invite',
                    fontSize: 18,
                    textAlign: TextAlign.start,
                    textColor: Colors.black),
              ),
              SizedBox(
                height: max * 0.01,
              ),
              TextButton(
                style: ButtonStyle(
                    overlayColor:
                        MaterialStateProperty.all(Colors.grey.shade300)),
                onPressed: () {
                  drawerController.sink.add('feedback');
                },
                child: CenturyGothicText(
                  data: 'Feedback',
                  fontSize: 18,
                  textAlign: TextAlign.start,
                  textColor: Colors.black,
                ),
              ),
              Expanded(child: SizedBox()),
              SizedBox(
                height: max * 0.01,
              ),
              Consumer<SocketService>(
                builder: (_, socketNotifier, __) => TextButton(
                  style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.grey.shade300)),
                  onPressed: () {
                    _logout(context);
                    socketNotifier.dismiss();
                  },
                  child: CenturyGothicText(
                      data: 'Log Out',
                      fontSize: 18,
                      textAlign: TextAlign.start,
                      textColor: Colors.black),
                ),
              ),
              SizedBox(
                height: max * 0.01,
              ),
              TextButton(
                style: ButtonStyle(
                    overlayColor:
                        MaterialStateProperty.all(Colors.grey.shade300)),
                onPressed: () {
                  drawerController.sink.add('terms');
                },
                child: CenturyGothicText(
                  data: 'Terms and Privacy',
                  fontSize: 18,
                  textAlign: TextAlign.start,
                  textColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

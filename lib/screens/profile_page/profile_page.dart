import 'package:flutter/material.dart';
import 'package:tripd_travel_app/screens/others_profile_page/others_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return OthersProfilePage();
  }
}

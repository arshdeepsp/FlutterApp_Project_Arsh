import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/screens/home_screen/home_screen.dart';
import 'package:tripd_travel_app/screens/email_verification/email_verification.dart';
import 'package:tripd_travel_app/screens/sign_in/sign_in.dart';
import 'package:tripd_travel_app/screens/set_profile/set_profile.dart';
import 'package:tripd_travel_app/services/auth_service.dart';
import 'package:tripd_travel_app/theme/resources/color_code.dart';

class StartupController extends StatefulWidget {
  @override
  _StartupControllerState createState() => _StartupControllerState();
}

class _StartupControllerState extends State<StartupController> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    final Color color1 = HexColor("6700E3");
    return StreamBuilder<User?>(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;
            if (user == null) {
              return SignInPage();
            }
            if (user.providerData[0].providerId == 'password' &&
                !user.emailVerified) {
              return EmailVerification();
            }
            if (user.displayName == null) {
              return SetProfile();
            }
            return HomePage();
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: color1,
              ),
            ),
          );
        });
  }
}

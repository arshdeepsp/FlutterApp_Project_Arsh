import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/dialogs/auth_dialog.dart';
import 'package:tripd_travel_app/services/auth_service.dart';
import 'package:tripd_travel_app/theme/resources/color_code.dart';
import 'package:tripd_travel_app/components/widgets/custom_raised_button.dart';
import 'package:tripd_travel_app/components/widgets/custom_text.dart';

import 'package:tripd_travel_app/controllers/startup_controller.dart';

class EmailVerification extends StatefulWidget {
  @override
  _EmailVerificationState createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  bool _loading = false;

  Color color1 = HexColor("6700E3");

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _sendEmailVerification().then((value) {});
    super.initState();
  }

  Future _sendEmailVerification() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    User? user = auth.currentUser;
    setState(() {
      _loading = true;
    });
    try {
      await user!.sendEmailVerification();
    } on Exception catch (e) {
      showDialog(
          context: context,
          builder: (context) => AuthExceptionDialog(
                exception: e,
              ),
          barrierDismissible: false);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _resendVerification() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    User? user = auth.currentUser;
    setState(() {
      _loading = true;
    });
    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
      } on Exception catch (e) {
        showDialog(
            context: context,
            builder: (context) => AuthExceptionDialog(
                  exception: e,
                ),
            barrierDismissible: false);
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _signOut() async {
    setState(() {
      _loading = true;
    });
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      await auth.signOut();
    } on Exception catch (e) {
      showDialog(
          context: context,
          builder: (context) => AuthExceptionDialog(
                exception: e,
              ),
          barrierDismissible: false);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> checkEmailVerification() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    setState(() {
      _loading = true;
    });
    try {
      await auth.currentUser!.reload();
    } on Exception catch (e) {
      showDialog(
          context: context,
          builder: (context) => AuthExceptionDialog(
                exception: e,
              ),
          barrierDismissible: false);
    } finally {
      setState(() {
        _loading = false;
      });
    }
    if (auth.currentUser!.emailVerified) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => StartupController()),
        (Route<dynamic> route) => false,
      );
    } else {}
  }

  Widget _loadingIndicator() {
    if (_loading) {
      return SizedBox(
        height: 5,
        child: LinearProgressIndicator(
          color: color1,
          backgroundColor: Colors.deepPurple.shade200,
        ),
      );
    }
    return SizedBox(
      height: 5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: SizedBox(
                height: 0,
              )),
              SizedBox(
                child: Image.asset('images/tripd.png'),
                height: 70,
              ),
              _loadingIndicator(),
              SizedBox(
                height: 30,
              ),
              Text(
                'You registered an account on Tripd, before being able to use your account you need to verify that this is your email address by clicking the link sent to your registered email.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, fontFamily: 'CenturyGothic'),
              ),
              SizedBox(
                height: 30,
              ),
              CustomRaisedButton(
                  isDisabled: false,
                  child: CustomText(
                    textColor: Colors.black,
                    fontFamily: 'CenturyGothic',
                    fontSize: 15,
                    data: 'Resend email',
                    textAlign: TextAlign.center,
                  ),
                  color: Colors.white,
                  borderColor: color1,
                  onPressed: _resendVerification),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  SizedBox(
                    child: CustomRaisedButton(
                        isDisabled: false,
                        child: CustomText(
                          textColor: Colors.black,
                          fontFamily: 'CenturyGothic',
                          fontSize: 15,
                          data: 'Continue',
                          textAlign: TextAlign.center,
                        ),
                        color: Colors.white,
                        borderColor: color1,
                        onPressed: checkEmailVerification),
                    width: 150,
                  ),
                  SizedBox(
                    child: Text('or'),
                  ),
                  SizedBox(
                    child: CustomRaisedButton(
                        isDisabled: false,
                        child: CustomText(
                          fontFamily: 'CenturyGothic',
                          fontSize: 15,
                          data: 'Go back',
                          textColor: Colors.black,
                          textAlign: TextAlign.center,
                        ),
                        color: Colors.white,
                        borderColor: color1,
                        onPressed: _signOut),
                    width: 150,
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              Expanded(child: SizedBox())
            ],
          ),
        ),
      ),
    );
  }
}

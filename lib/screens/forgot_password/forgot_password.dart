import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/dialogs/auth_dialog.dart';
import 'package:tripd_travel_app/services/auth_service.dart';
import 'package:tripd_travel_app/theme/resources/color_code.dart';
import 'package:tripd_travel_app/components/widgets/custom_raised_button.dart';
import 'package:tripd_travel_app/components/widgets/custom_text.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  String get _email => _emailController.text;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  void backToLogin(context) {
    Navigator.pop(context);
  }

  Future<void> _sendPasswordResetEmail() async {
    setState(() {
      _loading = true;
    });
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      await auth.sendPasswordResetEmail(email: _email.trim());
      setState(() {
        _offstage = !_offstage;
      });
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

  bool _emailNullCheck = true;
  bool _offstage = true;
  bool _loading = false;

  Color color1 = HexColor("6700E3");

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
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Expanded(child: SizedBox()),
                SizedBox(
                  height: 70,
                  child: Image.asset('images/tripd.png'),
                ),
                _loadingIndicator(),
                SizedBox(
                  height: 30,
                ),
                if (_offstage)
                  Column(
                    children: [
                      SizedBox(
                        child: CustomText(
                            data: 'Trouble Logging in?',
                            fontFamily: 'CenturyGothic',
                            fontSize: 17,
                            textColor: Colors.black,
                            textAlign: TextAlign.center),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        child: CustomText(
                            data:
                                'Enter your email and we\'ll send you a link to\n get back into your account',
                            fontFamily: 'CenturyGothic',
                            fontSize: 11.6,
                            textColor: Colors.black,
                            textAlign: TextAlign.center),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        onChanged: (_email) => {
                          _emailController.addListener(() {
                            if (_emailController.text.isEmpty) {
                              setState(() {
                                _emailNullCheck = true;
                              });
                            } else {
                              setState(() {
                                _emailNullCheck = false;
                              });
                            }
                          })
                        },
                        controller: _emailController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: color1, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black26, width: 1.0),
                          ),
                          hintText: 'Enter email',
                          fillColor: Colors.black26,
                          hintStyle: TextStyle(fontFamily: 'CenturyGothic'),
                          suffixIcon: IconButton(
                            onPressed: () {
                              _emailController.clear();
                            },
                            icon: Icon(
                              Icons.close,
                              color: (_emailController.text.isEmpty)
                                  ? Colors.grey
                                  : color1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                Offstage(
                    offstage: _offstage,
                    child: Column(
                      children: [
                        CustomText(
                            data:
                                'A password reset link has been sent to the email\n you provided. Please reset password and login again.',
                            fontFamily: 'CenturyGothic',
                            fontSize: 13,
                            textColor: Colors.black,
                            textAlign: TextAlign.center)
                      ],
                    )),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: CustomRaisedButton(
                    isDisabled: _emailNullCheck,
                    child: CustomText(
                        data: (_offstage)
                            ? 'Send password reset email'
                            : 'Resend email',
                        fontFamily: 'CenturyGothic',
                        fontSize: 15,
                        textColor: Colors.white,
                        textAlign: TextAlign.center),
                    color: color1,
                    borderColor: color1,
                    onPressed: _sendPasswordResetEmail,
                    borderRadius: 30,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomRaisedButton(
                    isDisabled: false,
                    borderRadius: 30,
                    child: CustomText(
                        data: 'Back to Login',
                        fontFamily: 'CenturyGothic',
                        fontSize: 15,
                        textColor: Colors.black,
                        textAlign: TextAlign.center),
                    color: Colors.white,
                    borderColor: color1,
                    onPressed: () {
                      backToLogin(context);
                    }),
                Expanded(
                    child: SizedBox(
                  height: 0,
                )),
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          )),
    );
  }
}

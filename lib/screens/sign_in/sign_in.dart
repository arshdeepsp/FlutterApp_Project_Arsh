import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/dialogs/auth_dialog.dart';
import 'package:tripd_travel_app/services/auth_service.dart';
import 'package:tripd_travel_app/theme/resources/color_code.dart';
import 'package:tripd_travel_app/screens/forgot_password/forgot_password.dart';
import 'package:tripd_travel_app/components/widgets/sign_in_button.dart';
import 'package:tripd_travel_app/components/widgets/custom_text.dart';
import 'package:tripd_travel_app/components/widgets/social_sign_in_button.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isSignIn = true;
  bool _forgotPassword = false;
  bool _obscureText = true;
  bool _credentialNullCheck = true;
  bool _loading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String get _email => _emailController.text.trim();
  String get _password => _passwordController.text;

  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  Color color1 = HexColor("6700E3");

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
  }

  void _enableLogin() {
    _emailController.addListener(() {
      _passwordController.addListener(() {
        if (_passwordController.text.isNotEmpty &&
            _emailController.text.isNotEmpty) {
          setState(() {
            _credentialNullCheck = false;
          });
        } else {
          setState(() {
            _credentialNullCheck = true;
          });
        }
      });
    });
  }

  Future<User?> _signInWithFacebook() async {
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      await auth.signInWithFacebook();
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) => AuthExceptionDialog(
                exception: e,
              ),
          barrierDismissible: false);
    }
  }

  Future<User?> _signInWithCredential() async {
    if (_isSignIn == true) {
      setState(() {
        _loading = true;
      });
      try {
        final auth = Provider.of<AuthService>(context, listen: false);
        await auth.signInWithCredential(email: _email, password: _password);
      } on FirebaseAuthException catch (e) {
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
    } else {
      setState(() {
        _loading = true;
      });
      try {
        final auth = Provider.of<AuthService>(context, listen: false);
        await auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
      } on FirebaseAuthException catch (e) {
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

  void _resetPasswordPage() {
    _emailFocusNode.unfocus();
    _passwordFocusNode.unfocus();

    Navigator.push(
        context, MaterialPageRoute(builder: (_) => ForgotPassword()));
  }

  void _toggleFormType() {
    setState(() {
      _isSignIn = !_isSignIn;
      _forgotPassword = !_forgotPassword;
    });
    _emailFocusNode.unfocus();
    _passwordFocusNode.unfocus();
  }

  double widgetHeightPercentage(double percentage) {
    return MediaQuery.of(context).size.height * (percentage / 100);
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
      body: _buildContent(),
      backgroundColor: Colors.grey.shade100,
    );
  }

  Widget _buildContent() {
    final _formTypeText =
        _isSignIn ? 'Need an account? Register' : 'Have an account? Sign in';
    final _submitButtonText = _isSignIn ? 'Log In' : 'Register account';
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.all(widgetHeightPercentage(1.5)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: SizedBox(
                  height: 0,
                )),
                SizedBox(
                  height: widgetHeightPercentage(9),
                  child: Image.asset('images/tripd.png'),
                ),
                _loadingIndicator(),
                SizedBox(
                  height: widgetHeightPercentage(3.1),
                ),
                TextField(
                  controller: _emailController,
                  style: TextStyle(fontFamily: 'CenturyGothic'),
                  focusNode: _emailFocusNode,
                  onChanged: (_email) => _enableLogin(),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: color1, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black26, width: 1.0),
                      ),
                      hintText: 'Email or Username',
                      fillColor: Colors.black26,
                      hintStyle: TextStyle(fontFamily: 'CenturyGothic')),
                ),
                SizedBox(
                  height: widgetHeightPercentage(1.2),
                ),
                TextField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  style: TextStyle(fontFamily: 'CenturyGothic'),
                  onChanged: (_password) => _enableLogin(),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: color1, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black26, width: 1.0),
                      ),
                      hintText: 'Password',
                      fillColor: Colors.black26,
                      hintStyle: TextStyle(fontFamily: 'CenturyGothic'),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            });
                          },
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: (_obscureText) ? Colors.grey : color1,
                          ))),
                  obscureText: _obscureText,
                ),
                SizedBox(
                  height: widgetHeightPercentage(2.4),
                ),
                Container(
                  width: 400,
                  child: SignInButton(
                    isDisabled: _credentialNullCheck,
                    color: color1,
                    onPressed: _signInWithCredential,
                    text: _submitButtonText,
                    textColor: Colors.white,
                    height: widgetHeightPercentage(5),
                    borderColor: color1,
                    fontFamily: 'CenturyGothic',
                    fontSize: 16,
                    borderRadius: 5,
                  ),
                ),
                Offstage(
                  child: SizedBox(
                    height: widgetHeightPercentage(1.4),
                  ),
                  offstage: !_forgotPassword,
                ),
                Offstage(
                  offstage: _forgotPassword,
                  child: TextButton(
                    onPressed: _resetPasswordPage,
                    child: CustomText(
                      textColor: Colors.black,
                      fontFamily: 'CenturyGothic',
                      fontSize: 15,
                      data: 'Forgot Password?',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                CustomText(
                  data: 'or',
                  fontFamily: 'CenturyGothic',
                  fontSize: 15,
                  textColor: Colors.black,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: widgetHeightPercentage(2),
                ),
                SocialSignInButton(
                  color: Colors.blue.shade800,
                  text: 'Sign in with Facebook',
                  textColor: Colors.white,
                  onPressed: _signInWithFacebook,
                  logo: 'images/facebook-logo.png',
                  fontFamily: 'CenturyGothic',
                  fontSize: 15,
                ),
                Expanded(child: SizedBox(height: 0)),
                TextButton(
                  onPressed: _toggleFormType,
                  child: CustomText(
                    textColor: Colors.black,
                    fontFamily: 'CenturyGothic',
                    fontSize: 15,
                    data: _formTypeText,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: widgetHeightPercentage(0.6),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          )),
    );
  }
}

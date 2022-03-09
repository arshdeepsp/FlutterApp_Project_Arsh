import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/dialogs/auth_dialog.dart';
import 'package:tripd_travel_app/services/auth_service.dart';
import 'package:tripd_travel_app/services/profile_service.dart';
import 'package:tripd_travel_app/theme/resources/color_code.dart';
import 'package:tripd_travel_app/components/widgets/sign_in_button.dart';
import 'package:tripd_travel_app/components/widgets/custom_text.dart';
import 'package:tripd_travel_app/controllers/startup_controller.dart';

class SetProfile extends StatefulWidget {
  @override
  _SetProfileState createState() => _SetProfileState();
}

class _SetProfileState extends State<SetProfile> {
  final TextEditingController unameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  final Profile profile = Profile();

  bool _usernameOffstage = true;
  bool _loading = false;

  Color color1 = HexColor("6700E3");

  int status = 0;

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    unameController.dispose();
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

  Future<void> _checkUniqueName() async {
    status = await profile.checkUniqueName(uname: unameController.text);
    if (status != -1) {
      setState(() {
        _usernameOffstage = false;
      });
    }
  }

  Future<void> _setProfile() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final idToken = await auth.currentUser!.getIdToken();
    final email = auth.currentUser!.email;

    // print({
    //   "userName": unameController.text,
    //   "firstName": firstNameController.text,
    //   "lastName": lastNameController.text,
    //   "email": email
    // });
    var response = await profile.setProfile(
        token: idToken,
        userName: unameController.text,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: email);
    if (response["status"] == true) {
      setState(() {
        _loading = true;
      });
      try {
        await auth.currentUser!.updateDisplayName(unameController.text);
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
    if (auth.currentUser!.displayName != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => StartupController()),
        (Route<dynamic> route) => false,
      );
    }
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
      resizeToAvoidBottomInset: true,
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
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
                height: 15,
              ),
              TextField(
                controller: unameController,
                onChanged: (text) {
                  _checkUniqueName();
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26, width: 1.0),
                  ),
                  hintText: 'Username',
                  hintStyle: TextStyle(fontFamily: 'CenturyGothic'),
                  fillColor: Colors.black26,
                ),
              ),
              Offstage(
                child: CustomText(
                  data: (status == 1) ? "Available" : "Not available",
                  fontFamily: 'CenturyGothic',
                  fontSize: 15,
                  textColor: (status == 1) ? Colors.green : Colors.red,
                  textAlign: TextAlign.center,
                ),
                offstage: _usernameOffstage,
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26, width: 1.0),
                  ),
                  hintText: 'First Name',
                  hintStyle: TextStyle(fontFamily: 'CenturyGothic'),
                  fillColor: Colors.black26,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26, width: 1.0),
                  ),
                  hintText: 'Last Name',
                  hintStyle: TextStyle(fontFamily: 'CenturyGothic'),
                  fillColor: Colors.black26,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                  height: 20,
                  child: CustomText(
                      data: 'Date of Birth',
                      fontFamily: 'CenturyGothic',
                      fontSize: 15,
                      textColor: Colors.black,
                      textAlign: TextAlign.left)),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 150,
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.cyan, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black26, width: 1.0),
                        ),
                        hintText: 'Year',
                        hintStyle: TextStyle(fontFamily: 'CenturyGothic'),
                        fillColor: Colors.black26,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                      child: SizedBox(
                    width: 100,
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.cyan, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black26, width: 1.0),
                        ),
                        hintText: 'Month',
                        hintStyle: TextStyle(fontFamily: 'CenturyGothic'),
                        fillColor: Colors.black26,
                      ),
                    ),
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                      child: SizedBox(
                    width: 100,
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.cyan, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black26, width: 1.0),
                        ),
                        hintText: 'Day',
                        hintStyle: TextStyle(fontFamily: 'CenturyGothic'),
                        fillColor: Colors.black26,
                      ),
                    ),
                  )),
                ],
              ),
              SizedBox(height: 10),
              SignInButton(
                isDisabled: (status != 1),
                text: 'Update Profile',
                color: color1,
                textColor: Colors.white,
                onPressed: () => _setProfile(),
                height: 40,
                borderColor: color1,
                fontFamily: 'CenturyGothic',
                fontSize: 15,
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                'By clicking Sign Up, you are indicating that you have read and acknowledged the Terms of Service and Privacy Notice.',
                style: TextStyle(fontSize: 10.5, fontFamily: 'CenturyGothic'),
                textAlign: TextAlign.center,
              ),
              Expanded(child: SizedBox()),
              SignInButton(
                isDisabled: false,
                text: 'Back to Login',
                color: Colors.white,
                textColor: Colors.black,
                onPressed: _signOut,
                height: 40,
                borderColor: color1,
                fontFamily: 'CenturyGothic',
                fontSize: 15,
              ),
              SizedBox(
                height: 5,
              ),
              Expanded(
                  child: SizedBox(
                height: 0,
              ))
            ],
            crossAxisAlignment: CrossAxisAlignment.stretch,
          ),
        ),
      ),
    );
  }
}

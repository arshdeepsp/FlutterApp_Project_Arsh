import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/widgets/century_gothic_text.dart';
import 'package:tripd_travel_app/components/widgets/stretched_text_button.dart';
import 'package:tripd_travel_app/models/user_profile.dart';
import 'package:tripd_travel_app/services/auth_service.dart';
import 'package:tripd_travel_app/services/profile_pic_service.dart';
import 'package:tripd_travel_app/services/profile_service.dart';
import 'package:tripd_travel_app/theme/resources/colors.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({Key? key}) : super(key: key);

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  UserProfile? userProfile;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _websiteController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  var file;
  var currentFile;

  bool isLoading = false;

  ImagePicker imagePicker = ImagePicker();

  @override
  void initState() {
    _getProfile();
    super.initState();
  }

  void _getProfile() async {
    final profileService = Provider.of<Profile>(context, listen: false);
    final auth = Provider.of<AuthService>(context, listen: false);
    var token = await auth.currentUser!.getIdToken();
    var data = await profileService.getProfile(token: token);
    //print(data['data']);
    setState(() {
      userProfile = data;
      _usernameController.text = userProfile!.username ?? '';
      _firstnameController.text = userProfile!.firstName ?? '';
      _lastnameController.text = userProfile!.lastName ?? '';
      _emailController.text = userProfile!.email ?? '';
      _websiteController.text = userProfile!.website ?? '';
      _bioController.text = userProfile!.bio ?? '';
    });
  }

  void _updateProfile() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final profileService = Provider.of<Profile>(context, listen: false);
    final idToken = await auth.currentUser!.getIdToken();
    setState(() {
      isLoading = true;
    });
    var response = await profileService.updateProfile(
        token: idToken,
        userName: _usernameController.text,
        firstName: _firstnameController.text,
        lastName: _lastnameController.text,
        bio: _bioController.text,
        context: context);
    print(response);
  }

  void _updateProfilePic() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final profilePicService =
        Provider.of<ProfilePicService>(context, listen: false);
    final idToken = await auth.currentUser!.getIdToken();
    setState(() {
      isLoading = true;
    });
    await profilePicService.updateProfilePicture(
        token: idToken, file: currentFile, context: context);
  }

  @override
  Widget build(BuildContext context) {
    var max = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: isLoading
                          ? Container(
                              height: 20,
                              width: 20,
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                color: color1,
                              ),
                            )
                          : IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                size: 35,
                              )),
                    ),
                  ),
                  CenturyGothicText(
                    data: 'Profile Settings',
                    fontSize: 23,
                    textOverflow: TextOverflow.clip,
                  ),
                  Expanded(
                    child: Container(),
                  )
                ],
              ),
            ),
          ),
          const Divider(
            thickness: 0.5,
            height: 0,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: max * 0.02,
                  ),
                  CenturyGothicText(data: 'Profile Picture', fontSize: 15),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
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
                                      : currentFile == null
                                          ? Image.network(
                                              userProfile!.profilePic,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.file(
                                              File(currentFile.path),
                                              fit: BoxFit.cover,
                                            ),

                                  // child: InkWell(onTap: onClicked),
                                ),
                              )),
                        ),
                        SizedBox(
                          width: max * 0.02,
                        ),
                        TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.grey.shade300),
                              overlayColor: MaterialStateProperty.all(
                                  Colors.grey.shade400)),
                          onPressed: () async {
                            file = await imagePicker.pickImage(
                                source: ImageSource.gallery);
                            if (file != null)
                              setState(() {
                                currentFile = file;
                              });
                            if (currentFile != null) _updateProfilePic();
                          },
                          child: CenturyGothicText(
                              data: 'Change',
                              fontSize: 15,
                              textAlign: TextAlign.start,
                              textColor: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: max * 0.015,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: max * 0.02,
                            ),
                            CenturyGothicText(data: 'Username', fontSize: 12),
                          ],
                        ),
                        SizedBox(
                          height: max * 0.005,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(30)),
                          child: TextField(
                            controller: _usernameController,
                            cursorColor: color1,
                            style: TextStyle(fontFamily: 'CenturyGothic'),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Username',
                              suffixIcon: IconButton(
                                splashRadius: double.minPositive,
                                icon: Icon(Icons.close),
                                color: color1,
                                iconSize: 20,
                                onPressed: () {
                                  _usernameController.clear();
                                },
                              ),
                              fillColor: Colors.grey,
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontFamily: 'CenturyGothic',
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: max * 0.02,
                            ),
                            CenturyGothicText(data: 'First Name', fontSize: 12),
                          ],
                        ),
                        SizedBox(
                          height: max * 0.005,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(30)),
                          child: TextField(
                            controller: _firstnameController,
                            cursorColor: color1,
                            style: TextStyle(fontFamily: 'CenturyGothic'),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'First Name',
                              suffixIcon: IconButton(
                                splashRadius: double.minPositive,
                                icon: Icon(Icons.close),
                                color: color1,
                                iconSize: 20,
                                onPressed: () {
                                  _firstnameController.clear();
                                },
                              ),
                              fillColor: Colors.grey,
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontFamily: 'CenturyGothic',
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: max * 0.02,
                            ),
                            CenturyGothicText(data: 'Last Name', fontSize: 12),
                          ],
                        ),
                        SizedBox(
                          height: max * 0.005,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(30)),
                          child: TextField(
                            controller: _lastnameController,
                            cursorColor: color1,
                            style: TextStyle(fontFamily: 'CenturyGothic'),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Last Name',
                              suffixIcon: IconButton(
                                splashRadius: double.minPositive,
                                icon: Icon(Icons.close),
                                color: color1,
                                iconSize: 20,
                                onPressed: () {
                                  _lastnameController.clear();
                                },
                              ),
                              fillColor: Colors.grey,
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontFamily: 'CenturyGothic',
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: max * 0.02,
                            ),
                            CenturyGothicText(data: 'Bio', fontSize: 12),
                          ],
                        ),
                        SizedBox(
                          height: max * 0.005,
                        ),
                        Container(
                          height: 125,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(30)),
                          child: TextField(
                            controller: _bioController,
                            cursorColor: color1,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            maxLength: 150,
                            maxLines: 6,
                            style: TextStyle(fontFamily: 'CenturyGothic'),
                            decoration: InputDecoration(
                              counterText: '',
                              counterStyle: TextStyle(fontSize: 0),
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 20, 20, 20),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Bio',
                              suffixIcon: IconButton(
                                splashRadius: double.minPositive,
                                icon: Icon(Icons.close),
                                color: color1,
                                iconSize: 20,
                                onPressed: () {
                                  _bioController.clear();
                                },
                              ),
                              fillColor: Colors.grey,
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontFamily: 'CenturyGothic',
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: max * 0.02,
                            ),
                            CenturyGothicText(data: 'Website', fontSize: 12),
                          ],
                        ),
                        SizedBox(
                          height: max * 0.005,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(30)),
                          child: TextField(
                            controller: _websiteController,
                            cursorColor: color1,
                            style: TextStyle(fontFamily: 'CenturyGothic'),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Your Website',
                              suffixIcon: IconButton(
                                splashRadius: double.minPositive,
                                icon: Icon(Icons.close),
                                color: color1,
                                iconSize: 20,
                                onPressed: () {
                                  _websiteController.clear();
                                },
                              ),
                              fillColor: Colors.grey,
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontFamily: 'CenturyGothic',
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          const Divider(
            thickness: 0.5,
            height: 0,
          ),
          SafeArea(
            top: false,
            child: Container(
                alignment: Alignment.center,
                child: StretchedTextButton(
                    borderColor: Colors.transparent,
                    onPressed: () {
                      _updateProfile();
                    },
                    splashColor: Colors.grey.shade400,
                    child: isLoading
                        ? Container(
                            height: 20,
                            width: 20,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              color: color1,
                            ),
                          )
                        : Container(
                            height: 20,
                            child: CenturyGothicText(
                              data: 'Save',
                              fontSize: 18,
                              textColor: Colors.black,
                            ),
                          ))),
          ),
        ],
      ),
    );
  }
}

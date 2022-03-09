import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/widgets/century_gothic_text.dart';
import 'package:tripd_travel_app/components/widgets/stretched_text_button.dart';
import 'package:tripd_travel_app/services/profile_service.dart';
import 'package:tripd_travel_app/theme/resources/colors.dart';

class InvitePage extends StatefulWidget {
  const InvitePage({Key? key}) : super(key: key);

  @override
  _InvitePageState createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  bool isLoading = false;

  TextEditingController _messageController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  var message;

  void _sendEmailInvite() async {
    final profileService = Provider.of<Profile>(context, listen: false);
    var response = await profileService.requestSignup(
        email: _emailController.text, context: context);
    setState(() {
      message = response;
    });
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
                    data: 'Invites',
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
                  Container(
                    width: 260,
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(
                            text: 'Send an Invite to your friends to join ',
                            style: TextStyle(
                                fontFamily: 'CenturyGothic',
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'Tripd :)',
                            style: TextStyle(
                                fontFamily: 'CenturyGothic',
                                fontSize: 18,
                                color: color1,
                                fontWeight: FontWeight.bold))
                      ]),
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
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
                            CenturyGothicText(data: 'Email', fontSize: 12),
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
                            controller: _emailController,
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
                              suffixIcon: IconButton(
                                splashRadius: double.minPositive,
                                icon: Icon(Icons.close),
                                color: color1,
                                iconSize: 20,
                                onPressed: () {
                                  _emailController.clear();
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
                            CenturyGothicText(data: 'Phone', fontSize: 12),
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
                            controller: _phoneController,
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
                              suffixIcon: IconButton(
                                splashRadius: double.minPositive,
                                icon: Icon(Icons.close),
                                color: color1,
                                iconSize: 20,
                                onPressed: () {
                                  _phoneController.clear();
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
                            CenturyGothicText(
                                data: 'Invite Message', fontSize: 12),
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
                            controller: _messageController,
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
                              hintText: 'Your Message',
                              suffixIcon: IconButton(
                                splashRadius: double.minPositive,
                                icon: Icon(Icons.close),
                                color: color1,
                                iconSize: 20,
                                onPressed: () {
                                  _messageController.clear();
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
                      _sendEmailInvite();
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
                              data: 'Send Invite',
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

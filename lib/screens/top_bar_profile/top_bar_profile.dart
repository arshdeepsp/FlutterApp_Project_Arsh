import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/widgets/border_text_button.dart';
import 'package:tripd_travel_app/models/PublicProfile.dart';
import 'package:tripd_travel_app/services/auth_service.dart';
import 'package:tripd_travel_app/services/profile_service.dart';
import 'package:tripd_travel_app/theme/resources/color_code.dart';

class TopBarProfile extends StatefulWidget {
  TopBarProfile({Key? key}) : super(key: key);

  @override
  _TopBarProfileState createState() => _TopBarProfileState();
}

class _TopBarProfileState extends State<TopBarProfile> {
  final Color color1 = HexColor("6700E3");
  final Profile profile = Profile();
  String followText = "Follow";
  PublicProfile? userProfile;
  void getProfile() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    var idToken = await auth.currentUser!.getIdToken();
    // print(idToken);
    var userId;

    var myProfile = await profile.getProfile(token: idToken);
    if (myProfile["status"]) {
      userId = myProfile["data"]["userId"];
    }

    // print(userId);
    var userProfileData =
        await profile.getProfile(token: idToken, userId: userId);
    if (userProfileData["status"]) {
      // username = userProfile["data"]["username"];
      setState(() => {
            // userProfile = userProfileData["data"],
            userProfile = PublicProfile.fromJson(userProfileData["data"])
          });
    }
  }

  @override
  void initState() {
    getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).size.height * 0.035;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, topPadding, 10, 0),
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      alignment: Alignment.centerLeft,
                      height: 70,
                      child: IconButton(
                          iconSize: 35,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back)),
                    )),
                    Container(
                        alignment: Alignment.center,
                        color: Colors.white,
                        height: 50,
                        child: Text(
                          'tripd',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Eurofurence',
                              fontSize: 38,
                              color: color1),
                        )),
                    Expanded(child: SizedBox()),
                  ],
                ),
              ),
            ),
            userProfile == null
                ? LinearProgressIndicator(
                    color: color1,
                    backgroundColor: Colors.deepPurple.shade200,
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: Column(
                      children: [
                        Text("@${userProfile!.username ?? 'username'}",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontFamily: 'CenturyGothic',
                                fontSize: 17)),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            ClipOval(
                              child: Material(
                                color: Colors.transparent,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Ink.image(
                                    image: Image.network(userProfile!
                                                    .profilePic !=
                                                null
                                            ? userProfile!.profilePic!
                                            : "https://tripd-ms.s3.us-west-1.amazonaws.com/default/default%20image.png")
                                        .image,
                                    fit: BoxFit.cover,
                                    width: 75,
                                    height: 75,
                                    // child: InkWell(onTap: onClicked),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Column(
                              children: [
                                Text(
                                  userProfile!.followers != null
                                      ? userProfile!.followers!.toString()
                                      : "0",
                                  style: TextStyle(
                                      fontFamily: 'CenturyGothic',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                                Text(
                                  "Followers",
                                  style: TextStyle(
                                      fontFamily: 'CenturyGothic',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                            SizedBox(width: 15),
                            Column(
                              children: [
                                Text(
                                  userProfile!.following != null
                                      ? userProfile!.following!.toString()
                                      : "0",
                                  style: TextStyle(
                                      fontFamily: 'CenturyGothic',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                                Text(
                                  "Following",
                                  style: TextStyle(
                                      fontFamily: 'CenturyGothic',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                )
                              ],
                            ),
                            Expanded(child: SizedBox()),
                            BorderTextButton(
                                data: 'Settings',
                                borderColor: color1,
                                borderRadius: 10,
                                fontSize: 15,
                                onPressed: () {},
                                textColor: color1,
                                overlayColor: Colors.grey.shade300)
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Bio",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'CenturyGothic'),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text("${userProfile!.bio ?? ''}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'CenturyGothic')),
                              ],
                            ),
                            (userProfile!.plans!.length == 0)
                                ? Container()
                                : const Divider(
                                    height: 30,
                                    thickness: 1,
                                    indent: 0,
                                    endIndent: 0,
                                  ),
                            (userProfile!.plans!.length == 0)
                                ? Container()
                                : Column(children: [
                                    Row(children: [
                                      Text("Wants to do",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'CenturyGothic'))
                                    ]),
                                    GridView.count(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 15, 0, 0),
                                        physics: NeverScrollableScrollPhysics(),
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 20,
                                        shrinkWrap: true,
                                        children:
                                            userProfile!.plans!.map((item) {
                                          return InkWell(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            onTap: () {
                                              print('tap');
                                            },
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Container(
                                                    color: Colors.grey.shade300,
                                                    width: double.infinity,
                                                    height: 110,
                                                    child: (item.file == null)
                                                        ? Container(
                                                            child: Text(
                                                                'No image',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'CenturyGothic')),
                                                            color: Colors
                                                                .grey.shade200,
                                                          )
                                                        : Image.network(
                                                            item.file!,
                                                            fit: BoxFit.cover,
                                                          ))),
                                          );
                                        }).toList())
                                  ]),
                            (userProfile!.collections!.length == 0)
                                ? Container()
                                : const Divider(
                                    height: 30,
                                    thickness: 1,
                                    indent: 0,
                                    endIndent: 0,
                                  ),
                            (userProfile!.collections!.length == 0)
                                ? Container()
                                : Column(children: [
                                    Row(children: [
                                      Text("Collections",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'CenturyGothic'))
                                    ]),
                                    (userProfile!.collections!.length == 0)
                                        ? Container()
                                        : GridView.count(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 15, 0, 0),
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 20,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            mainAxisSpacing: 20,
                                            shrinkWrap: true,
                                            children: [
                                                ...userProfile!.collections!
                                                    .map((item) {
                                                      return InkWell(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        onTap: () {
                                                          print('tap');
                                                        },
                                                        child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child: Container(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300,
                                                                width: double
                                                                    .infinity,
                                                                height: 110,
                                                                child: (item.collectionImage ==
                                                                        null)
                                                                    ? Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child: Text(
                                                                            'No image',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: TextStyle(fontFamily: 'CenturyGothic')),
                                                                        color: Colors
                                                                            .grey
                                                                            .shade200,
                                                                      )
                                                                    : Image
                                                                        .network(
                                                                        item.collectionImage!,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ))),
                                                      );
                                                    })
                                                    .toList()
                                                    .sublist(
                                                        0,
                                                        userProfile!.collections!
                                                                    .length >=
                                                                5
                                                            ? 5
                                                            : userProfile!
                                                                .collections!
                                                                .length),
                                                userProfile!.collections!
                                                            .length >
                                                        5
                                                    ? Container(
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 0.2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: InkWell(
                                                            splashColor:
                                                                Colors.grey,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            onTap: () {},
                                                            child: Container(
                                                                height: 100,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    "See More",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          'CenturyGothic',
                                                                    )))),
                                                      )
                                                    : Container()
                                              ])
                                  ])
                          ],
                        )
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

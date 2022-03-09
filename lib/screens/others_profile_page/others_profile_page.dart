import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/domain/collection_item.dart';
import 'package:tripd_travel_app/components/domain/image_bar.dart';
import 'package:tripd_travel_app/components/widgets/border_text_button.dart';
import 'package:tripd_travel_app/components/widgets/century_gothic_text.dart';
import 'package:tripd_travel_app/components/streams/streams.dart';
import 'package:tripd_travel_app/models/PublicProfile.dart';
import 'package:tripd_travel_app/models/collection.dart';
import 'package:tripd_travel_app/models/user_profile.dart';
import 'package:tripd_travel_app/services/auth_service.dart';
import 'package:tripd_travel_app/services/collection_service.dart';
import 'package:tripd_travel_app/services/profile_service.dart';
import 'package:tripd_travel_app/theme/resources/color_code.dart';
import 'package:tripd_travel_app/theme/resources/custom_scroll_behaviour.dart';

class OthersProfilePage extends StatefulWidget {
  OthersProfilePage({Key? key, this.userId}) : super(key: key);
  final String? userId;
  @override
  _OthersProfilePageState createState() => _OthersProfilePageState();
}

class _OthersProfilePageState extends State<OthersProfilePage> {
  final Color color1 = HexColor("6700E3");
  final Profile profile = Profile();
  String followText = "Follow";
  int collectionCount = 5;
  List<Collection>? collectionList;
  PublicProfile? userProfile;

  UserProfile? profileData;

  void _getProfileData() async {
    final profileService = Provider.of<Profile>(context, listen: false);
    final auth = Provider.of<AuthService>(context, listen: false);
    var token = await auth.currentUser!.getIdToken();
    var data = await profileService.getProfile(token: token);

    setState(() {
      profileData = data;
    });
  }

  void getProfile() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    var idToken = await auth.currentUser!.getIdToken();
    // print(idToken);
    var userId;
    if (widget.userId == null) {
      var myProfile = await profile.getProfileJson(token: idToken);
      if (myProfile["status"]) {
        userId = myProfile["data"]["userId"];
      }
    } else {
      userId = widget.userId;
    }
    // print(userId);
    var userProfileData =
        await profile.getProfileJson(token: idToken, userId: userId);
    if (userProfileData["status"]) {
      // username = userProfile["data"]["username"];
      setState(() => {
            // userProfile = userProfileData["data"],
            userProfile = PublicProfile.fromJson(userProfileData["data"])
          });
    }
  }

  getAllCollection() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    var idToken = await auth.currentUser!.getIdToken();
    print(idToken);

    final collectionService =
        Provider.of<CollectionService>(context, listen: false);
    var allCollections =
        await collectionService.getAllCollection(token: idToken);
    setState(() {
      collectionList = allCollections;
    });
  }

  followUser() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    var idToken = await auth.currentUser!.getIdToken();
    var followResp =
        await profile.followUser(token: idToken, userId: widget.userId);
    if (followResp["status"]) {
      setState(() {
        followText = "Following";
      });
    }
  }

  @override
  void initState() {
    getProfile();
    _getProfileData();
    getAllCollection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var max = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ImageBar(),
          const Divider(
            thickness: 0.5,
            height: 0,
          ),
          userProfile == null
              ? LinearProgressIndicator(
                  color: color1,
                  backgroundColor: Colors.deepPurple.shade200,
                )
              : Expanded(
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: max * 0.015,
                            ),
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
                                    child: widget.userId != null
                                        ? Ink.image(
                                            image: Image.network(profileData!
                                                            .profilePic !=
                                                        null
                                                    ? profileData!.profilePic!
                                                    : "https://tripd-ms.s3.us-west-1.amazonaws.com/default/default%20image.png")
                                                .image,
                                            fit: BoxFit.cover,
                                            width: 75,
                                            height: 75,
                                            // child: InkWell(onTap: onClicked),
                                          )
                                        : GestureDetector(
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
                                widget.userId != null
                                    ? BorderTextButton(
                                        data: followText,
                                        borderColor: color1,
                                        borderRadius: 10,
                                        fontSize: 15,
                                        onPressed: followUser,
                                        textColor: color1,
                                        overlayColor: Colors.grey.shade300,
                                      )
                                    : BorderTextButton(
                                        data: 'Settings',
                                        borderColor: color1,
                                        borderRadius: 10,
                                        fontSize: 15,
                                        onPressed: () {
                                          drawerController.sink.add('drawer');
                                        },
                                        textColor: color1,
                                        overlayColor: Colors.grey.shade300)
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Column(
                              children: [
                                (userProfile!.firstName != null)
                                    ? Row(
                                        children: [
                                          Text(
                                            "${userProfile!.firstName} ${userProfile!.lastName}",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'CenturyGothic'),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                (userProfile!.firstName != null)
                                    ? const Divider(
                                        height: 30,
                                        thickness: 1,
                                        indent: 0,
                                        endIndent: 0,
                                      )
                                    : Container(),
                                (userProfile!.bio != null)
                                    ? Row(
                                        children: [
                                          Text(
                                            "Bio",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'CenturyGothic'),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                (userProfile!.bio != null)
                                    ? SizedBox(
                                        height: 5,
                                      )
                                    : Container(),
                                (userProfile!.bio != null)
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: CenturyGothicText(
                                              data: "${userProfile!.bio ?? ''}",
                                              fontSize: 15,
                                              textOverflow: TextOverflow.clip,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                (userProfile!.bio != null)
                                    ? const Divider(
                                        height: 30,
                                        thickness: 1,
                                        indent: 0,
                                        endIndent: 0,
                                      )
                                    : Container(),
                                (userProfile!.plans!.length == 0)
                                    ? Container()
                                    : Column(children: [
                                        Row(children: [
                                          Text("Wants to do",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: 'CenturyGothic'))
                                        ]),
                                        GridView.count(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 15, 0, 0),
                                            physics:
                                                NeverScrollableScrollPhysics(),
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
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Container(
                                                        color: Colors
                                                            .grey.shade300,
                                                        width: double.infinity,
                                                        height: 110,
                                                        child:
                                                            (item.file == null)
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
                                                                        .grey
                                                                        .shade200,
                                                                  )
                                                                : Image.network(
                                                                    item.file!,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ))),
                                              );
                                            }).toList())
                                      ]),
                                (userProfile!.plans!.length == 0)
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
                                                  fontSize: 18,
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
                                                      return CollectionItem(
                                                          item: item);

                                                      // InkWell(
                                                      //   borderRadius:
                                                      //       BorderRadius.circular(
                                                      //           10),
                                                      //   onTap: () {
                                                      //     print('tap');
                                                      //   },
                                                      //   child: ClipRRect(
                                                      //       borderRadius:
                                                      //           BorderRadius
                                                      //               .circular(10),
                                                      //       child: Container(
                                                      //           color: Colors.grey
                                                      //               .shade300,
                                                      //           width: double
                                                      //               .infinity,
                                                      //           height: 110,
                                                      //           child: (item.collectionImage ==
                                                      //                   null)
                                                      //               ? Container(
                                                      //                   alignment:
                                                      //                       Alignment
                                                      //                           .center,
                                                      //                   child: Text(
                                                      //                       'No image',
                                                      //                       textAlign: TextAlign
                                                      //                           .center,
                                                      //                       style:
                                                      //                           TextStyle(fontFamily: 'CenturyGothic')),
                                                      //                   color: Colors
                                                      //                       .grey
                                                      //                       .shade200,
                                                      //                 )
                                                      //               : Image
                                                      //                   .network(
                                                      //                   item.collectionImage!,
                                                      //                   fit: BoxFit
                                                      //                       .cover,
                                                      //                 ))),
                                                      // );
                                                    }).toList()
                                                  ])
                                      ])
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

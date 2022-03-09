import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/domain/all_offerings_collection.dart';
import 'package:tripd_travel_app/components/domain/top_bar.dart';
import 'package:tripd_travel_app/screens/others_profile_page/others_profile_page.dart';
import 'package:tripd_travel_app/screens/plan_details/plan_details.dart';
import 'package:tripd_travel_app/services/socket_service.dart';
import 'package:tripd_travel_app/theme/resources/colors.dart';
import 'package:tripd_travel_app/theme/resources/custom_scroll_behaviour.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopBar(),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30)),
            child: TextField(
              focusNode: _focusNode,
              onChanged: (text) async {},
              cursorColor: color1,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Search user',
                suffixIcon: IconButton(
                  splashRadius: double.minPositive,
                  icon: Icon(Icons.close),
                  color: color1,
                  iconSize: 25,
                  onPressed: () {
                    _focusNode.unfocus();
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
        ),
        Expanded(
            child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: SingleChildScrollView(
            child: Consumer<SocketService>(builder: (_, stomptNotifier, __) {
              print("stomptNotifier feeds printing.............");
              print(stomptNotifier.feeds.length);
              print(stomptNotifier.feeds.last);
              var validFeeds = stomptNotifier.feeds.where(
                  (feed) => feed["user"] != null && feed["object"] != null);

              return Container(
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  // itemCount: stomptNotifier.feeds.length,
                  itemCount: validFeeds.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: MaterialButton(
                          padding: EdgeInsets.all(20),
                          elevation: 0,
                          color: Colors.white,
                          onPressed: () {
                            setState(() {});
                          },
                          splashColor: Colors.transparent,
                          child: Padding(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () => {
                                        Navigator.push(context,
                                            PageRouteBuilder(
                                                pageBuilder: (context, a, b) {
                                          return OthersProfilePage(
                                              userId: stomptNotifier.feeds!
                                                      .elementAt(index)["user"]
                                                  ["userId"]);
                                        }))
                                      },
                                      child: ClipOval(
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Ink.image(
                                            image: Image.network(
                                                    "${validFeeds!.elementAt(index)["user"]["profilePic"]}")
                                                .image,
                                            fit: BoxFit.cover,
                                            width: 35,
                                            height: 35,
                                            // child: InkWell(onTap: onClicked),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        enableFeedback: true,
                                        onTap: () {},
                                        child: Container(
                                            width: 290,
                                            child: Text.rich(
                                              validFeeds!.elementAt(
                                                          index)["user"] !=
                                                      null
                                                  ? TextSpan(
                                                      // default text style
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text:
                                                                '${validFeeds.elementAt(index)["user"]["username"]} ',
                                                            style: TextStyle(
                                                                overflow:
                                                                    TextOverflow
                                                                        .clip,
                                                                fontFamily:
                                                                    'CenturyGothic',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        TextSpan(
                                                            text:
                                                                '${validFeeds!.elementAt(index)["verb"]} named ',
                                                            style: TextStyle(
                                                                overflow:
                                                                    TextOverflow
                                                                        .clip,
                                                                fontFamily:
                                                                    'CenturyGothic',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal)),
                                                        TextSpan(
                                                            text:
                                                                '${validFeeds!.elementAt(index)["object"]["name"]}',
                                                            style: TextStyle(
                                                                overflow:
                                                                    TextOverflow
                                                                        .clip,
                                                                fontFamily:
                                                                    'CenturyGothic',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ],
                                                    )
                                                  : TextSpan(
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text: ' Somebody ',
                                                            style: TextStyle(
                                                                overflow:
                                                                    TextOverflow
                                                                        .clip,
                                                                fontFamily:
                                                                    'CenturyGothic',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic)),
                                                        TextSpan(
                                                            text:
                                                                '${validFeeds!.elementAt(index)["verb"]}',
                                                            style: TextStyle(
                                                                overflow:
                                                                    TextOverflow
                                                                        .clip,
                                                                fontFamily:
                                                                    'CenturyGothic',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ],
                                                    ),
                                            ))),
                                    Expanded(child: SizedBox())
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 40),
                                  child: InkWell(
                                    onTap: () => {
                                      if (validFeeds!
                                              .elementAt(index)["feedType"] ==
                                          "collection")
                                        {
                                          print(validFeeds!
                                              .elementAt(index)["object"]),
                                          Navigator.push(context,
                                              PageRouteBuilder(
                                                  pageBuilder: (context, a, b) {
                                            return AllOfferingsByCollection(
                                                collectionId: validFeeds!
                                                    .elementAt(
                                                        index)["object"]["id"]);
                                          }))
                                        }
                                      else if (validFeeds!
                                              .elementAt(index)["feedType"] ==
                                          "plan")
                                        {
                                          Navigator.push(context,
                                              PageRouteBuilder(
                                                  pageBuilder: (context, a, b) {
                                            return PlanDetailsPage(
                                              id: validFeeds!.elementAt(
                                                  index)["object"]["id"],
                                            );
                                          }))
                                        }
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                          // "${stomptNotifier.feeds!.elementAt(index)["object"]["${stomptNotifier.feeds!.elementAt(index)["feedType"]}Image"]}"
                                          "${validFeeds.elementAt(index)["object"]["${validFeeds!.elementAt(index)["feedType"]}Image"]}",
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error,
                                                  stackTrace) =>
                                              Container(
                                                height: 100,
                                                width: 100,
                                                color: Colors.grey.shade200,
                                                alignment: Alignment.center,
                                                child: Text('No image',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'CenturyGothic')),
                                              )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(5),
                          )),
                    );
                  },
                ),
              );
            }),
          ),
        ))
      ],
    );
  }
}

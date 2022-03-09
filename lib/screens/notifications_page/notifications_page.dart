import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/widgets/century_gothic_text.dart';
import 'package:tripd_travel_app/services/socket_service.dart';
import 'package:tripd_travel_app/theme/resources/colors.dart';
import 'package:tripd_travel_app/theme/resources/custom_scroll_behaviour.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
        ),
        Row(children: [
          Expanded(
              child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            alignment: Alignment.centerLeft,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: 35,
                )),
          )),
          CenturyGothicText(
              data: 'Notifications',
              fontSize: 25,
              textColor: Colors.black,
              textAlign: TextAlign.center),
          Expanded(child: SizedBox()),
        ]),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
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
                hintText: 'Search',
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
              child: Consumer<SocketService>(
                builder: (_, stomptNotifier, __) => ListView.builder(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: stomptNotifier.notifications.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      splashFactory: NoSplash.splashFactory,
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Container(
                          height: 60,
                          child: Row(
                            children: [
                              Image.network(
                                // "https://tripd-ms.s3.us-west-1.amazonaws.com/default/default%20image.png",
                                stomptNotifier.notifications
                                    .elementAt(index)["user"]["profilePic"],
                                height: 50,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                children: [
                                  Expanded(child: SizedBox()),
                                  Container(
                                    width: 250,
                                    child: CenturyGothicText(
                                      data: stomptNotifier.notifications
                                          .elementAt(index)["verb"],
                                      fontSize: 13,
                                      textOverflow: TextOverflow.clip,
                                    ),
                                  ),
                                  Expanded(child: SizedBox()),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

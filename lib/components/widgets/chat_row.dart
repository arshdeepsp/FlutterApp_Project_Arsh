import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/widgets/century_gothic_text.dart';
import 'package:tripd_travel_app/components/widgets/stacked_widgets.dart';
import 'package:tripd_travel_app/screens/group_details_page/group_details_page.dart';
import 'package:tripd_travel_app/services/socket_service.dart';
import 'package:tripd_travel_app/theme/resources/colors.dart';

class ChatRow extends StatelessWidget {
  const ChatRow({Key? key, required this.items}) : super(key: key);
  final List items;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
      child: Column(
          children: items.map((plan) {
        // ignore: unused_local_variable
        List<Widget> list = plan["members"]
            .map<Widget>((member) => buildImage(member["profilePic"]))
            .toList();

        return InkWell(
          splashFactory: InkRipple.splashFactory,
          onTap: () => {
            Navigator.push(context,
                PageRouteBuilder(pageBuilder: (context, a, b) {
              return GroupDetails(groupId: plan["id"], group: plan);
            }))
          },
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                StackedWidgets(items: list),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: CenturyGothicText(
                        textOverflow: TextOverflow.ellipsis,
                        data: plan["name"],
                        fontSize: 15,
                        textAlign: TextAlign.left),
                  ),
                ),
                CenturyGothicText(
                    data: '7:45 PM', fontSize: 15, textAlign: TextAlign.center),
                SizedBox(width: 10),
                Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: color1,
                    ),
                    height: 30,
                    width: 30,
                    child: Center(
                      child: Consumer<SocketService>(
                        builder: (_, socketNotifier, __) {
                          int liveCount = socketNotifier.liveMessageCount
                                  .containsKey(plan["id"])
                              ? socketNotifier.liveMessageCount[plan["id"]]
                              : 0;

                          return CenturyGothicText(
                            data: (plan["count"] + liveCount).toString(),
                            fontSize: 13,
                            textColor: Colors.white,
                          );
                        },
                      ),
                    ))
              ],
            ),
          ),
        );
      }).toList()),
    );
  }
}

Widget buildImage(String urlImage) {
  return ClipOval(
    child: Image.network(
      urlImage,
      fit: BoxFit.cover,
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/domain/collection_item.dart';
import 'package:tripd_travel_app/components/domain/plan_item.dart';
import 'package:tripd_travel_app/models/group_saves.dart';
import 'package:tripd_travel_app/services/auth_service.dart';
import 'package:tripd_travel_app/services/socket_service.dart';

class GroupSavesView extends StatefulWidget {
  const GroupSavesView({Key? key, required this.groupId}) : super(key: key);
  final String groupId;
  @override
  _GroupSavesViewState createState() => _GroupSavesViewState();
}

class _GroupSavesViewState extends State<GroupSavesView> {
  List<GroupSave> groupSaves = [];
  getGroupSaves() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    var idToken = await auth.currentUser!.getIdToken();
    final socketService = Provider.of<SocketService>(context, listen: false);
    var grpSaves = await socketService.getGroupSaves(
        token: idToken, groupId: widget.groupId);
    setState(() {
      groupSaves = grpSaves;
    });
  }

  @override
  void initState() {
    getGroupSaves();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        children: groupSaves.map((item) {
          print(item.content);
          return InkWell(
            onTap: () {
              print('tap');
            },
            child: item.type == GroupSavesType.Plan
                ? PlanItem(item: item.content)
                : item.type == GroupSavesType.Collection
                    ? CollectionItem(item: item.content, similarToPlans: true)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                            color: Colors.grey.shade300,
                            width: double.infinity,
                            height: 110,
                            child: (item.image == null)
                                ? Container(
                                    child: Text('No image',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'CenturyGothic')),
                                    color: Colors.grey.shade200,
                                  )
                                : Image.network(
                                    item.image!,
                                    fit: BoxFit.cover,
                                  ))),
          );
        }).toList());
  }
}

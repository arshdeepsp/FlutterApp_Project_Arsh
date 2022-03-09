import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/dialogs/plans_dialog.dart';
import 'package:tripd_travel_app/services/auth_service.dart';
import 'package:tripd_travel_app/services/group_service.dart';
import 'package:tripd_travel_app/services/plan_service.dart';
import 'package:tripd_travel_app/theme/resources/border_preset.dart';

import 'group_dialog.dart';

class OptionsDialog extends StatefulWidget {
  @override
  _OptionsDialogState createState() => _OptionsDialogState();
}

class _OptionsDialogState extends State<OptionsDialog> {
  Future<void> _initPlan() async {
    final planService = Provider.of<PlanService>(context, listen: false);
    final auth = Provider.of<AuthService>(context, listen: false);
    final idToken = await auth.currentUser!.getIdToken();
    var response = await planService.initializePlan(
      token: idToken,
    );
    if (response['status']) {
      await showDialog(
          context: context,
          builder: (BuildContext context) => PlanDialog(
              id: response['data']['id'], groupId: response['data']['groupId']),
          barrierDismissible: false);
      // print(callback);
      Navigator.pop(context);
    } else {
      print(response['status']);
    }
  }

  void _initGroup() async {
    final groupService = Provider.of<GroupService>(context, listen: false);
    final auth = Provider.of<AuthService>(context, listen: false);
    final idToken = await auth.currentUser!.getIdToken();
    var response = await groupService.initializeGroup(
      token: idToken,
    );
    // print(response);
    if (response['status']) {
      await showDialog(
          context: context,
          builder: (BuildContext context) => GroupDialog(
                groupId: response['data']['id'],
              ),
          barrierDismissible: false);

      Navigator.pop(context);
    } else {
      // print(response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderPresets.borderSide()),
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 35, 0, 35),
        alignment: Alignment.center,
        height: 200,
        width: 100,
        child: Column(
          children: [
            TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                    overlayColor:
                        MaterialStateProperty.all(Colors.grey.shade100)),
                onPressed: () {
                  _initPlan();
                },
                child: Text(
                  'Create a plan',
                  style: TextStyle(
                      fontFamily: 'CenturyGothic',
                      fontSize: 17,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                )),
            const Divider(
              height: 25,
              thickness: 2,
              indent: 30,
              endIndent: 30,
            ),
            TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                    overlayColor:
                        MaterialStateProperty.all(Colors.grey.shade100)),
                onPressed: _initGroup,
                child: Text(
                  'Create a Group Chat',
                  style: TextStyle(
                      fontFamily: 'CenturyGothic',
                      fontSize: 17,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                )),
          ],
        ),
      ),
    );
  }
}

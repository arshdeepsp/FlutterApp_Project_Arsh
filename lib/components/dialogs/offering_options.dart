import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/dialogs/add_to_chat_dialog.dart';
import 'package:tripd_travel_app/components/dialogs/plans_dialog.dart';
import 'package:tripd_travel_app/components/dialogs/view_plans_dialog.dart';
import 'package:tripd_travel_app/components/domain/collections.dart';
import 'package:tripd_travel_app/services/auth_service.dart';
import 'package:tripd_travel_app/services/plan_service.dart';
import 'package:tripd_travel_app/theme/resources/border_preset.dart';

class OfferingOptions extends StatefulWidget {
  const OfferingOptions({Key? key, required this.offeringId}) : super(key: key);
  final offeringId;
  @override
  _OfferingOptionsState createState() => _OfferingOptionsState();
}

Future<void> _initPlan(BuildContext context) async {
  final planService = Provider.of<PlanService>(context, listen: false);
  final auth = Provider.of<AuthService>(context, listen: false);
  final idToken = await auth.currentUser!.getIdToken();
  var response = await planService.initializePlan(
    token: idToken,
  );
  if (response['status']) {
    int callback = await showDialog(
        context: context,
        builder: (BuildContext context) => PlanDialog(
            id: response['data']['id'], groupId: response['data']['groupId']),
        barrierDismissible: false);
    // print(callback);
    Navigator.pop(context, callback);
  } else {
    print(response['status']);
  }
}

class _OfferingOptionsState extends State<OfferingOptions> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.fromLTRB(70, 0, 70, 0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderPresets.borderSide()),
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
        alignment: Alignment.center,
        height: 240,
        child: Column(
          children: [
            TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                    overlayColor:
                        MaterialStateProperty.all(Colors.grey.shade100)),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => Collections(
                          forModal: true, offeringId: widget.offeringId));
                },
                child: Text(
                  'Add to Collection',
                  style: TextStyle(
                      fontFamily: 'CenturyGothic',
                      fontSize: 18,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                )),
            Expanded(child: SizedBox()),
            const Divider(
              thickness: 0.5,
              height: 5,
            ),
            Expanded(child: SizedBox()),
            TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                    overlayColor:
                        MaterialStateProperty.all(Colors.grey.shade100)),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => ViewPlansDialog(
                          forModal: true, offeringId: widget.offeringId));
                },
                child: Text(
                  'Add to Plans',
                  style: TextStyle(
                      fontFamily: 'CenturyGothic',
                      fontSize: 18,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                )),
            Expanded(child: SizedBox()),
            const Divider(
              thickness: 0.5,
              height: 5,
            ),
            Expanded(child: SizedBox()),
            TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                    overlayColor:
                        MaterialStateProperty.all(Colors.grey.shade100)),
                onPressed: () {
                  _initPlan(context);
                },
                child: Text(
                  'Create a Plan',
                  style: TextStyle(
                      fontFamily: 'CenturyGothic',
                      fontSize: 18,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                )),
            Expanded(child: SizedBox()),
            const Divider(
              height: 5,
              thickness: 0.5,
            ),
            Expanded(child: SizedBox()),
            TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                    overlayColor:
                        MaterialStateProperty.all(Colors.grey.shade100)),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AddToChatDialog(
                          type: "offering",
                          typeId: widget.offeringId,
                          image: ""),
                      barrierDismissible: true);
                },
                child: Text(
                  'Share to chat',
                  style: TextStyle(
                      fontFamily: 'CenturyGothic',
                      fontSize: 18,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                )),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/dialogs/plans_dialog.dart';
import 'package:tripd_travel_app/components/domain/view_plan_layout.dart';
import 'package:tripd_travel_app/components/widgets/century_gothic_text.dart';
import 'package:tripd_travel_app/models/plan.dart';
import 'package:tripd_travel_app/services/auth_service.dart';
import 'package:tripd_travel_app/services/plan_service.dart';
import 'package:tripd_travel_app/services/profile_service.dart';
import 'package:tripd_travel_app/theme/resources/colors.dart';

class ViewPlans extends StatefulWidget {
  @override
  _ViewPlansState createState() => _ViewPlansState();
}

class _ViewPlansState extends State<ViewPlans> {
  @override
  void initState() {
    super.initState();
    _getPlans();
  }

  List<Plan> createdPlans = [];
  List<Plan> invitedPlans = [];

  void _getPlans() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final planService = Provider.of<PlanService>(context, listen: false);
    final Profile profile = Profile();

    var idToken = await auth.currentUser!.getIdToken();
    var allPlans = await planService.getAllPlans(token: idToken);

    var userId;
    var myProfile = await profile.getProfileJson(token: idToken);
    if (myProfile["status"]) {
      userId = myProfile["data"]["userId"];
    }

    setState(() {
      createdPlans = allPlans.where((item) => item.creator == userId).toList();
      invitedPlans = allPlans.where((item) => item.creator != userId).toList();
    });
  }

  Future<void> _initPlan(BuildContext context) async {
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
              callback: _getPlans,
              id: response['data']['id'],
              groupId: response['data']['groupId']),
          barrierDismissible: false);
    } else {
      print(response['status']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Column(
            children: [
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
                    data: 'Plans',
                    fontSize: 30,
                    textColor: Colors.black,
                    textAlign: TextAlign.center),
                Expanded(child: SizedBox()),
              ]),
              SizedBox(
                height: 20,
              ),
              Expanded(
                  child: Container(
                width: double.infinity,
                child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        TabBar(
                          tabs: [
                            Container(
                                height: 40,
                                alignment: Alignment.center,
                                child: CenturyGothicText(
                                    data: 'Created',
                                    fontSize: 15,
                                    textColor: Colors.black,
                                    textAlign: TextAlign.center)),
                            Container(
                              height: 40,
                              alignment: Alignment.center,
                              child: CenturyGothicText(
                                  data: 'Invited To',
                                  fontSize: 15,
                                  textColor: Colors.black,
                                  textAlign: TextAlign.center),
                            ),
                          ],
                          indicator: UnderlineTabIndicator(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black),
                              insets: EdgeInsets.all(0)),
                        ),
                        Expanded(
                            child: TabBarView(children: [
                          ViewPlanLayout(plans: createdPlans),
                          ViewPlanLayout(plans: invitedPlans),
                        ]))
                      ],
                    )),
              ))
            ],
          ),
        ),
        floatingActionButton: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: () {
              _initPlan(context);
            },
            child: Container(
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: color1,
                    border: Border.all(width: 2, color: Colors.white)),
                child:
                    Icon(Icons.add_rounded, color: Colors.white, size: 50))));
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/widgets/century_gothic_text.dart';
import 'package:tripd_travel_app/components/widgets/custom_text.dart';
import 'package:tripd_travel_app/models/plan.dart';
import 'package:tripd_travel_app/services/auth_service.dart';
import 'package:tripd_travel_app/services/plan_service.dart';
import 'package:tripd_travel_app/theme/resources/border_preset.dart';
import 'package:tripd_travel_app/theme/resources/colors.dart';
import 'package:tripd_travel_app/theme/resources/custom_scroll_behaviour.dart';

class ViewPlansDialog extends StatefulWidget {
  const ViewPlansDialog({Key? key, this.forModal = false, this.offeringId})
      : super(key: key);
  final forModal;
  final offeringId;
  @override
  _ViewPlansDialogState createState() => _ViewPlansDialogState();
}

class _ViewPlansDialogState extends State<ViewPlansDialog> {
  @override
  void initState() {
    super.initState();
    _getPlans();
  }

  List<Plan>? plans = [];
  var status;

  void _getPlans() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final planService = Provider.of<PlanService>(context, listen: false);

    var idToken = await auth.currentUser!.getIdToken();
    var allPlans = await planService.getAllPlans(token: idToken);

    setState(() {
      plans = allPlans;
    });
  }

  addOffering({required String id}) async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final planService = Provider.of<PlanService>(context, listen: false);
    var idToken = await auth.currentUser!.getIdToken();
    status = await planService.addOffering(
        token: idToken,
        id: id,
        offeringId: widget.offeringId,
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    var container = Container(
        height: 450,
        child: plans == null
            ? LinearProgressIndicator(
                color: color1,
                backgroundColor: Colors.deepPurple.shade200,
              )
            : Padding(
                padding: EdgeInsets.all(15),
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: SizedBox()),
                          CustomText(
                            data: "My Plans",
                            fontFamily: 'CenturyGothic',
                            fontSize: 25,
                            textAlign: TextAlign.center,
                            textColor: Colors.black,
                            fontWeight: FontWeight.w100,
                          ),
                          Expanded(child: SizedBox()),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      TabBar(
                        indicatorPadding: EdgeInsets.fromLTRB(30, 0, 30, 2),
                        tabs: [
                          Container(
                              height: 30,
                              alignment: Alignment.center,
                              child: CenturyGothicText(
                                  data: 'Created',
                                  fontSize: 15,
                                  textColor: Colors.black,
                                  textAlign: TextAlign.center)),
                          Container(
                            height: 30,
                            alignment: Alignment.center,
                            child: CenturyGothicText(
                                data: 'Invited To',
                                fontSize: 15,
                                textColor: Colors.black,
                                textAlign: TextAlign.center),
                          ),
                        ],
                        indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            ScrollConfiguration(
                              behavior: MyBehavior(),
                              child: GlowingOverscrollIndicator(
                                axisDirection: AxisDirection.down,
                                color: color1,
                                child: GridView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            mainAxisExtent: 150,
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 8,
                                            crossAxisSpacing: 18),
                                    itemCount: plans!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Material(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            onTap: () async {
                                              await addOffering(
                                                  id: plans![index].id!);
                                            },
                                            splashFactory:
                                                NoSplash.splashFactory,
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              alignment: Alignment.bottomCenter,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: 130,
                                                    alignment: Alignment.center,
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        child: (plans!
                                                                    .elementAt(
                                                                        index)
                                                                    .file !=
                                                                null)
                                                            ? Image.network(
                                                                plans!
                                                                    .elementAt(
                                                                        index)
                                                                    .file,
                                                                fit: BoxFit
                                                                    .cover,
                                                                errorBuilder: (context,
                                                                        error,
                                                                        stackTrace) =>
                                                                    Text(
                                                                        'Some errors occurred!'),
                                                                height: 108.9,
                                                                width: 153,
                                                              )
                                                            : CircularProgressIndicator()),
                                                  ),
                                                  Opacity(
                                                    opacity: 0.3,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(child: SizedBox()),
                                                  Container(
                                                      width: 100,
                                                      alignment:
                                                          Alignment.center,
                                                      child: CenturyGothicText(
                                                        textOverflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                        textColor: Colors.black,
                                                        data: plans!
                                                            .elementAt(index)
                                                            .name!,
                                                        fontSize: 16,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ));
                                    }),
                              ),
                            ),
                            Container()
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));

    return widget.forModal
        ? Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderPresets.borderSide()),
            child: container,
          )
        : container;
  }
}

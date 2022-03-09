import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/dialogs/edit_plan.dart';
import 'package:tripd_travel_app/components/widgets/century_gothic_text.dart';
import 'package:tripd_travel_app/models/plan_info.dart';
import 'package:tripd_travel_app/screens/view_offering/view_offering.dart';
import 'package:tripd_travel_app/screens/view_plans/view_plans.dart';
import 'package:tripd_travel_app/services/auth_service.dart';
import 'package:tripd_travel_app/services/plan_service.dart';
import 'package:tripd_travel_app/theme/resources/color_code.dart';

class PlanDetailsPage extends StatefulWidget {
  const PlanDetailsPage({Key? key, required this.id}) : super(key: key);
  final String? id;

  @override
  _PlanDetailsPageState createState() => _PlanDetailsPageState();
}

class _PlanDetailsPageState extends State<PlanDetailsPage> {
  PlanInfo? planInfo;
  List<dynamic> offerings = [];
  Future deletePlan(context) async {
    final planService = Provider.of<PlanService>(context, listen: false);
    print(widget.id!);
    await planService.deletePlan(id: widget.id!);
  }

  Future getPlanDetails() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final planService = Provider.of<PlanService>(context, listen: false);
    var idToken = await auth.currentUser!.getIdToken();
    planInfo = await planService.getPlanDetails(token: idToken, id: widget.id!);
    setState(() {
      offerings = planInfo!.offerings!;
    });
  }

  @override
  void initState() {
    getPlanDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color color1 = HexColor("6700E3");

    return Scaffold(
      backgroundColor: Colors.white,
      body: (planInfo == null)
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.fromLTRB(0, 35, 0, 0),
              child: ScrollConfiguration(
                behavior: ScrollBehavior(),
                child: GlowingOverscrollIndicator(
                  axisDirection: AxisDirection.down,
                  color: color1,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
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
                          Container(
                            alignment: Alignment.center,
                            width: 200,
                            child: CenturyGothicText(
                              textAlign: TextAlign.center,
                              data: planInfo!.name!,
                              fontSize: 20,
                              textOverflow: TextOverflow.clip,
                              textColor: color1,
                            ),
                          ),
                          Expanded(child: SizedBox()),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
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
                                              data: 'Details',
                                              fontSize: 15,
                                              textColor: Colors.black,
                                              textAlign: TextAlign.center)),
                                      Container(
                                        height: 40,
                                        alignment: Alignment.center,
                                        child: CenturyGothicText(
                                            data: 'Offerings',
                                            fontSize: 15,
                                            textColor: Colors.black,
                                            textAlign: TextAlign.center),
                                      )
                                    ],
                                    indicator: UnderlineTabIndicator(
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.black),
                                        insets: EdgeInsets.all(0)),
                                  ),
                                  Expanded(
                                      child: TabBarView(children: [
                                    SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 10, 0),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(15),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    InkWell(
                                                      child: Row(children: [
                                                        CenturyGothicText(
                                                          data: 'Edit Plan',
                                                          fontSize: 15,
                                                        ),
                                                        SizedBox(width: 10),
                                                        Icon(Icons.edit),
                                                      ]),
                                                      onTap: () async {
                                                        await showDialog(
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context2) =>
                                                                EditPlan(
                                                                  deletePlan:
                                                                      () {
                                                                    deletePlan(
                                                                        context2);
                                                                    Navigator.pop(
                                                                        context2);
                                                                    Navigator.pushAndRemoveUntil(
                                                                        context,
                                                                        PageRouteBuilder(pageBuilder: (context,
                                                                            _,
                                                                            __) {
                                                                      return ViewPlans();
                                                                    }),
                                                                        ModalRoute.withName(
                                                                            '/'));
                                                                  },
                                                                ),
                                                            barrierDismissible:
                                                                false);
                                                      },
                                                      splashFactory: InkRipple
                                                          .splashFactory,
                                                    ),
                                                    Container(
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        decoration: BoxDecoration(
                                                            color: color1,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30)),
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              print('Hi');
                                                            },
                                                            child: Icon(
                                                              Icons.person_add,
                                                              color:
                                                                  Colors.white,
                                                              size: 20,
                                                            ))),
                                                  ]),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(child: SizedBox()),
                                                Container(
                                                  alignment: Alignment.center,
                                                  height: 50,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Colors.green,
                                                          width: 1.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.check_circle,
                                                        color: Colors.green,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      CenturyGothicText(
                                                          data: 'Yes',
                                                          textColor:
                                                              Colors.green,
                                                          fontSize: 15),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(child: SizedBox()),
                                                Container(
                                                  alignment: Alignment.center,
                                                  height: 50,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Colors
                                                              .yellow.shade800,
                                                          width: 1.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.help_rounded,
                                                        color: Colors
                                                            .yellow.shade800,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      CenturyGothicText(
                                                          textColor: Colors
                                                              .yellow.shade800,
                                                          data: 'Unsure',
                                                          fontSize: 15),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(child: SizedBox()),
                                                Container(
                                                  alignment: Alignment.center,
                                                  height: 50,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: color1,
                                                          width: 1.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.lock_clock,
                                                        color: color1,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      CenturyGothicText(
                                                          textColor: color1,
                                                          data: 'Another\nTime',
                                                          fontSize: 15),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(child: SizedBox()),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            planInfo!.creator == null
                                                ? LinearProgressIndicator(
                                                    color: color1,
                                                    backgroundColor: Colors
                                                        .deepPurple.shade200,
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          ClipOval(
                                                            child:
                                                                Image.network(
                                                              planInfo!.creator!
                                                                  .profilePic!,
                                                              fit: BoxFit.cover,
                                                              width: 45,
                                                              height: 45,
                                                            ),
                                                          ),
                                                          SizedBox(width: 10),
                                                          Text(
                                                            planInfo!.creator!
                                                                .username!,
                                                            style: TextStyle(
                                                                fontSize: 15),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.check_circle,
                                                            color: Colors.green,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          2),
                                                              decoration: BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                          color:
                                                                              color1)),
                                                              child: Center(
                                                                  child: Text(
                                                                      "Creator",
                                                                      style: TextStyle(
                                                                          color:
                                                                              color1)))),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                            Divider(
                                              height: 30,
                                            ),
                                            Column(
                                                children: planInfo!.members ==
                                                        null
                                                    ? [Container()]
                                                    : planInfo!.members!
                                                        .map<Widget>((member) =>
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      ClipOval(
                                                                        child: Image
                                                                            .network(
                                                                          member
                                                                              .profilePic,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          width:
                                                                              45,
                                                                          height:
                                                                              45,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              10),
                                                                      Text(
                                                                        member
                                                                            .username,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .help_rounded,
                                                                        color: Colors
                                                                            .yellow
                                                                            .shade800,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .remove_circle_outline,
                                                                        size:
                                                                            35,
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                    ],
                                                                  )
                                                                ]))
                                                        .toList()),
                                            SizedBox(height: 5),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: planInfo == null
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator(
                                                color: color1,
                                                backgroundColor:
                                                    color1.withOpacity(0.5),
                                              ))
                                            : ScrollConfiguration(
                                                behavior: ScrollBehavior(),
                                                child:
                                                    GlowingOverscrollIndicator(
                                                  axisDirection:
                                                      AxisDirection.down,
                                                  color: color1,
                                                  child: offerings.length == 0
                                                      ? Column(
                                                          children: [
                                                            Expanded(
                                                                child:
                                                                    SizedBox()),
                                                            CenturyGothicText(
                                                                data:
                                                                    "Empty Collection",
                                                                fontSize: 20),
                                                            Expanded(
                                                                child:
                                                                    SizedBox()),
                                                          ],
                                                        )
                                                      : Column(
                                                          children: [
                                                            Expanded(
                                                              child: GridView
                                                                  .builder(
                                                                      padding: EdgeInsets
                                                                          .fromLTRB(
                                                                              10,
                                                                              10,
                                                                              10,
                                                                              15),
                                                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                          mainAxisExtent:
                                                                              110,
                                                                          crossAxisCount:
                                                                              1,
                                                                          mainAxisSpacing:
                                                                              10,
                                                                          crossAxisSpacing:
                                                                              5),
                                                                      itemCount:
                                                                          offerings
                                                                              .length,
                                                                      itemBuilder:
                                                                          (BuildContext context,
                                                                              int index) {
                                                                        return Material(
                                                                          color:
                                                                              Colors.white,
                                                                          borderRadius:
                                                                              BorderRadius.circular(15),
                                                                          child:
                                                                              InkWell(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15),
                                                                            onTap:
                                                                                () {
                                                                              Navigator.push(context, PageRouteBuilder(pageBuilder: (context, a, b) {
                                                                                return ViewOffering();
                                                                              }));
                                                                            },
                                                                            splashFactory:
                                                                                NoSplash.splashFactory,
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(15),
                                                                              ),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Row(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Container(
                                                                                          alignment: Alignment.centerRight,
                                                                                          padding: EdgeInsets.all(3),
                                                                                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                                                                          width: 200,
                                                                                          height: 80,
                                                                                          child: Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            children: [
                                                                                              Container(
                                                                                                alignment: Alignment.centerLeft,
                                                                                                child: CenturyGothicText(textAlign: TextAlign.start, textOverflow: (offerings[index].name.length > 60) ? TextOverflow.ellipsis : TextOverflow.clip, data: offerings[index].name, fontSize: 14),
                                                                                              ),
                                                                                              Container(
                                                                                                alignment: Alignment.centerLeft,
                                                                                                child: CenturyGothicText(
                                                                                                  data: (offerings[index].date == 'null') ? "No date" : offerings[index].date.substring(0, 10),
                                                                                                  fontSize: 13,
                                                                                                  textColor: Colors.black,
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        Expanded(child: SizedBox()),
                                                                                        Container(
                                                                                          height: 80,
                                                                                          width: 120,
                                                                                          child: ClipRRect(
                                                                                            borderRadius: BorderRadius.circular(15),
                                                                                            child: Image.network(
                                                                                              planInfo!.image!,
                                                                                              fit: BoxFit.cover,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    const Divider(
                                                                                      thickness: 0.8,
                                                                                      height: 20,
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }),
                                                            ),
                                                          ],
                                                        ),
                                                ),
                                              ))
                                  ]))
                                ],
                              ))),
                    ],
                  ),
                ),
              )),
    );
  }
}

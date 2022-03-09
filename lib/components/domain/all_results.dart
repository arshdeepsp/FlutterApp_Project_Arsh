import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tripd_travel_app/components/widgets/century_gothic_text.dart';
import 'package:tripd_travel_app/theme/resources/color_code.dart';

class AllResults extends StatelessWidget {
  static const IconData add = IconData(0xe047, fontFamily: 'MaterialIcons');

  AllResults(
      {Key? key,
      required this.results,
      required this.options,
      required this.queryType})
      : super(key: key);
  final List? results;
  final options;
  final String? queryType;

  // Widget buildLost(BuildContext context) {
  //   Color color1 = HexColor("6700E3");
  //   Color color2 = HexColor('D1D1D1');

  //   return Padding(
  //     padding: EdgeInsets.all(5),
  //     child: Container(
  //       child: StaggeredGridView.countBuilder(
  //           padding: EdgeInsets.all(1),
  //           crossAxisCount: 1,
  //           itemCount: categories!.length,
  //           crossAxisSpacing: 5,
  //           mainAxisSpacing: 20,
  //           staggeredTileBuilder: (index) {
  //             return StaggeredTile.fit(1);
  //           },
  //           itemBuilder: (BuildContext context, int index) {
  //             return Column(
  //               children: [
  //                 Container(
  //                   child: Row(
  //                     children: [
  //                       Container(
  //                         decoration: BoxDecoration(
  //                             color: Colors.grey.shade200,
  //                             borderRadius: BorderRadius.circular(10)),
  //                         width: 95,
  //                         child: CustomText(
  //                             data: 'Sat, May 5\n 7:30 PM',
  //                             fontFamily: 'CenturyGothic',
  //                             fontSize: 13,
  //                             textColor: Colors.black,
  //                             textAlign: TextAlign.center),
  //                       ),
  //                       Expanded(
  //                           child: Container(
  //                         alignment: Alignment.center,
  //                         height: 60,
  //                         child: Material(
  //                           borderRadius: BorderRadius.circular(10),
  //                           color: Colors.white,
  //                           child: InkWell(
  //                             borderRadius: BorderRadius.circular(10),
  //                             splashColor: color1,
  //                             onTap: () {},
  //                             child: CustomText(
  //                                 data: categories![index].name,
  //                                 fontFamily: 'CenturyGothic',
  //                                 fontSize: 13,
  //                                 textColor: Colors.black,
  //                                 textAlign: TextAlign.center),
  //                           ),
  //                         ),
  //                       )),
  //                       Container(
  //                         width: 30,
  //                         child: Material(
  //                           borderRadius: BorderRadius.circular(1000),
  //                           color: color2,
  //                           child: InkWell(
  //                             borderRadius: BorderRadius.circular(1000),
  //                             splashColor: Colors.green,
  //                             onTap: () {},
  //                             child: Icon(add),
  //                           ),
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //                 Container(
  //                   child: ListView.builder(
  //                     physics: const NeverScrollableScrollPhysics(),
  //                     shrinkWrap: true,
  //                     itemBuilder: (context, index2) {
  //                       return Column(
  //                         mainAxisAlignment: MainAxisAlignment.start,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Container(
  //                             padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
  //                             alignment: Alignment.centerLeft,
  //                             height: 30,
  //                             child: Material(
  //                               color: Colors.deepPurple.shade400,
  //                               borderRadius:
  //                                   BorderRadius.all(Radius.circular(5)),
  //                               child: InkWell(
  //                                   borderRadius:
  //                                       BorderRadius.all(Radius.circular(5)),
  //                                   enableFeedback: true,
  //                                   customBorder:
  //                                       Border.all(width: 2, color: color1),
  //                                   splashColor: color1,
  //                                   onTap: () {},
  //                                   child: Text(
  //                                     ' ${categories!.elementAt(index).offerings[index2].name} ',
  //                                     style: TextStyle(
  //                                         color: Colors.white,
  //                                         fontFamily: 'CenturyGothic',
  //                                         fontSize: 16),
  //                                     textAlign: TextAlign.center,
  //                                   )),
  //                             ),
  //                           ),
  //                         ],
  //                       );
  //                     },
  //                     itemCount: categories!.elementAt(index).offerings.length,
  //                   ),
  //                 )
  //               ],
  //             );
  //           }),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    Color color1 = HexColor("6700E3");

    return Scaffold(
      backgroundColor: Colors.white,
      body: ScrollConfiguration(
        behavior: ScrollBehavior(),
        // child: GlowingOverscrollIndicator(
        //   axisDirection: AxisDirection.down,
        //   color: color1,
        child: (results == null)
            ? CircularProgressIndicator(
                color: color1,
              )
            : Column(
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
                        data: queryType!,
                        fontSize: 20,
                        textColor: Colors.black,
                        textAlign: TextAlign.center),
                    Expanded(child: SizedBox()),
                  ]),
                  const Divider(
                    thickness: 1,
                  ),
                  Expanded(
                    child: StaggeredGridView.countBuilder(
                        padding: EdgeInsets.fromLTRB(8, 15, 8, 0),
                        staggeredTileBuilder: (index) {
                          return StaggeredTile.fit(1);
                        },
                        crossAxisCount: 1,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        itemCount: results!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    width: 90,
                                    child: CenturyGothicText(
                                        data: (results![index].date == null)
                                            ? "No date"
                                            : results![index]
                                                .date
                                                .substring(0, 10),
                                        fontSize: 13,
                                        textColor: Colors.black,
                                        textAlign: TextAlign.center),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                      child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    padding: EdgeInsets.all(2),
                                    alignment: Alignment.center,
                                    child: Material(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      child: InkWell(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          enableFeedback: true,
                                          splashFactory:
                                              InkRipple.splashFactory,
                                          highlightColor:
                                              color1.withOpacity(0.4),
                                          onTap: () {},
                                          child: Container(
                                            child: CenturyGothicText(
                                                data:
                                                    ' ${results!.elementAt(index).name} ',
                                                fontSize: 12,
                                                textColor: Colors.black,
                                                textAlign: TextAlign.center),
                                            padding: EdgeInsets.all(5),
                                          )),
                                    ),
                                  )),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    width: 20,
                                    height: 20,
                                    child: Material(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      child: InkWell(
                                        borderRadius:
                                            BorderRadius.circular(1000),
                                        highlightColor:
                                            Colors.green.withOpacity(0.4),
                                        splashFactory: InkRipple.splashFactory,
                                        onTap: () => options(
                                            results!.elementAt(index).id),
                                        child: Icon(
                                          add,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ));
                        }),
                  ),
                ],
              ),
      ),
    );
  }
}

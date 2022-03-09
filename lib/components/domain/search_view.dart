import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tripd_travel_app/components/domain/all_results.dart';
import 'package:tripd_travel_app/components/widgets/century_gothic_text.dart';
import 'package:tripd_travel_app/components/widgets/custom_text.dart';
import 'package:tripd_travel_app/theme/resources/color_code.dart';
import 'package:tripd_travel_app/theme/resources/custom_scroll_behaviour.dart';

class SearchView extends StatelessWidget {
  SearchView(
      {Key? key,
      required this.itemList,
      required this.showOfferingOptions,
      required this.controller})
      : super(key: key);
  final List? itemList;

  final showOfferingOptions;
  final Color color1 = HexColor("6700E3");
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: (itemList == null)
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : (itemList!.length == 0)
              ? Container()
              : Padding(
                  padding: EdgeInsets.all(20),
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: StaggeredGridView.countBuilder(
                      padding: EdgeInsets.all(5),
                      staggeredTileBuilder: (index) {
                        return StaggeredTile.fit(1);
                      },
                      crossAxisCount: 1,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      itemCount: itemList!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                  data: itemList!.elementAt(index).name,
                                  fontFamily: 'CenturyGothic',
                                  fontSize: 21,
                                  textColor: Colors.black,
                                  textAlign: TextAlign.left),
                              SizedBox(
                                height: 10,
                              ),
                              ListView.builder(
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index2) {
                                  return Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                    alignment: Alignment.centerLeft,
                                    child: Material(
                                      color: Colors.deepPurple.shade400,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      child: InkWell(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          enableFeedback: true,
                                          customBorder: Border.all(
                                              width: 2, color: color1),
                                          splashColor: color1,
                                          onTap: () {
                                            print("helooooooooooooo");
                                          },
                                          child: Container(
                                            child: CenturyGothicText(
                                                data:
                                                    ' ${itemList!.elementAt(index).offerings[index2].name} ',
                                                fontSize: 14,
                                                textColor: Colors.white,
                                                textAlign: TextAlign.center),
                                            padding: EdgeInsets.all(6),
                                          )),
                                    ),
                                  );
                                },
                                itemCount: itemList!
                                            .elementAt(index)
                                            .offerings
                                            .length >
                                        3
                                    ? 3
                                    : itemList!
                                        .elementAt(index)
                                        .offerings
                                        .length,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                alignment: Alignment.centerRight,
                                height: 30,
                                child: Material(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  child: InkWell(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      splashColor: color1,
                                      onTap: () => {
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                  pageBuilder: (context, a, b) {
                                                    return AllResults(
                                                      queryType:
                                                          'Results for: ${controller.text}',
                                                      options:
                                                          (offeringId) async {
                                                        await showOfferingOptions(
                                                            context,
                                                            offeringId);
                                                      },
                                                      results: itemList!
                                                          .elementAt(index)
                                                          .offerings,
                                                    );
                                                  },
                                                  transitionDuration:
                                                      Duration(microseconds: 0),
                                                  reverseTransitionDuration:
                                                      Duration(
                                                          microseconds: 0)),
                                            )
                                          },
                                      child: Text(
                                        ' See all results ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w100,
                                            fontFamily: 'CenturyGothic',
                                            fontSize: 15),
                                      )),
                                ),
                              ),
                              const Divider(
                                height: 40,
                                thickness: 1.5,
                                indent: 30,
                                endIndent: 30,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )),
    );
  }
}

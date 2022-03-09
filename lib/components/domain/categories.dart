import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/domain/all_results.dart';
import 'package:tripd_travel_app/components/widgets/custom_text.dart';
import 'package:tripd_travel_app/models/offering.dart';
import 'package:tripd_travel_app/services/offering_service.dart';
import 'package:tripd_travel_app/theme/resources/color_code.dart';
import 'package:tripd_travel_app/theme/resources/custom_scroll_behaviour.dart';

class Categories extends StatelessWidget {
  Categories(
      {Key? key,
      required this.itemList,
      required this.showOptions,
      required this.showOfferingOptions})
      : super(key: key);

  final List? itemList;
  final showOfferingOptions;
  final VoidCallback showOptions;

  Future _getOfferingsById(
      {required String? idCategory, required BuildContext context}) async {
    final offeringService =
        Provider.of<OfferingService>(context, listen: false);
    List<Offering> results =
        await offeringService.getOfferingsById(idCategory!);
    return results;
  }

  @override
  Widget build(BuildContext context) {
    Color color1 = HexColor("6700E3");
    return Scaffold(
        backgroundColor: Colors.white,
        body: ScrollConfiguration(
            behavior: MyBehavior(),
            child: GridView.builder(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 225,
                    crossAxisCount: 2,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 5),
                itemCount: itemList!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () async {
                          var idCategory = itemList!.elementAt(index).id;
                          var offeringList = await _getOfferingsById(
                              idCategory: idCategory, context: context);

                          Navigator.push(
                            context,
                            PageRouteBuilder(
                                pageBuilder: (context, a, b) {
                                  return AllResults(
                                    queryType: itemList![index].name,
                                    options: (offeringId) async {
                                      await showOfferingOptions(
                                          context, offeringId);
                                    },
                                    results: offeringList,
                                  );
                                },
                                transitionDuration: Duration(microseconds: 0),
                                reverseTransitionDuration:
                                    Duration(microseconds: 0)),
                          );
                        },
                        splashFactory: NoSplash.splashFactory,
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: [
                              SizedBox(
                                child: CustomText(
                                  data: itemList!.elementAt(index).name,
                                  fontFamily: 'CenturyGothic',
                                  fontSize: 15.5,
                                  textAlign: TextAlign.center,
                                  textColor: Colors.black,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    itemList!.elementAt(index).image,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;

                                      return Center(
                                          child: CircularProgressIndicator
                                              .adaptive(
                                        backgroundColor: color1,
                                        semanticsLabel: 'Loading..',
                                      ));
                                    },
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Text('Some errors occurred!'),
                                  ),
                                ),
                                height: 180,
                                width: 183,
                              ),
                              SizedBox(
                                height: 18,
                              )
                            ],
                          ),
                        ),
                      ));
                })),
        floatingActionButton: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: showOptions,
            child: Container(
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: color1,
                    border: Border.all(width: 2, color: Colors.white)),
                child:
                    Icon(Icons.add_rounded, color: Colors.white, size: 50))));
  }
}

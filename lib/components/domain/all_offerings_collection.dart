import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/dialogs/offering_options.dart';
import 'package:tripd_travel_app/components/widgets/century_gothic_text.dart';
import 'package:tripd_travel_app/models/collection.dart';
import 'package:tripd_travel_app/screens/view_offering/view_offering.dart';
import 'package:tripd_travel_app/services/auth_service.dart';
import 'package:tripd_travel_app/services/collection_service.dart';
import 'package:tripd_travel_app/theme/resources/color_code.dart';

class AllOfferingsByCollection extends StatefulWidget {
  static const IconData add = IconData(0xe047, fontFamily: 'MaterialIcons');

  AllOfferingsByCollection({Key? key, required this.collectionId})
      : super(key: key);
  final String collectionId;

  @override
  State<AllOfferingsByCollection> createState() =>
      _AllOfferingsByCollectionState();
}

class _AllOfferingsByCollectionState extends State<AllOfferingsByCollection> {
  List? results;
  Collection? collection;

  getOfferingsByCollection() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    var idToken = await auth.currentUser!.getIdToken();
    final collectionService =
        Provider.of<CollectionService>(context, listen: false);
    final offerings = await collectionService.getCollectionOfferings(
        collectionId: widget.collectionId, token: idToken);

    setState(() => {results = offerings});
  }

  getCollectionDetails() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    var idToken = await auth.currentUser!.getIdToken();
    final collectionService =
        Provider.of<CollectionService>(context, listen: false);
    final collection = await collectionService.getCollectionDetails(
        collectionId: widget.collectionId, token: idToken);
    // print(offerings);
    setState(() {
      this.collection = collection;
    });
    print(collection.toString());
  }

  @override
  void initState() {
    print(widget.collectionId);
    getOfferingsByCollection();
    getCollectionDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color color1 = HexColor("6700E3");

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          padding: EdgeInsets.fromLTRB(0, 35, 0, 0),
          child: results == null || collection == null
              ? Center(
                  child: CircularProgressIndicator(
                  color: color1,
                  backgroundColor: color1.withOpacity(0.5),
                ))
              : ScrollConfiguration(
                  behavior: ScrollBehavior(),
                  child: GlowingOverscrollIndicator(
                    axisDirection: AxisDirection.down,
                    color: color1,
                    child: results!.length == 0
                        ? Column(
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
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
                                    width: 150,
                                    child: CenturyGothicText(
                                        textAlign: TextAlign.center,
                                        textOverflow: TextOverflow.clip,
                                        data: collection!.name,
                                        fontSize: 22),
                                  ),
                                  Expanded(child: SizedBox())
                                ],
                              ),
                              const Divider(
                                height: 40,
                                thickness: 1,
                              ),
                              Expanded(child: SizedBox()),
                              CenturyGothicText(
                                  data: "Empty Collection", fontSize: 20),
                              Expanded(child: SizedBox()),
                            ],
                          )
                        : Column(
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
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
                                    width: 150,
                                    child: CenturyGothicText(
                                        textAlign: TextAlign.center,
                                        textOverflow: TextOverflow.clip,
                                        data: collection!.name,
                                        fontSize: 22),
                                  ),
                                  Expanded(child: SizedBox())
                                ],
                              ),
                              const Divider(
                                height: 40,
                                thickness: 1,
                              ),
                              Expanded(
                                child: GridView.builder(
                                    padding: EdgeInsets.fromLTRB(8, 0, 8, 16),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            mainAxisExtent: 110,
                                            crossAxisCount: 1,
                                            mainAxisSpacing: 10,
                                            crossAxisSpacing: 5),
                                    itemCount: results!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Material(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          onTap: () {
                                            Navigator.push(context,
                                                PageRouteBuilder(pageBuilder:
                                                    (context, a, b) {
                                              return ViewOffering();
                                            }));
                                          },
                                          splashFactory: NoSplash.splashFactory,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15, 10, 15, 0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        padding:
                                                            EdgeInsets.all(3),
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        width: 200,
                                                        height: 80,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: CenturyGothicText(
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  textOverflow: (results![
                                                                                  index]
                                                                              .name
                                                                              .length >
                                                                          60)
                                                                      ? TextOverflow
                                                                          .ellipsis
                                                                      : TextOverflow
                                                                          .clip,
                                                                  data: results![
                                                                          index]
                                                                      .name,
                                                                  fontSize: 14),
                                                            ),
                                                            Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child:
                                                                  CenturyGothicText(
                                                                data: results![index]
                                                                            .date ==
                                                                        'null'
                                                                    ? 'No date'
                                                                    : results![
                                                                            index]
                                                                        .date
                                                                        .substring(
                                                                            0,
                                                                            10),
                                                                fontSize: 13,
                                                                textColor:
                                                                    Colors
                                                                        .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                          child: SizedBox()),
                                                      Container(
                                                        height: 80,
                                                        width: 120,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          child: Image.network(
                                                              collection!
                                                                      .collectionImage ??
                                                                  "",
                                                              fit: BoxFit.cover,
                                                              errorBuilder:
                                                                  (context,
                                                                          error,
                                                                          stackTrace) =>
                                                                      Container(
                                                                        height:
                                                                            100,
                                                                        width:
                                                                            150,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade200,
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child: Text(
                                                                            'No image',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: TextStyle(fontFamily: 'CenturyGothic')),
                                                                      )),
                                                        ),
                                                      ),
                                                      Expanded(
                                                          child: SizedBox()),
                                                      InkWell(
                                                          onTap: () => {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder: (BuildContext
                                                                            context) =>
                                                                        OfferingOptions(
                                                                            offeringId:
                                                                                results![index].id))
                                                              },
                                                          child:
                                                              Icon(Icons.add)),
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
                )),
    );
  }
}

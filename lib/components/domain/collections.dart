import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/dialogs/create_collection_dialog.dart';
import 'package:tripd_travel_app/components/domain/all_offerings_collection.dart';
import 'package:tripd_travel_app/components/domain/collection_item.dart';
import 'package:tripd_travel_app/components/widgets/custom_text.dart';
import 'package:tripd_travel_app/services/auth_service.dart';
import 'package:tripd_travel_app/services/collection_service.dart';
import 'package:tripd_travel_app/theme/resources/color_code.dart';
import 'package:tripd_travel_app/theme/resources/custom_scroll_behaviour.dart';

class Collections extends StatefulWidget {
  const Collections({Key? key, this.forModal = false, this.offeringId})
      : super(key: key);
  final forModal;
  final offeringId;
  @override
  _CollectionsState createState() => _CollectionsState();
}

class _CollectionsState extends State<Collections> {
  var collectionList;
  final TextEditingController nameController = TextEditingController();
  Color color1 = HexColor("6700E3");

  getAllCollection() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    var idToken = await auth.currentUser!.getIdToken();
    print(idToken);

    final collectionService =
        Provider.of<CollectionService>(context, listen: false);
    var allCollections =
        await collectionService.getAllCollection(token: idToken);
    setState(() {
      collectionList = allCollections;
    });
  }

  addOffering({required collectionId}) async {
    final auth = Provider.of<AuthService>(context, listen: false);
    var idToken = await auth.currentUser!.getIdToken();
    final collectionService =
        Provider.of<CollectionService>(context, listen: false);
    // print(
    //     "collectionId: $collectionId, offeringId: ${widget.offeringId} token: $idToken");
    await collectionService.addOffering(
        collectionId: collectionId,
        offeringId: widget.offeringId,
        token: idToken,
        context: context);
  }

  @override
  void initState() {
    getAllCollection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var container = collectionList == null
        ? Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              color: color1,
              backgroundColor: color1.withOpacity(0.4),
            ),
          )
        : Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: SizedBox()),
                    CustomText(
                      data: "My Collections",
                      fontFamily: 'CenturyGothic',
                      fontSize: 25,
                      textAlign: TextAlign.center,
                      textColor: Colors.black,
                      fontWeight: FontWeight.w100,
                    ),
                    Expanded(
                        child: Container(
                      height: 30,
                      alignment: Alignment.centerRight,
                      child: FloatingActionButton.small(
                        elevation: 0,
                        child: Icon(Icons.add_rounded, color: color1, size: 25),
                        backgroundColor: Colors.white,
                        shape: CircleBorder(
                            side: BorderSide(width: 1, color: color1)),
                        onPressed: () async {
                          await showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  CreateCollectionDialog(
                                      callback: getAllCollection),
                              barrierDismissible: false);
                        },
                      ),
                    )),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: 120,
                            crossAxisCount: 3,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 10),
                        itemCount: collectionList!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CollectionItem(
                            item: collectionList.elementAt(index),
                            onItemClick: () => {
                              if (widget.forModal)
                                {
                                  addOffering(
                                      collectionId:
                                          collectionList!.elementAt(index).id)
                                }
                              else
                                {
                                  Navigator.push(context, PageRouteBuilder(
                                      pageBuilder: (context, a, b) {
                                    return AllOfferingsByCollection(
                                        collectionId: collectionList!
                                            .elementAt(index)
                                            .id);
                                  })),
                                }
                            },
                          );
                        }),
                  ),
                ),
              ],
            ),
          );
    return widget.forModal
        ? Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: Container(
              height: 450,
              child: container,
            ),
          )
        : container;
  }
}

import 'package:flutter/material.dart';
import 'package:tripd_travel_app/components/domain/all_offerings_collection.dart';
import 'package:tripd_travel_app/components/widgets/century_gothic_text.dart';
import 'package:tripd_travel_app/models/collection.dart';
import 'package:tripd_travel_app/theme/resources/colors.dart';

class CollectionItem extends StatelessWidget {
  const CollectionItem(
      {Key? key,
      required this.item,
      this.onItemClick,
      this.similarToPlans = false})
      : super(key: key);
  final Collection item;
  final void Function()? onItemClick;
  final bool similarToPlans;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onItemClick ??
            () => {
                  Navigator.push(context,
                      PageRouteBuilder(pageBuilder: (context, a, b) {
                    return AllOfferingsByCollection(collectionId: item.id);
                  }))
                },
        splashFactory: NoSplash.splashFactory,
        child: Container(
          alignment: Alignment.bottomCenter,
          padding: similarToPlans
              ? EdgeInsets.fromLTRB(5, 15, 5, 15)
              : EdgeInsets.zero,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: similarToPlans ? 140 : 130,
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          item.collectionImage ??
                              "https://tripd-ms.s3.us-west-1.amazonaws.com/collection_images/collection_image_picker3709893041044464156.jpg.jpg",
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                                child: CircularProgressIndicator.adaptive(
                              backgroundColor: color1,
                              semanticsLabel: 'Loading..',
                            ));
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              Text('Some errors occurred!'),
                          height: 108.9,
                          width: 153,
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: 0.3,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item.offerings.length.toString(),
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white)),
                            item.isPrivate != null && item.isPrivate == true
                                ? Icon(Icons.lock_outline_rounded,
                                    size: 15, color: Colors.white)
                                : SizedBox()
                          ]),
                    ),
                  ],
                ),
              ),
              Container(
                  width: 120,
                  alignment: Alignment.center,
                  child: CenturyGothicText(
                    textOverflow: TextOverflow.ellipsis,
                    textColor: Colors.black,
                    data: item.name,
                    fontSize: 16,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

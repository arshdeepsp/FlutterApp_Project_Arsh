import 'package:flutter/material.dart';
import 'package:tripd_travel_app/components/widgets/century_gothic_text.dart';
import 'package:tripd_travel_app/models/plan.dart';
import 'package:tripd_travel_app/screens/plan_details/plan_details.dart';

class PlanItem extends StatelessWidget {
  const PlanItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Plan item;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      splashColor: Colors.transparent,
      onPressed: () {
        Navigator.push(context, PageRouteBuilder(pageBuilder: (context, a, b) {
          return PlanDetailsPage(
            id: item.id,
          );
        }));
      },
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: Colors.grey,
                width: 140,
                height: 110,
                child: (item.file == null)
                    ? Container(
                        child: Text('No image',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'CenturyGothic')),
                        color: Colors.grey.shade200,
                      )
                    : Image.network(
                        item.file,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: 130,
              alignment: Alignment.center,
              child: CenturyGothicText(
                textColor: Colors.black,
                data: item.name!,
                fontSize: 16,
                textOverflow: TextOverflow.ellipsis,
              ),
            )

            /*Column(
                // alignment: Alignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: // MainAxisAlignment.start,
                    MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AddToChatDialog(
                                type: "plan",
                                typeId: item.id!,
                                image: item.file),
                            barrierDismissible: true);
                      },
                      child: Icon(Icons.add, size: 30, color: Colors.white),
                    ),
                  ),
                ])*/
          ],
        ),
      ),
    );
  }
}

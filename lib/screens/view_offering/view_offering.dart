import 'package:flutter/material.dart';

import 'package:tripd_travel_app/theme/resources/color_code.dart';

class ViewOffering extends StatefulWidget {
  static const IconData add = IconData(0xe047, fontFamily: 'MaterialIcons');

  ViewOffering({Key? key}) : super(key: key);

  @override
  State<ViewOffering> createState() => _ViewOfferingState();
}

class _ViewOfferingState extends State<ViewOffering> {
  @override
  Widget build(BuildContext context) {
    Color color1 = HexColor("6700E3");

    return Scaffold(
        appBar: PreferredSize(
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        size: 35,
                      ))
                ],
              ),
            ),
            preferredSize: Size(double.infinity, 51)),
        backgroundColor: Colors.white,
        body: Container(
            padding: EdgeInsets.fromLTRB(0, 35, 0, 0),
            child: Center(
                child: CircularProgressIndicator(
              color: color1,
              backgroundColor: color1.withOpacity(0.5),
            ))));
  }
}

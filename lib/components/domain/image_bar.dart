import 'package:flutter/material.dart';

import 'package:tripd_travel_app/theme/resources/colors.dart';

class ImageBar extends StatefulWidget {
  const ImageBar({Key? key}) : super(key: key);

  @override
  _ImageBarState createState() => _ImageBarState();
}

class _ImageBarState extends State<ImageBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).size.height * 0.035;
    return Padding(
      padding: EdgeInsets.fromLTRB(10, topPadding, 10, 0),
      child: Row(
        children: [
          Expanded(
              child: Container(
            height: 70,
          )),
          Container(
              alignment: Alignment.center,
              color: Colors.white,
              height: 50,
              child: Text(
                'tripd',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Eurofurence', fontSize: 38, color: color1),
              )),
          Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tripd_travel_app/theme/resources/color_code.dart';

class SearchStatusMessage extends StatelessWidget {
  SearchStatusMessage({Key? key, required this.offstage}) : super(key: key);

  final bool offstage;
  final Color color1 = HexColor("6700E3");

  @override
  Widget build(BuildContext context) {
    return Offstage(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Container(
            height: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: color1, width: 1),
            ),
            child: Material(
              color: Colors.white,
              child: Text(
                'No results found',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'CenturyGothic',
                ),
              ),
            )),
      ),
      offstage: offstage,
    );
  }
}

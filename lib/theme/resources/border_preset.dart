import 'package:flutter/material.dart';
import 'package:tripd_travel_app/theme/resources/color_code.dart';

class BorderPresets {
  static Color color1 = HexColor("6700E3");

  static Border border() {
    return Border.all(width: 0, color: color1);
  }

  static BorderSide borderSide() {
    return BorderSide(width: 0.5, color: color1);
  }
}

import 'package:flutter/material.dart';
import 'package:tripd_travel_app/theme/resources/colors.dart';

class FloatingButtonOne extends StatelessWidget {
  const FloatingButtonOne({Key? key, required this.showOptions})
      : super(key: key);
  final Function() showOptions;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: showOptions,
        child: Container(
            decoration: new BoxDecoration(
                color: Colors.deepPurple.shade100.withOpacity(0.9),
                shape: BoxShape.circle,
                border: Border.all(width: 2, color: color1)),
            child: Icon(Icons.add_rounded, color: color1, size: 50)));
  }
}

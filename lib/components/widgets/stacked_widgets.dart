import 'package:flutter/material.dart';

class StackedWidgets extends StatelessWidget {
  final List<Widget> items;
  final TextDirection direction;
  final double size;
  final double xShift;

  const StackedWidgets({
    Key? key,
    required this.items,
    this.direction = TextDirection.rtl,
    this.size = 45,
    this.xShift = 18,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var slicedList = items.length > 4 ? items.sublist(0, 4) : items;
    final left = size - xShift;
    final allItems = slicedList
        .asMap()
        .map((index, item) {
          final value = Container(
            width: size,
            height: size,
            child: item,
            margin: EdgeInsets.only(left: left * index),
          );

          return MapEntry(index, value);
        })
        .values
        .toList();
    var allItemsWithMoreIndicator = items.length > 4
        ? [
            ...allItems,
            Container(
              margin: EdgeInsets.only(left: left * 4),
              child: ClipOval(
                  child: Container(
                decoration: BoxDecoration(border: Border.all(width: 2)),
                child: Container(
                    color: Colors.white,
                    width: size - 2,
                    height: size - 2,
                    child: Center(
                        child: Text("+${(items.length - 4).toString()}"))),
              )),
            ),
          ]
        : allItems;
    return Stack(
      children: direction == TextDirection.ltr
          ? allItemsWithMoreIndicator.reversed.toList()
          : allItemsWithMoreIndicator,
    );
  }
}

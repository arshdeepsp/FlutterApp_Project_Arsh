import 'package:flutter/material.dart';

class NavigationBar extends StatelessWidget {
  NavigationBar({Key? key, required this.height}) : super(key: key);
  final double height;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 0.5)),
      child: Row(
        children: [
          Expanded(child: SizedBox()),
          SizedBox(
            width: 5,
          ),
          IconButton(
            onPressed: () {
              print('pressed!');
            },
            icon: Icon(
              Icons.cases_outlined,
              size: 30,
            ),
            splashColor: Colors.red,
          ),
          Expanded(child: SizedBox()),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.feed_outlined,
                size: 30,
              )),
          Expanded(child: SizedBox()),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.cloud_circle_outlined,
                size: 30,
              )),
          Expanded(child: SizedBox()),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.person_outline,
                size: 30,
              )),
          Expanded(child: SizedBox()),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.message_outlined,
                size: 30,
              )),
          SizedBox(
            width: 5,
          ),
          Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}

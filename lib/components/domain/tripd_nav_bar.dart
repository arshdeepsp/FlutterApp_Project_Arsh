import 'package:flutter/material.dart';
import 'package:tripd_travel_app/theme/resources/color_code.dart';

// ignore: must_be_immutable
class TripdNavigationBar extends StatefulWidget {
  TripdNavigationBar(
      {Key? key, required this.currentIndex, required this.onTap})
      : super(key: key);
  int currentIndex;
  void Function(int) onTap;
  @override
  _TripdNavigationBarState createState() => _TripdNavigationBarState();
}

class _TripdNavigationBarState extends State<TripdNavigationBar> {
  Color color1 = HexColor("6700E3");

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(width: double.minPositive)),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        elevation: 0,
        backgroundColor: Colors.white,
        fixedColor: color1,
        currentIndex: widget.currentIndex,
        selectedIconTheme: IconThemeData(size: 40),
        unselectedIconTheme: IconThemeData(size: 35),
        selectedLabelStyle:
            TextStyle(fontFamily: 'CenturyGothic', fontSize: 12),
        unselectedLabelStyle:
            TextStyle(fontFamily: 'CenturyGothic', fontSize: 10),
        unselectedItemColor: Colors.black,
        onTap: widget.onTap,
        items: [
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('images/collections.png')),
              label: 'Collections'),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('images/feed.png')), label: 'Feed'),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('images/home.png')),
            label: 'Search',
          ),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('images/profile.png')),
              label: 'Profile'),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('images/inbox.png')), label: 'Chats')
        ],
      ),
    );
  }
}

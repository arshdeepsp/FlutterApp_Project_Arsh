import 'package:flutter/material.dart';
import 'package:tripd_travel_app/components/domain/collections.dart';
import 'package:tripd_travel_app/components/domain/top_bar.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({Key? key}) : super(key: key);

  @override
  _CollectionPageState createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(0),
        child: Column(
          children: [TopBar(), Expanded(child: Collections())],
        ),
      ),
    );
  }
}

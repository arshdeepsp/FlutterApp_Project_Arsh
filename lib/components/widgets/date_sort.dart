import 'package:flutter/material.dart';
import 'package:tripd_travel_app/components/widgets/stretched_text_button.dart';

class DateSort extends StatefulWidget {
  const DateSort({Key? key}) : super(key: key);
  @override
  _DateSortState createState() => _DateSortState();
}

class _DateSortState extends State<DateSort> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 330,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        child: Padding(
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Expanded(child: SizedBox()),
                  IconButton(
                    icon: Icon(Icons.close),
                    color: Colors.black,
                    iconSize: 25,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              StretchedTextButton(
                  onPressed: () {
                    Navigator.pop(context, 'All');
                  },
                  splashColor: Colors.grey,
                  data: 'All dates'),
              StretchedTextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Today');
                  },
                  splashColor: Colors.grey,
                  data: 'Today'),
              StretchedTextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Weekend');
                  },
                  splashColor: Colors.grey,
                  data: 'This weekend'),
              StretchedTextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Month');
                  },
                  splashColor: Colors.grey,
                  data: 'This month'),
              StretchedTextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Custom');
                  },
                  splashColor: Colors.grey,
                  data: 'Custom'),
            ],
          ),
          padding: EdgeInsets.all(5),
        ));
  }
}

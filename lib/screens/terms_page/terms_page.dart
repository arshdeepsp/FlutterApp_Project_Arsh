import 'package:flutter/material.dart';
import 'package:tripd_travel_app/components/widgets/century_gothic_text.dart';
import 'package:tripd_travel_app/theme/resources/colors.dart';

class TermsPage extends StatefulWidget {
  const TermsPage({Key? key}) : super(key: key);

  @override
  _TermsPageState createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: isLoading
                          ? Container(
                              height: 20,
                              width: 20,
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                color: color1,
                              ),
                            )
                          : IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                size: 35,
                              )),
                    ),
                  ),
                  CenturyGothicText(
                    data: 'Terms and Privacy',
                    fontSize: 23,
                    textOverflow: TextOverflow.clip,
                  ),
                  Expanded(
                    child: Container(),
                  )
                ],
              ),
            ),
          ),
          const Divider(
            thickness: 0.5,
            height: 0,
          ),
          Expanded(
            child: SingleChildScrollView(),
          ),
        ],
      ),
    );
  }
}

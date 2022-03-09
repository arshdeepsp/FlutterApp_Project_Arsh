import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tripd_travel_app/components/widgets/century_gothic_text.dart';
import 'package:tripd_travel_app/components/widgets/stretched_text_button.dart';
import 'package:tripd_travel_app/theme/resources/colors.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  bool isLoading = false;

  TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var max = MediaQuery.of(context).size.height;
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
                    data: 'Feedback',
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: max * 0.02,
                  ),
                  Container(
                    width: 320,
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(
                            text:
                                'Tell us if something isn\'t working or if you have a suggestion on how to make Tripd better',
                            style: TextStyle(
                              fontFamily: 'CenturyGothic',
                              fontSize: 14,
                            )),
                      ]),
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: max * 0.015,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: max * 0.02,
                            ),
                            CenturyGothicText(data: 'Feedback', fontSize: 12),
                          ],
                        ),
                        SizedBox(
                          height: max * 0.005,
                        ),
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(30)),
                          child: TextField(
                            controller: _feedbackController,
                            cursorColor: color1,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            maxLength: 150,
                            maxLines: 9,
                            style: TextStyle(fontFamily: 'CenturyGothic'),
                            decoration: InputDecoration(
                              counterText: '',
                              counterStyle: TextStyle(fontSize: 0),
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 20, 20, 20),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Your feedback',
                              suffixIcon: IconButton(
                                splashRadius: double.minPositive,
                                icon: Icon(Icons.close),
                                color: color1,
                                iconSize: 20,
                                onPressed: () {
                                  _feedbackController.clear();
                                },
                              ),
                              fillColor: Colors.grey,
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontFamily: 'CenturyGothic',
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            thickness: 0.5,
            height: 0,
          ),
          SafeArea(
            top: false,
            child: Container(
                alignment: Alignment.center,
                child: StretchedTextButton(
                    borderColor: Colors.transparent,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    splashColor: Colors.grey.shade400,
                    child: isLoading
                        ? Container(
                            height: 20,
                            width: 20,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              color: color1,
                            ),
                          )
                        : Container(
                            height: 20,
                            child: CenturyGothicText(
                              data: 'Submit',
                              fontSize: 18,
                              textColor: Colors.black,
                            ),
                          ))),
          ),
        ],
      ),
    );
  }
}

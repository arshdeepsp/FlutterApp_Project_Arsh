import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/widgets/century_gothic_text.dart';
import 'package:tripd_travel_app/components/widgets/left_icon_button.dart';
import 'package:tripd_travel_app/services/auth_service.dart';
import 'package:tripd_travel_app/services/collection_service.dart';
import 'package:tripd_travel_app/theme/resources/border_preset.dart';
import 'package:tripd_travel_app/theme/resources/color_code.dart';

class CreateCollectionDialog extends StatefulWidget {
  const CreateCollectionDialog({Key? key, this.callback}) : super(key: key);
  final callback;
  @override
  _CreateCollectionDialogState createState() => _CreateCollectionDialogState();
}

class _CreateCollectionDialogState extends State<CreateCollectionDialog> {
  Color color1 = HexColor('6700E3');

  bool privateGroup = false;
  bool canInvite = false;
  bool fillDetails = true;

  TextEditingController nameController = TextEditingController();

  FocusNode planFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();

  String imageHintText = 'Add image';

  ImagePicker imagePicker = ImagePicker();
  var file;
  var currentFile;

  createCollection() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    var idToken = await auth.currentUser!.getIdToken();
    // print(idToken);
    final collectionService =
        Provider.of<CollectionService>(context, listen: false);

    await collectionService.createCollection(
        token: idToken,
        name: nameController.text,
        file: currentFile,
        private: privateGroup,
        context: context,
        callback: widget.callback);
  }

  String state = "";

  void refreshImageHint() {
    if (currentFile == null) {
      setState(() {
        imageHintText = 'Add image';
      });
    } else {
      setState(() {
        imageHintText = 'Change image';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderPresets.borderSide()),
      child: SingleChildScrollView(
        child: Container(
            height: 400,
            width: double.infinity,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 5),
                  child: Column(
                    children: [
                      Text(
                        'Create a Collection',
                        style: TextStyle(
                            fontFamily: 'CenturyGothic',
                            fontSize: 16,
                            color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      const Divider(
                        height: 25,
                        thickness: 1,
                        indent: 30,
                        endIndent: 30,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(child: SizedBox()),
                          TextField(
                            controller: nameController,
                            cursorColor: color1,
                            maxLength: 35,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: nameController.clear,
                                icon: Icon(
                                  Icons.close,
                                  size: 20,
                                ),
                              ),
                              constraints:
                                  BoxConstraints(maxHeight: 65, maxWidth: 300),
                              hintText: 'Name your collection',
                              hintStyle: TextStyle(fontFamily: 'CenturyGothic'),
                              contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: color1, width: 0.5),
                              ),
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Expanded(child: SizedBox()),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          children: [
                            CenturyGothicText(
                                data: 'This collection is private',
                                fontSize: 13,
                                textColor: Colors.black,
                                textAlign: TextAlign.left),
                            Transform.scale(
                              scale: 0.75,
                              child: Switch.adaptive(
                                  activeTrackColor: Colors.deepPurple.shade300,
                                  activeColor: color1,
                                  value: privateGroup,
                                  onChanged: (isOn) {
                                    setState(() {
                                      privateGroup = isOn;
                                    });
                                  }),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          children: [
                            CenturyGothicText(
                                data:
                                    'Private collections won\'t be shown in the feed.\nOnly you and invitees can see these plans.',
                                fontSize: 12,
                                textColor: Colors.grey.shade500,
                                textAlign: TextAlign.left),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LeftIconButton(
                            text: imageHintText,
                            iconData: Icons.image,
                            iconColor: color1,
                            iconSize: 30,
                            onPressed: () async {
                              file = await imagePicker.pickImage(
                                  source: ImageSource.gallery);
                              if (file != null)
                                setState(() {
                                  currentFile = file;
                                });
                              refreshImageHint();
                            },
                          ),
                          if (currentFile != null)
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border:
                                        Border.all(width: 1, color: color1)),
                                child: IconButton(
                                    padding: EdgeInsets.all(0),
                                    iconSize: 20,
                                    color: color1,
                                    tooltip: 'Remove image',
                                    splashColor: color1,
                                    splashRadius: 30,
                                    onPressed: () {
                                      setState(() {
                                        file = null;
                                        currentFile = null;
                                      });
                                      refreshImageHint();
                                    },
                                    icon: Icon(Icons.close)),
                              ),
                            ),
                        ],
                      ),
                      Expanded(child: SizedBox()),
                      const Divider(
                        height: 25,
                        thickness: 1,
                        indent: 30,
                        endIndent: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.grey.shade100),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: CenturyGothicText(
                                  data: 'Cancel',
                                  fontSize: 14,
                                  textColor: Colors.black,
                                  textAlign: TextAlign.center)),
                          Expanded(child: SizedBox()),
                          TextButton(
                              style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.deepPurple.shade400),
                                  backgroundColor:
                                      MaterialStateProperty.all(color1)),
                              onPressed: () async {
                                createCollection();
                              },
                              child: CenturyGothicText(
                                  data: 'Create',
                                  fontSize: 13,
                                  textColor: Colors.white,
                                  textAlign: TextAlign.center))
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

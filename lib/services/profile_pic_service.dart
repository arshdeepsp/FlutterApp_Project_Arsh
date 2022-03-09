import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tripd_travel_app/components/widgets/custom_toast.dart';

class ProfilePicService {
  ProfilePicService._();

  factory ProfilePicService() {
    return ProfilePicService._();
  }

  Future<dynamic> updateProfilePicture(
      {required token, required file, required BuildContext context}) async {
    var url = Uri.parse("https://ms.tripd.co/profiles/uploadProfilePic");
    var response;
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    try {
      var request = http.MultipartRequest('POST', url);

      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      print('hello');
      request.headers.addAll(headers);

      response = await request.send();

      var respStream = response.stream.bytesToString().asStream();
      respStream.listen((event) {
        var parsedJson = json.decode(event);
        print(parsedJson.toString());
        //response = parsedJson;
        imageCache!.clear();
        if (parsedJson["status"] == true) {
          print('done');

          Timer(Duration(seconds: 2), () {
            Navigator.pop(context);
          });
          showToast(
              msg: "Profile picture uploaded successfully.",
              context: context,
              type: toastTypes.Success,
              duration: 1);
        } else {
          Timer(Duration(seconds: 2), () {
            Navigator.pop(context);
          });

          showToast(
              msg: "Profile picture not uploaded.",
              context: context,
              type: toastTypes.Error,
              duration: 1);
        }
      });
    } catch (e) {}
    return response;
  }
}

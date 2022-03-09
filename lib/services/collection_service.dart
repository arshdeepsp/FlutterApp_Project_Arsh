import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tripd_travel_app/components/widgets/custom_toast.dart';
import 'dart:convert';

import 'package:tripd_travel_app/models/collection.dart';
import 'package:tripd_travel_app/models/offering.dart';

class CollectionService {
  CollectionService._();

  factory CollectionService() {
    return CollectionService._();
  }

  Future<dynamic> createCollection(
      {required token,
      required String name,
      file,
      private,
      required BuildContext context,
      callback}) async {
    var url = Uri.parse("https://ms.tripd.co/collections");
    var response;
    final Map<String, String> headers = {
      "Content-Type": "multipart/form-data",
      "Authorization": "Bearer $token",
    };
    try {
      var request = http.MultipartRequest('POST', url);
      if (file != null) {
        request.files.add(await http.MultipartFile.fromPath("file", file.path));
      }

      var body = {
        "name": name,
        "isPrivate": private.toString(),
      };
      request.headers.addAll(headers);
      request.fields.addAll(body);
      response = await request.send();
    } catch (e) {
      print(e.toString());
    }
    var respStream = response.stream.bytesToString().asStream();
    respStream.listen((event) {
      var parsedJson = json.decode(event);
      // print(parsedJson);
      if (parsedJson["status"] == true) {
        showToast(
            msg: "Collection Created Successfully",
            context: context,
            type: toastTypes.Success,
            duration: 2);
      }
      Timer(
          Duration(seconds: 2),
          () => {
                if (callback != null) {callback(), Navigator.of(context).pop()}
              });
    });
  }

  Future<dynamic> getAllCollection({required token}) async {
    var url = Uri.parse("https://ms.tripd.co/collections");
    var data;
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    List<Collection> collections = [];
    try {
      var response = await http.get(url, headers: headers);
      data = json.decode(response.body);
      if (data["status"]) {
        data["data"].forEach((val) {
          collections.add(Collection.fromJson(val));
        });
      }

      return collections;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> getCollectionOfferings(
      {required collectionId, required token}) async {
    var url = Uri.parse("https://ms.tripd.co/collections/$collectionId");
    var data;
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    List<Offering> offerings = [];
    try {
      var response = await http.get(url, headers: headers);
      data = json.decode(response.body);

      if (data["status"]) {
        data["data"]["offerings"].forEach((val) {
          var offering = Offering.fromJson(val);
          offerings.add(offering);
        });
      }
      print(offerings);
      return offerings;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> getCollectionDetails(
      {required collectionId, required token}) async {
    var url = Uri.parse("https://ms.tripd.co/collections/$collectionId");
    var data;
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    Collection? collection;
    try {
      var response = await http.get(url, headers: headers);
      data = json.decode(response.body);
      print(data);
      collection = Collection.fromJson(data["data"]);
      return collection;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> addOffering(
      {required collectionId,
      required offeringId,
      required token,
      required BuildContext context}) async {
    var url =
        Uri.parse("https://ms.tripd.co/collections/$collectionId/offerings");
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    var body = json.encode({"offeringId": offeringId});
    try {
      var response = await http.put(url, headers: headers, body: body);
      var parsedJson = json.decode(response.body);
      print(parsedJson);
      if (parsedJson["status"] == true) {
        showToast(
            msg: "Offering successfully added to the collection",
            context: context,
            type: toastTypes.Success,
            duration: 2);
        Timer(Duration(seconds: 2), () => {Navigator.of(context).pop()});
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

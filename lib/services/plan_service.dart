import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tripd_travel_app/components/streams/streams.dart';
import 'package:tripd_travel_app/components/widgets/custom_toast.dart';
import 'package:tripd_travel_app/models/plan.dart';
import 'package:tripd_travel_app/models/plan_info.dart';

class PlanService {
  Future<dynamic> initializePlan({
    required token,
  }) async {
    var url = Uri.parse("https://ms.tripd.co/plans");
    var data;
    print(token);
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    try {
      var response = await http.post(url, headers: headers, body: null);
      data = json.decode(response.body);
    } catch (e) {
      print(e.toString());
    }
    return data;
  }

  Future<void> completePlan(
      {required token,
      required id,
      required name,
      required fromDate,
      required toDate,
      required description,
      required canInvite,
      required privateGroup,
      required file,
      VoidCallback? callback,
      required BuildContext context}) async {
    var url = Uri.parse("https://ms.tripd.co/plans");
    var response;
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    try {
      var request = http.MultipartRequest('POST', url);
      if (file != null) {
        request.files.add(await http.MultipartFile.fromPath("file", file.path));
      }
      request.fields["id"] = id ?? "";
      request.fields["name"] = name ?? "";
      request.fields["fromDate"] = fromDate ?? "";
      request.fields["toDate"] = toDate ?? "";
      request.fields["description"] = description ?? "";
      request.fields["invitable"] = canInvite.toString();
      request.fields["private"] = privateGroup.toString();
      print(
          "id= $id name= $name fromDate= $fromDate toDate= $toDate description=$description invitable = ${canInvite.toString()} private = ${privateGroup.toString()}");
      request.headers.addAll(headers);
      response = await request.send();

      var respStream = response.stream.bytesToString().asStream();
      respStream.listen((event) {
        var parsedJson = json.decode(event);
        // print(parsedJson);
        // print(response.statusCode);
        if (parsedJson["status"] == true) {
          showToast(
              msg: "Plan created successfully",
              context: context,
              type: toastTypes.Success,
              duration: 2);

          Timer(Duration(seconds: 3), () {
            if (callback != null) {
              callback();
              Navigator.of(context).pop();
            } else {
              navController.sink.add('plans');
            }
          });
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> getAllPlans({
    required token,
  }) async {
    var url = Uri.parse("https://ms.tripd.co/plans");
    var data = {};
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    List<Plan> plans = [];
    try {
      var response = await http.get(url, headers: headers);
      data = json.decode(response.body);
      // print(data);
      if (data['status']) {
        data['data'].forEach((val) {
          plans.add(Plan.fromJson(val));
        });
      }
    } catch (e) {
      print(e.toString());
    }

    return plans;
  }

  Future<Plan?> getPlan({required String id}) async {
    var url = Uri.parse("https://ms.tripd.co/plans/$id");
    Plan? plan;
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
    try {
      var response = await http.get(url, headers: headers);
      var data = json.decode(response.body);
      print(data);
      if (data['status']) {
        plan = Plan.fromJson(data['data']);
      }
    } catch (e) {}
    return plan;
  }

  Future getPlanDetails({required String token, required String id}) async {
    var url = Uri.parse("https://ms.tripd.co/plans/$id/details");
    var message = {};
    PlanInfo? planInfo;
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    var response = await http.get(url, headers: headers);
    message = json.decode(response.body);
    var data = message['data'];
    print(data);
    if (message['status']) planInfo = PlanInfo.fromJson(data);

    return planInfo;
  }

  Future deletePlan({required String id}) async {
    var url = Uri.parse("https://ms.tripd.co/plans/$id");
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    var response = await http.delete(url, headers: headers);
    var data = json.decode(response.body);
    print(data['data']);
  }

  Future addOffering(
      {required String token,
      required String id,
      required String offeringId,
      required BuildContext context}) async {
    var url = Uri.parse("https://ms.tripd.co/plans/$id/offerings");
    var data = {};
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    var msg = json.encode({"offeringId": offeringId});

    var response = await http.put(url, headers: headers, body: msg);

    data = jsonDecode(response.body);
    print(data);
    if (data["status"] == true) {
      showToast(
          msg: "Offering successfully added to the plan",
          context: context,
          type: toastTypes.Success,
          duration: 2);
      Timer(Duration(seconds: 3), () => {Navigator.pop(context)});
    }
    return data['status'];
  }
}

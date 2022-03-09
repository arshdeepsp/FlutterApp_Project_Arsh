import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tripd_travel_app/components/widgets/custom_toast.dart';
import 'package:tripd_travel_app/models/group.dart';

class GroupService {
  GroupService._();

  /// Returns an instance of [GroupService].
  factory GroupService() {
    return GroupService._();
  }

  /// Sends plan invitation to the members included in the invite list using the [GroupService] instance.
  /// Uses Tripd Group Invite API.
  Future<dynamic> initializeGroup({
    required token,
  }) async {
    var url = Uri.parse("https://ms.tripd.co/groups");
    var data;
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    try {
      var response = await post(url, headers: headers, body: jsonEncode({}));
      data = json.decode(response.body);
    } catch (e) {
      print(e.toString());
    }
    return data;
  }

  Future<dynamic> getUserGroups({
    required token,
    String? groupId,
  }) async {
    var data;
    try {
      var endpoint = "https://ms.tripd.co/profiles/groups";
      var url = Uri.parse(endpoint);
      // print(endpoint);
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var response = await get(url, headers: headers);

      var respJson = json.decode(response.body);
      if (respJson["status"]) {
        data = respJson["data"];
      } else
        data = [];
    } catch (e) {
      print(e.toString());
    }
    return data;
  }

  Future<dynamic> getGroup({required groupId, required token}) async {
    var groupData;
    try {
      var url = Uri.parse("https://ms.tripd.co/groups/$groupId");
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var response = await get(url, headers: headers);
      var data = json.decode(response.body);
      /* List<Group> collections = [];
      print(data); */
      if (data["status"]) {
        groupData = Group.fromJson(data["data"]);
      }
    } catch (e) {
      print(e.toString());
    }
    return groupData;
  }

  Future<dynamic> createGroup(
      {required id,
      required name,
      required token,
      required BuildContext context}) async {
    var url = Uri.parse("https://ms.tripd.co/groups");
    var data = {};
    var response;
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    data["id"] = id;
    data["name"] = name;

    var body = jsonEncode(data);

    try {
      var data = await post(url, headers: headers, body: body);
      response = jsonDecode(data.body);
      // print(response);
      if (response["status"] == true) {
        showToast(
            msg: "Group created successfully",
            context: context,
            type: toastTypes.Success,
            duration: 1);
        int count = 0;
        Timer(Duration(seconds: 1),
            () => {Navigator.of(context).popUntil((_) => count++ >= 1)});
      }
    } catch (e) {
      print(e.toString());
    }
    return response;
  }

  Future<dynamic> inviteMembers(
      {required String token,
      required String groupdId,
      required List<String?> members,
      String invitationType = "groupInvitation",
      required BuildContext context,
      required bool isEmail}) async {
    var data = {};
    var response;
    var url = Uri.parse('https://ms.tripd.co/groups/invite');

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    data["groupId"] = groupdId;
    data["inviteeIds"] = members;
    data["invitationType"] = isEmail ? "email" : invitationType;

    // print(data);
    var body = jsonEncode(data);

    try {
      var data = await post(url, headers: headers, body: body);
      response = jsonDecode(data.body);
      if (response["status"] == true) {
        showToast(
            msg: response["message"],
            context: context,
            type: toastTypes.Success,
            duration: 1);
        Timer(Duration(seconds: 1), () => {Navigator.of(context).pop()});
      }
    } catch (e) {
      print(e.toString());
    }
    return response;
  }
}

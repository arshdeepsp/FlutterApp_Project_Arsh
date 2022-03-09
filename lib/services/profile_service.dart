import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tripd_travel_app/components/widgets/custom_toast.dart';
import 'package:tripd_travel_app/models/user_profile.dart';

class Profile {
  Profile._();

  /// Returns a [Profile].
  factory Profile() {
    return Profile._();
  }

  Future<int> checkUniqueName({required uname}) async {
    int status = -1;
    try {
      if (uname.length <= 3) {
        status = -1;
      } else {
        var response =
            await get(Uri.parse("https://ms.tripd.co/profiles/unique/$uname"));
        if (json.decode(response.body)["data"]) {
          status = 1;
        } else {
          status = 0;
        }
      }
    } catch (e) {
      print(e.toString());
    }
    return status;
  }

  Future<dynamic> getFollowers({required token}) async {
    var url = Uri.parse("https://ms.tripd.co/profiles/followers");
    var data;
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    try {
      var response = await get(url, headers: headers);
      data = json.decode(response.body);
      // print(data);
    } catch (e) {
      print(e.toString());
    }
    return data;
  }

  Future<dynamic> followUser({required token, required userId}) async {
    var url = Uri.parse("https://ms.tripd.co/profiles/follow?userId=$userId");
    var data;
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    try {
      var response = await post(url, headers: headers, body: null);
      data = json.decode(response.body);
      // print(data);
    } catch (e) {
      print(e.toString());
    }
    return data;
  }

  Future<dynamic> setProfile({
    required token,
    required userName,
    required firstName,
    required lastName,
    required email,
  }) async {
    var data = {};
    try {
      data["username"] = userName;
      data["firstName"] = firstName;
      data["lastName"] = lastName;
      data["profilePic"] = "https://fake.com/fake.jpg";
      data["bio"] = "Sample bio";
      data["email"] = email;
      // print("data");
      // print(data);
      var url = Uri.parse("https://ms.tripd.co/profiles/");
      final msg = json.encode(data);
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var response = await post(url, headers: headers, body: msg);
      data = json.decode(response.body);
      // print(data);
    } catch (e) {
      return e;
    }
    return data;
  }

  Future<dynamic> updateProfile(
      {required token,
      userName,
      firstName,
      lastName,
      bio,
      required BuildContext context}) async {
    var data = {};
    try {
      data['username'] = userName;
      data['firstName'] = firstName;
      data['lastName'] = lastName;
      data['bio'] = bio;

      // print(data);
      var url = Uri.parse("https://ms.tripd.co/profiles");
      final msg = json.encode(data);
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var response = await put(url, headers: headers, body: msg);
      data = json.decode(response.body);
      if (data['status']) {
        Timer(Duration(seconds: 2), () {
          Navigator.pop(context);
        });
        showToast(
            msg: "Profile updated successfully.",
            context: context,
            type: toastTypes.Success,
            duration: 1);
      }
      print(data);
    } catch (e) {
      return e;
    }
    return data;
  }

  Future<dynamic> getProfile({
    required token,
    String? userId,
  }) async {
    UserProfile? userProfile;
    print(token);
    try {
      var endpoint = userId == null
          ? "https://ms.tripd.co/profiles/"
          : "https://ms.tripd.co/profiles/public/$userId";
      var url = Uri.parse(endpoint);
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var response = await get(url, headers: headers);
      var data = json.decode(response.body);
      //print(data);
      userProfile = UserProfile.fromJson(data['data']);
    } catch (e) {
      print(e.toString());
    }
    return userProfile;
  }

  Future<dynamic> getProfileJson({
    required token,
    String? userId,
  }) async {
    var data = {};
    print(token);
    try {
      var endpoint = userId == null
          ? "https://ms.tripd.co/profiles/"
          : "https://ms.tripd.co/profiles/public/$userId";
      var url = Uri.parse(endpoint);
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var response = await get(url, headers: headers);
      data = json.decode(response.body);
      // print(data);

    } catch (e) {
      print(e.toString());
    }
    return data;
  }

  Future<String?> requestSignup(
      {required String email, required BuildContext context}) async {
    var url =
        Uri.parse("https://ms.tripd.co/profiles/requestSignupInvite/$email");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var message;
    try {
      if (email.isNotEmpty) {
        var response = await post(url, headers: headers);
        var data = jsonDecode(response.body);
        print(data);
        if (data['status']) {
          message = 'Signup request sent';
          Timer(Duration(seconds: 2), () {
            Navigator.pop(context);
          });
          showToast(
              msg: message,
              context: context,
              type: toastTypes.Success,
              duration: 1);
        } else {
          message = 'Signup request failed';
          Timer(Duration(seconds: 2), () {
            Navigator.pop(context);
          });
          showToast(
              msg: message,
              context: context,
              type: toastTypes.Error,
              duration: 1);
        }
      } else {
        showToast(
            msg: 'Please enter an email address',
            context: context,
            type: toastTypes.Error,
            duration: 1);
      }
    } catch (e) {
      print(e.toString());
    }
    return message;
  }
}

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:tripd_travel_app/models/chat_message.dart';
import 'package:tripd_travel_app/models/collection.dart';
import 'package:tripd_travel_app/models/group_saves.dart';
import 'package:tripd_travel_app/models/plan.dart';
import 'package:tripd_travel_app/services/auth_service.dart';
import 'package:tripd_travel_app/services/profile_service.dart';

class SocketService with ChangeNotifier {
  static const SOCKET_URL = 'http://feeds.tripd.co:4001';
  // static const SOCKET_URL = 'http://10.0.2.2:4001';

  final Profile profile = Profile();
  String? username;
  String? userProfilePic;
  var _feeds = [];
  var _notifications = [];

  HashMap _fetchedGroupChats = new HashMap<String, List<ChatMessage?>>();
  HashMap _liveMessageCount = new HashMap<String, int>();

  IO.Socket? _socket;

  get feeds {
    return _feeds;
  }

  get notifications {
    return _notifications;
  }

  get fetchedGroupChats {
    return _fetchedGroupChats;
  }

  get liveMessageCount {
    return _liveMessageCount;
  }

  Future<dynamic> getAllFeeds({
    required token,
  }) async {
    var url = Uri.parse("https://ms.tripd.co/feeds/rest/getFeeds");

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    try {
      var response = await http.get(url, headers: headers);
      var data = json.decode(response.body);
      print(data);
      if (data['status']) {
        _feeds = [];
        data['data'].forEach((val) {
          if (val["user"] != null) {
            feeds.add(val);
          }
        });
      }
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> getAllNotifications({
    required token,
  }) async {
    var url = Uri.parse("https://ms.tripd.co/feeds/rest/getNotifications");

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    try {
      var response = await http.get(url, headers: headers);
      var data = json.decode(response.body);
      // print(data);
      if (data['status']) {
        _notifications = [];
        data['data'].forEach((val) {
          if (val["user"] != null) {
            notifications.add(val);
          }
        });
      }
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> getAllMessages({
    required token,
    required groupId,
  }) async {
    if (_fetchedGroupChats.containsKey(groupId)) {
      return _fetchedGroupChats[groupId];
    }
    var url = Uri.parse("https://ms.tripd.co/feeds/rest/getMessages/$groupId");
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    try {
      var response = await http.get(url, headers: headers);
      var responseData = json.decode(response.body);
      if (responseData['status']) {
        List<ChatMessage?> grpMessages = [];
        var reveredChat = responseData['data'];
        reveredChat.forEach((data) {
          if (data["user"] != null && data["verb"] != null) {
            print("text....................................");
            var chatMsg = ChatMessage(
                id: data["id"],
                messageType: ChatMessageType.text,
                text: data["verb"],
                createdAt: data["createdAt"],
                isSender: data["user"]["username"] == username,
                groupId: data["groupId"],
                messageStatus: MessageStatus.not_view,
                userId: data["user"]["userId"],
                username: data["user"]["username"],
                profilePic: data["user"]["profilePic"]);
            grpMessages.add(chatMsg);
          } else if (data["user"] != null &&
              data["object"] != null &&
              data["verb"] == null) {
            print("content....................................");
            var chatMsg = ChatMessage(
              id: data["id"],
              messageType: ChatMessageType.content,
              text: data["feedType"] ?? "",
              createdAt: data["createdAt"],
              isSender: data["user"]["username"] == username,
              groupId: data["groupId"],
              messageStatus: MessageStatus.not_view,
              userId: data["user"]["userId"],
              username: data["user"]["username"],
              profilePic: data["user"]["profilePic"],
              image: data["object"]["${data["feedType"]}Image"],
            );
            grpMessages.add(chatMsg);
          }
        });
        _fetchedGroupChats[groupId] = grpMessages;
      }
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> getGroupSaves({required token, required groupId}) async {
    var url =
        Uri.parse("https://ms.tripd.co/feeds/rest/getGroupSaves/$groupId");
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    print(groupId);
    List<GroupSave> groupSaves = [];
    try {
      var response = await http.get(url, headers: headers);
      var responseData = json.decode(response.body);
      if (responseData['status']) {
        responseData['data'].forEach((val) {
          if (val["user"] != null) {
            var type = val["feedType"] == "plan"
                ? GroupSavesType.Plan
                : val["feedType"] == "collection"
                    ? GroupSavesType.Collection
                    : GroupSavesType.Offering;
            var grpSave = GroupSave(
                id: val["id"],
                isSender: val["user"]["username"] == username,
                groupId: val["groupId"],
                createdAt: val["createdAt"],
                username: val["user"]["username"],
                profilePic: val["user"]["profilePic"],
                type: type,
                content: type == GroupSavesType.Plan
                    ? Plan.fromJson(val["object"])
                    : val["feedType"] == "collection"
                        ? Collection(
                            id: val["object"]["id"],
                            name: val["object"]["name"],
                            userId: val["object"]["userId"],
                            offerings: val["object"]["offerings"],
                            collectionImage: val["object"]["collectionImage"],
                            isPrivate: val["object"]["isPrivate"])
                        : val["object"],
                image: val["object"]["${val["feedType"]}Image"]);
            groupSaves.add(grpSave);
          }
        });
        return groupSaves;
      }
    } catch (e) {}
  }

  void initializeSocket(auth) async {
    var idToken = await auth.currentUser!.getIdToken();
    print("initializing........." + SOCKET_URL);
    if (username == null) {
      var userProfile = await profile.getProfileJson(token: idToken);
      // print(userProfile);
      if (userProfile["status"]) {
        username = userProfile["data"]["username"];
        userProfilePic = userProfile["data"]["profilePic"];
      }
      await getAllFeeds(token: idToken);
      await getAllNotifications(token: idToken);
    }
    // print(username);

    if (_socket == null || _socket!.connected == false) {
      print("Sending token.... " + idToken);
      _socket = IO.io(
          SOCKET_URL,
          IO.OptionBuilder()
              .setTransports(['websocket'])
              .disableAutoConnect()
              // .setQuery({"token": "Bearer $idToken"})
              .build());

      IO.Socket socket = _socket!;

      socket.on("session", (data) {
        print("session response");
        print(data);
      });

      socket.onConnect((_) {
        print('connect');
        _socket!.emit("authenticate", {"token": "Bearer $idToken"});
      });
      //  Getting Feeds.....................................................................................
      socket.on('public-feed', (data) {
        print("Got Feed.......");
        if (data["user"]["username"] != username) {
          print(data);
          _feeds = [data, ..._feeds];
        }
        notifyListeners();
      });

      //  Getting Notifications.............................................................................
      socket.on('notification', (data) async {
        print("Got Notification.............");
        print(data);
        if (data["user"]["username"] != username) {
          _notifications = [data, ..._notifications];
        }
        notifyListeners();
      });

      //  Getting Messages...................................................................................
      socket.on('message', (data) async {
        print("Got message.......");
        print(data);
        // print(data["id"]);
        if (!_fetchedGroupChats.containsKey(data["groupId"])) {
          print("nooooooooooooooooooo");
          final auth = Auth();
          var idToken = await auth.currentUser!.getIdToken();
          await getAllMessages(token: idToken, groupId: data["groupId"]);
        }
        if (!_liveMessageCount.containsKey(data["groupId"])) {
          _liveMessageCount[data["groupId"]] = 1;
        } else {
          _liveMessageCount[data["groupId"]]++;
        }

        final isAlready = _fetchedGroupChats[data["groupId"]]
            .where((msg) => msg.id == data["id"]);

        print("isAlready...................");
        // print(isAlready);

        if (isAlready.length == 0) {
          if (data["feedType"] != "plan" || data["feedType"] != "collection") {
            var msg = ChatMessage(
                id: data["id"],
                messageType: ChatMessageType.text,
                text: data["message"],
                createdAt: data["createdAt"],
                isSender: false,
                groupId: data["groupId"],
                messageStatus: MessageStatus.not_view,
                userId: data["user"]["userId"],
                username: data["user"]["username"],
                profilePic: data["user"]["profilePic"]);

            _fetchedGroupChats[data["groupId"]].insert(0, msg);
          } else {
            var msg = ChatMessage(
              id: data["id"],
              messageType: ChatMessageType.content,
              text: data["feedType"] ?? "",
              createdAt: data["createdAt"],
              isSender: data["user"]["username"] == username,
              groupId: data["groupId"],
              messageStatus: MessageStatus.not_view,
              userId: data["user"]["userId"],
              username: data["user"]["username"],
              profilePic: data["user"]["profilePic"],
              image: data["object"]["${data["feedType"]}Image"],
            );
            _fetchedGroupChats[data["groupId"]].insert(0, msg);
          }
          notifyListeners();
        }
      });

      socket.on('connecting', (data) => print("connecting"));
      socket.on(
          'connect_error', (data) => {print("connect_error"), print(data)});
      socket.onDisconnect((err) => {print('disconnect'), print(err)});

      socket.connect();
      print(socket.connected);
    }
  }

  sendMessage(
      {required String msg, required String groupId, required String token}) {
    print("sending message ==>> " + msg);
    // print(_socket);
    _socket!.emit("message", {"message": msg, "groupId": groupId});
    var message = ChatMessage(
        messageType: ChatMessageType.text,
        text: msg,
        isSender: true,
        groupId: groupId,
        id: "user",
        createdAt: DateTime.now().millisecondsSinceEpoch,
        messageStatus: MessageStatus.not_view,
        username: username,
        profilePic: userProfilePic
        // userId: data["user"]["userId"],
        );

    // _messages = [..._messages, message];
    _fetchedGroupChats[groupId].insert(0, message);

    notifyListeners();
    saveMessage(token: token, groupId: groupId, message: msg);
  }

  sendContentMessage({
    required String type,
    required String typeId,
    required String groupId,
    required String image,
    required String token,
  }) async {
    // print(
    //     "neeeeeeeeeeeeeeeeeeee type: $type, typeId: $typeId, groupId: $groupId}");
    _socket!
        .emit("message", {"type": type, "typeId": typeId, "groupId": groupId});
    var chatMsg = ChatMessage(
        id: "user",
        messageType: ChatMessageType.content,
        isSender: true,
        groupId: groupId,
        messageStatus: MessageStatus.not_view,
        username: username,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        profilePic: userProfilePic,
        image: image,
        text: type);

    if (!_fetchedGroupChats.containsKey(groupId)) {
      print("nooooooooooooooooooo");
      final auth = Auth();
      var idToken = await auth.currentUser!.getIdToken();
      print(idToken);
      await getAllMessages(token: idToken, groupId: groupId);
    }
    _fetchedGroupChats[groupId].insert(0, chatMsg);

    notifyListeners();
    saveContentMessage(
        type: type, typeId: typeId, groupId: groupId, token: token);
  }

  Future<dynamic> saveMessage({
    required token,
    required groupId,
    required message,
  }) async {
    var data = {};
    try {
      data["groupId"] = groupId;
      data["message"] = message;

      print("data");
      print(data);
      var url = Uri.parse("https://ms.tripd.co/feeds/rest/addMessage");
      final msg = json.encode(data);
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var response = await http.post(url, headers: headers, body: msg);
      data = json.decode(response.body);
      // print(data);
    } catch (e) {
      return e;
    }
    return data;
  }

  Future<dynamic> saveContentMessage(
      {required String type,
      required String typeId,
      required String groupId,
      required String token}) async {
    var data = {};
    try {
      data["type"] = type;
      data["typeId"] = typeId;
      data["groupId"] = groupId;

      print("data");
      print(data);
      var url = Uri.parse("https://ms.tripd.co/feeds/rest/addMessage");
      final msg = json.encode(data);
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var response = await http.post(url, headers: headers, body: msg);
      data = json.decode(response.body);
      print(data);
    } catch (e) {
      return e;
    }
    return data;
  }

  markAsRead({required token, required groupId}) async {
    var url = Uri.parse("https://ms.tripd.co/feeds/rest/markRead");
    var data = {};
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    var body = json.encode({"groupId": groupId});

    var response = await http.post(url, headers: headers, body: body);

    data = jsonDecode(response.body);
    print(data);
    if (data['status']) {
      _liveMessageCount[groupId] = 0;
    }

    return data['status'];
  }

  dismiss() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.destroy();
      _socket = null;
      _feeds = [];
      _notifications = [];
      username = null;
      _fetchedGroupChats = new HashMap<String, List<ChatMessage?>>();
    }
  }
}

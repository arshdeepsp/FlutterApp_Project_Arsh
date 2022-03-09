import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/domain/side_menu.dart';
import 'package:tripd_travel_app/components/domain/tripd_nav_bar.dart';
import 'package:tripd_travel_app/components/streams/streams.dart';
import 'package:tripd_travel_app/screens/chat_page/chat_page.dart';
import 'package:tripd_travel_app/screens/collection_page/collection_page.dart';
import 'package:tripd_travel_app/screens/feed_page/feed_page.dart';
import 'package:tripd_travel_app/screens/feedback_page/feedback_page.dart';
import 'package:tripd_travel_app/screens/invite_page/invite_page.dart';
import 'package:tripd_travel_app/screens/profile_page/profile_page.dart';
import 'package:tripd_travel_app/screens/search_page/search_page.dart';
import 'package:tripd_travel_app/screens/settings_page/settings_page.dart';
import 'package:tripd_travel_app/screens/terms_page/terms_page.dart';
import 'package:tripd_travel_app/screens/view_plans/view_plans.dart';
import 'package:tripd_travel_app/services/auth_service.dart';
import 'package:tripd_travel_app/services/socket_service.dart';

class HomeController extends StatefulWidget {
  HomeController({
    Key? key,
  }) : super(key: key);
  @override
  _HomeControllerState createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  int num = 2;
  final _key = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  String message = '';

  void connectSocket() {
    final auth = Provider.of<AuthService>(context, listen: false);

    final socket = Provider.of<SocketService>(context, listen: false);
    socket.initializeSocket(auth);
  }

  @override
  void initState() {
    super.initState();
    connectSocket();
    _openDrawer();
    _navigate();
  }

  Future<void> _openDrawer() async {
    drawerController.stream.listen((val) async {
      if (val == 'drawer') {
        _globalKey.currentState!.openDrawer();
      }
    });
  }

  void _settingsPage() {
    Navigator.push(context, PageRouteBuilder(pageBuilder: (context, a, b) {
      return ProfileSettings();
    }));
  }

  void _invitePage() {
    Navigator.push(context, PageRouteBuilder(pageBuilder: (context, a, b) {
      return InvitePage();
    }));
  }

  void _feedbackPage() {
    Navigator.push(context, PageRouteBuilder(pageBuilder: (context, a, b) {
      return FeedbackPage();
    }));
  }

  void _termsPage() {
    Navigator.push(context, PageRouteBuilder(pageBuilder: (context, a, b) {
      return TermsPage();
    }));
  }

  Future<void> _navigate() async {
    drawerController.stream.listen((val) async {
      if (val == 'settings') {
        if (_globalKey.currentState!.isDrawerOpen) Navigator.pop(context);
        _settingsPage();
      }
      if (val == 'invite') {
        if (_globalKey.currentState!.isDrawerOpen) Navigator.pop(context);
        _invitePage();
      }
      if (val == 'feedback') {
        if (_globalKey.currentState!.isDrawerOpen) Navigator.pop(context);
        _feedbackPage();
      }
      if (val == 'terms') {
        if (_globalKey.currentState!.isDrawerOpen) Navigator.pop(context);
        _termsPage();
      }
    });
    navController.stream.listen((val) {
      if (val == 'plans') {
        Navigator.pop(context);
        _key.currentState!.push(PageRouteBuilder(
            transitionDuration: Duration(microseconds: 0),
            reverseTransitionDuration: Duration(microseconds: 0),
            pageBuilder: (context, a, b) {
              return ViewPlans();
            }));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _globalKey,
        drawer: SafeArea(child: SideMenu()),
        body: WillPopScope(
          child: Navigator(
              key: _key,
              onGenerateRoute: (RouteSettings settings) {
                WidgetBuilder builder;
                switch (settings.name) {
                  default:
                    builder = (BuildContext context) => SearchPage();
                    break;
                }
                return MaterialPageRoute(builder: builder, settings: settings);
              }),
          onWillPop: () async {
            if (_key.currentState!.canPop()) {
              _key.currentState!.pop();
              if (!_key.currentState!.canPop()) {
                setState(() {
                  this.num = 2;
                });
              }
              return false;
            }
            return true;
          },
        ),
        backgroundColor: Colors.white,
        bottomNavigationBar: TripdNavigationBar(
          currentIndex: num,
          onTap: (int num) {
            setState(() {
              this.num = num;
            });
            if (this.num == 0)
              _key.currentState!.pushAndRemoveUntil(
                  PageRouteBuilder(
                    pageBuilder: (context, a, b) {
                      return CollectionPage();
                    },
                    transitionDuration: Duration(seconds: 0),
                    reverseTransitionDuration: Duration(seconds: 0),
                    maintainState: true,
                  ),
                  ModalRoute.withName('/'));
            if (this.num == 1)
              _key.currentState!.pushAndRemoveUntil(
                  PageRouteBuilder(
                    pageBuilder: (context, a, b) {
                      return FeedPage();
                    },
                    transitionDuration: Duration(seconds: 0),
                    reverseTransitionDuration: Duration(seconds: 0),
                    maintainState: true,
                  ),
                  ModalRoute.withName('/'));
            if (this.num == 2) {
              _key.currentState!.popUntil(ModalRoute.withName('/'));
            }
            if (this.num == 3)
              _key.currentState!.pushAndRemoveUntil(
                  PageRouteBuilder(
                    pageBuilder: (context, a, b) {
                      return ProfilePage();
                    },
                    transitionDuration: Duration(seconds: 0),
                    reverseTransitionDuration: Duration(seconds: 0),
                    maintainState: true,
                  ),
                  ModalRoute.withName('/'));
            if (this.num == 4)
              _key.currentState!.pushAndRemoveUntil(
                  PageRouteBuilder(
                    pageBuilder: (context, a, b) {
                      return ChatPage();
                    },
                    transitionDuration: Duration(seconds: 0),
                    reverseTransitionDuration: Duration(seconds: 0),
                    maintainState: true,
                  ),
                  ModalRoute.withName('/'));
          },
        ));
    // return ChatView();
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/controllers/startup_controller.dart';
import 'package:tripd_travel_app/services/auth_service.dart';
import 'package:tripd_travel_app/services/collection_service.dart';
import 'package:tripd_travel_app/services/group_service.dart';
import 'package:tripd_travel_app/services/location_service.dart';
import 'package:tripd_travel_app/services/offering_service.dart';
import 'package:tripd_travel_app/services/places_service.dart';
import 'package:tripd_travel_app/services/plan_service.dart';
import 'package:tripd_travel_app/services/profile_pic_service.dart';
import 'package:tripd_travel_app/services/profile_service.dart';
import 'package:tripd_travel_app/services/socket_service.dart';

Future<void> main() async {
  Provider.debugCheckInvalidValueType = null;
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) {
      runApp(MyApp());
    });
  } on Exception catch (e) {
    print(e.toString());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthService>(
            create: (_) => Auth(),
          ),
          Provider<GroupService>(
            create: (_) => GroupService(),
          ),
          Provider<LocationService>(
            create: (_) => LocationService(),
          ),
          Provider<OfferingService>(
            create: (_) => OfferingService(),
          ),
          Provider<PlacesService>(
            create: (_) => PlacesService(),
          ),
          Provider<PlanService>(
            create: (_) => PlanService(),
          ),
          Provider<Profile>(
            create: (_) => Profile(),
          ),
          Provider<ProfilePicService>(
            create: (_) => ProfilePicService(),
          ),
          Provider<CollectionService>(create: (_) => CollectionService()),
          ChangeNotifierProvider<SocketService>(create: (_) => SocketService())
        ],
        child: MaterialApp(
          title: 'Tripd App',
          home: StartupController(),
          theme: ThemeData(),
        ));
  }
}

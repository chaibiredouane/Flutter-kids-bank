// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:first/models/kidModel.dart';
import 'package:first/models/user.dart';
import 'package:first/screens/Accueil.dart';
import 'package:first/screens/KidDetails.dart';
import 'package:first/screens/authanticate/authanticateScreen.dart';
import 'package:first/screens/dialogs/prayerDialog.dart';
import 'package:first/screens/kidsListScreen.dart';
import 'package:first/screens/products.dart';
import 'package:first/screens/splashscreen_wrapper.dart';
import 'package:first/services/authentication.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (!kIsWeb) {
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(kDebugMode ? false : true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }
  runApp(FirstClass());
}

class FirstClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser?>.value(
      value: AuthenticationService().user,
      initialData: null,
      child: MaterialApp(
        title: 'Bank kids',
        initialRoute: '/',
        onGenerateRoute: (settings) => RouteGenerator.generateRoute(settings),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => SplashScreenWrapper());
      case '/signin':
        return MaterialPageRoute(builder: (context) => AuthanticateScreen());
      case '/kids':
        return MaterialPageRoute(builder: (context) => KidsListScreeen());
      case '/details':
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                KidsDetails(settings.arguments as Kid),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            });
      case '/accueil':
        return MaterialPageRoute(builder: (context) => Accueil());
      case '/products':
        return MaterialPageRoute(builder: (context) => Products());
      case '/prayer_dialog':
        return MaterialPageRoute(
            builder: (context) => PrayerDialog(settings.arguments as Kid));
      default:
        return MaterialPageRoute(
            builder: (context) => Scaffold(
                  appBar: AppBar(title: Text("Error"), centerTitle: true),
                  body: Center(
                    child: Text("Page not found"),
                  ),
                ));
    }
  }
}

import 'package:first/models/user.dart';
import 'package:first/screens/authanticate/authanticateScreen.dart';
import 'package:first/screens/kidsListScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreenWrapper extends StatelessWidget {
  const SplashScreenWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    if (user == null) {
      return AuthanticateScreen();
    } else {
      return KidsListScreeen();
    }
  }
}

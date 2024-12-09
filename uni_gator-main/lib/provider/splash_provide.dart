// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uni_gator/screens/splash/onboarding_screen.dart';

import '../resources/service_constants.dart';
import '../screens/bottomnav_bar.dart';

class SplashScreenViewModel extends ChangeNotifier {
  Timer? timer;

  void splashScreenCounter(BuildContext context) async {
    if (user != null) {
      timer = Timer(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const BottomNavScreen(),
          ),
        );
      });
    } else {
      timer = Timer(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const OnBoardingScreen(),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}

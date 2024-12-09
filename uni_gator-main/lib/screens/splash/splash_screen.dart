import 'package:flutter/material.dart';

import '../../provider/splash_provide.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Welcome to Unigator\n Let’s find University!",
      "image": "assets/images/unigatorr.png"
    },
  ];

  final SplashScreenViewModel _viewModel = SplashScreenViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.splashScreenCounter(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/unigatorr.png",
            ),
          ],
        ),
      ),
    );
  }
}

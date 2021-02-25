import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sqflite_battery/screens/batter_list_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
      Duration(seconds: 7),
      () => Navigator.pushReplacement(
        context,
        PageTransition(
            child: BatteryListScreen(), type: PageTransitionType.rightToLeft),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 300,
                child: Lottie.asset('assets/animation/spalsh.json'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

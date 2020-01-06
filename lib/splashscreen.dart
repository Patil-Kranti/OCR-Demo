import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'login.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoggedIn = false;
  Animation<double> animation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    loadData();

    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 5))
          ..addListener(() {});
    animationController.forward();
          animation = CurvedAnimation(parent: animationController, curve: Curves.elasticInOut);
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 6), onDoneLoading);
  }

  onDoneLoading() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('_isLoggedIn');
    if (_isLoggedIn ?? false) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MyHomePage()));
    } else {                                                                                                                              
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => AuthPage()));                                                                                                                              
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5), BlendMode.dstATop)),
          ),
          padding: EdgeInsets.all(25),
          child: Center(
            child: RotationTransition(child: Image.asset("assets/images/logo.png"), turns: animation,),
          ),
        ),
      ),
    );
  }

  DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Toast.show("Please Press again to exit", context,
          duration: Toast.LENGTH_LONG);

      return Future.value(false);
    }
    return Future.value(true);
  }
}

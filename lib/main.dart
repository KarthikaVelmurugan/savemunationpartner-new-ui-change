import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:savemynationpartner/splashandloginbg.dart';
import 'package:savemynationpartner/home.dart';
import 'package:savemynationpartner/loginui.dart';
import 'package:savemynationpartner/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Save My Nation Partner',
      color: color,
      home: new SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/HomePage': (BuildContext context) => new HomePage(),
        '/WelcomePage': (BuildContext context) => new Login(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
// prefs.clear();
    bool firstTime = prefs.getBool('first_time');

    var _duration = new Duration(seconds: 2);
    if (firstTime != null && !firstTime) {
      // Not first time
      return new Timer(_duration, navigationPageHome);
    } else {
      // First time

      return new Timer(_duration, navigationPageWel);
    }
  }

  void navigationPageHome() {
    //  toast(context, "You are already Registered!!");
    Navigator.of(context).pushReplacementNamed('/HomePage');
  }

  void navigationPageWel() {
    //  toast(context, "User enter into registration page");
    Navigator.of(context).pushReplacementNamed('/WelcomePage');
  }

  String fetchlatitude = '';
  String fetchlongitude = '';
  String time = '';
  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double wt = screenSize.width;
    TextStyle ts = TextStyle(
      fontSize: wt / 15,
      color: Color(0xFF6F35A5),
      fontWeight: FontWeight.w900,
      fontStyle: FontStyle.italic,
      letterSpacing: 1,
    );
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Background(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Save My Nation',
                    style: ts,
                  ),
                  Text(
                    'Partner',
                    style: ts,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

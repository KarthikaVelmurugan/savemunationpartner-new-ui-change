import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/location.dart';
import 'package:savemynationpartner/splashandloginbg.dart';
import 'package:savemynationpartner/animation_delay.dart';
import 'package:savemynationpartner/checknetconnectivity.dart';
import 'package:savemynationpartner/components/rounded_button.dart';
import 'package:savemynationpartner/constants.dart';
import 'package:savemynationpartner/formreg.dart';
import 'package:savemynationpartner/globals.dart';

import 'package:savemynationpartner/shared.dart';
import 'package:savemynationpartner/sign_in.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final Location location = Location();
  final int delayedAmount = 500;

  AnimationController _controller;

  getSignIn() async {
    await signInWithGoogle().whenComplete(() async {
      if (name == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              //check user do googlesignin properly or not
              return Login();
            },
          ),
        );
      } else {
        //user signed properly
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return FirstScreen();
            },
          ),
        );
      }
    });
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkingnet(context);

    MediaQueryData queryData = MediaQuery.of(context);
    double ht = queryData.size.height;
    double wt = queryData.size.width;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Save My Nation Partner',
        color: color,
        home: WillPopScope(
            onWillPop: _onBackPressed,
            child: MaterialApp(
              title: "Save My Nation Partner",
              debugShowCheckedModeBanner: false,
              color: color,
              home: Scaffold(
                body: Background(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(height: ht / 13),
                      DelayedAnimation(
                          child: Container(
                              padding: EdgeInsets.all(8.0),
                              height: ht / 2,
                              width: queryData.size.width,
                              child: SvgPicture.asset(
                                "assets/icons/chat.svg",
                                height: ht / 4,
                              )),
                          delay: delayedAmount + 500),
                      DelayedAnimation(
                          child: Padding(
                              padding: EdgeInsets.all(wt / 10),
                              child: Container(child: _signInButton())),
                          delay: delayedAmount + 2000),
                    ],
                  ),
                ),
              ),
            )));
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () {
                  //  toast(context, "Thank You For Your Collaboration!!");
                  Navigator.of(context).pop(true);
                },
                child: Text("YES"),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget _signInButton() {
    return RoundedButton(
      press: () async {
        checkingnet(context);

        if (checknet == 'connected') {
          signInWithGoogle().whenComplete(() {
            if (name == null) {
              // toast(context, "Sorry!You are not signin properly! try again!");
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) {
                    return Login();
                  },
                ),
              );
            } else {
              // toast(context, "Successfully signin your google account!");
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return FirstScreen();
                  },
                ),
              );
            }
          });
        }
      },

      /*  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              highlightElevation: 0,      
              borderSide: BorderSide(color: Colors.white70,width: 2),
              child: Padding(        
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: 
                      Text(
                    'Sign in with Google',
                    style:btnstyle
                  ),
                   ),
              ),*/
      text: "Sign in with Google",
      color: kPrimaryColor,
      textColor: Colors.white,
    );
  }
}

int checkauth() {
  if (name != null) {
    return 0;
  } else {
    return 1;
  }
}

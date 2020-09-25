import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:savemynationpartner/concernsbg.dart';

import 'constants.dart';

class UserProfilePage extends StatelessWidget {
  final String url, name, email, professional, state, street, district, mobnum;
  UserProfilePage(this.url, this.name, this.email, this.professional,
      this.state, this.street, this.district, this.mobnum);

  Widget _buildProfileImage(double ht, double wt) {
    return Center(
      child: AvatarGlow(
        glowColor: Colors.deepPurple,
        endRadius: 90.0,
        duration: Duration(milliseconds: 2000),
        repeat: true,
        showTwoGlows: true,
        repeatPauseDuration: Duration(milliseconds: 100),
        child: Material(
          elevation: 8.0,
          shape: CircleBorder(),
          child: CircleAvatar(
            backgroundColor: Colors.grey[100],
            child: Container(
              width: wt / 3,
              height: wt / 3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(url),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(50.0),
                border: Border.all(
                  color: kActiveShadowColor,
                  width: 5,
                ),
              ),
            ),
            radius: 40.0,
          ),
        ),
      ),

      /* Container(
        width: wt / 3,
        height: wt / 3,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(url),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(50.0),
          border: Border.all(
            color: kActiveShadowColor,
            width: 5,
          ),
        ),
      ),*/
    );
  }

  Widget _buildFullName(double wt) {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Poppins',
      color: Colors.black,
      fontSize: wt / 20,
      fontWeight: FontWeight.w800,
    );

    return Text(
      name,
      style: _nameTextStyle,
    );
  }

  Widget leftWidget(TextStyle _style, String txt) {
    return Text(
      txt,
      textAlign: TextAlign.center,
      style: _style,
    );
  }

  Widget _buildBio(BuildContext context) {
    TextStyle bioTextStyle = TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400, //try changing weight to w500 if not thin
      fontStyle: FontStyle.italic,
      letterSpacing: 1,
      color: Colors.black45,
      fontSize: 15.0,
    );

    return Container(
      padding: EdgeInsets.all(8.0),
      child: Text(
        email,
        textAlign: TextAlign.center,
        style: bioTextStyle,
      ),
    );
  }

  Widget _buildSeparator(Size screenSize) {
    return Container(
      width: screenSize.width / 1.4,
      height: 2.5,
      color: Colors.black,
      margin: EdgeInsets.only(top: 14.0),
    );
  }

  Widget _buildDetails(BuildContext context, double ht, double wt) {
    TextStyle detailsTextStyle = TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500, //try changing weight to w500 if not thin
      fontStyle: FontStyle.italic,
      color: Colors.black,
      fontSize: wt / 30,
    );

    TextStyle detailsLeftTextStyle = TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.bold, //try changing weight to w500 if not thin
      fontStyle: FontStyle.italic,
      color: Colors.black,
      fontSize: wt / 30,
    );

    return Container(
      padding: EdgeInsets.only(left: ht / 12, top: ht / 70),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              leftWidget(detailsLeftTextStyle, 'Mobile Number')
            ],
          ),
          SizedBox(width: 3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                leftWidget(detailsTextStyle, mobnum),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double ht = screenSize.height;
    double wt = screenSize.width;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Save My Nation Partner',
        theme: ThemeData(
          fontFamily: "Poppins",
        ),
        home: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              height: ht,
              width: wt,
              child: Background(
                child: SafeArea(
                  bottom: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: ht / 50),
                      _buildProfileImage(screenSize.height, screenSize.width),
                      SizedBox(height: 10),
                      _buildFullName(screenSize.width),
                      SizedBox(height: 6),
                      _buildBio(context),
                      SizedBox(height: 6),
                      _buildSeparator(screenSize),
                      SizedBox(height: 5),
                      _buildDetails(context, ht, screenSize.width),
                      SizedBox(height: ht / 20),
                      /*  Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: PreventCard(
                            image: 'assets/cor.png',
                            title: "Prepare, Don't Panic!",
                            text:
                                'Wash your hands. Use a tissue for coughs. Avoid touching your face.'),
                      ),*/
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

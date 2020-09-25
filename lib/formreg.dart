import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:location/location.dart';
import 'package:savemynationpartner/formbg.dart';
import 'package:savemynationpartner/animation_delay.dart';
import 'package:savemynationpartner/checknetconnectivity.dart';
import 'package:savemynationpartner/fluttertoastmsg.dart';
import 'package:savemynationpartner/globals.dart';
import 'package:savemynationpartner/home.dart';
import 'package:savemynationpartner/netcheckdialogue.dart';
import 'package:savemynationpartner/shared.dart';
import 'package:savemynationpartner/showLocationdialogue.dart';
import 'package:savemynationpartner/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'loginui.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState> _key = GlobalKey();
  int _page = 1;
  final int delayedAmount = 500;

  AnimationController _controller;

  bool _validaten = false;
  bool _validatem = false;
  String _platformImei = 'Unknown';
  String uniqueId = "Unknown";
  FocusNode namefocusnode, mobilefocusnode;
  TextEditingController nameController = TextEditingController();
  TextEditingController mobnoController = TextEditingController();

  TextEditingController addController = TextEditingController();
  String sname, mobno;
  var toastText;
  String errD = '';
  bool _validateA = false;
  String errS = '';

  String _dropDownDistrictValue, _dropDownStateValue;
  String address, district, state;
  FocusNode addfocus, statefocus, disfocus;

  final String url = "https://api.savemynation.com/api/v1/savemynation/state";
  final String durl =
      "https://api.savemynation.com/api/v1/savemynation/district";
  var serverip = TextEditingController(text: '192.168.1.40');
  List<String> sdata = List();
  List<String> disdata = List();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final Location location = Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  String professional = '', contribution = '';
  String _dropDownValue, _dropDownValueC;
  FocusNode focusprof, contrifocus;
  bool validateP = false;
  bool validateC = false;

  var sessionToken = '';
  String lat, long;
  String errP = '';
  String errC = '';
  String firebaseToken;
  getLocation() async {
    _permissionGranted = await location.hasPermission();
    print("Permission status:");
    print(_permissionGranted);
//toast(context, "Permission Status :$_permissionGranted");
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
      if (_permissionGranted == PermissionStatus.granted) {
        return;
      }
    }
    print("permisision status:");
    print(_permissionGranted);
//toast(context, "Permission Status :$_permissionGranted");
    if (_permissionGranted == PermissionStatus.granted) {
      _serviceEnabled = await location.serviceEnabled();
      print("SeevicEnabled:");
      print(_serviceEnabled);
//toast(context,"Service enabled status: $_serviceEnabled");
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          //showLocation(context);
          print("after request press nothanks!!");
          print(_serviceEnabled);
          if (_serviceEnabled == false) {
            showLocation(context);
            print("showlocationok:");
            print(showlocationok);
          }

          return;
        }
      }
    } else {
      toast(
          context, "This app requires Location services!! \n Kindly Allow it!");
      getLocation();
    }

    _locationData = await location.getLocation();
    print(_locationData.latitude);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('latitude', _locationData.latitude.toString());
    prefs.setString('longitude', _locationData.longitude.toString());

    return;
  }

  Future<http.Response> _postRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("\n\nMy contribution is:" + prefs.getString('contribution'));
    Map data = {
      'name': prefs.getString('name'),
      'mobile': prefs.getString('mobno'),
      'address': prefs.getString('address'),
      'state': prefs.getString('state'),
      'district': prefs.getString('district'),
      'professional': prefs.getString('professional'),
      'device_latitude': prefs.getString('latitude'),
      'device_longitude': prefs.getString('longitude'),
      'email': prefs.getString('email'),
      'profileUrl': prefs.getString('url'),
      'deviceType': 'mobile',
      'firebaseToken': firebaseToken,
      'contribution': prefs.getString('contribution'),
      'imei': prefs.getString('imei'),
    };
    //encode Map to JSON
    //String body = json.encode(data);
    var sendResponse = await http.post(
        'https://api.savemynation.com/api/partner/savepartner/registervolunteer',
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: data,
        encoding: Encoding.getByName("gzip"));
    print('result');
    sessionToken = json.decode(sendResponse.body)['deviceToken'];
    print(sessionToken);
    //toast(context,"Sessiontoken : $sessionToken");
    prefs.setString('stoken', sessionToken);

    print(firebaseToken);
    //toast(context,"Firebasetoen is :$firebaseToken");

    setState(() {
      print(sendResponse.body);
    });
    return sendResponse;
  }

  firebaseCloudMessaging() async {
    String token = await _firebaseMessaging.getToken();

    firebaseToken = token;
  }

  Future<String> getSWData() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body)['state'];
    print(resBody);
    List<String> tags = resBody != null ? List.from(resBody) : null;
    setState(() {
      sdata = tags;
    });
    return "Sucess";
  }

  Future<http.Response> postDTRequest() async {
    Map data = {'state': state};
    print("ok");
    var response = await http.post(durl,
        headers: {'Content-Type': "application/x-www-form-urlencoded"},
        body: data,
        encoding: Encoding.getByName("gzip"));
    var reBody = json.decode(response.body)['district'];
    print(reBody);
    List<String> dtags = reBody != null ? List.from(reBody) : null;
    setState(() {
      disdata = dtags;
    });
    return response;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });

    initPlatformState();
    checkingnet(context);
    if (checknet == 'connected') {
      this.getSWData();
    } else {
      shownet(context);
    }
    addfocus = FocusNode();
    disfocus = FocusNode();
    statefocus = FocusNode();

    namefocusnode = FocusNode();
    mobilefocusnode = FocusNode();
    firebaseCloudMessaging();

    focusprof = FocusNode();
    contrifocus = FocusNode();

    setState(() {
      if (name == null) {
        toast(context, "Sorry!You are not signin properly! try again!");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    });
  }

  Future<void> initPlatformState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String platformImei = 'unknown';
    String saveimei = 'unknown';

    String idunique = 'unknown';
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformImei =
          await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
      idunique = await ImeiPlugin.getId();
    } on PlatformException {
      platformImei = "Failed to get platform version";
      toast(context,
          "This App requires phone/call management!!\nKindly allow it");
      initPlatformState();
    }

    if (!mounted) return;

    setState(() {
      print(idunique);
      _platformImei = platformImei;
      uniqueId = idunique;
      saveimei = uniqueId;
      prefs.setString('imei', saveimei);
      print(_platformImei);
    });
  }

  @override
  void dispose() {
    namefocusnode.dispose();
    mobilefocusnode.dispose();
    super.dispose();
  }

  double wt, ht;
  @override
  Widget build(BuildContext context) {
    if (name == null) {
      toast(context, "Sorry!You are not signin properly! try again!");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
    MediaQueryData queryData = MediaQuery.of(context);
    wt = queryData.size.width;
    ht = queryData.size.height;
    if (_page == 3) {
      if (checknet == 'connected') {
        getLocation();
      }
    }
    return MaterialApp(
        title: "Save My Nation Partner",
        debugShowCheckedModeBanner: false,
        color: color,
        home: Scaffold(
            body: Material(
                child: Background(
          child: Container(
            height: ht,
            width: wt,
            padding: EdgeInsets.only(bottom: 5),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(height: ht / 13),
                  DelayedAnimation(
                    child: Container(
                        padding: EdgeInsets.all(3.0),
                        height: ht / 3,
                        width: queryData.size.width,
                        child: SvgPicture.asset(
                          "assets/icons/login.svg",
                          height: ht / 3,
                        )),
                    delay: delayedAmount + 1000,
                  ),
                  DelayedAnimation(
                      child: welcomeTextRow(wt, ht),
                      delay: delayedAmount + 2000),
                  DelayedAnimation(
                      child: signInTextRow(wt), delay: delayedAmount + 3000),
                  SizedBox(
                    height: ht / 10,
                  ),
                  _selectForm(_page),
                  /* _page == 1
                      ? DelayedAnimation(
                          child: form(), delay: delayedAmount + 4000)
                      : form1(),
                  SizedBox(height: ht / 12),
                  // DelayedAnimation(child: button(), delay: delayedAmount + 5000),*/
                ],
              ),
            ),
          ),
        ))));
  }

  Widget _selectForm(int _page) {
    if (_page == 1)
      return DelayedAnimation(
        child: form(),
        delay: delayedAmount + 4000,
      );
    else if (_page == 2)
      return form1();
    else if (_page == 3) return form2();
  }

  Widget welcomeTextRow(double wt, double ht) {
    return Container(
      margin: EdgeInsets.only(left: wt / 20, top: ht / 100),
      child: Row(
        children: <Widget>[
          Text(
            "Hello!" + "\t" + name,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF6F35A5),
                fontSize: wt / 18 //_large? 60 : (_medium? 50 : 40),
                ),
          ),
        ],
      ),
    );
  }

  Widget signInTextRow(double wt) {
    return Center(
        child: Container(
      margin: EdgeInsets.only(left: wt / 15.0),
      child: Row(
        children: <Widget>[
          Text(
            "Personal Details",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color(0xFF6F35A5),
                fontWeight: FontWeight.w600,
                fontSize: wt / 25 // _large? 20 : (_medium? 17.5 : 15),
                ),
          ),
        ],
      ),
    ));
  }

  Widget form() {
    return Container(
        padding: EdgeInsets.all(25.0),
        //  margin: EdgeInsets.all(1.0),
        child: Card(
          key: _key,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          elevation: 10,
          shadowColor: Color(0xFF6F35A5),
          child: Container(
            padding: EdgeInsets.all(7.0),
            child: Column(
              children: <Widget>[
                //name
                nameTextFormField(),
                //mobile
                mobnoTextFormField(),
                Padding(
                  padding: EdgeInsets.all(6.0),
                  child: button(),
                )
              ],
            ),
          ),
        ));
  }

  Widget nameTextFormField() {
    return TextFormField(
      onChanged: (value) {
        sname = value;
      },
      focusNode: namefocusnode,
      onFieldSubmitted: (String value) {
        //   namefocusnode.unfocus();
        mobilefocusnode.requestFocus();
      },
      style: TextStyle(
          fontSize: wt / 30,
          color: Colors.black,
          letterSpacing: 1,
          fontWeight: FontWeight.w600),
      controller: nameController,
      keyboardType: TextInputType.text,
      cursorColor: Color(0xFF6F35A5),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person, color: Color(0xFF6F35A5), size: 25),
        hintText: "Name",
        hintStyle: TextStyle(fontSize: wt / 30),
        errorText:
            _validaten ? 'Name must contains atleast 4 characters' : null,
        errorStyle: TextStyle(
          fontSize: wt / 33,
          color: Colors.black45,
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none),
      ),
    );
  }

  Widget mobnoTextFormField() {
    return TextFormField(
      onChanged: (value) {
        mobno = value;
      },
      focusNode: mobilefocusnode,
      onFieldSubmitted: (String value) {
        mobilefocusnode.unfocus();
        //  mobilefocusnode.requestFocus();
      },
      style: TextStyle(
          fontSize: wt / 30,
          color: Colors.black,
          letterSpacing: 1,
          fontWeight: FontWeight.w600),
      controller: mobnoController,
      keyboardType: TextInputType.number,
      cursorColor: Color(0xFF6F35A5),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.call, color: Color(0xFF6F35A5), size: 25),
        hintText: "Mobile No",
        hintStyle: TextStyle(fontSize: wt / 30),
        errorText: _validatem ? 'Invalid Mobile Number' : null,
        errorStyle: TextStyle(
          fontSize: wt / 33,
          color: Colors.black45,
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none),
      ),
    );
  }

  Widget form1() {
    return Container(
        padding: EdgeInsets.all(25.0),
        //  margin: EdgeInsets.all(1.0),
        child: Card(
          key: _key,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          elevation: 10,
          shadowColor: Color(0xFF6F35A5),
          child: Container(
            padding: EdgeInsets.all(7.0),
            child: Column(
              children: <Widget>[
                //address
                addressTextFormField(),
                //state
                statedropdownbox(),
                //district
                districtdropdownbox(),
                Padding(
                  padding: EdgeInsets.all(6.0),
                  child: button(),
                )
              ],
            ),
          ),
        ));
  }

  Widget addressTextFormField() {
    return TextFormField(
      onChanged: (value) {
        address = value;
      },
      focusNode: addfocus,
      onFieldSubmitted: (String value) {
        addfocus.unfocus();
        statefocus.requestFocus();
      },
      style: TextStyle(
          fontSize: wt / 30,
          color: Colors.black,
          letterSpacing: 1,
          fontWeight: FontWeight.w600),
      controller: addController,
      keyboardType: TextInputType.text,
      cursorColor: Color(0xFF6F35A5),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.home, color: Color(0xFF6F35A5), size: 25),
        hintText: "Address",
        hintStyle: TextStyle(fontSize: wt / 30),
        errorText: _validateA ? 'Address must contains 6 more letters' : null,
        errorStyle: TextStyle(
          fontSize: wt / 33,
          color: Colors.black45,
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none),
      ),
    );
  }

  Widget districtdropdownbox() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: DropdownButton(
              underline: SizedBox(height: 0.5),
              focusNode: disfocus,
              hint: _dropDownDistrictValue == null
                  ? Row(children: <Widget>[
                      Padding(
                          padding: new EdgeInsets.all(3.0),
                          child: Icon(Icons.location_on,
                              color: Color(0xFF6F35A5), size: 25)),
                      SizedBox(width: 4.0),
                      Text('District',
                          style: TextStyle(
                            fontSize: wt / 30,
                            color: Colors.grey[600],
                            letterSpacing: 1,
                          ))
                    ])
                  : Row(children: <Widget>[
                      Padding(
                          padding: new EdgeInsets.all(1.0),
                          child: Icon(Icons.location_on,
                              color: Color(0xFF6F35A5), size: 25)),
                      SizedBox(width: 4.0),
                      Text(_dropDownDistrictValue,
                          style: TextStyle(
                            fontSize: wt / 30,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ))
                    ]),
              isExpanded: true,
              iconSize: 25.0,
              style: TextStyle(
                  fontSize: wt / 30,
                  color: Colors.black,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600),
              isDense: false,
              items: disdata.map(
                (val) {
                  return DropdownMenuItem<String>(
                    value: val,
                    child: Text(
                      val,
                      style: TextStyle(
                          fontSize: wt / 30,
                          color: Colors.black,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600),
                    ),
                  );
                },
              ).toList(),
              onChanged: (val) {
                setState(
                  () {
                    _dropDownDistrictValue = val;
                    district = val;
                    disfocus.unfocus();
                    // districtfocusnode.requestFocus();
                    //  this.postDTRequest();
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 9.0),
            child: Text(errD,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: wt / 33, color: Colors.black45)),
          ),
        ]);
  }

  Widget statedropdownbox() {
    return Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: DropdownButton(
              underline: SizedBox(height: 0.5),
              focusNode: statefocus,
              hint: _dropDownStateValue == null
                  ? Row(children: <Widget>[
                      Padding(
                          padding: new EdgeInsets.all(3.0),
                          child: Icon(Icons.book,
                              color: Color(0xFF6F35A5), size: 25)),
                      SizedBox(width: 4.0),
                      Text('State',
                          style: TextStyle(
                            fontSize: wt / 30,
                            color: Colors.grey[600],
                            letterSpacing: 1,
                          ))
                    ])
                  : Row(children: <Widget>[
                      Padding(
                          padding: new EdgeInsets.all(3.0),
                          child: Icon(Icons.book,
                              color: Color(0xFF6F35A5), size: 25)),
                      SizedBox(width: 4.0),
                      Text(_dropDownStateValue,
                          style: TextStyle(
                            fontSize: wt / 30,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ))
                    ]),
              isExpanded: true,
              iconSize: 24.0,
              style: TextStyle(
                  fontSize: wt / 30,
                  color: Colors.black,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600),
              isDense: false,
              items: sdata.map(
                (val) {
                  return DropdownMenuItem<String>(
                    value: val,
                    child: Text(
                      val,
                      style: TextStyle(
                          fontSize: wt / 30,
                          color: Colors.black,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600),
                    ),
                  );
                },
              ).toList(),
              onChanged: (val) {
                setState(
                  () {
                    _dropDownStateValue = val;
                    state = val;
                    statefocus.unfocus();
                    disfocus.requestFocus();
                    this.postDTRequest();
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 9.0),
            child: Text(errS,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: wt / 33, color: Colors.black45)),
          ),
        ]));
  }

  Widget form2() {
    return Container(
        padding: EdgeInsets.all(25.0),
        //  margin: EdgeInsets.all(1.0),
        child: Card(
          key: _key,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          elevation: 10,
          shadowColor: Color(0xFF6F35A5),
          child: Container(
            padding: EdgeInsets.all(7.0),
            child: Column(
              children: <Widget>[
                //profession
                professionBox(),

                //contribution
                contributionBox(),
                Padding(
                  padding: EdgeInsets.all(6.0),
                  child: button(),
                )
              ],
            ),
          ),
        ));
  }

  Widget contributionBox() {
    return Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: DropdownButton(
              underline: SizedBox(height: 0.5),
              focusNode: contrifocus,
              hint: _dropDownValueC == null
                  ? Row(children: <Widget>[
                      Padding(
                          padding: new EdgeInsets.all(3.0),
                          child: Icon(Icons.live_help,
                              color: Color(0xFF6F35A5), size: 25)),
                      SizedBox(width: 4.0),
                      Text('Contribution',
                          style: TextStyle(
                            fontSize: wt / 30,
                            color: Colors.grey[600],
                            letterSpacing: 1,
                          ))
                    ])
                  : Row(children: <Widget>[
                      Padding(
                          padding: new EdgeInsets.all(3.0),
                          child: Icon(Icons.live_help,
                              color: Color(0xFF6F35A5), size: 25)),
                      SizedBox(width: 4.0),
                      Text(_dropDownValueC,
                          style: TextStyle(
                            fontSize: wt / 30,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ))
                    ]),
              isExpanded: true,
              iconSize: 24.0,
              style: TextStyle(
                  fontSize: wt / 30,
                  color: Colors.black,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600),
              isDense: false,
              items: [
                'Call Center',
                'Contact Tracking',
                'Sanitation and Disinfection',
                'Transportation',
                'Web/Mobile App Development',
                'Other'
              ].map(
                (val) {
                  return DropdownMenuItem<String>(
                    value: val,
                    child: Text(
                      val,
                      style: TextStyle(
                          fontSize: wt / 30,
                          color: Colors.black,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600),
                    ),
                  );
                },
              ).toList(),
              onChanged: (val) {
                setState(
                  () {
                    _dropDownValueC = val;
                    contribution = val;

                    contrifocus.unfocus();
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(errC,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: wt / 33, color: Colors.black45)),
          ),
        ]));
  }

  Widget professionBox() {
    return Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: DropdownButton(
              underline: SizedBox(height: 0.5),
              focusNode: focusprof,
              hint: _dropDownValue == null
                  ? Row(children: <Widget>[
                      Padding(
                          padding: new EdgeInsets.all(3.0),
                          child: Icon(Icons.school,
                              color: Color(0xFF6F35A5), size: 25)),
                      SizedBox(width: 4.0),
                      Text('Profession',
                          style: TextStyle(
                            fontSize: wt / 30,
                            color: Colors.grey[600],
                            letterSpacing: 1,
                          ))
                    ])
                  : Row(children: <Widget>[
                      Padding(
                          padding: new EdgeInsets.all(3.0),
                          child: Icon(Icons.school,
                              color: Color(0xFF6F35A5), size: 25)),
                      SizedBox(width: 4.0),
                      Text(_dropDownValue,
                          style: TextStyle(
                            fontSize: wt / 30,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ))
                    ]),
              isExpanded: true,
              iconSize: 24.0,
              style: TextStyle(
                  fontSize: wt / 30,
                  color: Colors.black,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600),
              isDense: false,
              items: [
                'Medical Professional',
                'Working Professional',
                'Business Professional',
                'Student',
                'other'
              ].map(
                (val) {
                  return DropdownMenuItem<String>(
                    value: val,
                    child: Text(
                      val,
                      style: TextStyle(
                          fontSize: wt / 30,
                          color: Colors.black,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600),
                    ),
                  );
                },
              ).toList(),
              onChanged: (val) {
                setState(
                  () {
                    _dropDownValue = val;
                    professional = val;
                    focusprof.unfocus();
                    contrifocus.requestFocus();
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(errP,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: wt / 33, color: Colors.black45)),
          ),
        ]));
  }

  /*MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Save My Nation Partner",
      color: color,
      home:Scaffold(
            body :SingleChildScrollView(
              child:Container(
                height: queryData.size.height,
                color:color,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(height: wt/20),
                      Container(
                        child:SafeArea(child:Image(
                          image: AssetImage(
                            'assets/v6.png',
                          ),
                          height: queryData.size.height/4,
                          width: wt,
                        ),
                      ),),
                      SizedBox(height: wt/5),
                      Container(
                        child:Column(
                          children:<Widget>[
                      Text(
                        'Hello $name !',
                        style: TextStyle(
                            fontSize: wt / 12,
                            fontFamily: "Poppins",
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),

                      SizedBox(height:5),


                     
                     
                       
                      ]),),
                       Container(
                         child:Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children:<Widget>[
                       Padding(
                padding: const EdgeInsets.symmetric(horizontal:20.0),
                child: TextFormField(
                  
                  cursorColor: Colors.white,
                  focusNode: namefocusnode,
                onFieldSubmitted: (String value){
                  namefocusnode.unfocus();
                  mobilefocusnode.requestFocus();
                },
                onChanged: (value){
                  sname = value;
                },
                style: fieldstyle,
                decoration: id.copyWith(labelText: 'Name',labelStyle: labelstyle,errorText: _validaten ? 'Name must contains atleast 4 characters' : null,errorStyle: errorstyle,
                 ),
              ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:20.0),
                child: TextFormField(  
                  focusNode: mobilefocusnode,           
                    cursorColor: Colors.white,     
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  onFieldSubmitted: (String val){
                    mobilefocusnode.unfocus();
                  },
                onChanged: (value){
                  mobno = value;
                  
                },
                style: fieldstyle,
                decoration: id.copyWith(labelText: 'Mobile Number',labelStyle: labelstyle,errorText: _validatem ==true ? 'Invalid Mobile Number' : null,errorStyle: errorstyle),
              ),
              ),])),

                  Padding(
                    padding:EdgeInsets.all(8.0),

               child: RaisedButton(
                  
                        onPressed: () async {
                          
                 
                       
                          setState(() {
                           
                          var f= 0;
                         _validaten =false;
                         _validatem=false;

                                                
                   if(sname==null || sname.length<4){
                     
                      _validaten = true;
                    
                      f = 1;
                      
                    }
                   if(mobno==null || (mobno.length<10)) {
                      _validatem = true;
                     
                    
                      f =1;
                    }
                    if(f==0)
                    {
                      toast(context,"Your $name and Mobile $mobno saved!");
                     storeData();          
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>RegistrationForm1()
                    ),
                  );
                 
                  
                          }  });
                          
                        },

                        color: kPrimaryColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 30),
                          child: Text(
                            'Next',
                            style:btnstyle
                          ),
                        ),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),

                        ),
                      )
                   ) ],
                  ),
                ),
              ),
            
     ) ));*/
  Widget button() {
    return RaisedButton(
        onPressed: () async {
          if (_page == 3) {
            errP = '';
            errC = '';

            _locationData = await location.getLocation();
            print(_locationData.latitude);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('latitude', _locationData.latitude.toString());
            prefs.setString('longitude', _locationData.longitude.toString());
          }
          setState(() {
            if (_page == 1) {
              var f = 0;
              _validaten = false;
              _validatem = false;

              if (sname == null || sname.length < 4) {
                _validaten = true;

                f = 1;
              }
              if (mobno == null || (mobno.length < 10)) {
                _validatem = true;

                f = 1;
              }
              if (f == 0) {
                // toast(context, "Your $name and Mobile $mobno saved!");
                storeData();
                _page = 2;
                /*   Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegistrationForm1()),
              );*/
              }
            } else if (_page == 2) {
              var f1 = 0;
              errS = '';
              errD = '';
              _validateA = false;

              if (address == null || address.length < 6) {
                _validateA = true;

                f1 = 1;
              }
              if (_dropDownStateValue == null) {
                errS = 'Please Enter your State.';

                f1 = 1;
              }
              if (_dropDownDistrictValue == null) {
                errD = 'Please Enter your district.';

                f1 = 1;
              }

              if (f1 == 0) {
                storeData1();
                _page = 3;
              }
            } else if (_page == 3) {
              var f2 = 0;
              validateP = false;
              validateC = false;

              if (_dropDownValue == null) {
                errP = "Please Select Your Professional";

                f2 = 1;
              }
              if (_dropDownValueC == null) {
                setState(() {
                  f2 = 1;

                  errC = "Please Select your contribution";
                });
              }
              if (f2 == 0) {
                checkingnet(context);
                if (checknet == 'connected') {
                  if (_permissionGranted == PermissionStatus.granted) {
                    storeData2();
                    _postRequest().whenComplete(() async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool('first_time', false);
                      print('bool value changed');
                      //  toast(context, "Successfully registered!!!");
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    });
                  } else {
                    getLocation();
                  }
                }
                if (checknet == 'notconnected') {
                  shownet(context);
                }
              }
            }
          });
        },
        color: kPrimaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
          child: _page <= 2
              ? Text('Next', style: btnstyle)
              : Text('Submit', style: btnstyle),
        ),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(40.0)),
        ));
  }

  storeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('sname', name);
      prefs.setString('email', email);
      prefs.setString('url', imageUrl);
      prefs.setString('name', sname);
      prefs.setString('mobno', mobno);
    });
  }

  storeData1() async {
    print(district + state + address);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('address', address);
      prefs.setString('state', state);
      prefs.setString('district', district);
    });
  }

  storeData2() async {
    print("My professional:" + professional);
    print("My contribution:" + contribution);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('professional', professional);
      prefs.setString('contribution', contribution);
    });
  }
}

String checkname(String name) {
  if (name.length > 4 && name != null && name != '') return name;
}

String checkmob(String mob) {
  if (mob.length == 10 && mob != null) return mob;
}

String checkadd(String add) {
  if (add.length > 6 && add != null && add != '') return add;
}
String checkstate(String state) {
  if (state !='') return state;
}
String checkdistrict(String dis) {
  if (dis!='') return dis;
}


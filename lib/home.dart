import 'dart:async';
import 'dart:convert';

import 'package:background_location/background_location.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:savemynationpartner/checknetconnectivity.dart';
import 'package:savemynationpartner/condata.dart';
import 'package:savemynationpartner/dashboardpage.dart';
import 'package:savemynationpartner/fluttertoastmsg.dart';
import 'package:savemynationpartner/food.dart';
import 'package:savemynationpartner/globals.dart';
import 'package:savemynationpartner/grocery.dart';
import 'package:savemynationpartner/medicine.dart';
import 'package:savemynationpartner/profile.dart';
import 'package:savemynationpartner/shared.dart';
import 'package:savemynationpartner/showLocationdialogue.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double height, width;
  bool _isselected = false;
  static String url,
      name,
      email,
      professional,
      state,
      address,
      district,
      mobnum;
  String fetchlatitude = '';
  String fetchlongitude = '';
  String alatitude = '';
  String alongitude = '';
  String time = '';
  Timer timer;
  int i = 0;
  int _selectedIndex = 0;
  Future<List> a;
  List lis = [];
  List glis = [];
  List mlis = [];
  List flis = [];
  final controller = ScrollController();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  Future<List<ConData>> fun() async {
    // getLocation();
    lis.clear();
    glis.clear();
    flis.clear();
    mlis.clear();
    print("Fun function result\n");

    setState(() {
      loading = true;
    });

    a = fetchData();
    await a.then((value) {
      for (int i = 0; i < value.length; i++) {
        ConData s = new ConData(
          name: value[i]['name'],
          mobile: value[i]['mobile'],
          address: value[i]['address'],
          district: value[i]['district'],
          state: value[i]['state'],
          type: value[i]['type'],
          comments: value[i]['comments'],
          devicelatitude: value[i]['device_latitude'],
          devicelongitude: value[i]['device_longitude'],
        );
        lis.add(s);

        print(s.type);
        print(lis.length);

        if (s.type == 'Food') {
          flis.add(s);
        } else if (s.type == 'Grocery') {
          glis.add(s);
        } else if (s.type == 'Medicine') {
          mlis.add(s);
        }
      }
      print(lis.length);
      print(flis);
      print(mlis);
      print(glis);
      setState(() {
        loading = false;
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _isselected = true;
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    i = 2;
    checkingnet(context);

    getLocation();
    fun();
    getData();

    BackgroundLocation.startLocationService();
    /* BackgroundLocation().getCurrentLocation().then((location) {
      fetchlatitude = location.latitude.toString();
      fetchlongitude = location.longitude.toString();
      print("This is current Location" + location.longitude.toString());
     // findkm();
      
    });*/

    BackgroundLocation.getLocationUpdates((location) {
      print("Geofence Trigger in every 1 min");
      setState(() {
        this.fetchlatitude = location.latitude.toString();
        this.fetchlongitude = location.longitude.toString();

        time = DateTime.fromMillisecondsSinceEpoch(location.time.toInt())
            .toString();
      });
      print("After 500ms to get Location :");

      getCurrentLocation();

      print("""\n
      Latitude:  $fetchlatitude
      Longitude: $fetchlongitude
    
      Time: $time
      """);
    });
  }

  void getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
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
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
      if (_permissionGranted == PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    print(_locationData.latitude);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('latitude', _locationData.latitude.toString());
    prefs.setString('longitude', _locationData.longitude.toString());
  }

  getCurrentLocation() async {
    BackgroundLocation().getCurrentLocation().then((location) {
      fetchlatitude = location.latitude.toString();
      fetchlongitude = location.longitude.toString();
      print("This is current Location" + location.longitude.toString());
    });
    timer = Timer.periodic(Duration(seconds: 2000000), (Timer t) {
      findkm();
    });
  }

  findkm() async {
    final Distance distance = new Distance();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    alatitude = prefs.getString('latitude');
    alongitude = prefs.getString('longitude');

    print("my altitude: " + alatitude);
    print("my alongitude :" + alongitude);
    print("my fetchlatitude:" + fetchlatitude);
    print("my fetchlongitude :" + fetchlongitude);
    final double m = distance.as(
        LengthUnit.Kilometer,
        new LatLng(double.parse(alatitude), double.parse(alongitude)),
        new LatLng(double.parse(fetchlatitude), double.parse(fetchlongitude)));

    print("Meter value:" + m.toString());
    toast(context,
        "Your Meter value :$m\nHomeLatitude : $alatitude\nHomeLongitude:$alongitude\n\nBackgroundLatitude:$fetchlatitude\nBackgroundlongitude:$fetchlongitude");
    if (m < 1) {
      toast(context, "You are in inside of Home\n");
      callGeofenceApi();
    } else {
      toast(context, "you are in outside of Home\n");
      callGeofenceApi();
    }
  }

  void callGeofenceApi() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("details\n\n");
      print(fetchlatitude);
      print(fetchlongitude);
      print(prefs.getString('mobno'));
      print(prefs.getString('stoken'));

      String listurl =
          'https://api.savemynation.com/api/partner/savepartner/geolocation';
      Map data = {
        'mobile': prefs.getString('mobno'),
        'device_latitude': fetchlatitude,
        'device_longitude': fetchlongitude,
        'sessionToken': prefs.getString('stoken'),
      };
      print("call of Geofence API");
      var response = await http.post(listurl,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: data,
          encoding: Encoding.getByName("gzip"));
      i = 0;
      print(response.body);
      toast(context, response.body);
    } catch (e) {
      print("Exception arais in geofence api call" + e);
    }
  }

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name');
    mobnum = prefs.getString('mobno');
    address = prefs.getString('address');
    state = prefs.getString('state');
    district = prefs.getString('district');
    professional = prefs.getString('professional');
    email = prefs.getString('email');
    url = prefs.getString('url');
    print(url);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    if (checknet == 'connected') {
      BackgroundLocation.getLocationUpdates((location) {
        print("Geofence Trigger in every 1 min");
        setState(() {
          this.fetchlatitude = location.latitude.toString();
          this.fetchlongitude = location.longitude.toString();

          time = DateTime.fromMillisecondsSinceEpoch(location.time.toInt())
              .toString();
        });
        print("After 500ms to get Location :");

        print("""\n
      Latitude:  $fetchlatitude
      Longitude: $fetchlongitude
    
      Time: $time
      """);
        //findkm();
        // getCurrentLocation();
      });

      /* BackgroundLocation.getLocationUpdates((location) {
      setState(() {
      fetchlatitude = location.latitude.toString();
        fetchlongitude = location.longitude.toString();
       
        time = DateTime.fromMillisecondsSinceEpoch(location.time.toInt())
            .toString();
      });
      
 getCurrentLocation();
      print("""\n
      Latitude:  $fetchlatitude
      Longitude: $fetchlongitude
    
      Time: $time
      """);
  


   });}*/

      // getLocation();

      //print("Geofence Trigger in every 1 min");
      // findkm();
      //});
      // getCurrentLocation();
    }

    final List<Widget> _widgetOptions = <Widget>[
      DashBoardPage(
          grocery: glis.length, food: flis.length, medicine: mlis.length),
      Grocery(
        grocery: glis,
      ),
      Medicine(medicine: mlis),
      Food(food: flis),
      UserProfilePage(
          url, name, email, professional, state, address, district, mobnum)
    ];

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: MaterialApp(
          title: 'Save My Nation Partner',
          color: color,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Poppins'),
          home: Scaffold(
            bottomNavigationBar: CurvedNavigationBar(
              height: 50,
              // showSelectedLabels: true,

              backgroundColor: Colors.white, // Color.fromRGBO(0, 74, 173, 1),
              color: color,
              buttonBackgroundColor: Colors.white,

              items: <Widget>[
                Icon(Icons.home, color: Colors.black, size: 25),

                //Icon(Icons.local_activity),
                Icon(Icons.local_grocery_store),
                Icon(Icons.local_hospital),
                Icon(Icons.fastfood),
                Icon(Icons.person)
                /*  BottomNavigationBarItem(
               backgroundColor: Color.fromRGBO(0, 74, 173, 1),
              icon: Icon(Icons.local_grocery_store),
              title: Text('Grocery'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_hospital),
              backgroundColor: Color.fromRGBO(0, 74, 173, 1),
              title: Text('Medicine'),
            ),
             BottomNavigationBarItem(
              icon: Icon(Icons.fastfood),
             backgroundColor: Color.fromRGBO(0, 74, 173, 1),
              title: Text('Food'),
            ),*/
              ],

              onTap: _onItemTapped,
            ),
            /* bottomNavigationBar: FancyBottomBar(
                items: [
                  FancyItem(
                    textColor: color,
                    title: 'Home',
                    icon: Icon(Icons.home),
                  ),
                  FancyItem(
                    textColor: color,
                    title: 'Grocery',
                    icon: Icon(Icons.local_grocery_store),
                  ),
                  FancyItem(
                    textColor: color,
                    title: 'Food',
                    icon: Icon(Icons.fastfood),
                  ),
                  FancyItem(
                    textColor: color,
                    title: 'Medicine',
                    icon: Icon(Icons.local_hospital),
                  ),
                ],
                onItemSelected: (index) {
                  print(index);
                },
                type: FancyType.FancyV2,
              ),*/
            backgroundColor: Colors.white,
            body: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            /*  body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      height: height / 1.75,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: -40,
                            height: height / 1.75,
                            width: width,
                            child: FadeAnimation(
                                1,
                                Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/background.png'),
                                          fit: BoxFit.fill)),
                                )),
                          ),
                          Positioned(
                            height: height / 1.75,
                            width: width + 20,
                            child: FadeAnimation(
                                1.3,
                                Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/background-2.png'),
                                          fit: BoxFit.fill)),
                                )),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FadeAnimation(
                              1.5,
                              Text(
                                "DashBoard",
                                style: TextStyle(
                                    color: Color.fromRGBO(49, 39, 79, 1),
                                    fontWeight: FontWeight.w900,
                                    fontSize: width / 20),
                              )),
                          FadeAnimation(
                              1.7,
                              SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(children: <Widget>[
                                    _cardConcern('Grocery'),
                                    _cardConcern('Food'),
                                    _cardConcern('Medicine'),
                                  ])))
                        ],
                      ),
                    )
                  ],
                ),*/
          ),
        ));
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            elevation: 5,
            contentPadding: EdgeInsets.all(20),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () =>
                    SystemNavigator.pop(), //Navigator.of(context).pop(true),
                child: Text("YES"),
              ),
              SizedBox(width: 16),
            ],
          ),
        ) ??
        false;
  }

  Future<List> fetchData() async {
    try {
      // var time1 = DateTime.now().millisecondsSinceEpoch;
      // var time;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("details\n\n");
      print(prefs.getString('longitude'));
      print(prefs.getString('latitude'));
      print(prefs.getString('mobno'));
      print(prefs.getString('stoken'));

      String listurl =
          'https://api.savemynation.com/api/partner/savepartner/getlistofneeds';
      Map data = {
        'mobile': prefs.getString('mobno'),
        'homeLatitude': prefs.getString('latitude'),
        'homeLongitude': prefs.getString('longitude'),
        'deviceToken': prefs.getString('stoken'),
      };
      print("before url");
      var response = await http.post(listurl,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: data,
          encoding: Encoding.getByName("gzip"));
      print("before url1");
      print(response.body);

      var reBody = json.decode(response.body)['messages'];

      return reBody;
    } catch (e) {
      print("Exception");
      setState(() {
        loading = false;
      });

      throw Exception('Failed to Load..');
    }
  }
}

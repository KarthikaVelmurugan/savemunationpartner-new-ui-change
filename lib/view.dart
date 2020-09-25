import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';

import 'package:savemynationpartner/shared.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewPage extends StatefulWidget {
  final name,
      mobnum,
      address,
      district,
      state,
      type,
      comments,
      latitude11,
      longitude11;
  ViewPage(this.name, this.mobnum, this.address, this.district, this.state,
      this.type, this.comments, this.latitude11, this.longitude11);

  @override
  _ViewPageState createState() => _ViewPageState(name, mobnum, address,
      district, state, type, comments, latitude11, longitude11);
}

bool _detailsview = false;

class _ViewPageState extends State<ViewPage> {
  final name,
      mobnum,
      address,
      district,
      state,
      type,
      comments,
      latitude11,
      longitude11;
  _ViewPageState(this.name, this.mobnum, this.address, this.district,
      this.state, this.type, this.comments, this.latitude11, this.longitude11);
  double ht, wt;
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    ht = queryData.size.height;
    wt = queryData.size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Save My Nation Partner",
      color: color,
      home: Scaffold(
          /*  bottomNavigationBar: BottomAppBar(
         color:Color.fromRGBO(0, 74, 173, 1) ,
            child: IconButton(icon: Icon(Icons.arrow_drop_up,size: 40,color:Colors.white70,),
            onPressed: (){
                setState(() {
                  _detailsview = !_detailsview;
                  
                });
            },
      )),  */
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(40.0), // here the desired height
            child: AppBar(
              backgroundColor: color,
              title: Text('Location', style: TextStyle(fontSize: wt / 30)),
              elevation: 15,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              automaticallyImplyLeading: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, size: 20, color: Colors.white),
                onPressed: () => Navigator.pop(context, false),
              ),
            ),
          ),
          body: Column(children: <Widget>[
            Container(
              height: ht / 1.65,
              child:
                  MapView(double.parse(latitude11), double.parse(longitude11)),
            ),

            // _detailsview == false ? Container():

            // Positioned(
            // top:ht/3,

            //  child:
            Expanded(
              child: Container(
                height: ht - ht / 1.5,
                padding: EdgeInsets.all(wt / 20),
                width: queryData.size.width,
                child: DetailsView(
                    ht,
                    queryData.size.width,
                    district,
                    mobnum,
                    name,
                    state,
                    address,
                    type,
                    comments,
                    double.parse(latitude11),
                    double.parse(longitude11)),
              ),
            )
          ])),
    );
  }
}

class MapView extends StatefulWidget {
  final latitude1, longitude1;
  MapView(this.latitude1, this.longitude1);
  @override
  _MapViewState createState() => _MapViewState(latitude1, longitude1);
}

class _MapViewState extends State<MapView> {
  final latitude1, longitude1;
  _MapViewState(this.latitude1, this.longitude1);
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};

//  BitmapDescriptor pinLocationIcon;

  @override
  void initState() {
    super.initState();

    /*   BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5), 'assets/icons/l.png')
        .then((onValue) {
      pinLocationIcon = onValue;
    });*/
  }

  @override
  Widget build(BuildContext context) {
    LatLng pinPosition = LatLng(latitude1, longitude1);
    final CameraPosition _kLake = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(latitude1, longitude1),
        tilt: 5,
        zoom: 16);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          MapsLauncher.launchCoordinates(latitude1, longitude1);
        },
        isExtended: true,
        backgroundColor: color,
        label: Text('start',
            style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        icon: Icon(Icons.directions_walk),
      ),
      body: GoogleMap(
        zoomGesturesEnabled: true,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        mapToolbarEnabled: false,
        compassEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: _kLake,
        markers: Set.from(_markers),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          setState(() {
            _markers.add(Marker(
              markerId: MarkerId('<MARKER_ID>'),
              position: pinPosition,
              //  icon: pinLocationIcon,
            ));
          });
        },
      ),
    );
  }
}

class DetailsView extends StatefulWidget {
  final ht,
      wt,
      district,
      mobno,
      name,
      state,
      address,
      type,
      comments,
      latitude12,
      longitude12;
  DetailsView(
      this.ht,
      this.wt,
      this.district,
      this.mobno,
      this.name,
      this.state,
      this.address,
      this.type,
      this.comments,
      this.latitude12,
      this.longitude12);
  @override
  _DetailsViewState createState() => _DetailsViewState(ht, wt, district, mobno,
      name, state, address, type, comments, latitude12, longitude12);
}

class _DetailsViewState extends State<DetailsView> {
  final ht,
      wt,
      district,
      mobno,
      name,
      state,
      address,
      type,
      comments,
      latitude12,
      longitude12;

  _DetailsViewState(
      this.ht,
      this.wt,
      this.district,
      this.mobno,
      this.name,
      this.state,
      this.address,
      this.type,
      this.comments,
      this.latitude12,
      this.longitude12);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                  Text(name,
                      style: TextStyle(
                          fontSize: wt / 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  SizedBox(height: 5),
                  Text(address + "," + district + "," + state + ".",
                      style: TextStyle(
                          fontSize: wt / 30,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey[600])),
                  SizedBox(height: 5),
                  Text(
                    mobno,
                    style: TextStyle(fontSize: wt / 30, color: Colors.black38),
                  ),
                  SizedBox(height: 5),
                  Text('"' + comments + '"',
                      style: TextStyle(
                          fontSize: wt / 30,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic)),
                  SizedBox(height: 6),
                  Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {
                              launch("tel://" + mobno);
                            },
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.call, color: Colors.black, size: 25),
                                Text(
                                  "Contact",
                                  style: TextStyle(
                                    fontSize: wt / 30,
                                    fontFamily: "Poppins",
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              Share.share(
                                  'https://www.google.com/maps/search/?api=1&query=$latitude12+$longitude12');
                            },
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.share,
                                    color: Colors.black, size: 25),
                                Text(
                                  "Share",
                                  style: TextStyle(
                                    fontSize: wt / 30,
                                    fontFamily: "Poppins",
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                ]))));
  }
}

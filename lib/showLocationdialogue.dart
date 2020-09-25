
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:savemynationpartner/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';



final Location location = Location();
bool _serviceEnabled;
PermissionStatus _permissionGranted;
LocationData _locationData;

 showLocation(BuildContext context){
   refresh =true;
return showDialog(
    context: context,
    builder: (context) => new AlertDialog(
      
      title: new Text('Make sure your Location connectivity?'),
      content: new Text('This app requires Location services.kindly enable your Location Services.'),
      actions: <Widget>[

        FlatButton(child:Text("Ok"),
        onPressed: (){ 
          
          AppSettings.openLocationSettings();
         
          Navigator.of(context).pop(false);
          
       
           
  } ),]));
 
  }
        
       /* new GestureDetector(
          onTap: () {
           
             Navigator.of(context).pop(false);},
          child: Padding(padding: EdgeInsets.all(3.0),
          child: Text("Ok",style:
          TextStyle(
                            fontSize: 22,
                            fontFamily: "Poppins",
                            color: Colors.black,
                            fontWeight: FontWeight.bold),),
        ),),
        SizedBox(height: 16),
       
      ],
    ),
  ) ??
      false;
}*/
 void getLocation() async{
   print(_permissionGranted);
_permissionGranted = await location.hasPermission();
if (_permissionGranted == PermissionStatus.denied) {
  _permissionGranted = await location.requestPermission();
  if (_permissionGranted != PermissionStatus.granted) {
   // showLocation(context);
    return;
  }
  if(_permissionGranted == PermissionStatus.granted) {
    
    return;
  }
}

_locationData = await location.getLocation();
print(_locationData.latitude);
SharedPreferences prefs = await SharedPreferences.getInstance();
prefs.setString('latitude', _locationData.latitude.toString());
prefs.setString('longitude', _locationData.longitude.toString());

 }
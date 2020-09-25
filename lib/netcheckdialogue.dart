
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:savemynationpartner/checknetconnectivity.dart';
import 'package:savemynationpartner/globals.dart';

 shownet(BuildContext context){
   refresh = true;
return showDialog(
    context: context,
    builder: (context) => new AlertDialog(
      
      title: new Text('Make sure your network connectivity?'),
      content: new Text('This app requires Internet services.kindly enable your mobiledata.\n\nOpen The application again!!'),
      actions: <Widget>[
        new 
        FlatButton(child:Text("Ok"),
        onPressed: (){ 
           SystemNavigator.pop();
         // AppSettings.openWIFISettings();

          
         
          
       
           
  } ),]
        
        
        
        
        
    ));
}
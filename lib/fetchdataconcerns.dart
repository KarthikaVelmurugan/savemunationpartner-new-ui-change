

import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ConcernsData{
  final String cname;
  final String cmobno;
  final String cstate;
  final String cdistrict;
  final String caddress;
  final String ctype;
  final String ccomments;
  final String cdevicelatitude;
  final String cdevicelongitude;

 
  ConcernsData({this.cname,this.cmobno,this.cstate,this.cdistrict,this.caddress,this.ctype,this.ccomments
  ,this.cdevicelatitude,this.cdevicelongitude});
  factory ConcernsData.fromJson(Map<String, dynamic> json){
    return ConcernsData(
      cname:json['name'],
      cmobno: json['mobno'],
      cstate: json['state'],
      cdistrict: json['district'],
      caddress: json['address'],
      ctype: json['type'],
      ccomments: json['comments'],
      cdevicelatitude: json['device_latitude'],
      cdevicelongitude: json['device_longitude']
    );
  }}

 Future<List> fetchData() async {
  
   
    SharedPreferences prefs = await SharedPreferences.getInstance();
  String listurl = 'https://api.savemynation.com/api/partner/savepartner/getlistofneeds';
Map data={
'mobile': prefs.getString('mobno'),
'homeLatitude':prefs.getString('latitude'),
'homeLongitude':prefs.getString('longitude'),
'deviceToken':prefs.getString('stoken'),
};
final response = await http.post(listurl,
  
  headers: {"Content-Type":"application/x-www-form-urlencoded"},
  body: data,
  encoding: Encoding.getByName("gzip"));
    print(response.body);
    print("Time");
     
    if(response.statusCode == 200){
       var reBody = json.decode(response.body)['messages'];
       
      return reBody;//jsonResponse.map((data) => new ConcernsData.fromJson(data)).toList();
    }
   
    else
    {
      print("Exception");
      throw Exception('Failed to Load..');
    }
   
   
  }
  
import 'package:flutter/material.dart';

int getColorHexFromStr(String colorStr) {
  colorStr = "FF" + colorStr;
  colorStr = colorStr.replaceAll("#", "");
  int val = 0;
  int len = colorStr.length;
  for (int i = 0; i < len; i++) {
    int hexDigit = colorStr.codeUnitAt(i);
    if (hexDigit >= 48 && hexDigit <= 57) {
      val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
    } else if (hexDigit >= 65 && hexDigit <= 70) {
      // A..F
      val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
    } else if (hexDigit >= 97 && hexDigit <= 102) {
      // a..f
      val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
    } else {
      throw new FormatException("An error occurred when converting a color");
    }
  }
  return val;
}

var color = Color(0xFF6F35A5);
var btnstyle = TextStyle(
  fontSize: 18,
  fontFamily: 'Poppins',
  fontWeight: FontWeight.bold,
  letterSpacing: 1,
  color: Colors.white,
);
var fieldstyle = TextStyle(
    fontSize: 18,
    fontFamily: "Poppins",
    color: Colors.white,
    letterSpacing: 1,
    fontWeight: FontWeight.w500);
var labelstyle = TextStyle(
    fontSize: 16,
    fontFamily: "Poppins",
    color: Colors.white70,
    letterSpacing: 1,
    fontWeight: FontWeight.w300);
var errorstyle = TextStyle(
  color: Colors.grey[400],
  fontSize: 13,
);
var dropstyle = TextStyle(
    fontSize: 16,
    fontFamily: "Poppins",
    color: Colors.black,
    fontWeight: FontWeight.w500);
var id = new InputDecoration(
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      borderSide: BorderSide(color: Colors.white70, width: 2)),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      borderSide: BorderSide(color: Colors.white70, width: 2)),
  errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      borderSide: BorderSide(color: Colors.white70, width: 1)),
  labelStyle: TextStyle(color: Colors.white70),
);

var bd1 = BoxDecoration(
    border: Border.all(color: Colors.white70),
    borderRadius: BorderRadius.circular(10));
var bd2 = BoxDecoration(
  border: Border.all(color: Colors.black),
  borderRadius: BorderRadius.circular(10),
  color: color,
);
var bd3 = BoxDecoration(
  border: Border.all(color: Colors.black, width: 1),
  borderRadius: BorderRadius.circular(10),
);

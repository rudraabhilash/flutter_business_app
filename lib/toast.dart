import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

void showToast({required String message}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.deepPurple, // Background color
    textColor: Colors.white, // Text color
    fontSize: 16.0, // Font size
    webBgColor:
        "linear-gradient(to right, #FF5733, #FFBD33)", // Web-specific gradient background
    webPosition: "bottom",
  );
}

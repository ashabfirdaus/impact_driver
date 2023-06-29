import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotificationBar {
  static void toastr(String string, String type) {
    var color = Colors.black;

    Fluttertoast.showToast(
        msg: string,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

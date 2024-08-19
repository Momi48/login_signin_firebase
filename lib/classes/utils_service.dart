import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UtilsService{

  void message(String message){
   Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor:Colors.red,
        textColor: Colors.white,
        fontSize: 20.0
    );
  }
}
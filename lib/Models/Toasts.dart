


import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:veera_education_flutter/Controllers/Colors.dart';

errorToast(text){

  return Fluttertoast.showToast(
      msg:text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: appColors.error,
      textColor: appColors.white,
      fontSize: 16.0,
  );
}
successToast(text){

  return Fluttertoast.showToast(
      msg:text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(0xff018717),
      textColor: appColors.white,
      fontSize: 16.0
  );
}
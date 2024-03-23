



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

toast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}



Widget regularText(String text, [Color? pickColor, TextAlign? align]) {
  return Text(
    text,
    textAlign: align,
    style: GoogleFonts.poppins(
      color: pickColor ?? Colors.black,
      fontSize: 16.sp,
    ),
  );
}
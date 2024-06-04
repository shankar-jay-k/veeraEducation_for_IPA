import 'package:flutter/material.dart';

class appColors {
  static const Color scaffold = Color(0xfff7f7f7);
  static const Color ashGrey = Color(0xffd9d9d9);
  static const Color scannerBg = Color(0xd0d9d9d9);
  static const Color lightGold = Color(0xffe5d1aa);
  static const Color Shadow_Clr = Color(0x70e2e1e1);
  static const Color Shadow_Clr2 = Color(0x70b3b2b2);
  static const Color error = Color.fromARGB(255, 255, 4, 4);
  static const Color success = Color.fromARGB(255, 30, 226, 27);
  static const Color white=Colors.white;
}
class screenUtils {
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}


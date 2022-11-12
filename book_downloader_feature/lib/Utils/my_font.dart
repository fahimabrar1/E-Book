import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class MyCustomFonts {
  static TextStyle getRubik(
      {double? fontSize, Color? fontColor, FontWeight? fontWeight}) {
    return GoogleFonts.rubik(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: fontColor,
    );
  }

  static TextStyle getDmSans(
      {double? fontSize, Color? fontColor, FontWeight? fontWeight}) {
    return GoogleFonts.dmSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: fontColor,
    );
  }
}

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextGlobal extends StatelessWidget {
  TextGlobal(
      {super.key,
      required this.message,
      this.textAlign,
      this.textOverflow,
      this.maxLines,
      this.selectionColor,
      this.fontSize,
      this.fontWeight,
      this.colorText,
      this.styleText,
      this.underline});
  String message;
  TextAlign? textAlign;
  TextOverflow? textOverflow;
  int? maxLines;
  Color? selectionColor;
  double? fontSize;
  FontWeight? fontWeight;
  Color? colorText;
  TextDecoration? underline;
  FontStyle? styleText;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      textAlign: textAlign ?? TextAlign.left,
      overflow: textOverflow ?? TextOverflow.clip,
      maxLines: maxLines ?? 100,
      style: GoogleFonts.quicksand(
          fontStyle: styleText ?? FontStyle.normal,
          fontSize: fontSize ?? 14.0,
          color: colorText,
          decoration: underline ?? TextDecoration.none,
          fontWeight: fontWeight ?? FontWeight.normal),
    );
  }
}

String capitalizeWords(String input) {
  if (input.contains('-')) {
    var words = input.split('-');
    var capitalizedWords =
        words.map((word) => word[0].toUpperCase() + word.substring(1));
    var result = capitalizedWords.join(' ');
    return result;
  } else {
    var words = input.split('_');
    var capitalizedWords =
        words.map((word) => word[0].toUpperCase() + word.substring(1));
    var result = capitalizedWords.join(' ');
    return result;
  }
}

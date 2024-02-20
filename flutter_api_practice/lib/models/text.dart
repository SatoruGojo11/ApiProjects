import 'package:flutter/material.dart';

Text text(
  txt, {
  Color? color,
  double? fontSize,
  FontWeight? fontWeight,
}) {
  return Text(
    txt,
    style: TextStyle(
      color: color ?? Colors.black,
      fontSize: fontSize ?? 15,
      fontWeight: fontWeight ?? FontWeight.normal,
    ),
  );
}

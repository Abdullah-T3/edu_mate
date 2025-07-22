import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget customTextButton({
  required String text,
  required VoidCallback onPressed,
  double? width,
  double? height,
  TextStyle? textStyle,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Text(text, style: textStyle),
  );
}

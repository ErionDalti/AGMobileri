import 'package:flutter/material.dart';

class ColorUtil {
  static Color hexToColor(String code) {
    if (code == null) return Colors.grey;
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}

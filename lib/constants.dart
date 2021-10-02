import 'package:flutter/cupertino.dart';

const double edge_padding = 15;
const double card_spacing = 15;
const double horizontal_margin = 14;
const double vertical_margin = 16;
const double item_spacing = 16;
const double selector_height = 60;

const Color green = Color.fromRGBO(0, 223, 100, 1);
const Color title = Color(0xFF545454);
const Color subtitle = Color(0xFF787878);
const Color background = Color(0xFFF7F7F7);
const Color canvas = white;
const Color white = Color(0xFFFFFFFF);

class RightArrow {
  RightArrow._();

  static const _kFontFam = 'Arrow';
  static const _kFontPkg = null;

  static const IconData right_arrow = IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}

import 'package:flutter/material.dart';

class AppSizes {
  static const double iconSmall = 24;
  static const double iconLarge = 35;

  static const double p24 = 24;
  static const double p20 = 20;
  static const double p16 = 16;
  static const double p12 = 12;
  static const double p10 = 10;
  static const double p8 = 8;
  static const double p4 = 4;

  static const double sectionGap = 16;
  static const double topScreenPadding = 50;

  static const double cardLargeRadius = 20;
  static const double cardSmallRadius = 10;

  static final BoxShadow shadow = BoxShadow(
    color: Colors.black.withOpacity(0.25),
    offset: const Offset(4, 4),
    blurRadius: 8,
    spreadRadius: 0,
  );
}

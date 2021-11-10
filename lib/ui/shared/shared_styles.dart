import 'package:flutter/material.dart';

// Box Decorations

BoxDecoration fieldDecortaion = BoxDecoration(
    borderRadius: BorderRadius.circular(5), color: Colors.grey[200]);

BoxDecoration disabledFieldDecortaion = BoxDecoration(
    borderRadius: BorderRadius.circular(5), color: Colors.grey[100]);

// Field Variables
const TextStyle titleStyleHugeB = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
);
const TextStyle titleStyleHuge = TextStyle(
  fontSize: 32,
);
const TextStyle titleStyleLargeB = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
);
const TextStyle titleStyleLarge = TextStyle(
  fontSize: 28,
);
const TextStyle titleStyleMedium = TextStyle(
  fontSize: 24,
);
const TextStyle titleStyleMediumB = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
);
const double fieldHeight = 55;
const double smallFieldHeight = 40;
const double inputFieldBottomMargin = 30;
const double inputFieldSmallBottomMargin = 0;
const EdgeInsets fieldPadding = const EdgeInsets.symmetric(horizontal: 15);
const EdgeInsets largeFieldPadding =
    const EdgeInsets.symmetric(horizontal: 15, vertical: 15);

// Text Variables
const TextStyle buttonTitleTextStyle =
    const TextStyle(fontWeight: FontWeight.w700, color: Colors.white);

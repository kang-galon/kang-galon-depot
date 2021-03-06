import 'package:flutter/material.dart';

class Pallette {
  static EdgeInsets contentPadding =
      const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0);

  static EdgeInsets contentPadding2 = const EdgeInsets.all(10.0);

  static Color shimmerBaseColor = Colors.grey.shade300;

  static Color shimmerHighlightColor = Colors.grey.shade100;

  static BoxDecoration shimmerContainerDecoration = BoxDecoration(
    color: Colors.grey.shade300,
    borderRadius: BorderRadius.circular(10.0),
  );

  static BoxDecoration containerBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(10.0),
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.shade400,
        spreadRadius: 1.0,
        blurRadius: 5.0,
        offset: Offset(1, 2),
      )
    ],
  );

  static InputDecoration inputDecoration = InputDecoration(
    counterText: '',
    fillColor: Colors.grey.shade200,
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: BorderSide.none,
    ),
  );
}

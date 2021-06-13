import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String message, {bool isError: false}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: isError ? Colors.red : Colors.grey.shade800,
    content: Text(message),
  ));
}

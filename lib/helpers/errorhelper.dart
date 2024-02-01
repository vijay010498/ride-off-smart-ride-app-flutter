import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorHelper{
  void showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
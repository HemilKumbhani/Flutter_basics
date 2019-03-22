import 'package:flutter/material.dart';

InputDecoration textDecoration(String label) {
  return InputDecoration(
    hasFloatingPlaceholder: true,
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(10))),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(10))),
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(10))),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(10))),
    labelStyle: TextStyle(color: Colors.white),
    errorStyle: TextStyle(color: Colors.white),
    labelText: label,
  );
}

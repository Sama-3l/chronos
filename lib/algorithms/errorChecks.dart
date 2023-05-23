import 'package:flutter/material.dart';

class Errors {
  bool isSingleWord(String input) {
    // Define the regular expression pattern for a single word
    RegExp wordPattern = RegExp(r'^[a-zA-Z]+$');

    // Check if the input matches the word pattern
    return wordPattern.hasMatch(input) && input.length < 10;
  }
}
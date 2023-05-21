// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_switch/flutter_switch.dart';

class InputField extends StatefulWidget {
  InputField({super.key, required this.controller, required this.hintText, required this.left, required this.right});

  TextEditingController controller;
  String hintText;
  double left;
  double right;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: widget.left, right: widget.right),
      child: TextField(
        controller: widget.controller,
        cursorColor: Color(0xff1f1f1f),
        scrollPadding: EdgeInsets.only(bottom: 40),
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFFDADADA),
          hintText: widget.hintText,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(5)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(5)),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(5)),
        ),
      ),
    );
  }
}

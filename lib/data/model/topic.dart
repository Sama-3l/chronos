import 'package:flutter/material.dart';

class Topic{
  String description;
  List<Topic>? subtopics;

  Topic({required this.description, this.subtopics});
}
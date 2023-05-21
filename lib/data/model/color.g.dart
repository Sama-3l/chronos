import 'package:hive/hive.dart';
import 'package:flutter/material.dart';


class ColorAdapter extends TypeAdapter<Color> {
  @override
  final typeId = 0; // Unique identifier for this type adapter

  @override
  Color read(BinaryReader reader) {
    final value = reader.readInt();
    return Color(value);
  }

  @override
  void write(BinaryWriter writer, Color obj) {
    writer.writeInt(obj.value);
  }
}
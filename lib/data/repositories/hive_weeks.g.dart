// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_weeks.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeeksAdapter extends TypeAdapter<Weeks> {
  @override
  final int typeId = 6;

  @override
  Weeks read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Weeks()..weeks = (fields[0] as List).cast<Week>();
  }

  @override
  void write(BinaryWriter writer, Weeks obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.weeks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeeksAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

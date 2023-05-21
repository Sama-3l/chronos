// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_week.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeekAdapter extends TypeAdapter<Week> {
  @override
  final int typeId = 4;

  @override
  Week read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Week(
      monday: fields[0] as DateTime,
      sunday: fields[1] as DateTime,
      selected: fields[3] as bool,
      week: fields[2] as String,
      reminders: fields[4] as Reminders,
    );
  }

  @override
  void write(BinaryWriter writer, Week obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.monday)
      ..writeByte(1)
      ..write(obj.sunday)
      ..writeByte(2)
      ..write(obj.week)
      ..writeByte(3)
      ..write(obj.selected)
      ..writeByte(4)
      ..write(obj.reminders);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeekAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

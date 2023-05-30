// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_reminder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReminderAdapter extends TypeAdapter<Reminder> {
  @override
  final int typeId = 2;

  @override
  Reminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reminder(
      isDescriptive: fields[0] as bool,
      tag1: fields[1] as String,
      tag2: fields[2] as String,
      color: fields[3] as Color,
      deadline: fields[5] as DateTime,
      subtitle: fields[6] as String,
      deadlineType: fields[4] as String,
      topics: (fields[7] as List?)?.cast<Topic>(),
      notificationIDs: (fields[8] as List?)?.cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, Reminder obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.isDescriptive)
      ..writeByte(1)
      ..write(obj.tag1)
      ..writeByte(2)
      ..write(obj.tag2)
      ..writeByte(3)
      ..write(obj.color)
      ..writeByte(4)
      ..write(obj.deadlineType)
      ..writeByte(5)
      ..write(obj.deadline)
      ..writeByte(6)
      ..write(obj.subtitle)
      ..writeByte(7)
      ..write(obj.topics)
      ..writeByte(8)
      ..write(obj.notificationIDs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

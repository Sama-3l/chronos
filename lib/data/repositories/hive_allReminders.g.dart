// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_allReminders.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RemindersAdapter extends TypeAdapter<Reminders> {
  @override
  final int typeId = 5;

  @override
  Reminders read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reminders(
      allReminders: (fields[0] as List).cast<Reminder>(),
      remindersMappedToMonth: (fields[1] as Map?)?.map((dynamic k, dynamic v) =>
          MapEntry(k as Week, (v as List?)?.cast<Reminders>())),
    );
  }

  @override
  void write(BinaryWriter writer, Reminders obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.allReminders)
      ..writeByte(1)
      ..write(obj.remindersMappedToMonth);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RemindersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

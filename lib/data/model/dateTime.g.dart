import 'package:hive/hive.dart';

class DateTimeAdapter extends TypeAdapter<DateTime> {
  @override
  final int typeId = 1; // Unique identifier for this type adapter

  @override
  DateTime read(BinaryReader reader) {
    final millis = reader.readInt();
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  @override
  void write(BinaryWriter writer, DateTime obj) {
    writer.writeInt(obj.millisecondsSinceEpoch);
  }
}

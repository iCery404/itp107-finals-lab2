// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      title: fields[0] as String,
      date: fields[1] as DateTime,
      isDone: fields[2] == null ? false : fields[2] as bool,
      description: fields[3] == null ? '' : fields[3] as String,
      category: fields[4] == null ? '' : fields[4] as String,
      priority: fields[5] == null ? '' : fields[5] as String,
      location: fields[6] == null ? '' : fields[6] as String,
      assignedTo: fields[7] == null ? '' : fields[7] as String,
      time: fields[8] == null ? '' : fields[8] as String,
      notes: fields[9] == null ? '' : fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.isDone)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.priority)
      ..writeByte(6)
      ..write(obj.location)
      ..writeByte(7)
      ..write(obj.assignedTo)
      ..writeByte(8)
      ..write(obj.time)
      ..writeByte(9)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task()
      ..title = fields[0] as String
      ..isDone = fields[1] as bool
      ..importanceLevel = fields[2] as ImportanceLevel
      ..listName = fields[3] as String
      ..details = fields[4] as String;
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.isDone)
      ..writeByte(2)
      ..write(obj.importanceLevel)
      ..writeByte(3)
      ..write(obj.listName)
      ..writeByte(4)
      ..write(obj.details);
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

class ImportanceLevelAdapter extends TypeAdapter<ImportanceLevel> {
  @override
  final int typeId = 1;

  @override
  ImportanceLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ImportanceLevel.highImportance;
      case 1:
        return ImportanceLevel.normalImportance;
      case 2:
        return ImportanceLevel.lowImportance;
      default:
        return ImportanceLevel.highImportance;
    }
  }

  @override
  void write(BinaryWriter writer, ImportanceLevel obj) {
    switch (obj) {
      case ImportanceLevel.highImportance:
        writer.writeByte(0);
        break;
      case ImportanceLevel.normalImportance:
        writer.writeByte(1);
        break;
      case ImportanceLevel.lowImportance:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImportanceLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

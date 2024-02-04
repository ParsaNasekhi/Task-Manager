// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ListDataAdapter extends TypeAdapter<ListData> {
  @override
  final int typeId = 2;

  @override
  ListData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ListData()..listName = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, ListData obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.listName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

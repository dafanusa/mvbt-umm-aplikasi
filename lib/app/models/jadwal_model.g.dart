// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jadwal_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JadwalModelAdapter extends TypeAdapter<JadwalModel> {
  @override
  final int typeId = 1;

  @override
  JadwalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JadwalModel(
      id: fields[0] as int,
      title: fields[1] as String,
      date: fields[2] as DateTime,
      time: fields[3] as String,
      category: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, JadwalModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.time)
      ..writeByte(4)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JadwalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

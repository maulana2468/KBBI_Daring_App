// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_vocab.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataVocabAdapter extends TypeAdapter<DataVocab> {
  @override
  final int typeId = 0;

  @override
  DataVocab read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataVocab(
      fields[0] as String,
      fields[1] as String,
      (fields[2] as List).cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, DataVocab obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.vocab)
      ..writeByte(1)
      ..write(obj.lema)
      ..writeByte(2)
      ..write(obj.mean);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataVocabAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CharacterAdapter extends TypeAdapter<Character> {
  @override
  final int typeId = 0;

  @override
  Character read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Character(
      id: fields[0] as int,
      name: fields[1] as String,
      status: fields[2] as String,
      species: fields[3] as String,
      imageUrl: fields[4] as String,
      type: fields[5] as String,
      gender: fields[6] as String,
      origin: fields[7] as String,
      location: fields[8] as String,
      episodes: (fields[9] as List).cast<String>(),
      url: fields[10] as String,
      created: fields[11] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Character obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.species)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.gender)
      ..writeByte(7)
      ..write(obj.origin)
      ..writeByte(8)
      ..write(obj.location)
      ..writeByte(9)
      ..write(obj.episodes)
      ..writeByte(10)
      ..write(obj.url)
      ..writeByte(11)
      ..write(obj.created);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

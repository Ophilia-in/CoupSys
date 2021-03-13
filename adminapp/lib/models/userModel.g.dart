// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyUserAdapter extends TypeAdapter<MyUser> {
  @override
  final int typeId = 1;

  @override
  MyUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyUser(
      reason: fields[4] as String,
      phoneNo: fields[5] as String,
      createdAt: fields[3] as DateTime,
      email: fields[1] as String,
      name: fields[0] as String,
      uid: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MyUser obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.uid)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.reason)
      ..writeByte(5)
      ..write(obj.phoneNo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

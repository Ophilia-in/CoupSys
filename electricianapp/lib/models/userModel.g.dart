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
      accountType: fields[4] as String,
      createdAt: fields[6] as DateTime,
      reason: fields[9] as String,
      email: fields[1] as String,
      photoUrl: fields[2] as String,
      name: fields[0] as String,
      phone: fields[7] as String,
      points: fields[5] as int,
      earned: fields[8] as int,
      uid: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MyUser obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.photoUrl)
      ..writeByte(3)
      ..write(obj.uid)
      ..writeByte(4)
      ..write(obj.accountType)
      ..writeByte(5)
      ..write(obj.points)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.phone)
      ..writeByte(8)
      ..write(obj.earned)
      ..writeByte(9)
      ..write(obj.reason);
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

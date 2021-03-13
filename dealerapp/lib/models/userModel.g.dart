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
      reason: fields[10] as String,
      ids: (fields[11] as List)?.cast<dynamic>(),
      firmName: fields[12] as String,
      accountType: fields[4] as String,
      dealerId: fields[8] as String,
      createdAt: fields[9] as DateTime,
      email: fields[1] as String,
      photoUrl: fields[2] as String,
      name: fields[0] as String,
      phone: fields[6] as String,
      points: fields[5] as int,
      earned: fields[7] as int,
      uid: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MyUser obj) {
    writer
      ..writeByte(13)
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
      ..write(obj.phone)
      ..writeByte(7)
      ..write(obj.earned)
      ..writeByte(8)
      ..write(obj.dealerId)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.reason)
      ..writeByte(11)
      ..write(obj.ids)
      ..writeByte(12)
      ..write(obj.firmName);
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

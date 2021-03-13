import 'package:hive/hive.dart';

part 'userModel.g.dart';

@HiveType(typeId: 1)
class MyUser {
  @HiveField(0)
  String name;

  @HiveField(1)
  String email;

  @HiveField(2)
  String uid;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  String reason;

  @HiveField(5)
  String phoneNo;

  MyUser(
      {this.reason,
      this.phoneNo,
      this.createdAt,
      this.email,
      this.name,
      this.uid});
}

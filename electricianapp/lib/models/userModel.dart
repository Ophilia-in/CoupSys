import 'package:hive/hive.dart';

part 'userModel.g.dart';

//wrote by amanv8060

@HiveType(typeId: 1)
class MyUser {
  @HiveField(0)
  String name;

  @HiveField(1)
  String email;

  @HiveField(2)
  String photoUrl;

  @HiveField(3)
  String uid;

  @HiveField(4)
  String accountType;

  @HiveField(5)
  int points;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  String phone;

  @HiveField(8)
  int earned;

  @HiveField(9)
  String reason;

  MyUser(
      {this.accountType,
      this.createdAt,
      this.reason,
      this.email,
      this.photoUrl,
      this.name,
      this.phone,
      this.points,
      this.earned,
      this.uid});
}

import 'package:hive/hive.dart';

part 'userModel.g.dart';

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
  String phone;

  @HiveField(7)
  int earned;

  @HiveField(8)
  String dealerId;

  @HiveField(9)
  DateTime createdAt;

  @HiveField(10)
  String reason;

  @HiveField(11)
  List ids;

  @HiveField(12)
  String firmName;
  
  MyUser(
      {this.reason,
      this.ids,
      this.firmName,
      this.accountType,
      this.dealerId,
      this.createdAt,
      this.email,
      this.photoUrl,
      this.name,
      this.phone,
      this.points,
      this.earned,
      this.uid});
}

class Dealer {
  final String name;
  final String email;
  final String photoUrl;
  final String uid;
  final String accountType;
  final int points;
  final String phone;
  final int earned;
  final String dealerId;
  final DateTime createdAt;
  final String reason;
  final List ids;
  final String firmName;

  Dealer(
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

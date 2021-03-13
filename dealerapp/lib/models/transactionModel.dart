class TransactionRecord {
  final String type;
  final int points;
  final int amount;
  final DateTime date;
  final String senderUid;
  final String senderPhone;
  final String receiverPhone;
  final String receiverUid;
  final String transactionId;
  final String dealerId;
  final String subType;

  final String coupancode;
  final bool paid;
  final String senderName;
  final String recieverName;
  final DateTime markedAsPaidAt;

  TransactionRecord(
      {this.senderName,
      this.recieverName,
      this.markedAsPaidAt,
      this.type,
      this.subType,
      this.dealerId,
      this.points,
      this.amount,
      this.date,
      this.coupancode,
      this.senderUid,
      this.senderPhone,
      this.receiverPhone,
      this.receiverUid,
      this.paid,
      this.transactionId});
}

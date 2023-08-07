class CreditCardData {
  final String cardNumber;
  final double limit;
  final double outStanding;
  final String expiryDate;
  final String cardName;
  final String bankName;

  CreditCardData({
    required this.cardNumber,
    required this.limit,
    required this.outStanding,
    required this.expiryDate,
    required this.cardName,
    required this.bankName,
  });

  factory CreditCardData.fromJson(Map<String, dynamic> json) {
    return CreditCardData(
      cardNumber: json['cardNumber'],
      limit: json['limit'].toDouble(),
      outStanding: json['outStanding'].toDouble(),
      expiryDate: json['expiryDate'],
      cardName: json['cardName'],
      bankName: json['bankName'],
    );
  }
}

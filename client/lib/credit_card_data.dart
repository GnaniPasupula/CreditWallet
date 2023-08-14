class CreditCardData {
  final String cardNumber;
  final double limit;
  final double outStanding;
  final String expiryDate;
  final String cardName;
  final String bankName;
  final List<Transaction> transactions;

  CreditCardData({
    required this.cardNumber,
    required this.limit,
    required this.outStanding,
    required this.expiryDate,
    required this.cardName,
    required this.bankName,
    required this.transactions,
  });

  factory CreditCardData.fromJson(Map<String, dynamic> json) {
    final List<dynamic> jsonTransactions = json['transactions'] ?? [];
    final List<Transaction> transactions = jsonTransactions.map((transaction) {
      return Transaction(
        date: DateTime.parse(transaction['date']),
        amount: transaction['amount'].toDouble(),
        title: transaction['title'] ?? "Unknown",
        category: transaction['category'] ?? "Unknown",
      );
    }).toList();

    return CreditCardData(
      cardNumber: json['cardNumber'],
      limit: json['limit'].toDouble(),
      outStanding: json['outStanding'].toDouble(),
      expiryDate: json['expiryDate'],
      cardName: json['cardName'],
      bankName: json['bankName'],
      transactions: transactions,
    );
  }
}

class Transaction {
  final DateTime date;
  final double amount;
  final String title;
  final String category;

  Transaction({
    required this.date,
    required this.amount,
    required this.title,
    required this.category,
  });
}

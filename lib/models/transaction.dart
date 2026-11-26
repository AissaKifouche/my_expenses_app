enum TransactionType {income, expense}

enum Category {
  shopping,
  bills,
  entertainment,
  studies,
  transport,
  salary,
  freelance,
  other,
}

class Transaction {
  final int id;
  final TransactionType transactionType;
  final Category category;
  final DateTime dateTime;
  final double amount;
  final String? note;

  Transaction({
    required this.id,
    required this.transactionType,
    required this.category,
    required this.dateTime,
    required this.amount,
    this.note,
});

  // private constructor used only by copyWith, to preserve the original id
  Transaction._({
    required this.id,
    required this.transactionType,
    required this.category,
    required this.dateTime,
    required this.amount,
    this.note,
  });

  Transaction copyWith({
    TransactionType? transactionType,
    Category? category,
    DateTime? dateTime,
    double? amount,
    String? note,
  }) {
    return Transaction._(
      id: id, // always keeps the original id
      transactionType: transactionType ?? this.transactionType,
      category: category ?? this.category,
      dateTime: dateTime ?? this.dateTime,
      amount: amount ?? this.amount,
      note: note ?? this.note,
    );
  }
}

//a draft class to use it when creating and inserting transactions ( no id field)
class TransactionDraft {
  final TransactionType transactionType;
  final Category category;
  final DateTime dateTime;
  final double amount;
  final String? note;

  TransactionDraft({
    required this.transactionType,
    required this.category,
    required this.dateTime,
    required this.amount,
    this.note,
  });
}
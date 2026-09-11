import 'package:uuid/uuid.dart';

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
  final String id;
  final String title;
  final TransactionType transactionType;
  final Category category;
  final DateTime dateTime;
  final double amount;
  final String? note;

  Transaction({
    required this.title,
    required this.transactionType,
    required this.category,
    required this.dateTime,
    required this.amount,
    this.note,
}): id = Uuid().v4();

  // private constructor used only by copyWith, to preserve the original id
  Transaction._({
    required this.id,
    required this.title,
    required this.transactionType,
    required this.category,
    required this.dateTime,
    required this.amount,
    this.note,
  });

  Transaction copyWith({
    String? title,
    TransactionType? transactionType,
    Category? category,
    DateTime? dateTime,
    double? amount,
    String? note,
  }) {
    return Transaction._(
      id: id, // always keeps the original id
      title: title ?? this.title,
      transactionType: transactionType ?? this.transactionType,
      category: category ?? this.category,
      dateTime: dateTime ?? this.dateTime,
      amount: amount ?? this.amount,
      note: note ?? this.note,
    );
  }
}
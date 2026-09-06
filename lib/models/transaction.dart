import 'package:uuid/uuid.dart';

enum TransactionType {income, expense}

enum Category {
  food,
  bills,
  entertainment,
  studies,
  travel,
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
}
import 'package:uuid/uuid.dart';


class MonthlyBudget {
  final String id;
  final int year;
  final int month;
  final double amount;

  double spent;

  MonthlyBudget({
    required this.amount,
    required this.year,
    required this.month,
    this.spent = 0,
}): id = Uuid().v4();

  double get remaining => amount - spent;
}
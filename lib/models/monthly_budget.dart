class MonthlyBudget {
  final int id;
  final int year;
  final int month;
  final double amount;

  double spent;

  MonthlyBudget({
    required this.id,
    required this.amount,
    required this.year,
    required this.month,
    this.spent = 0,
});

  double get remaining => amount - spent;

  void addExpense(double amount){
    spent += amount;
  }

  void deleteExpense(double amount){
    spent -= amount;
  }
}

class MonthlyBudgetDraft {
  final int year;
  final int month;
  final double amount;
  final double spent;

  MonthlyBudgetDraft({
    required this.year,
    required this.month,
    required this.amount,
    this.spent = 0,
  });
}
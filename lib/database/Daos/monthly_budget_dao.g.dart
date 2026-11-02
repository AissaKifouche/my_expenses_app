// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_budget_dao.dart';

// ignore_for_file: type=lint
mixin _$MonthlyBudgetDaoMixin on DatabaseAccessor<AppDatabase> {
  $MonthlyBudgetsTable get monthlyBudgets => attachedDatabase.monthlyBudgets;
  MonthlyBudgetDaoManager get managers => MonthlyBudgetDaoManager(this);
}

class MonthlyBudgetDaoManager {
  final _$MonthlyBudgetDaoMixin _db;
  MonthlyBudgetDaoManager(this._db);
  $$MonthlyBudgetsTableTableManager get monthlyBudgets =>
      $$MonthlyBudgetsTableTableManager(
        _db.attachedDatabase,
        _db.monthlyBudgets,
      );
}

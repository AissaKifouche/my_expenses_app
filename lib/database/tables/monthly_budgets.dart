// ignore_for_file: recursive_getters
import 'package:drift/drift.dart';

class MonthlyBudgets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get year => integer()();
  IntColumn get month => integer().check(month.isBetweenValues(1, 12),)();
  RealColumn get amount => real().check(amount.isBiggerOrEqualValue(0))();
  RealColumn get spent => real().withDefault(const Constant(0)).check(spent.isBiggerOrEqualValue(0))();
  @override
  List<Set<Column>> get uniqueKeys => [
    {year, month},
  ];
}
// ignore_for_file: recursive_getters
import 'package:drift/drift.dart';

class Goals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get targetAmount =>
      real().check(targetAmount.isBiggerThanValue(0))();
  RealColumn get savedAmount => real()
      .withDefault(const Constant(0))
      .check(savedAmount.isBiggerOrEqualValue(0))();

  @override
  List<String> get customConstraints => [
    'CHECK (saved_amount <= target_amount)',
  ];
}
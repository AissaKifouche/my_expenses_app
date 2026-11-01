// ignore_for_file: recursive_getters
import 'package:drift/drift.dart';
import 'package:my_expenses/database/tables/categories.dart';
import 'package:my_expenses/database/tables/transaction_types.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  IntColumn get transactionTypeId =>
      integer().references(TransactionTypes, #id)();
  IntColumn get categoryId =>
      integer().references(Categories, #id)();
  DateTimeColumn get dateAndTime => dateTime()();
  RealColumn get amount =>
      real().check(amount.isBiggerThanValue(0))();
  TextColumn get note => text().nullable()();
}
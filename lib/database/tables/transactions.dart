import 'package:drift/drift.dart';
import 'package:my_expenses/database/tables/categories.dart';
import 'package:my_expenses/database/tables/transaction_types.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  IntColumn get transactionTypeId => integer().references(TransactionTypes, #id)();
  IntColumn get categoryId => integer().references(Categories, #id)();
  DateTimeColumn get dateAndTime => dateTime()();
  RealColumn get amount => real().check(Constant('amount > 0' as bool?))();
  TextColumn get note => text().nullable()();
}
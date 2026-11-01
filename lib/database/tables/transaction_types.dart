import 'package:drift/drift.dart';

class TransactionTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}
import 'package:drift/drift.dart';

// define the currencies table
class Currencies extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text()();
  TextColumn get name => text()();
  TextColumn get symbol => text()();
  TextColumn get flag => text()();
}

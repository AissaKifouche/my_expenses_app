import 'package:drift/drift.dart';
import 'package:my_expenses/database/tables/currencies.dart';

class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get selectedCurrencyId => integer().references(Currencies, #id)();
}
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'tables/currencies.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Currencies]
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;
}
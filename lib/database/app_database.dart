import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/currencies.dart';
import 'tables/app_settings.dart';
import 'tables/wallets.dart';
import 'tables/transaction_types.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Currencies,
    AppSettings,
    Wallets,
    TransactionTypes,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationSupportDirectory();
    final file = File(p.join(dbFolder.path, 'expenses.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}
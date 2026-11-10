import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'database_seeder.dart';

import 'tables/currencies.dart';
import 'tables/app_settings.dart';
import 'tables/wallets.dart';
import 'tables/transaction_types.dart';
import 'tables/categories.dart';
import 'tables/transactions.dart';
import 'tables/goals.dart';
import 'tables/monthly_budgets.dart';

import 'daos/currency_dao.dart';
import 'daos/app_settings_dao.dart';
import 'daos/wallet_dao.dart';
import 'daos/transaction_dao.dart';
import 'daos/goal_dao.dart';
import 'daos/monthly_budget_dao.dart';
import 'daos/category_dao.dart';
import 'daos/transaction_type_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Currencies,
    AppSettings,
    Wallets,
    TransactionTypes,
    Categories,
    Transactions,
    Goals,
    MonthlyBudgets,
  ],
  daos: [
    CurrencyDao,
    AppSettingsDao,
    WalletDao,
    TransactionDao,
    GoalDao,
    MonthlyBudgetDao,
    CategoryDao,
    TransactionTypeDao
  ]
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      // create all database tables
      await m.createAll();
      // insert initial data
      await DatabaseSeeder(this).seed();
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationSupportDirectory();
    final file = File(p.join(dbFolder.path, 'expenses.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}
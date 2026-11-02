import 'package:drift/drift.dart';

import 'app_database.dart';

class DatabaseSeeder {
  final AppDatabase db;

  DatabaseSeeder(this.db);

  Future<void> seed() async {
    await db.transaction(() async {
      await _seedCurrencies();
      await _seedTransactionTypes();
      await _seedCategories();
      await _seedSettings();
      await _seedWallet();
    });
  }

  Future<void> _seedCurrencies() async {
    await db.currencyDao.insertCurrency(
      CurrenciesCompanion.insert(
        code: 'USD',
        name: 'US Dollar',
        symbol: r'$',
        flag: '🇺🇸',
      ),
    );

    await db.currencyDao.insertCurrency(
      CurrenciesCompanion.insert(
        code: 'EUR',
        name: 'Euro',
        symbol: '€',
        flag: '🇪🇺',
      ),
    );

    await db.currencyDao.insertCurrency(
      CurrenciesCompanion.insert(
        code: 'DZD',
        name: 'Algerian Dinar',
        symbol: 'DA',
        flag: '🇩🇿',
      ),
    );

    await db.currencyDao.insertCurrency(
      CurrenciesCompanion.insert(
        code: 'GBP',
        name: 'British Pound',
        symbol: '£',
        flag: '🇬🇧',
      ),
    );

    await db.currencyDao.insertCurrency(
      CurrenciesCompanion.insert(
        code: 'CAD',
        name: 'Canadian Dollar',
        symbol: 'CA\$',
        flag: '🇨🇦',
      ),
    );

    await db.currencyDao.insertCurrency(
      CurrenciesCompanion.insert(
        code: 'SAR',
        name: 'Saudi Riyal',
        symbol: 'SR',
        flag: '🇸🇦',
      ),
    );

    await db.currencyDao.insertCurrency(
      CurrenciesCompanion.insert(
        code: 'AED',
        name: 'UAE Dirham',
        symbol: 'AED',
        flag: '🇦🇪',
      ),
    );
  }

  Future<void> _seedTransactionTypes() async {
    await db.transactionTypeDao.insertTransactionType(
      TransactionTypesCompanion.insert(
        name: 'income',
      ),
    );

    await db.transactionTypeDao.insertTransactionType(
      TransactionTypesCompanion.insert(
        name: 'expense',
      ),
    );
  }

  Future<void> _seedCategories() async {
    final categories = [
      ('shopping', 'shopping_bag'),
      ('bills', 'receipt_long'),
      ('entertainment', 'movie'),
      ('studies', 'school'),
      ('transport', 'directions_bus'),
      ('salary', 'account_balance_wallet'),
      ('freelance', 'laptop'),
      ('other', 'category'),
    ];

    for (final category in categories) {
      await db.categoryDao.insertCategory(
        CategoriesCompanion.insert(
          name: category.$1,
          icon: category.$2,
        ),
      );
    }
  }

  Future<void> _seedSettings() async {
    // USD is the first currency inserted, so its generated ID is 1.
    await db.appSettingsDao.insertSettings(
      AppSettingsCompanion.insert(
        selectedCurrencyId: 1,
      ),
    );
  }

  Future<void> _seedWallet() async {
    await db.walletDao.insertWallet(
      WalletsCompanion.insert(
        name: 'Main Wallet',
        balance: 0,
      ),
    );
  }
}
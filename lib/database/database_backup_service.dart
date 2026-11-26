import 'package:drift/drift.dart';
import 'dart:convert';
import 'app_database.dart';
import 'database_backup.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

class DatabaseBackupService {
  final AppDatabase database;

  DatabaseBackupService(this.database);



  Future<Map<String, dynamic>> _exportSettings() async {
    final settings = await database.select(database.appSettings).getSingle();

    final currency = await (database.select(database.currencies)
      ..where((c) => c.id.equals(settings.selectedCurrencyId)))
        .getSingle();

    return {
      'selectedCurrencyCode': currency.code,
    };
  }

  Future<List<Map<String, dynamic>>> _exportWallets() async {
    final wallets = await database.select(database.wallets).get();

    return wallets.map((wallet) {
      return {
        'name': wallet.name,
        'balance': wallet.balance,
      };
    }).toList();
  }


  Future<List<Map<String, dynamic>>> _exportTransactions() async {
    final query = database.select(database.transactions).join([
      innerJoin(
        database.transactionTypes,
        database.transactionTypes.id.equalsExp(
          database.transactions.transactionTypeId,
        ),
      ),
      innerJoin(
        database.categories,
        database.categories.id.equalsExp(
          database.transactions.categoryId,
        ),
      ),
    ]);

    final rows = await query.get();

    return rows.map((row) {
      final transaction = row.readTable(database.transactions);
      final type = row.readTable(database.transactionTypes);
      final category = row.readTable(database.categories);

      return {
        'transactionType': type.name,
        'category': category.name,
        'dateAndTime': transaction.dateAndTime.toIso8601String(),
        'amount': transaction.amount,
        'note': transaction.note,
      };
    }).toList();
  }


  Future<List<Map<String, dynamic>>> _exportGoals() async {
    final goals = await database.select(database.goals).get();

    return goals.map((goal) {
      return {
        'name': goal.name,
        'targetAmount': goal.targetAmount,
        'savedAmount': goal.savedAmount,
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> _exportMonthlyBudgets() async {
    final budgets = await database.select(database.monthlyBudgets).get();

    return budgets.map((budget) {
      return {
        'year': budget.year,
        'month': budget.month,
        'amount': budget.amount,
        'spent': budget.spent,
      };
    }).toList();
  }



  Future<DatabaseBackup> createBackup() async {
    return database.transaction(() async {
      final backupData = BackupData(
        settings: await _exportSettings(),
        wallets: await _exportWallets(),
        transactions: await _exportTransactions(),
        goals: await _exportGoals(),
        monthlyBudgets: await _exportMonthlyBudgets(),
      );

      return DatabaseBackup(
        app: 'Maliya',
        backupVersion: 1,
        createdAt: DateTime.now().toUtc(),
        data: backupData.toJson(),
      );
    });

  }

  //converts DatabaseBackup object into JSON text
  String encodeBackup(DatabaseBackup backup) {
    return const JsonEncoder.withIndent('  ').convert(
      backup.toJson(),
    );
  }

  Future<Uri?> saveBackup() async {
    // Create the backup data.
    final backup = await createBackup();

    // Convert the backup to formatted JSON.
    final json = encodeBackup(backup);

    // Convert the JSON string into bytes.
    final bytes = Uint8List.fromList(utf8.encode(json));

    // Let the user choose where to save the file.
    return FilePicker.saveFile(
      dialogTitle: 'Save Maliya Backup',
      fileName:
      'maliya_backup_${DateTime.now().toIso8601String().split('T').first}.json',
      bytes: bytes,
      mimeType: 'application/json'
    );
  }

}

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

  Future<DatabaseBackup?> readBackupFile() async {
    // Let the user select a backup file.
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['json'],
      dialogTitle: 'Select Maliya Backup',
    );

    // The user cancelled the picker.
    if (file == null) return null;

    // Read the file contents.
    final bytes = await file.readAsBytes();

    // Convert bytes into a JSON string.
    final jsonString = utf8.decode(bytes);

    // Decode JSON into a Dart object.
    final decodedJson = jsonDecode(jsonString);

    // Convert the decoded object into DatabaseBackup.
    final backup = DatabaseBackup.fromJson(
      Map<String, dynamic>.from(decodedJson as Map),
    );

    return backup;
  }


  BackupData validateBackup(DatabaseBackup backup) {
    // Check that this backup belongs to Maliya.
    if (backup.app != 'Maliya') {
      throw FormatException('This is not a Maliya backup.');
    }

    // Check whether we support this backup format.
    if (backup.backupVersion != 1) {
      throw FormatException(
        'Unsupported backup version: ${backup.backupVersion}',
      );
    }

    // Parse and validate the backup data structure.
    final backupData = BackupData.fromJson(backup.data);
    _validateRecords(backupData);

    // Check the selected currency code.
    final currencyCode =
    backupData.settings['selectedCurrencyCode'];

    if (currencyCode is! String || currencyCode.trim().isEmpty) {
      throw FormatException('Invalid selected currency.');
    }

    return backupData;
  }

  double _requireNumber(
      Map<String, dynamic> item,
      String key,
      ) {
    final value = item[key];

    if (value is! num || !value.toDouble().isFinite) {
      throw FormatException('Invalid $key value.');
    }

    return value.toDouble();
  }

  String _requireString(
      Map<String, dynamic> item,
      String key,
      ) {
    final value = item[key];

    if (value is! String || value.trim().isEmpty) {
      throw FormatException('Invalid $key value.');
    }

    return value;
  }

  void _validateRecords(BackupData data) {
    // Validate wallets.
    for (final wallet in data.wallets) {
      _requireString(wallet, 'name');

      _requireNumber(wallet, 'balance');
    }

    // Validate transactions.
    for (final transaction in data.transactions) {
      _requireString(transaction, 'transactionType');
      _requireString(transaction, 'category');

      final date = transaction['dateAndTime'];

      if (date is! String || DateTime.tryParse(date) == null) {
        throw FormatException('Invalid transaction date.');
      }

      final amount = _requireNumber(transaction, 'amount');

      if (amount <= 0) {
        throw FormatException('Transaction amount must be positive.');
      }

      final note = transaction['note'];

      if (note != null && note is! String) {
        throw FormatException('Invalid transaction note.');
      }
    }

    // Validate savings goals.
    for (final goal in data.goals) {
      _requireString(goal, 'name');

      final target = _requireNumber(goal, 'targetAmount');
      final saved = _requireNumber(goal, 'savedAmount');

      if (target <= 0 || saved < 0 || saved > target) {
        throw FormatException('Invalid savings goal amounts.');
      }
    }

    // Validate monthly budgets.
    for (final budget in data.monthlyBudgets) {
      final year = budget['year'];
      final month = budget['month'];

      if (year is! int || year <= 0 || month is! int ||
          month < 1 || month > 12) {
        throw FormatException('Invalid budget date.');
      }

      final amount = _requireNumber(budget, 'amount');
      final spent = _requireNumber(budget, 'spent');

      if (amount <= 0 || spent < 0) {
        throw FormatException('Invalid budget amounts.');
      }
    }
  }

}

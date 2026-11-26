class DatabaseBackup {
  final String app;
  final int backupVersion;
  final DateTime createdAt;
  final Map<String, dynamic> data;

  const DatabaseBackup({
    required this.app,
    required this.backupVersion,
    required this.createdAt,
    required this.data,
});

  Map<String, dynamic> toJson() {
    return {
      'app': app,
      'backupVersion': backupVersion,
      'createdAt': createdAt.toIso8601String(),
      'data': data,
    };
  }

  factory DatabaseBackup.fromJson(Map<String, dynamic> json) {
    return DatabaseBackup(
      app: json['app'] as String,
      backupVersion: json['backupVersion'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      data: Map<String, dynamic>.from(json['data'] as Map),
    );
  }

}



class BackupData {
  final Map<String, dynamic> settings;
  final List<Map<String, dynamic>> wallets;
  final List<Map<String, dynamic>> transactions;
  final List<Map<String, dynamic>> goals;
  final List<Map<String, dynamic>> monthlyBudgets;
  final List<Map<String, dynamic>> customCategories;
  final List<Map<String, dynamic>> customCurrencies;

  const BackupData({
    required this.settings,
    required this.wallets,
    required this.transactions,
    required this.goals,
    required this.monthlyBudgets,
    this.customCategories = const [],
    this.customCurrencies = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'settings': settings,
      'wallets': wallets,
      'transactions': transactions,
      'goals': goals,
      'monthlyBudgets': monthlyBudgets,
      'customCategories': customCategories,
      'customCurrencies': customCurrencies,
    };
  }

  factory BackupData.fromJson(Map<String, dynamic> json) {
    return BackupData(
      settings: Map<String, dynamic>.from(json['settings'] as Map),
      wallets: List<Map<String, dynamic>>.from(
        (json['wallets'] as List).map(
              (item) => Map<String, dynamic>.from(item as Map),
        ),
      ),
      transactions: List<Map<String, dynamic>>.from(
        (json['transactions'] as List).map(
              (item) => Map<String, dynamic>.from(item as Map),
        ),
      ),
      goals: List<Map<String, dynamic>>.from(
        (json['goals'] as List).map(
              (item) => Map<String, dynamic>.from(item as Map),
        ),
      ),
      monthlyBudgets: List<Map<String, dynamic>>.from(
        (json['monthlyBudgets'] as List).map(
              (item) => Map<String, dynamic>.from(item as Map),
        ),
      ),
      customCategories: List<Map<String, dynamic>>.from(
        (json['customCategories'] as List? ?? []).map(
              (item) => Map<String, dynamic>.from(item as Map),
        ),
      ),
      customCurrencies: List<Map<String, dynamic>>.from(
        (json['customCurrencies'] as List? ?? []).map(
              (item) => Map<String, dynamic>.from(item as Map),
        ),
      ),
    );
  }
}

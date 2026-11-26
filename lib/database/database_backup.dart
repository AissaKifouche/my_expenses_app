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
      'createdAt': createdAt,
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
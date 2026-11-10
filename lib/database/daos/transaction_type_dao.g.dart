// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_type_dao.dart';

// ignore_for_file: type=lint
mixin _$TransactionTypeDaoMixin on DatabaseAccessor<AppDatabase> {
  $TransactionTypesTable get transactionTypes =>
      attachedDatabase.transactionTypes;
  TransactionTypeDaoManager get managers => TransactionTypeDaoManager(this);
}

class TransactionTypeDaoManager {
  final _$TransactionTypeDaoMixin _db;
  TransactionTypeDaoManager(this._db);
  $$TransactionTypesTableTableManager get transactionTypes =>
      $$TransactionTypesTableTableManager(
        _db.attachedDatabase,
        _db.transactionTypes,
      );
}

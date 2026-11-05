import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/transaction_types.dart';

part 'transaction_type_dao.g.dart';

@DriftAccessor(tables: [TransactionTypes])
class TransactionTypeDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionTypeDaoMixin {
  TransactionTypeDao(super.db);

  Future<List<TransactionType>> getAll() {
    return select(transactionTypes).get();
  }

  Future<TransactionType?> getById(int id) {
    return (select(transactionTypes)
      ..where((type) => type.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> insertTransactionType(
      TransactionTypesCompanion transactionType,
      ) {
    return into(transactionTypes).insert(transactionType);
  }

  Future<TransactionType?> getByName(String name) {
    return (select(transactionTypes)..where((t) => t.name.equals(name))).getSingleOrNull();
  }
}
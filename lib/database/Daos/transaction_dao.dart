import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/transactions.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(tables: [Transactions])
class TransactionDao extends DatabaseAccessor<AppDatabase> with _$TransactionDaoMixin {
  TransactionDao(super.db);

  //a function to select all transactions
  Future<List<Transaction>> getAll() {
    return select(transactions).get();
  }
  
  //a function to select a transaction by id
  Future<Transaction?> getTransactionById (int id) {
    final query = select(transactions)..where((transaction) => transaction.id.equals(id));
    return query.getSingleOrNull();
  }
  
  //a function to insert a new transaction
  Future<int> insertTransaction(TransactionsCompanion transaction) {
    return into(transactions).insert(transaction);
  }
  
  //a function to update a transaction
  Future<bool> updateTransaction (int id, TransactionsCompanion transaction) async {
    final count = await (update(transactions)
      ..where((transaction) => transaction.id.equals(id)))
        .write(transaction);

    return count > 0;  }


  Future<bool> deleteTransaction (int id) async {
    final count = await (delete(transactions)
      ..where((transaction) => transaction.id.equals(id)))
        .go();

    return count > 0;
  }
}
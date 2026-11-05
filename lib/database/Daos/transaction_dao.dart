import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/transactions.dart';
import '../../models/transaction.dart' as model;
import 'transaction_type_dao.dart';
import 'category_dao.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(tables: [Transactions])
class TransactionDao extends DatabaseAccessor<AppDatabase> with _$TransactionDaoMixin {

  late final TransactionTypeDao _typeDao;
  late final CategoryDao _categoryDao;

  TransactionDao(super.db) {
    _typeDao = TransactionTypeDao(db);
    _categoryDao = CategoryDao(db);
  }

  //a function to select all transactions
  Future<List<model.Transaction>> getAll() async {
    final rows = await select(transactions).get();
    final types = await _typeDao.getAll();
    final categories = await _categoryDao.getAll();

    final typeNames = {
      for (final type in types) type.id : type.name
    };

    final categoryNames = {
      for (final category in categories) category.id : category.name
    };

    return rows.map((row) {
      final typeName = typeNames[row.transactionTypeId];
      final categoryName = categoryNames[row.categoryId];

      if(typeName == null || categoryName == null) {
        throw StateError("Transaction references missing reference data.");
      }

      return _toTransactionModel(row, typeName, categoryName);
    }).toList();
  }
  
  //a function to select a transaction by id
  Future<model.Transaction?> getTransactionById (int id) async {
    final row = await (select(transactions)..where((transaction) => transaction.id.equals(id))).getSingleOrNull();
    if (row == null) return null;

    final type = await _typeDao.getById(row.transactionTypeId);
    final category = await _categoryDao.getById(row.categoryId);

    if (type == null || category == null ){
      throw StateError("Transaction references missing reference data.");
    }

    return _toTransactionModel(row, type.name, category.name);
  }
  
  //a function to insert a new transaction
  Future<int> insertTransaction(model.Transaction transaction) async {

    final typeId = await _getTypeId(transaction.transactionType);
    final categoryId = await _getCategoryId(transaction.category);

    return into(transactions).insert(
      TransactionsCompanion.insert(
        title: transaction.title,
        transactionTypeId: typeId,
        categoryId: categoryId,
        dateAndTime: transaction.dateTime,
        amount: transaction.amount,
        note: Value(transaction.note),
      ),
    );
  }
  
  //a function to update a transaction
  Future<bool> updateTransaction (int id, model.Transaction transaction) async {

    final typeId = await _getTypeId(transaction.transactionType);
    final categoryId = await _getCategoryId(transaction.category);

    final count = await (update(transactions)
      ..where((t) => t.id.equals(id)))
        .write(
        TransactionsCompanion.insert(
          title: transaction.title,
          transactionTypeId: typeId,
          categoryId: categoryId,
          dateAndTime: transaction.dateTime,
          amount: transaction.amount,
          note: Value(transaction.note),
        ));

    return count > 0;
  }


  Future<bool> deleteTransaction (int id) async {
    final count = await (delete(transactions)
      ..where((t) => t.id.equals(id)))
        .go();

    return count > 0;
  }

  model.Transaction _toTransactionModel(Transaction row, String typeName, String categoryName) {
    return model.Transaction(
        id: row.id,
        title: row.title,
        transactionType: model.TransactionType.values.byName(typeName),
        category: model.Category.values.byName(categoryName),
        dateTime: row.dateAndTime,
        amount: row.amount,
    );
  }

  Future<int> _getTypeId(model.TransactionType type) async {
    final row = await _typeDao.getByName(type.name);

    if (row == null) {
      throw StateError('Transaction type "${type.name}" was not found.');
    }

    return row.id;
  }

  Future<int> _getCategoryId(model.Category category) async {
    final row = await _categoryDao.getByName(category.name);

    if (row == null) {
      throw StateError('Category "${category.name}" was not found.');
    }

    return row.id;
  }

}
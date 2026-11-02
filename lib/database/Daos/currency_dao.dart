import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/currencies.dart';

part 'currency_dao.g.dart';

@DriftAccessor(tables: [Currencies])
class CurrencyDao extends DatabaseAccessor<AppDatabase> with _$CurrencyDaoMixin {
  CurrencyDao(AppDatabase db) : super(db);

  //a function to select all currencies in the database
  Future<List<Currency>> getCurrencies(){
    return select(currencies).get();
  }

  // a function to select a currency by id
  Future<Currency?> getCurrencyById(int id) {
    final query = select(currencies)
      ..where((c) => c.id.equals(id));

    return query.getSingleOrNull();
  }

  //a function to insert into the currencies table
  Future<int> insertCurrency(CurrenciesCompanion currency){
    return into(currencies).insert(currency);
  }

  //a function to update/edit a currency
  Future<bool> updateCurrency (int id, CurrenciesCompanion currency) {
    return (update(currencies)..where((t) => t.id.equals(id)))
        .write(currency).then((count) => count > 0);
  }

  //a function to delete a currency
  Future<bool> deleteCurrency(int id) {
    return (delete(currencies)..where((t) => t.id.equals(id))).go().then((count) => count > 0);
  }
}
import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/currencies.dart';
import '../../widgets/currency.dart' as c;

part 'currency_dao.g.dart';

@DriftAccessor(tables: [Currencies])
class CurrencyDao extends DatabaseAccessor<AppDatabase> with _$CurrencyDaoMixin {
  CurrencyDao(super.db);


  // a function to select a currency by id
  Future<Currency?> getCurrencyById(int id)  {
    final query = select(currencies)
      ..where((c) => c.id.equals(id));

    return query.getSingleOrNull();
  }

  Future<c.Currency?> getCurrencyModelById (int id,) async {
    final row = await getCurrencyById(id);
    return row == null ? null : _toCurrency(row);
  }

  //a function to insert into the currencies table
  Future<int> insertCurrency(CurrenciesCompanion currency){
    return into(currencies).insert(currency);
  }

  //a function to update/edit a currency
  Future<bool> updateCurrency (int id, CurrenciesCompanion currency) async {
    final count = await (update(currencies)..where((t) => t.id.equals(id)))
        .write(currency);
    return count > 0;
  }

  //a function to delete a currency
  Future<bool> deleteCurrency(int id) async {
    final count = await (delete(currencies)..where((t) => t.id.equals(id))).go();

    return count > 0;
  }

  //a method to return database rows as currency instances (list)
  Future<List<c.Currency>> getCurrencies() async {
    final rows = await select(currencies).get();
    
    return rows.map((row) => _toCurrency(row)).toList();
  }

  //convert a Drift Currency row into the app Currency model
  c.Currency _toCurrency(Currency row) {
    return c.Currency(
      id: row.id,
      code: row.code,
      name: row.name,
      flag: row.flag,
      symbol: row.symbol
    );
  }
}
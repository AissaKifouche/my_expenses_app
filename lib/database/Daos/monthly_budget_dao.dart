import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/monthly_budgets.dart';

part 'monthly_budget_dao.g.dart';

@DriftAccessor(tables: [MonthlyBudgets])
class MonthlyBudgetDao extends DatabaseAccessor<AppDatabase> with _$MonthlyBudgetDaoMixin{
  MonthlyBudgetDao(super.db);

  //a function to select all monthly budgets
  Future<List<MonthlyBudget>> getAll() {
    return select(monthlyBudgets).get();
  }

  Future<MonthlyBudget?> getMonthlyBudgetById (int id) {
    final query = select(monthlyBudgets)..where((m) => m.id.equals(id));
    return query.getSingleOrNull();
  }

  Future<int> insertMonthlyBudget (MonthlyBudgetsCompanion budget) {
    return into(monthlyBudgets).insert(budget);
  }

  Future<bool> updateMonthlyBudget (int id, MonthlyBudgetsCompanion budget) async {
    final count = await (update(monthlyBudgets)..where((t) => t.id.equals(id)))
        .write(budget);
    return count > 0;
  }

  //a function to delete a monthly budget
  Future<bool> deleteMonthlyBudget (int id) async {
    final count = await (delete(monthlyBudgets)..where((t) => t.id.equals(id))).go();

    return count > 0;
  }
}
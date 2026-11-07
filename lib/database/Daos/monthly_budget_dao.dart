import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/monthly_budgets.dart';
import '../../models/monthly_budget.dart' as model;

part 'monthly_budget_dao.g.dart';

@DriftAccessor(tables: [MonthlyBudgets])
class MonthlyBudgetDao extends DatabaseAccessor<AppDatabase> with _$MonthlyBudgetDaoMixin{
  MonthlyBudgetDao(super.db);

  // Convert a Drift row into the application model.
  model.MonthlyBudget _toBudgetModel(MonthlyBudget row) {
    return model.MonthlyBudget(
      id: row.id,
      year: row.year,
      month: row.month,
      amount: row.amount,
      spent: row.spent,
    );
  }

  //a function to select all monthly budgets
  Future<List<model.MonthlyBudget>> getAll() async {
    final rows = await select(monthlyBudgets).get();
    return rows.map(_toBudgetModel).toList();
  }

  //get a monthly budget by id
  Future<model.MonthlyBudget?> getMonthlyBudgetById (int id) async {
    final query = select(monthlyBudgets)..where((m) => m.id.equals(id));
    final row = await query.getSingleOrNull();
    return row == null ? null : _toBudgetModel(row);
  }

  //insert a new monthly budget
  Future<int> insertMonthlyBudget (model.MonthlyBudgetDraft draft) {
    return into(monthlyBudgets).insert(MonthlyBudgetsCompanion(
      year: Value(draft.year),
      month: Value(draft.month),
      amount: Value(draft.amount),
      spent: Value(draft.spent),
    ));
  }

  //update an existing budget
  Future<bool> updateMonthlyBudget (model.MonthlyBudget budget) async {
    final count = await (update(monthlyBudgets)..where((t) => t.id.equals(budget.id)))
        .write(
      MonthlyBudgetsCompanion(
        year: Value(budget.year),
        month: Value(budget.month),
        amount: Value(budget.amount),
        spent: Value(budget.spent),
      ),
    );
    return count > 0;
  }

  //a function to delete a monthly budget
  Future<bool> deleteMonthlyBudget (int id) async {
    final count = await (delete(monthlyBudgets)..where((t) => t.id.equals(id))).go();

    return count > 0;
  }

  // Get a budget for a particular month and year.
  Future<model.MonthlyBudget?> getByYearMonth(int year, int month) async {
    final query = select(monthlyBudgets)
      ..where((m) => m.year.equals(year) & m.month.equals(month));
    final row = await query.getSingleOrNull();
    return row == null ? null : _toBudgetModel(row);
  }
}
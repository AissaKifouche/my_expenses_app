import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/goals.dart';
import '../../models/goal.dart' as model;

part 'goal_dao.g.dart';

@DriftAccessor(tables: [Goals])
class GoalDao extends DatabaseAccessor<AppDatabase> with _$GoalDaoMixin{
  GoalDao(super.db);

  // Convert a Drift row into the application model.
  model.Goal _toGoalModel(Goal row) {
    return model.Goal(
      id: row.id,
      title: row.name,
      targetedAmount: row.targetAmount,
      savedAmount: row.savedAmount,
    );
  }

  Future<List<model.Goal>> getGoals() async {
    final rows = await select(goals).get();
    return rows.map(_toGoalModel).toList();
  }

  Future<model.Goal?> getGoalById(int id) async {
    final query = select(goals)..where((g) => g.id.equals(id));
    final row = await query.getSingleOrNull();
    return row == null ? null : _toGoalModel(row);
  }

  Future<int> insertGoal(model.GoalDraft draft) {
    return into(goals).insert(
      GoalsCompanion(
        name: Value(draft.title),
        targetAmount: Value(draft.targetedAmount),
        savedAmount: Value(draft.savedAmount),
      ),
    );
  }

  Future<bool> updateGoal(model.Goal goal) async {
    final count = await (update(goals)
      ..where((g) => g.id.equals(goal.id)))
        .write(
      GoalsCompanion(
        name: Value(goal.title),
        targetAmount: Value(goal.targetedAmount),
        savedAmount: Value(goal.savedAmount),
      ),
    );

    return count > 0;
  }

  //a function to delete a goal
  Future<bool> deleteGoal(int id) async {
    final count = await (delete(goals)..where((g) => g.id.equals(id))).go();

    return count > 0;
  }
}
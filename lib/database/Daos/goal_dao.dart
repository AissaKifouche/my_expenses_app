import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/goals.dart';

part 'goal_dao.g.dart';

@DriftAccessor(tables: [Goals])
class GoalDao extends DatabaseAccessor<AppDatabase> with _$GoalDaoMixin{
  GoalDao(super.db);

  Future<List<Goal>> getGoals() {
    return select(goals).get();
  }

  Future<Goal?> getGoalById(int id) {
    final query = select(goals)..where((g) => g.id.equals(id));
    return query.getSingleOrNull();
  }

  Future<int> insertGoal(GoalsCompanion goal) {
    return into(goals).insert(goal);
  }

  Future<bool> updateGoal (int id, GoalsCompanion goal) async {
    final count = await (update(goals)..where((t) => t.id.equals(id)))
        .write(goal);
    return count > 0;
  }

  //a function to delete a goal
  Future<bool> deleteGoal(int id) async {
    final count = await (delete(goals)..where((g) => g.id.equals(id))).go();

    return count > 0;
  }
}
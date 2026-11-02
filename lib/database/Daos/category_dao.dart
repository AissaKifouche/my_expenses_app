import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/categories.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [Categories])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.db);

  Future<List<Category>> getAll() {
    return select(categories).get();
  }

  Future<Category?> getById(int id) {
    return (select(categories)
      ..where((category) => category.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> insertCategory(CategoriesCompanion category) {
    return into(categories).insert(category);
  }

  Future<bool> updateCategory(
      int id,
      CategoriesCompanion category,
      ) async {
    final count = await (update(categories)
      ..where((category) => category.id.equals(id)))
        .write(category);

    return count > 0;
  }

  Future<bool> deleteCategory(int id) async {
    final count = await (delete(categories)
      ..where((category) => category.id.equals(id)))
        .go();

    return count > 0;
  }
}
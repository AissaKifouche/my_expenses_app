import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/app_settings.dart';

part 'app_settings_dao.g.dart';

@DriftAccessor(tables :[AppSettings])
class AppSettingsDao extends DatabaseAccessor<AppDatabase> with _$AppSettingsDaoMixin {
  AppSettingsDao(AppDatabase db) : super(db);

  Future<AppSetting?> getSettings() {
    return select(appSettings).getSingleOrNull();
  }

  Future<bool> setSelectedCurrency(int currencyId) async {
    final count = await update(appSettings).write(
      AppSettingsCompanion(
        selectedCurrencyId: Value(currencyId),
      ),
    );

    return count > 0;
  }
}
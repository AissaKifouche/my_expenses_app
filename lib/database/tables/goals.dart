import 'package:drift/drift.dart';

class Goals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get targetAmount => real().check(Constant('targetAmount > 0' as bool?))();
  RealColumn get savedAmount => real().check(Constant('savedAmount >= 0 && savedAmount <= targetAmount' as bool?))();
}
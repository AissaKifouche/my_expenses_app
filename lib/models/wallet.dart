import 'package:uuid/uuid.dart';

class Wallet {
  final String id;
  final String name;
  double balance;

  Wallet({
    required this.name,
    required this.balance,
}): id = Uuid().v4();
}
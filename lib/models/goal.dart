import 'package:uuid/uuid.dart';

class Goal {
  final String id;
  final String title;
  final double targetedAmount;
  double savedAmount;

  Goal({
    required this.title,
    required this.targetedAmount,
    this.savedAmount = 0,
}) : id = Uuid().v4();

  double get remaining => targetedAmount - savedAmount;
  double get progress => savedAmount / targetedAmount;
}
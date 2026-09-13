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


  Goal._({
    required this.id,
    required this.title,
    required this.targetedAmount,
    required this.savedAmount ,
});

  Goal copyWith({
    String? title,
    double? targetedAmount,
}){
    return Goal._(
      id: id,
      title: title ?? this.title,
      targetedAmount: targetedAmount ?? this.targetedAmount,
      savedAmount: savedAmount,
    );
  }

}
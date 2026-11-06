class Goal {
  final int id;
  final String title;
  final double targetedAmount;
  double savedAmount;

  Goal({
    required this.id,
    required this.title,
    required this.targetedAmount,
    this.savedAmount = 0,
});

  double get remaining => targetedAmount - savedAmount;
  double get progress => savedAmount / targetedAmount;



  Goal copyWith({
    String? title,
    double? targetedAmount,
    double? savedAmount,
}){
    return Goal(
      id: id,
      title: title ?? this.title,
      targetedAmount: targetedAmount ?? this.targetedAmount,
      savedAmount: savedAmount ?? this.savedAmount,
    );
  }

}

// a new goal model used in insertion ( no id field)
class GoalDraft {
  final String title;
  final double targetedAmount;
  final double savedAmount;

  GoalDraft({
    required this.title,
    required this.targetedAmount,
    this.savedAmount = 0,
  });
}
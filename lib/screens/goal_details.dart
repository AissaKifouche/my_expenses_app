import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_expenses/data/app_data.dart';
import 'package:my_expenses/screens/add_goal_sheet.dart';
import 'package:my_expenses/widgets/goal_add_and_remove_money.dart';
import '../models/goal.dart';

class GoalDetailPage extends StatefulWidget {
  final AppData appData;
  final Goal goal;

  const GoalDetailPage({super.key, required this.appData, required this.goal});

  static const _accent = Color(0xFF058E84);

  @override
  State<GoalDetailPage> createState() => _GoalDetailPageState();
}

class _GoalDetailPageState extends State<GoalDetailPage> {
  bool get _isComplete => widget.goal.savedAmount / widget.goal.targetedAmount >= 1;

  Color _progressColor() {
    if (widget.goal.savedAmount >= 6 / 7 * widget.goal.targetedAmount) return const Color(0xFF002017);
    if (widget.goal.savedAmount >= 5 / 7 * widget.goal.targetedAmount) return const Color(0xFF004231);
    if (widget.goal.savedAmount >= 4 / 7 * widget.goal.targetedAmount) return const Color(0xFF00674F);
    if (widget.goal.savedAmount >= 3 / 7 * widget.goal.targetedAmount) return const Color(0xFF008F6F);
    if (widget.goal.savedAmount >= 2 / 7 * widget.goal.targetedAmount) return const Color(0xFF00B890);
    if (widget.goal.savedAmount >= 1 / 7 * widget.goal.targetedAmount) return const Color(0xFF00E4B2);
    return const Color(0xFFBAFFE5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20.w, MediaQuery.of(context).padding.top + 12.h, 20.w, 36.h),
              decoration: BoxDecoration(
                color: GoalDetailPage._accent,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32.r),
                  bottomRight: Radius.circular(32.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(20.r),
                        onTap: () => Navigator.of(context).maybePop(),
                        child: Padding(
                          padding: EdgeInsets.all(4.w),
                          child: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24.sp),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Goal',
                        style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(height: 28.h),
                  Text(
                    widget.goal.title,
                    style: TextStyle(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    '\$${widget.goal.savedAmount.toStringAsFixed(2)} of \$${widget.goal.targetedAmount.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.white70, fontSize: 15.sp),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 32.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: _isComplete
                        ? Container(height: 14.h, color: const Color(0xFF00E4B2))
                        : LinearProgressIndicator(
                      value: widget.goal.savedAmount / widget.goal.targetedAmount,
                      minHeight: 14.h,
                      backgroundColor: const Color(0xFFD9D9D9),
                      color: _progressColor(),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    _isComplete
                        ? 'Goal completed 🎉'
                        : '${((widget.goal.savedAmount / widget.goal.targetedAmount) * 100).clamp(0, 100).toStringAsFixed(0)}% saved',
                    style: TextStyle(fontSize: 13.sp, color: Colors.black54),
                  ),
                  SizedBox(height: 24.h),

                  // detail rows
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F8F8),
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    child: Column(
                      children: [
                        _DetailRow(label: 'Saved', value: '\$${widget.goal.savedAmount.toStringAsFixed(2)}'),
                        const Divider(height: 1, color: Color(0xFFE8E8E8)),
                        _DetailRow(label: 'Target', value: '\$${widget.goal.targetedAmount.toStringAsFixed(2)}'),
                        const Divider(height: 1, color: Color(0xFFE8E8E8)),
                        _DetailRow(label: 'Remaining', value: '\$${widget.goal.remaining.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                  SizedBox(height: 28.h),

                  // add / remove money
                  Row(
                    children: [

                      //add money to the goal from the main wallet
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            double? amount = await showAddOrRemoveDialog(context, widget.appData, true, widget.goal);
                            if (amount != null){
                              widget.appData.addMoneyToGoal(widget.goal.id, amount);
                            }
                          },
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: const Text('Add money'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: GoalDetailPage._accent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),

                      //remove money from the goal and put them back in the main wallet
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            double? amount = await showAddOrRemoveDialog(context, widget.appData, false, widget.goal);
                            if (amount != null){
                              widget.appData.removeMoneyFromGoal(widget.goal.id, amount);
                            }
                          },
                          icon: const Icon(Icons.remove_rounded, size: 18),
                          label: const Text('Remove money'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: GoalDetailPage._accent,
                            side: BorderSide(color: GoalDetailPage._accent.withValues(alpha: 0.4)),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // edit / delete
                  Row(
                    children: [

                      //to edit a goal
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final updated = await showModalBottomSheet(
                              useSafeArea: true,
                              isScrollControlled: true,
                              context: context,
                              constraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.height * 0.7,
                              ),
                              builder: (context) {
                                return AddGoalSheet(initialGoal: widget.goal,);
                              }
                            );

                            if(updated != null){
                              widget.appData.editGoal(updated);
                              Navigator.of(context).pop();
                            }
                          },
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          label: const Text('Edit'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black54,
                            side: const BorderSide(color: Colors.black26),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),

                      //to delete a goal
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            widget.appData.deleteGoal(widget.goal.id);
                          },
                          icon: const Icon(Icons.delete_outline_rounded, size: 18),
                          label: const Text('Delete'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFBEAE6),
                            foregroundColor: const Color(0xFFB3402B),
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 15.sp, color: Colors.black54)),
          Text(value, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.black87)),
        ],
      ),
    );
  }
}
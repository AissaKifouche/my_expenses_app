import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/goal.dart';

class GoalDetailPage extends StatelessWidget {
  final Goal goal;

  const GoalDetailPage({super.key, required this.goal});

  static const _accent = Color(0xFF058E84);

  bool get _isComplete => goal.savedAmount / goal.targetedAmount >= 1;

  Color _progressColor() {
    if (goal.savedAmount >= 6 / 7 * goal.targetedAmount) return const Color(0xFF002017);
    if (goal.savedAmount >= 5 / 7 * goal.targetedAmount) return const Color(0xFF004231);
    if (goal.savedAmount >= 4 / 7 * goal.targetedAmount) return const Color(0xFF00674F);
    if (goal.savedAmount >= 3 / 7 * goal.targetedAmount) return const Color(0xFF008F6F);
    if (goal.savedAmount >= 2 / 7 * goal.targetedAmount) return const Color(0xFF00B890);
    if (goal.savedAmount >= 1 / 7 * goal.targetedAmount) return const Color(0xFF00E4B2);
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
                color: _accent,
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
                    goal.title,
                    style: TextStyle(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    '\$${goal.savedAmount.toStringAsFixed(2)} of \$${goal.targetedAmount.toStringAsFixed(2)}',
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
                      value: goal.savedAmount / goal.targetedAmount,
                      minHeight: 14.h,
                      backgroundColor: const Color(0xFFD9D9D9),
                      color: _progressColor(),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    _isComplete
                        ? 'Goal completed 🎉'
                        : '${((goal.savedAmount / goal.targetedAmount) * 100).clamp(0, 100).toStringAsFixed(0)}% saved',
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
                        _DetailRow(label: 'Saved', value: '\$${goal.savedAmount.toStringAsFixed(2)}'),
                        const Divider(height: 1, color: Color(0xFFE8E8E8)),
                        _DetailRow(label: 'Target', value: '\$${goal.targetedAmount.toStringAsFixed(2)}'),
                        const Divider(height: 1, color: Color(0xFFE8E8E8)),
                        _DetailRow(label: 'Remaining', value: '\$${goal.remaining.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                  SizedBox(height: 28.h),

                  // add / remove money
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: hook up add money flow
                          },
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: const Text('Add money'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _accent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: hook up remove money flow
                          },
                          icon: const Icon(Icons.remove_rounded, size: 18),
                          label: const Text('Remove money'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _accent,
                            side: BorderSide(color: _accent.withValues(alpha: 0.4)),
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
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: hook up edit flow
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
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: hook up delete flow
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
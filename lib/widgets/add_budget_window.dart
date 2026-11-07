import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses/data/app_data.dart';

import '../models/monthly_budget.dart';

Future<MonthlyBudgetDraft?> showSetBudgetDialog(
    BuildContext context,
    AppData appData,
    ) {
  return showDialog<MonthlyBudgetDraft>(
    context: context,
    builder: (_) => _SetBudgetDialog(appData: appData),
  );
}

class _SetBudgetDialog extends StatefulWidget {
  final AppData appData;

  const _SetBudgetDialog({
    required this.appData,
  });

  @override
  State<_SetBudgetDialog> createState() => _SetBudgetDialogState();
}

class _SetBudgetDialogState extends State<_SetBudgetDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _now = DateTime.now();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveBudget() {
    if (!_formKey.currentState!.validate()) return;

    final draft = MonthlyBudgetDraft(
      amount: double.parse(_controller.text.trim()),
      year: _now.year,
      month: _now.month,
    );

    Navigator.of(context).pop(draft);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: 24.w,
        vertical: 24.h,
      ),
      contentPadding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 0),
      titlePadding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
      title: Text(
        'Set a monthly budget for ${DateFormat("MMMM yyyy").format(_now)}',
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 320.w,
          child: TextFormField(
            controller: _controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'^\d*\.?\d{0,2}'),
              ),
            ],
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              prefixText: '${widget.appData.currency.symbol} ',
              prefixStyle: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
              ),
              hintText: '0.00',
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 18.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Enter an amount';
              }

              final parsed = double.tryParse(v.trim());

              if (parsed == null || parsed <= 0) {
                return 'Enter a valid amount';
              }

              return null;
            },
          ),
        ),
      ),
      actionsPadding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 20.h),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(fontSize: 16.sp),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF058E84),
            padding: EdgeInsets.symmetric(
              horizontal: 22.w,
              vertical: 14.h,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          onPressed: _saveBudget,
          child: Text(
            'Save',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
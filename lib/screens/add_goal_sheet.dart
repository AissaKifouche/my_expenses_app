import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_expenses/data/app_data.dart';
import '../models/goal.dart';



class AddGoalSheet extends StatefulWidget {
  final Goal? initialGoal;
  final AppData appData;
  const AddGoalSheet({super.key, this.initialGoal, required this.appData});

  @override
  State<AddGoalSheet> createState() => _AddGoalSheetState();
}

class _AddGoalSheetState extends State<AddGoalSheet> {
  static const _accent = Color(0xFF058E84);

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController ;
  late TextEditingController _targetController ;

  bool get isEditing => widget.initialGoal != null;

  @override
  void initState() {
    super.initState();
    final g = widget.initialGoal;

    _titleController = TextEditingController(text: g?.title ?? "");
    _targetController = TextEditingController(text: g?.targetedAmount.toStringAsFixed(2) ?? "" );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final Goal goal;

    if (isEditing){
      goal = widget.initialGoal!.copyWith(
        title: _titleController.text.trim(),
        targetedAmount: double.tryParse(_targetController.text.trim()),
      );
    }
    else {
      goal = Goal(
        title: _titleController.text.trim(),
        targetedAmount: double.parse(_targetController.text.trim()),
      );
    }
    Navigator.of(context).pop(goal);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28.r),
            topRight: Radius.circular(28.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 20.h),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    isEditing ? 'Edit goal' : 'Add a goal',
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: Colors.black87),
                  ),
                  SizedBox(height: 22.h),
              
                  _FieldLabel('Goal title'),
                  SizedBox(height: 6.h),
                  TextFormField(
                    controller: _titleController,
                    style: TextStyle(fontSize: 15.sp),
                    decoration: _fieldDecoration('e.g. New laptop'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter a title' : null,
                  ),
                  SizedBox(height: 16.h),
              
                  _FieldLabel('Target amount'),
                  SizedBox(height: 6.h),
                  TextFormField(
                    controller: _targetController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
                    decoration: _fieldDecoration('0.00', prefixText: '${widget.appData.currency.symbol} '),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Enter a target amount';
                      final parsed = double.tryParse(v.trim());
                      if (parsed == null || parsed <= 0) return 'Target amount must be greater than 0';
                      return null;
                    },
                  ),
                  SizedBox(height: 26.h),
              
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accent,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                      ),
                      child: Text(
                        isEditing? 'Update goal' : 'Save goal',
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(String hint, {String? prefixText}) {
    return InputDecoration(
      hintText: hint,
      prefixText: prefixText,
      hintStyle: const TextStyle(color: Colors.black38),
      filled: true,
      fillColor: const Color(0xFFF4F4F4),
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.black54),
    );
  }
}
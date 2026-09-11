import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_expenses/models/transaction.dart';
import 'package:my_expenses/screens/transaction_details.dart';

Future<Transaction?> showAddTransactionSheet(BuildContext context) {
  return showModalBottomSheet<Transaction>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    // Allows the modal bottom sheet to extend up to 90% of screen height
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.9,
    ),
    builder: (_) => const AddTransactionSheet(),
  );
}

class AddTransactionSheet extends StatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  static const _teal = Color(0xFF058E84);
  static const _expense = Colors.red;

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  TransactionType _type = TransactionType.expense;
  Category _category = Category.shopping;
  DateTime _dateTime = DateTime.now();

  Color get _accent => _type == TransactionType.income ? _teal : _expense;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    DateTime now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(now.year, now.month, 1),
      lastDate: DateTime(now.year, now.month + 1, 0),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: _accent),
        ),
        child: child!,
      ),
    );

    if (picked == null) return;
    if (!mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dateTime),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: _accent),
        ),
        child: child!,
      ),
    );

    if (!mounted) return;

    setState(() {
      _dateTime = DateTime(
        picked.year,
        picked.month,
        picked.day,
        time?.hour ?? _dateTime.hour,
        time?.minute ?? _dateTime.minute,
      );
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final transaction = Transaction(
      title: _titleController.text.trim(),
      transactionType: _type,
      category: _category,
      dateTime: _dateTime,
      amount: double.parse(_amountController.text.trim()),
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
    );
    Navigator.of(context).pop(transaction);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.r),
          topRight: Radius.circular(28.r),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          // Adjust padding dynamically with keyboard height
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 20.h),
            child: Form(
              key: _formKey,
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
                    'Add transaction',
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: Colors.black87),
                  ),
                  SizedBox(height: 20.h),

                  // Income / Expense Toggle
                  _TypeToggle(
                    type: _type,
                    accent: _accent,
                    onChanged: (t) => setState(() => _type = t),
                  ),
                  SizedBox(height: 18.h),

                  // Amount Input
                  TextFormField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                    style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w700, color: _accent),
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 16.w, right: 6.w),
                        child: Text(
                          '\$',
                          style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w700, color: _accent),
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                      hintText: '0.00',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.r),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.r),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Enter an amount';
                      final parsed = double.tryParse(v.trim());
                      if (parsed == null || parsed <= 0) return 'Enter a valid amount';
                      return null;
                    },
                  ),
                  const Divider(height: 24, color: Color(0xFFF0F0F0)),

                  // Title Input
                  const _FieldLabel('Title'),
                  SizedBox(height: 6.h),
                  TextFormField(
                    controller: _titleController,
                    style: TextStyle(fontSize: 15.sp),
                    decoration: _fieldDecoration('e.g. Grocery run'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter a title' : null,
                  ),
                  SizedBox(height: 16.h),

                  // Category Selector
                  const _FieldLabel('Category'),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children: Category.values.map((c) {
                      final selected = c == _category;
                      return ChoiceChip(
                        label: Text(TransactionDetailPage.categoryLabel(c)),
                        avatar: Icon(
                          TransactionDetailPage.categoryIcon(c),
                          size: 16.sp,
                          color: selected ? Colors.white : Colors.black54,
                        ),
                        selected: selected,
                        onSelected: (_) => setState(() => _category = c),
                        selectedColor: _accent,
                        backgroundColor: const Color(0xFFF4F4F4),
                        labelStyle: TextStyle(
                          fontSize: 13.sp,
                          color: selected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                          side: BorderSide.none,
                        ),
                        showCheckmark: false,
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16.h),

                  // Date & Time Picker
                  const _FieldLabel('Date & time'),
                  SizedBox(height: 6.h),
                  InkWell(
                    borderRadius: BorderRadius.circular(12.r),
                    onTap: _pickDate,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F4F4),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_rounded, size: 18.sp, color: Colors.black54),
                          SizedBox(width: 10.w),
                          Text(_formatDateTime(_dateTime), style: TextStyle(fontSize: 14.sp, color: Colors.black87)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Note Input
                  const _FieldLabel('Note (optional)'),
                  SizedBox(height: 6.h),
                  TextFormField(
                    controller: _noteController,
                    style: TextStyle(fontSize: 15.sp),
                    maxLines: 2,
                    decoration: _fieldDecoration('Add a note'),
                  ),
                  SizedBox(height: 26.h),

                  // Save Button
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
                        'Save transaction',
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

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black38),
      filled: true,
      fillColor: const Color(0xFFF4F4F4),
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: _expense),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: _expense),
      ),
    );
  }

  static String _formatDateTime(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final hour = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final minute = d.minute.toString().padLeft(2, '0');
    final period = d.hour >= 12 ? 'PM' : 'AM';
    return '${d.day} ${months[d.month - 1]} ${d.year} • $hour:$minute $period';
  }
}

class _TypeToggle extends StatelessWidget {
  final TransactionType type;
  final Color accent;
  final ValueChanged<TransactionType> onChanged;

  const _TypeToggle({required this.type, required this.accent, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: TransactionType.values.map((t) {
          final selected = t == type;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(t),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                  color: selected ? accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  t == TransactionType.income ? 'Income' : 'Expense',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : Colors.black54,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_expenses/data/app_data.dart';
import 'package:my_expenses/models/goal.dart';

Future<double?> showAddOrRemoveDialog(BuildContext context, AppData appData, bool add, Goal goal) async {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        contentPadding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 0),
        titlePadding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
        title: Text(
          "How much would you like to add?",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: formKey,
              child: SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: controller,
                  autofocus: true,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    prefixText: '${appData.currency.symbol} ',
                    prefixStyle: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600),
                    hintText: '0.00',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14.r)),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Enter an amount';
                    final parsed = double.tryParse(v.trim());
                    if (parsed == null || parsed <= 0) return 'Enter a valid amount';
                    if (add){
                      if (parsed > appData.wallet.balance) return 'Amount exceeds wallet balance';
                    }
                    else{
                      if (parsed > goal.savedAmount) return 'Amount exceeds what is saved in this goal';
                    }
                    return null;
                  },
                ),
              ),
            ),

            SizedBox(height: 15.h,),

            Text(
              add ? "Available in wallet: ${appData.currency.symbol} ${appData.wallet.balance}" : "Saved in this goal: ${appData.currency.symbol} ${goal.savedAmount}",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),

        actionsPadding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 20.h),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: TextStyle(fontSize: 16.sp)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF058E84),
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 14.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              Navigator.of(context).pop(double.parse(controller.text.trim()));
            },
            child: Text('Save', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
          ),
        ],
      );
    }
  );
}
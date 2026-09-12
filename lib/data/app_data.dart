import 'package:my_expenses/models/transaction.dart';
import 'package:my_expenses/models/wallet.dart';

class AppData {
  Wallet wallet = Wallet(
    name: "Main Wallet",
    balance: 0,
  );

  List<Transaction> transactions = [];
}
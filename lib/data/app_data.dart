import 'package:my_expenses/models/transaction.dart';
import 'package:my_expenses/models/wallet.dart';

class AppData {
  Wallet wallet = Wallet(
    name: "Main Wallet",
    balance: 0,
  );

  List<Transaction> transactions = [];

  void addTransaction(Transaction transaction){
    transactions.insert(0, transaction);
    transaction.transactionType == TransactionType.income ? wallet.balance += transaction.amount : wallet.balance -= transaction.amount;
  }

  void deleteTransaction(String id){
    int index = transactions.indexWhere((transaction) => transaction.id == id);
    transactions[index].transactionType == TransactionType.income ?
        wallet.balance -= transactions[index].amount
        : wallet.balance += transactions[index].amount;
    transactions.removeAt(index);
  }

  void editTransaction(Transaction updated){
    int index = transactions.indexWhere((transaction) => transaction.id == updated.id);
    if (index != -1){
      Transaction oldTransaction = transactions[index];
      double oldAmount = oldTransaction.amount;
      double newAmount = updated.amount;
      transactions[index] = updated;
      if(oldTransaction.transactionType == TransactionType.income && updated.transactionType == TransactionType.income){
        wallet.balance += newAmount - oldAmount;
      }
      else if(oldTransaction.transactionType == TransactionType.expense && updated.transactionType == TransactionType.expense){
        wallet.balance += oldAmount - newAmount;
      }
      else if(oldTransaction.transactionType == TransactionType.income && updated.transactionType == TransactionType.expense){
        wallet.balance -= oldAmount + newAmount;
      }
      else {
        wallet.balance += oldAmount + newAmount;
      }
    }
  }

}
import 'package:my_expenses/models/goal.dart';
import 'package:my_expenses/models/monthly_budget.dart';
import 'package:my_expenses/models/transaction.dart';
import 'package:my_expenses/models/wallet.dart';

class AppData {
  Wallet wallet = Wallet(
    name: "Main Wallet",
    balance: 0,
  );

  List<Transaction> transactions = [];
  List<MonthlyBudget> budgets = [];
  List<Goal> goals = [];



  void addTransaction(Transaction transaction){
    transactions.insert(0, transaction);
    transaction.transactionType == TransactionType.income ? wallet.balance += transaction.amount : wallet.balance -= transaction.amount;
    if (transaction.transactionType == TransactionType.expense){
      int index = budgets.indexWhere((budget) => budget.month == transaction.dateTime.month && budget.year == transaction.dateTime.year);
      budgets[index].addExpense(transaction.amount);
    }
  }

  void deleteTransaction(String id){
    int index = transactions.indexWhere((transaction) => transaction.id == id);
    if (transactions[index].transactionType == TransactionType.expense){
      int i = budgets.indexWhere((budget) => budget.month == transactions[index].dateTime.month && budget.year == transactions[index].dateTime.year);
      budgets[i].deleteExpense(transactions[index].amount);
    }
    transactions[index].transactionType == TransactionType.income ?
        wallet.balance -= transactions[index].amount
        : wallet.balance += transactions[index].amount;
    transactions.removeAt(index);
  }

  void editTransaction(Transaction updated){
    int index = transactions.indexWhere((transaction) => transaction.id == updated.id);
    if (index != -1){
      int i = budgets.indexWhere((b) => b.month == updated.dateTime.month && b.year == updated.dateTime.year);
      Transaction oldTransaction = transactions[index];
      double oldAmount = oldTransaction.amount;
      double newAmount = updated.amount;
      transactions[index] = updated;
      if(oldTransaction.transactionType == TransactionType.income && updated.transactionType == TransactionType.income){
        wallet.balance += newAmount - oldAmount;
      }
      else if(oldTransaction.transactionType == TransactionType.expense && updated.transactionType == TransactionType.expense){
        wallet.balance += oldAmount - newAmount;
        budgets[i].addExpense(newAmount - oldAmount);
      }
      else if(oldTransaction.transactionType == TransactionType.income && updated.transactionType == TransactionType.expense){
        wallet.balance -= oldAmount + newAmount;
        budgets[i].addExpense(newAmount);
      }
      else {
        wallet.balance += oldAmount + newAmount;
        budgets[i].deleteExpense(oldAmount);
      }
    }
  }


  //add a monthly budget to the list
  void addBudget(MonthlyBudget budget){
    budgets.add(budget);
  }


  //add a goal to the list
  void addGoal(Goal goal){
    goals.add(goal);
  }

}
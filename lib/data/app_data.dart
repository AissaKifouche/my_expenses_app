import 'package:my_expenses/models/goal.dart';
import 'package:my_expenses/models/monthly_budget.dart';
import 'package:my_expenses/models/transaction.dart';
import 'package:my_expenses/models/wallet.dart';
import 'package:my_expenses/widgets/currency.dart';

class AppData {
  Wallet wallet = Wallet(
    name: "Main Wallet",
    balance: 0,
  );

  Currency currency = currencies[0];
  List<Transaction> transactions = [];
  List<MonthlyBudget> budgets = [];
  List<Goal> goals = [];



  void addTransaction(Transaction transaction){
    transactions.insert(0, transaction);
    transaction.transactionType == TransactionType.income ? wallet.balance += transaction.amount : wallet.balance -= transaction.amount;
    if (transaction.transactionType == TransactionType.expense){
      int index = budgets.indexWhere((budget) => budget.month == transaction.dateTime.month && budget.year == transaction.dateTime.year);
      if(index != -1 ){
        budgets[index].addExpense(transaction.amount);
      }
    }
  }

  void deleteTransaction(String id){
    int index = transactions.indexWhere((transaction) => transaction.id == id);
    if (transactions[index].transactionType == TransactionType.expense){
      int i = budgets.indexWhere((budget) => budget.month == transactions[index].dateTime.month && budget.year == transactions[index].dateTime.year);
      if (i != -1){
        budgets[i].deleteExpense(transactions[index].amount);
      }
    }
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
      int j = budgets.indexWhere((test) => test.year == oldTransaction.dateTime.year && test.month == oldTransaction.dateTime.month);
      int i = budgets.indexWhere((b) => b.month == updated.dateTime.month && b.year == updated.dateTime.year);

      //case both are incomes
      if(oldTransaction.transactionType == TransactionType.income && updated.transactionType == TransactionType.income){
        wallet.balance += newAmount - oldAmount;
      }

      //case both are expenses
      else if(oldTransaction.transactionType == TransactionType.expense && updated.transactionType == TransactionType.expense){
        wallet.balance += oldAmount - newAmount;
        if (i != -1){
          budgets[i].addExpense(newAmount);
        }

        if (j != -1){
          budgets[j].deleteExpense(oldAmount);
        }

      }

      //case old is income new is expense
      else if(oldTransaction.transactionType == TransactionType.income && updated.transactionType == TransactionType.expense){
        wallet.balance -= oldAmount + newAmount;
        if (i != -1){
          budgets[i].addExpense(newAmount);
        }
      }

      //case old is expense new is income
      else {
        wallet.balance += oldAmount + newAmount;
        if (j != -1){
          budgets[j].deleteExpense(oldAmount);
        }
      }
    }
  }


  //add a monthly budget to the list
  void addBudget(MonthlyBudget budget){
    budget.addExpense(
        transactions.where((test)
        => test.transactionType == TransactionType.expense &&
            test.dateTime.year == budget.year &&
            test.dateTime.month == budget.month
        ).fold(0, (sum, transaction) => sum + transaction.amount)
    );
    budgets.add(budget);
  }


  //add a goal to the list
  void addGoal(Goal goal){
    goals.add(goal);
  }


  bool addMoneyToGoal(String goalId, double amount){
    if (wallet.balance < amount) {
      return false;
    }

    final goal = goals.firstWhere((g) => g.id == goalId);
    wallet.balance -= amount;
    goal.savedAmount += amount;

    return true;
  }

  bool removeMoneyFromGoal(String goalId, double amount){
    final goal = goals.firstWhere((g) => g.id == goalId);
    if (goal.savedAmount < amount ){
      return false;
    }

    goal.savedAmount -= amount;
    wallet.balance += amount;
    return true;
  }

  void deleteGoal(String id){
    int i = goals.indexWhere((test) => test.id == id);
    wallet.balance += goals[i].savedAmount;
    goals.removeAt(i);
  }

  void editGoal(Goal updated){
    int i = goals.indexWhere((test) => test.id == updated.id);
    if(i != -1){
      goals[i] = updated;
    }
  }


  //get expenses of a month
  double getMonthlyExpenses(int year, int month){
    return transactions.where((test)
      => test.transactionType == TransactionType.expense &&
        test.dateTime.year == year &&
        test.dateTime.month == month
    ).fold(0, (sum, transaction) => sum + transaction.amount);
  }

  //get income of a month
  double getMonthlyIncome(int year, int month){
    return transactions.where((test)
    => test.transactionType == TransactionType.income &&
        test.dateTime.year == year &&
        test.dateTime.month == month
    ).fold(0, (sum, transaction) => sum + transaction.amount);
  }

  //to get expenses by category
  Map<Category, double> getMonthlyExpensesByCategory(int year, int month){
    final result = <Category, double>{};

    for(final transaction in transactions){
      if( transaction.transactionType == TransactionType.expense &&
          transaction.dateTime.year == year &&
          transaction.dateTime.month == month
      ){
        result[transaction.category] = (result[transaction.category] ?? 0) + transaction.amount;
      }
    }

    return result;
  }

}
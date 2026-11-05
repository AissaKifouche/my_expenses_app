import 'package:my_expenses/models/goal.dart';
import 'package:my_expenses/models/monthly_budget.dart';
import 'package:my_expenses/models/transaction.dart';
import 'package:my_expenses/models/wallet.dart';
import 'package:my_expenses/widgets/currency.dart';
import '../database/app_database.dart' as ad;
import '../database/Daos/currency_dao.dart' as cd;
import '../database/Daos/app_settings_dao.dart' as asd;
import '../database/Daos/wallet_dao.dart' as wd;
import '../database/Daos/transaction_dao.dart' as td;
import 'package:drift/drift.dart';
import '../database/tables/wallets.dart';

class AppData {

  final ad.AppDatabase database;

  late final cd.CurrencyDao _currencyDao;
  late final asd.AppSettingsDao _appSettingsDao;
  late final wd.WalletDao _walletDao;
  late final td.TransactionDao _transactionDao;

  AppData(this.database) {
    _currencyDao = cd.CurrencyDao(database);
    _appSettingsDao = asd.AppSettingsDao(database);
    _walletDao = wd.WalletDao(database);
    _transactionDao = td.TransactionDao(database);
  }


  late Wallet wallet;

  List<Currency> currencies = [];
  late Currency currency;

  List<Transaction> transactions = [];
  List<MonthlyBudget> budgets = [];
  List<Goal> goals = [];

  bool isInitialized = false;

  Future<void> initialize() async {
    currencies = await _currencyDao.getCurrencies();

    final selectedCurrencyId = await _appSettingsDao.getSelectedCurrencyId();
    final selectedCurrency = currencies.where((c) => c.id == selectedCurrencyId);

    if (selectedCurrency.isEmpty) throw StateError("The selected currency was not found");

    currency = selectedCurrency.first;
    isInitialized = true;
    wallet = (await _walletDao.getWallet()) ?? (throw StateError("Main wallet was not found"));
  }

  Future<void> changeCurrency(Currency newCurrency) async {
    if(!currencies.any((c) => c.id == newCurrency.id)) {
      throw ArgumentError("Currency does not exist in the available list");
    }

    final updated = await _appSettingsDao.setSelectedCurrency(newCurrency.id);
    if (!updated) {
      throw StateError("Could not update the selected currency");
    }
    currency = newCurrency;
  }



  Future<Transaction> addTransaction(TransactionDraft draft) async {
    final result = await database.transaction(() async {
      final currentWallet = await _walletDao.getWallet();

      if (currentWallet == null ){
        throw StateError("Main wallet was not found.");
      }

      final id = await _transactionDao.insertTransaction(draft);

      final savedTransaction = await _transactionDao.getTransactionById(id);
      if(savedTransaction == null) {
        throw StateError("Could not retrieve the inserted transaction.");
      }

      final delta = savedTransaction.transactionType == TransactionType.income
        ? savedTransaction.amount : -savedTransaction.amount;

      final newBalance = currentWallet.balance + delta;

      final updated = await _walletDao.updateWallet(
          id,
          ad.WalletsCompanion(
            balance: Value(newBalance),
          ),
      );

      if(!updated) {
        throw StateError('Could not update wallet balance.');
      }

      return (transaction: savedTransaction, balance: newBalance);
    });

    wallet.balance = result.balance;
    transactions.insert(0, result.transaction);

    if (result.transaction.transactionType == TransactionType.expense) {
      final index = budgets.indexWhere(
          (b) =>
              b.month == result.transaction.dateTime.month && b.year == result.transaction.dateTime.year,
      );

      if(index != -1) {
        budgets[index].addExpense(result.transaction.amount);
      }
    }

    return result.transaction;
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



  //a method that returns the expenses of last 6 months
  List<MonthlyExpense> getLastSixMonthsExpenses(int year, int month) {
    final result = <MonthlyExpense>[];
    DateTime selectedDate = DateTime(year, month);
    for (int i = 5; i >= 0; i--) {
      final date = DateTime(
        selectedDate.year,
        selectedDate.month - i,
      );
      final amount = getMonthlyExpenses(
        date.year,
        date.month,
      );
      result.add(
        MonthlyExpense(
          year: date.year,
          month: date.month,
          amount: amount,
        ),
      );
    }
    return result;
  }

}


//the piece of data used in getLastSixMonthsExpenses
class MonthlyExpense {
  final int year;
  final int month;
  final double amount;

  MonthlyExpense({
    required this.year,
    required this.month,
    required this.amount,
  });
}
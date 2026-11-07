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
import '../database/Daos/goal_dao.dart' as gd;
import '../database/Daos/monthly_budget_dao.dart' as mbd;
import 'package:drift/drift.dart';

class AppData {

  final ad.AppDatabase database;

  late final cd.CurrencyDao _currencyDao;
  late final asd.AppSettingsDao _appSettingsDao;
  late final wd.WalletDao _walletDao;
  late final td.TransactionDao _transactionDao;
  late final gd.GoalDao _goalDao;
  late final mbd.MonthlyBudgetDao _monthlyBudgetDao;

  AppData(this.database) {
    _currencyDao = cd.CurrencyDao(database);
    _appSettingsDao = asd.AppSettingsDao(database);
    _walletDao = wd.WalletDao(database);
    _transactionDao = td.TransactionDao(database);
    _goalDao = gd.GoalDao(database);
    _monthlyBudgetDao = mbd.MonthlyBudgetDao(database);
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

    wallet = (await _walletDao.getWallet()) ?? (throw StateError("Main wallet was not found"));
    transactions = await _transactionDao.getAll();
    goals = await _goalDao.getGoals();
    budgets = await _monthlyBudgetDao.getAll();
    isInitialized = true;
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
      if (savedTransaction.transactionType == TransactionType.expense) {
        await _changeBudgetSpent(
          savedTransaction.dateTime.year,
          savedTransaction.dateTime.month,
          savedTransaction.amount,
        );
      }

      final delta = savedTransaction.transactionType == TransactionType.income
        ? savedTransaction.amount : -savedTransaction.amount;

      final newBalance = currentWallet.balance + delta;

      final updated = await _walletDao.updateWallet(
          currentWallet.id,
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
      budgets = await _monthlyBudgetDao.getAll();
    }

    return result.transaction;
  }

  Future<bool> deleteTransaction(int id) async {
    final index = transactions.indexWhere((t) => t.id == id);

    if (index == -1) return false;

    final oldTransaction = transactions[index];

    final newBalance = await database.transaction(() async {
      final currentWallet = await _walletDao.getWallet();
      if (currentWallet == null) {
        throw StateError('Main wallet was not found.');
      }

      final deleted = await _transactionDao.deleteTransaction(id);
      if(!deleted) return null;

      if (oldTransaction.transactionType == TransactionType.expense) {
        await _changeBudgetSpent(
          oldTransaction.dateTime.year,
          oldTransaction.dateTime.month,
          -oldTransaction.amount,
        );
      }

      final delta = oldTransaction.transactionType == TransactionType.income ?
          -oldTransaction.amount
          : oldTransaction.amount;

      final balance = currentWallet.balance + delta;

      final updated = await _walletDao.updateWallet(
          currentWallet.id,
          ad.WalletsCompanion(balance: Value(balance),),
      );

      if (!updated) {
        throw StateError('Could not update wallet balance.');
      }

      return balance;
    });

    if (newBalance == null) return false;

    wallet.balance = newBalance;
    if(oldTransaction.transactionType == TransactionType.expense){
      budgets = await _monthlyBudgetDao.getAll();
    }

    transactions.removeAt(index);
    return true;
  }

  Future<bool> editTransaction(Transaction updatedTransaction) async {
    final index = transactions.indexWhere(
          (t) => t.id == updatedTransaction.id,
    );

    if (index == -1) return false;

    final oldTransaction = transactions[index];

    final newBalance = await database.transaction(() async {
      final currentWallet = await _walletDao.getWallet();

      if (currentWallet == null) {
        throw StateError('Main wallet was not found.');
      }

      final updated = await _transactionDao.updateTransaction(
        updatedTransaction.id,
        updatedTransaction,
      );

      if (!updated) return null;

      // Reverse the old expense.
      if (oldTransaction.transactionType == TransactionType.expense) {
        await _changeBudgetSpent(
          oldTransaction.dateTime.year,
          oldTransaction.dateTime.month,
          -oldTransaction.amount,
        );
      }

      // Apply the new expense.
      if (updatedTransaction.transactionType == TransactionType.expense) {
        await _changeBudgetSpent(
          updatedTransaction.dateTime.year,
          updatedTransaction.dateTime.month,
          updatedTransaction.amount,
        );
      }

      double effect(Transaction t) {
        return t.transactionType == TransactionType.income
            ? t.amount
            : -t.amount;
      }

      final balance = currentWallet.balance +
          effect(updatedTransaction) -
          effect(oldTransaction);

      final walletUpdated = await _walletDao.updateWallet(
        currentWallet.id,
        ad.WalletsCompanion(balance: Value(balance)),
      );

      if (!walletUpdated) {
        throw StateError('Could not update wallet balance.');
      }

      return balance;
    });

    if (newBalance == null) return false;

    wallet.balance = newBalance;

    if (oldTransaction.transactionType == TransactionType.expense ||
        updatedTransaction.transactionType == TransactionType.expense) {
      budgets = await _monthlyBudgetDao.getAll();
    }



    transactions[index] = updatedTransaction;
    return true;
  }


  //add a monthly budget to the database
  Future<MonthlyBudget> addBudget(MonthlyBudgetDraft draft) async {
    final spent = getMonthlyExpenses(draft.year, draft.month);

    final savedDraft = MonthlyBudgetDraft(
      year: draft.year,
      month: draft.month,
      amount: draft.amount,
      spent: spent,
    );

    final savedBudget = await database.transaction(() async {
      final id = await _monthlyBudgetDao.insertMonthlyBudget(savedDraft);

      final budget = await _monthlyBudgetDao.getMonthlyBudgetById(id);

      if (budget == null) {
        throw StateError('Could not retrieve the inserted budget.');
      }

      return budget;
    });

    budgets.add(savedBudget);

    return savedBudget;
  }

  Future<bool> deleteBudget(int id) async {
    final deleted = await _monthlyBudgetDao.deleteMonthlyBudget(id);

    if (!deleted) return false;

    budgets.removeWhere((budget) => budget.id == id);

    return true;
  }


  Future<void> _changeBudgetSpent(
      int year,
      int month,
      double amount,
      ) async {
    final budget = await _monthlyBudgetDao.getByYearMonth(year, month);

    if (budget == null) return;

    final newSpent = (budget.spent + amount).clamp(0.0, double.infinity);

    final updatedBudget = MonthlyBudget(
      id: budget.id,
      year: budget.year,
      month: budget.month,
      amount: budget.amount,
      spent: newSpent,
    );

    final updated = await _monthlyBudgetDao.updateMonthlyBudget(updatedBudget);

    if (!updated) {
      throw StateError('Could not update monthly budget spending.');
    }
  }


  //add a goal to the database
  Future<Goal> addGoal(GoalDraft draft) async {
    final savedGoal = await database.transaction(() async {
      final id = await _goalDao.insertGoal(draft);
      final goal = await _goalDao.getGoalById(id);
      if (goal == null) {
        throw StateError('Could not retrieve the inserted goal.');
      }
      return goal;
    });
    goals.add(savedGoal);
    return savedGoal;
  }


  Future<bool> addMoneyToGoal(int goalId, double amount) async {
    if (amount <= 0 || !amount.isFinite) return false;

    final result = await database.transaction(() async {
      final currentWallet = await _walletDao.getWallet();
      final currentGoal = await _goalDao.getGoalById(goalId);

      if (currentWallet == null || currentGoal == null) {
        return null;
      }

      if (currentWallet.balance < amount) {
        return null;
      }

      final updatedGoal = Goal(
        id: currentGoal.id,
        title: currentGoal.title,
        targetedAmount: currentGoal.targetedAmount,
        savedAmount: currentGoal.savedAmount + amount,
      );

      final goalUpdated = await _goalDao.updateGoal(updatedGoal);

      if (!goalUpdated) {
        throw StateError('Could not update goal balance.');
      }

      final newWalletBalance = currentWallet.balance - amount;

      final walletUpdated = await _walletDao.updateWallet(
        currentWallet.id,
        ad.WalletsCompanion(
          balance: Value(newWalletBalance),
        ),
      );

      if (!walletUpdated) {
        throw StateError('Could not update wallet balance.');
      }

      return (
      goal: updatedGoal,
      walletBalance: newWalletBalance,
      );
    });

    if (result == null) return false;

    wallet.balance = result.walletBalance;

    final index = goals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      goals[index] = result.goal;
    }

    return true;
  }

  Future<bool> removeMoneyFromGoal(int goalId, double amount) async {
    if (amount <= 0 || !amount.isFinite) return false;

    final result = await database.transaction(() async {
      final currentWallet = await _walletDao.getWallet();
      final currentGoal = await _goalDao.getGoalById(goalId);

      if (currentWallet == null || currentGoal == null) {
        return null;
      }

      if (currentGoal.savedAmount < amount) {
        return null;
      }

      final updatedGoal = Goal(
        id: currentGoal.id,
        title: currentGoal.title,
        targetedAmount: currentGoal.targetedAmount,
        savedAmount: currentGoal.savedAmount - amount,
      );

      final goalUpdated = await _goalDao.updateGoal(updatedGoal);

      if (!goalUpdated) {
        throw StateError('Could not update goal balance.');
      }

      final newWalletBalance = currentWallet.balance + amount;

      final walletUpdated = await _walletDao.updateWallet(
        currentWallet.id,
        ad.WalletsCompanion(
          balance: Value(newWalletBalance),
        ),
      );

      if (!walletUpdated) {
        throw StateError('Could not update wallet balance.');
      }

      return (
      goal: updatedGoal,
      walletBalance: newWalletBalance,
      );
    });

    if (result == null) return false;

    wallet.balance = result.walletBalance;

    final index = goals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      goals[index] = result.goal;
    }

    return true;
  }

  Future<bool> deleteGoal(int id) async {
    final result = await database.transaction(() async {
      final currentGoal = await _goalDao.getGoalById(id);

      if (currentGoal == null) {
        return null;
      }

      final currentWallet = await _walletDao.getWallet();

      if (currentWallet == null) {
        throw StateError('Main wallet was not found.');
      }

      final deleted = await _goalDao.deleteGoal(id);

      if (!deleted) {
        return null;
      }

      // Return the goal's saved money to the wallet.
      final newWalletBalance =
          currentWallet.balance + currentGoal.savedAmount;

      final walletUpdated = await _walletDao.updateWallet(
        currentWallet.id,
        ad.WalletsCompanion(
          balance: Value(newWalletBalance),
        ),
      );

      if (!walletUpdated) {
        throw StateError('Could not update wallet balance.');
      }

      return newWalletBalance;
    });

    if (result == null) return false;

    wallet.balance = result;
    goals.removeWhere((g) => g.id == id);

    return true;
  }

  Future<bool> editGoal(Goal updated) async {
    final index = goals.indexWhere((g) => g.id == updated.id);

    if (index == -1) return false;

    final success = await _goalDao.updateGoal(updated);

    if (!success) return false;

    goals[index] = updated;

    return true;
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
import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/wallets.dart';

part 'wallet_dao.g.dart';

@DriftAccessor(tables: [Wallets])
class WalletDao extends DatabaseAccessor<AppDatabase>
    with _$WalletDaoMixin {
  WalletDao(AppDatabase db) : super(db);

  Future<List<Wallet>> getAll() {
    return select(wallets).get();
  }

  Future<Wallet?> getWallet() {
    return select(wallets).getSingleOrNull();
  }

  Future<int> insertWallet(WalletsCompanion wallet) {
    return into(wallets).insert(wallet);
  }

  Future<bool> updateWallet(
      int id,
      WalletsCompanion wallet,
      ) async {
    final count = await (update(wallets)
      ..where((wallet) => wallet.id.equals(id)))
        .write(wallet);

    return count > 0;
  }

  Future<bool> deleteWallet(int id) async {
    final count = await (delete(wallets)
      ..where((wallet) => wallet.id.equals(id)))
        .go();

    return count > 0;
  }

  Future<bool> addToWallet(double amount) async {
    final mainWallet = await getWallet();

    if (mainWallet == null) {
      return false;
    }

    final newBalance = mainWallet.balance + amount;

    final count = await (update(wallets)
      ..where((wallet) => wallet.id.equals(mainWallet.id)))
        .write(
      WalletsCompanion(
        balance: Value(newBalance),
      ),
    );

    return count > 0;
  }

  Future<bool> subtractFromWallet(double amount) async {
    final mainWallet = await getWallet();

    if (mainWallet == null) {
      return false;
    }

    final newBalance = mainWallet.balance - amount;

    final count = await (update(wallets)
      ..where((wallet) => wallet.id.equals(mainWallet.id)))
        .write(
      WalletsCompanion(
        balance: Value(newBalance),
      ),
    );

    return count > 0;
  }
}
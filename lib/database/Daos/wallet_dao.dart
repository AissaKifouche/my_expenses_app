import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/wallets.dart';
import '../../models/wallet.dart' as model;

part 'wallet_dao.g.dart';

@DriftAccessor(tables: [Wallets])
class WalletDao extends DatabaseAccessor<AppDatabase>
    with _$WalletDaoMixin {
  WalletDao(super.db);

  Future<model.Wallet?> getWallet() async {
    final row = await select(wallets).getSingleOrNull();
    return row == null ? null : _toWalletModel(row);
  }

  Future<int> insertWallet(WalletsCompanion wallet) {
    return into(wallets).insert(wallet);
  }

  Future<bool> updateWallet(
      int id,
      WalletsCompanion wallet,
      ) async {
    final count = await (update(wallets)
      ..where((w) => w.id.equals(id)))
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
    final wallet = await getWallet();

    if (wallet == null) return false;

    return updateWallet(
      wallet.id,
      WalletsCompanion(
        balance: Value(wallet.balance + amount),
      ),
    );
  }

  Future<bool> subtractFromWallet(double amount) async {
    final wallet = await getWallet();

    if (wallet == null) return false;

    return updateWallet(wallet.id, WalletsCompanion(
      balance: Value(wallet.balance - amount),
    ));
  }

  model.Wallet _toWalletModel(Wallet row) {
    return model.Wallet(
        id: row.id,
        name: row.name,
        balance: row.balance,
    );
  }
}
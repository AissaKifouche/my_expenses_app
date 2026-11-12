# My Expenses

My Expenses is a personal finance management application built with Flutter. It helps users track their income and expenses, manage their monthly budgets, monitor their savings goals, and keep an overview of their financial activity.

## Features

- **Transaction Management:** Create, edit, delete, and browse income and expense transactions.
- **Transaction Filtering:** Filter transactions by date range and transaction type (income or expense).
- **Wallet Management:** Automatically update the wallet balance whenever a transaction is added, edited, or deleted.
- **Monthly Budgets:** Set monthly spending limits and track expenses against those limits.
- **Savings Goals:** Create savings goals, track progress, and add or withdraw money.
- **Statistics:** Visualize financial activity through monthly summaries and expense breakdowns.
- **Currency Selection:** Choose a preferred currency for displaying financial amounts.
- **Local Data Storage:** Persist application data locally using SQLite.

## Screenshots

<!-- Screenshots will be added here. -->

## Built With

- **[Flutter](https://flutter.dev/)** — Cross-platform UI framework.
- **[Dart](https://dart.dev/)** — Programming language.
- **[Drift](https://drift.simonbinder.eu/)** — Type-safe SQLite database library.
- **[SQLite](https://www.sqlite.org/)** — Local relational database.
- **[Provider](https://pub.dev/packages/provider)** — Dependency injection for sharing the database instance across the widget tree.

## Installation

1. Go to the [Releases](https://github.com/AissaKifouche/my_expenses_app/releases) page.
2. Download the latest APK.
3. Install the APK on your Android device.

## Database

My Expenses uses **SQLite** with **Drift** to store application data locally on the device.

The database manages:
- Wallet information and balance.
- Income and expense transactions.
- Transaction categories and types.
- Monthly budgets.
- Savings goals.
- Currencies and application settings.

## Project Status

My Expenses is currently under development. New features, improvements, and bug fixes may be introduced in future updates.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

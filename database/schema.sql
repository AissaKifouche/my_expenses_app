PRAGMA foreign_keys = ON;

CREATE TABLE currencies (
    id INTEGER PRIMARY KEY,
    code TEXT NOT NULL,
    name TEXT NOT NULL,
    symbol TEXT NOT NULL,
    flag TEXT NOT NULL
);

CREATE TABLE app_settings (
    id INTEGER PRIMARY KEY,
    selected_currency_id INTEGER NOT NULL,
    FOREIGN KEY (selected_currency_id) REFERENCES currencies(id)
);

CREATE TABLE wallets (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    balance REAL NOT NULL
);

CREATE TABLE transaction_types (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE categories (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE transactions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    transaction_type_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    date_time TEXT NOT NULL,
    amount REAL NOT NULL,
    note TEXT,
    FOREIGN KEY (transaction_type_id) REFERENCES transaction_types(id),
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE goals (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    target_amount REAL NOT NULL CHECK (target_amount > 0),
    saved_amount REAL NOT NULL CHECK (
        saved_amount >= 0 AND saved_amount <= target_amount
    )
);

CREATE TABLE monthly_budgets (
    id INTEGER PRIMARY KEY,
    year INTEGER NOT NULL,
    month INTEGER NOT NULL CHECK (month BETWEEN 1 AND 12),
    amount REAL NOT NULL CHECK (amount >= 0),
    spent REAL NOT NULL CHECK (spent >= 0),
    UNIQUE (year, month)
);
PRAGMA foreign_keys = ON;

INSERT INTO transaction_types (name)
VALUES
    ('income'),
    ('expense');

INSERT INTO categories (name)
VALUES
    ('shopping'),
    ('bills'),
    ('entertainment'),
    ('studies'),
    ('transport'),
    ('salary'),
    ('freelance'),
    ('other');


INSERT INTO currencies (code, name, symbol, flag)
VALUES
    ('USD', 'US Dollar', '$', '🇺🇸'),
    ('EUR', 'Euro', '€', '🇪🇺'),
    ('DZD', 'Algerian Dinar', 'DA', '🇩🇿'),
    ('GBP', 'British Pound', '£', '🇬🇧'),
    ('CAD', 'Canadian Dollar', 'CA$', '🇨🇦'),
    ('SAR', 'Saudi Riyal', 'SR', '🇸🇦'),
    ('AED', 'UAE Dirham', 'AED', '🇦🇪');

INSERT INTO app_settings (id, selected_currency_id)
VALUES (1, 1);


INSERT INTO wallets (id, name, balance)
VALUES (1, 'Main Wallet', 0);
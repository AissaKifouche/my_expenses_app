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
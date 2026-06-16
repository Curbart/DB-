- ── 1. AUTHOR ────────────────────────────────────────────────
CREATE TABLE author (
    author_id   SERIAL PRIMARY KEY,
    first_name  VARCHAR(100) NOT NULL,
    last_name   VARCHAR(100) NOT NULL,
    nationality VARCHAR(100)
);
 
INSERT INTO author (first_name, last_name, nationality) VALUES
    ('Ліна',      'Костенко',  'Українська'),
    ('Frank',     'Herbert',   'Американська'),
    ('George',    'Orwell',    'Британська'),
    ('Іван',      'Франко',    'Українська'),
    ('Haruki',    'Murakami',  'Японська');
 
 
-- ── 2. BOOK ──────────────────────────────────────────────────
CREATE TABLE book (
    book_id        SERIAL PRIMARY KEY,
    title          VARCHAR(255) NOT NULL,
    isbn           VARCHAR(20)  NOT NULL UNIQUE,
    year_published INTEGER      CHECK (year_published BETWEEN 1000 AND 2100),
    genre          VARCHAR(100)
);
 
INSERT INTO book (title, isbn, year_published, genre) VALUES
    ('Маруся Чурай',            '978-966-03-1234-1', 1979, 'Роман у віршах'),
    ('Dune',                    '978-0-441-17271-9', 1965, 'Наукова фантастика'),
    ('1984',                    '978-0-452-28423-4', 1949, 'Антиутопія'),
    ('Захар Беркут',            '978-966-03-5678-2', 1883, 'Історична проза'),
    ('Norwegian Wood',          '978-0-375-70402-6', 1987, 'Сучасна проза');
 
 
-- ── 3. BOOK_AUTHOR (M:N) ─────────────────────────────────────
CREATE TABLE book_author (
    book_id   INTEGER NOT NULL REFERENCES book(book_id),
    author_id INTEGER NOT NULL REFERENCES author(author_id),
    PRIMARY KEY (book_id, author_id)
);
 
INSERT INTO book_author (book_id, author_id) VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5);
 
 
-- ── 4. COPY ──────────────────────────────────────────────────
CREATE TABLE copy (
    copy_id   SERIAL PRIMARY KEY,
    book_id   INTEGER     NOT NULL REFERENCES book(book_id),
    condition VARCHAR(50) NOT NULL DEFAULT 'good'
                          CHECK (condition IN ('new', 'good', 'worn', 'damaged')),
    status    VARCHAR(20) NOT NULL DEFAULT 'available'
                          CHECK (status IN ('available', 'on_loan', 'damaged', 'lost'))
);
 
INSERT INTO copy (book_id, condition, status) VALUES
    (1, 'good',    'available'),
    (1, 'worn',    'on_loan'),
    (2, 'new',     'available'),
    (3, 'good',    'available'),
    (4, 'damaged', 'damaged'),
    (5, 'good',    'on_loan');
 
 
-- ── 5. MEMBER ────────────────────────────────────────────────
CREATE TABLE member (
    member_id       SERIAL PRIMARY KEY,
    full_name       VARCHAR(200) NOT NULL,
    email           VARCHAR(200) NOT NULL UNIQUE,
    phone           VARCHAR(20),
    membership_date DATE         NOT NULL DEFAULT CURRENT_DATE,
    expiry_date     DATE         NOT NULL,
    CONSTRAINT chk_expiry CHECK (expiry_date > membership_date)
);
 
INSERT INTO member (full_name, email, phone, membership_date, expiry_date) VALUES
    ('Олена Мельник',  'o.melnyk@email.com',  '+380501234567', '2024-01-10', '2025-01-10'),
    ('Тарас Шевченко', 't.shevchenko@ukr.net', '+380671234567', '2024-03-15', '2025-03-15'),
    ('Марія Іваненко', 'm.ivanenko@gmail.com', '+380931234567', '2023-09-01', '2024-09-01'),
    ('Андрій Коваль',  'a.koval@ukr.net',      NULL,            '2024-06-20', '2025-06-20'),
    ('Sofía García',   'sofia.g@example.com',  '+380661234567', '2024-11-05', '2025-11-05');
 
 
-- ── 6. LOAN ──────────────────────────────────────────────────
CREATE TABLE loan (
    loan_id     SERIAL PRIMARY KEY,
    copy_id     INTEGER NOT NULL REFERENCES copy(copy_id),
    member_id   INTEGER NOT NULL REFERENCES member(member_id),
    loan_date   DATE    NOT NULL DEFAULT CURRENT_DATE,
    due_date    DATE    NOT NULL,
    return_date DATE,
    CONSTRAINT chk_due      CHECK (due_date > loan_date),
    CONSTRAINT chk_return   CHECK (return_date IS NULL OR return_date >= loan_date)
);
 
INSERT INTO loan (copy_id, member_id, loan_date, due_date, return_date) VALUES
    (2, 1, '2025-01-05', '2025-01-19', NULL),
    (6, 2, '2025-01-10', '2025-01-24', NULL),
    (3, 3, '2024-12-01', '2024-12-15', '2024-12-14'),
    (4, 4, '2024-11-20', '2024-12-04', '2024-12-03'),
    (1, 5, '2024-10-10', '2024-10-24', '2024-10-22');
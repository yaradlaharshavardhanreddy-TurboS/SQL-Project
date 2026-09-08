CREATE DATABASE Banking_Management_System;

USE Banking_Management_System;

CREATE TABLE BRANCHES(
    BRANCH_ID INT PRIMARY KEY,
    BRANCH_NAME VARCHAR(20),
    LOCATION VARCHAR(30),
    IFSC_CODE VARCHAR(30)
);

INSERT INTO BRANCHES VALUES
(1,'MG ROAD','BENGALURU','IFSC001'),
(2,'BANJARA HILLS','HYDERABAD','IFSC002'),
(3,'GOVERNORPET','VIJAYAWADA','IFSC003'),
(4,'DWARAKA NAGAR','VIZAG','IFSC004'),
(5,'BRODIPET','GUNTUR','IFSC005');


CREATE TABLE CUSTOMERS(
    CUSTOMER_ID INT PRIMARY KEY,
    CUSTOMER_NAME VARCHAR(20),
    PHONE VARCHAR(30),
    EMAIL VARCHAR(30),
    ADDRESS VARCHAR(30)
);

INSERT INTO CUSTOMERS VALUES
(1,'AARAV','9000000001','AARAV@MAIL.COM','BENGALURU'),
(2,'BHAVYA','9000000002','BHAVYA@MAIL.COM','HYDERABAD'),
(3,'CHARAN','9000000003','CHARAN@MAIL.COM','VIJAYAWADA'),
(4,'DEEPIKA','9000000004','DEEPIKA@MAIL.COM','VIZAG'),
(5,'ESHA','9000000005','ESHA@MAIL.COM','GUNTUR'),
(6,'FARHAN','9000000006','FARHAN@MAIL.COM','NELLORE'),
(7,'GOPI','9000000007','GOPI@MAIL.COM','KURNOOL'),
(8,'HARI','9000000008','HARI@MAIL.COM','ONGOLE'),
(9,'ISHA','9000000009','ISHA@MAIL.COM','WARANGAL'),
(10,'JOHN','9000000010','JOHN@MAIL.COM','CHENNAI');


CREATE TABLE ACCOUNT_TYPES(
    ACCOUNT_TYPE_ID INT PRIMARY KEY,
    ACCOUNT_TYPE_NAME VARCHAR(30)
);

INSERT INTO ACCOUNT_TYPES VALUES
(1,'SAVINGS'),
(2,'CURRENT');


CREATE TABLE ACCOUNTS(
    ACCOUNT_ID INT PRIMARY KEY,
    BRANCH_ID INT,
    CUSTOMER_ID INT,
    ACCOUNT_TYPE_ID INT,
    ACCOUNT_NUMBER VARCHAR(30),
    BALANCE DECIMAL(12,2),
    OPENING_DATE DATE,
    STATUS VARCHAR(20),
    FOREIGN KEY (BRANCH_ID) REFERENCES BRANCHES(BRANCH_ID),
    FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMERS(CUSTOMER_ID),
    FOREIGN KEY (ACCOUNT_TYPE_ID) REFERENCES ACCOUNT_TYPES(ACCOUNT_TYPE_ID)
);

INSERT INTO ACCOUNTS VALUES
(101,1,1,1,'100000001',25000,'2025-01-01','ACTIVE'),
(102,2,2,1,'100000002',50000,'2025-01-02','ACTIVE'),
(103,2,3,1,'200000003',120000,'2025-01-03','ACTIVE'),
(104,3,3,1,'100000004',35000,'2025-01-04','ACTIVE'),
(105,4,4,1,'100000005',65000,'2025-01-05','ACTIVE'),
(106,4,4,2,'200000006',150000,'2025-01-06','ACTIVE'),
(107,5,5,2,'200000007',90000,'2025-01-07','ACTIVE'),
(108,1,1,1,'100000008',18000,'2025-01-08','INACTIVE'),
(109,2,2,1,'100000009',27000,'2025-01-09','ACTIVE'),
(110,3,3,2,'200000010',78000,'2025-01-10','ACTIVE'),
(111,4,4,1,'100000011',45000,'2025-01-11','ACTIVE'),
(112,5,4,2,'200000012',99000,'2025-01-12','ACTIVE'),
(113,1,5,1,'100000013',69000,'2025-01-13','ACTIVE'),
(114,1,1,2,'200000014',85000,'2025-01-14','ACTIVE'),
(115,3,3,2,'200000015',110000,'2025-01-15','ACTIVE');


CREATE TABLE TRANSACTIONS(
    TRANSACTION_ID INT PRIMARY KEY,
    ACCOUNT_ID INT,
    TRANSACTION_TYPE VARCHAR(20),
    AMOUNT DECIMAL(12,2),
    TRANSACTION_DATE DATE,
    DESCRIPTION VARCHAR(100),
    FOREIGN KEY (ACCOUNT_ID) REFERENCES ACCOUNTS(ACCOUNT_ID)
);

INSERT INTO TRANSACTIONS VALUES
(1,101,'DEPOSIT',5000.00,'2025-01-02','CASH DEPOSIT'),
(2,101,'WITHDRAW',2000.00,'2025-01-05','ATM WITHDRAW'),
(3,102,'DEPOSIT',10000.00,'2025-01-03','SALARY CREDIT'),
(4,103,'DEPOSIT',20000.00,'2025-01-04','CHEQUE DEPOSIT'),
(5,104,'WITHDRAW',5000.00,'2025-01-06','ONLINE PURCHASE');


SET SQL_SAFE_UPDATES = 0;

SELECT * FROM Customers;
SELECT *
FROM Accounts
WHERE status = 'Active';

UPDATE Accounts
SET status = 'Inactive'
WHERE account_id = 108;

SELECT 
    c.customer_name,
    a.account_number,
    at.account_type_name
FROM Customers c
JOIN Accounts a
    ON c.customer_id = a.customer_id
JOIN Account_Types at
    ON a.account_type_id = at.account_type_id;

SELECT
    a.account_number,
    b.branch_name,
    b.location
FROM Accounts a
JOIN Branches b
    ON a.branch_id = b.branch_id;


SELECT MAX(balance) AS highest_balance
FROM Accounts;

SELECT 
    c.customer_name,
    a.account_number,
    a.balance
FROM Customers c
JOIN Accounts a
    ON c.customer_id = a.customer_id
WHERE a.balance = (
    SELECT MAX(balance)
    FROM Accounts
);

SELECT
    CONCAT(c.customer_name, ' - ', a.account_number) AS customer_account
FROM Customers c
JOIN Accounts a
    ON c.customer_id = a.customer_id;

SELECT
    transaction_id,
    amount,
    CEIL(amount) AS ceiling_value,
    FLOOR(amount) AS floor_value
FROM Transactions;

SELECT
    account_id,
    account_number,
    opening_balance,
    balance,
    ABS(opening_balance - balance) AS balance_difference
FROM Accounts;

SELECT DISTINCT
    c.customer_name,
    b.branch_name,
    b.location
FROM Customers c
JOIN Accounts a
    ON c.customer_id = a.customer_id
JOIN Branches b
    ON a.branch_id = b.branch_id;

SELECT
    b.branch_name,
    SUM(t.amount) AS total_deposits
FROM Branches b
JOIN Accounts a
    ON b.branch_id = a.branch_id
JOIN Transactions t
    ON a.account_id = t.account_id
WHERE t.transaction_type = 'Deposit'
GROUP BY b.branch_name;

SELECT
    SUM(balance) AS total_balance
FROM Accounts;

SELECT
    MAX(balance) AS highest_balance,
    MIN(balance) AS lowest_balance,
    AVG(balance) AS average_balance
FROM Accounts;

SELECT
    SUM(CASE 
        WHEN transaction_type = 'Deposit'
        THEN amount ELSE 0 END) AS total_deposited,

    SUM(CASE 
        WHEN transaction_type = 'Withdrawal'
        THEN amount ELSE 0 END) AS total_withdrawn
FROM Transactions;

SELECT
    b.branch_name,
    COUNT(DISTINCT a.customer_id) AS customer_count
FROM Branches b
JOIN Accounts a
    ON b.branch_id = a.branch_id
GROUP BY b.branch_name;

SELECT
    at.account_type_name,
    COUNT(a.account_id) AS account_count
FROM Account_Types at
LEFT JOIN Accounts a
    ON at.account_type_id = a.account_type_id
GROUP BY at.account_type_name;

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(a.account_id) AS number_of_accounts
FROM Customers c
JOIN Accounts a
    ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(a.account_id) > 1;

SELECT *
FROM Transactions t
WHERE transaction_date = (
    SELECT MAX(t2.transaction_date)
    FROM Transactions t2
    WHERE t2.account_id = t.account_id
);

SELECT DISTINCT
    c.customer_name,
    a.balance
FROM Customers c
JOIN Accounts a
    ON c.customer_id = a.customer_id
WHERE a.balance = (
    SELECT MAX(balance)
    FROM Accounts
);

SELECT
    account_number,
    balance
FROM Accounts
WHERE balance > (
    SELECT AVG(balance)
    FROM Accounts
);

SELECT
    MONTH(transaction_date) AS month_number,
    MONTHNAME(transaction_date) AS month_name,
    ROUND(SUM(amount), 2) AS total_amount
FROM Transactions
GROUP BY
    MONTH(transaction_date),
    MONTHNAME(transaction_date)
ORDER BY month_number;

SELECT
    c.customer_id,
    c.customer_name
FROM Customers c
LEFT JOIN Accounts a
    ON c.customer_id = a.customer_id
LEFT JOIN Transactions t
    ON a.account_id = t.account_id
WHERE t.transaction_id IS NULL;


SELECT *
FROM Accounts
WHERE status = 'Inactive';


SELECT
    account_id,
    account_number,
    balance
FROM Accounts
ORDER BY balance DESC
LIMIT 5;

SELECT
    transaction_type,
    COUNT(*) AS transaction_count
FROM Transactions
GROUP BY transaction_type;

SELECT
    YEAR(transaction_date) AS year,
    MONTH(transaction_date) AS month,
    MONTHNAME(transaction_date) AS month_name,
    COUNT(*) AS total_transactions,
    SUM(amount) AS total_amount,
    ROUND(AVG(amount), 2) AS average_amount
FROM Transactions
GROUP BY
    YEAR(transaction_date),
    MONTH(transaction_date),
    MONTHNAME(transaction_date)
ORDER BY year, month;

SELECT
    b.branch_name,
    SUM(a.balance) AS total_balance
FROM Branches b
JOIN Accounts a
    ON b.branch_id = a.branch_id
GROUP BY b.branch_name;

SELECT
    UPPER(c.customer_name) AS customer_name,
    ROUND(a.balance, 0) AS rounded_balance
FROM Customers c
JOIN Accounts a
    ON c.customer_id = a.customer_id;

CREATE VIEW Active_Account_Details AS
SELECT
    a.account_id,
    a.account_number,
    a.balance,
    a.opening_date,
    a.status,
    c.customer_name,
    c.phone,
    c.email,
    b.branch_name,
    b.location,
    at.account_type_name
FROM Accounts a
JOIN Customers c
    ON a.customer_id = c.customer_id
JOIN Branches b
    ON a.branch_id = b.branch_id
JOIN Account_Types at
    ON a.account_type_id = at.account_type_id
WHERE a.status = 'Active';

SELECT *
FROM Active_Account_Details;

START TRANSACTION;

UPDATE Accounts
SET balance = balance - 10000
WHERE account_id = 101;

UPDATE Accounts
SET balance = balance + 10000
WHERE account_id = 102;

COMMIT;

SELECT account_id, account_number, balance
FROM Accounts
WHERE account_id IN (101, 102);

DELIMITER //

CREATE PROCEDURE GetCustomerAccounts(
    IN p_customer_id INT
)
BEGIN

    SELECT
        a.account_number,
        at.account_type_name,
        a.balance,
        a.status
    FROM Accounts a
    JOIN Account_Types at
        ON a.account_type_id = at.account_type_id
    WHERE a.customer_id = p_customer_id;

END //

DELIMITER ;

CALL GetCustomerAccounts(2);
CALL GetCustomerAccounts(2);

DELIMITER //

CREATE PROCEDURE GetAccountTransactions(
    IN p_account_id INT
)
BEGIN

    SELECT
        transaction_type,
        amount,
        transaction_date,
        description
    FROM Transactions
    WHERE account_id = p_account_id
    ORDER BY transaction_date;

END //

DELIMITER ;

CALL GetAccountTransactions(101);

CREATE TABLE Transaction_Log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id INT,
    account_id INT,
    transaction_type VARCHAR(20),
    amount DECIMAL(12,2),
    transaction_date DATE,
    log_created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER Transaction_Audit_Log
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN

    INSERT INTO Transaction_Log
    (
        transaction_id,
        account_id,
        transaction_type,
        amount,
        transaction_date
    )
    VALUES
    
    
    (
        NEW.transaction_id,
        NEW.account_id,
        NEW.transaction_type,
        NEW.amount,
        NEW.transaction_date
    );

END //

DELIMITER ;

INSERT INTO Transactions
VALUES
(1031, 101, 'Deposit', 5000, '2025-08-01', 'Test Deposit');

SELECT *
FROM Transaction_Log;

DELIMITER //

CREATE TRIGGER Prevent_Negative_Balance
BEFORE UPDATE ON Accounts
FOR EACH ROW
BEGIN

    IF NEW.balance < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Account balance cannot be negative';
    END IF;

END //

DELIMITER ;

UPDATE Accounts
SET balance = -5000
WHERE account_id = 101;

SHOW TABLES;
DESC Branches;
DESC Customers;
DESC Account_Types;
DESC Accounts;
DESC Transactions;
DESC Transaction_Log;

SELECT * FROM Branches;

SELECT * FROM Customers;

SELECT * FROM Account_Types;

SELECT * FROM Accounts;

SELECT * FROM Transactions;

SELECT * FROM Transaction_Log;

SHOW PROCEDURE STATUS
WHERE Db = 'Banking_Management_System';

SHOW TRIGGERS;

SHOW FULL TABLES
WHERE Table_type = 'VIEW';

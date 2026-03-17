BEGIN;
SELECT pg_current_wal_lsn();
SELECT pg_current_wal_insert_lsn();

INSERT INTO identity.passport 
(   
    fullname, 
    issuedate, 
    validuntil, 
    biometry, 
    country
    ) 
VALUES 
(
    'John Doe number 67', 
    CURRENT_DATE, 
    CURRENT_DATE + (random()*3000)::int, 
    1, 
    7
);

SELECT pg_current_wal_insert_lsn();

COMMIT;

SELECT pg_current_wal_lsn();





SELECT pg_current_wal_lsn();

INSERT INTO identity.passport(fullName, issueDate, validUntil, country, biometry)
SELECT
    'Bulk ' || g,
    '2020-01-01',
    '2030-01-01',
    7,
    1
FROM generate_series(1, 10000) g;

SELECT pg_current_wal_lsn();


SELECT pg_size_pretty(
    pg_wal_lsn_diff(
        '0/1F36660',
        '0/2000000'
    )
);
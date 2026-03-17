insert into identity.country (id, name) 
values 
    (1, 'Россия'),
    (2, 'США'),
    (3, 'КНДР'),
    (4, 'Китай'),
    (5, 'Казахстан'),
    (6, 'Германия'),
    (7, 'Афганистан'),
    (8, 'Мексика'),
    (9, 'Нигер')
ON CONFLICT (id) DO NOTHING;

INSERT INTO identity.biometry
SELECT FROM generate_series(1, 250000)
ON CONFLICT (id) DO NOTHING;

INSERT INTO identity.passport (fullName, issueDate, validUntil, biometry, country)
SELECT 
    'Person ' || b.id,
    CURRENT_DATE - (random()*3000)::int,
    CURRENT_DATE + (random()*3000)::int,
    b.id,
    1
FROM identity.biometry b
ON CONFLICT (id) DO NOTHING;
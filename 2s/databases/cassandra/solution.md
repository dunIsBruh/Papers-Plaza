# Поднять кластер Cassandra из 3 нод с помощью Docker Compose. Создать keyspace с replication_factor = 3 и убедиться, что все ноды доступны.

```
> docker ps

CONTAINER ID   IMAGE              COMMAND                  CREATED              STATUS                        PORTS                                         NAMES
eb54739b05c4   cassandra:latest   "docker-entrypoint.s…"   About a minute ago   Up 30 seconds (healthy)       7000-7001/tcp, 7199/tcp, 9042/tcp, 9160/tcp   cassandra3
bbc5b74cb04e   cassandra:latest   "docker-entrypoint.s…"   About a minute ago   Up 48 seconds (healthy)       7000-7001/tcp, 7199/tcp, 9042/tcp, 9160/tcp   cassandra2
94d3c366974a   cassandra:latest   "docker-entrypoint.s…"   About a minute ago   Up About a minute (healthy)   0.0.0.0:9042->9042/tcp, [::]:9042->9042/tcp   cassandra1
```

```
docker exec -it cassandra1 cqlsh
```

```
cqlsh> CREATE KEYSPACE homework WITH replication = { 'class': 'SimpleStrategy', 'replication_factor': 3};

cqlsh> DESCRIBE KEYSPACES;

homework  system_auth         system_schema  system_views         
system    system_distributed  system_traces  system_virtual_schema
```

# Создать две таблицы с одинаковыми данными, но спроектированные под разные запросы (например, по разным ключам). Заполнить обе таблицы одинаковыми данными.

```
cqlsh> USE homework;
cqlsh:homework> CREATE TABLE users_by_id (
            ...   user_id UUID PRIMARY KEY,
            ...   name TEXT,
            ...   email TEXT,
            ...   age INT
            ... );
cqlsh:homework> CREATE TABLE users_by_email (
            ...   email TEXT PRIMARY KEY,
            ...   user_id UUID,
            ...   name TEXT,
            ...   age INT
            ... );
```

```
cqlsh:homework> INSERT INTO users_by_id (user_id, name, email, age)
            ... VALUES (uuid(), 'Alice', 'alice@test.com', 25);
 users_by_email (email, user_id, name, age)
VALUES ('alice@test.com', uuid(), 'Alice', 25);cqlsh:homework> 
cqlsh:homework> INSERT INTO users_by_email (email, user_id, name, age)
            ... VALUES ('alice@test.com', uuid(), 'Alice', 25);
```

# Выполнить операции INSERT, SELECT, UPDATE и DELETE. Попробовать выполнить SELECT по полю, которое не является частью ключа, и получить ошибку.

```
cqlsh:homework> SELECT * FROM users_by_id;
by_email WHERE email = 'alice@test.com';
 user_id                              | age | email          | name
--------------------------------------+-----+----------------+-------
 3e2a7135-9655-48f2-996d-3c264002b367 |  25 | alice@test.com | Alice

(1 rows)
 
cqlsh:homework> SELECT * FROM users_by_email WHERE email = 'alice@test.com';

 email          | age | name  | user_id
----------------+-----+-------+--------------------------------------
 alice@test.com |  25 | Alice | 221c24be-ec4b-4f70-a468-cac17f392a5d

(1 rows)
```

```
cqlsh:homework> UPDATE users_by_id
            ... SET age = 26
            ... WHERE user_id = 3e2a7135-9655-48f2-996d-3c264002b367;
```

```
 user_id                              | age | email          | name
--------------------------------------+-----+----------------+-------
 3e2a7135-9655-48f2-996d-3c264002b367 |  26 | alice@test.com | Alice
 
 (1 rows)
```

```
cqlsh:homework> DELETE FROM users_by_email
test.com';            ... WHERE email = 'alice@test.com';
cqlsh:homework> SELECT * FROM users_by_id;
```

```
cqlsh:homework> SELECT * FROM users_by_email;

 email | age | name | user_id
-------+-----+------+---------

(0 rows)
```

```
cqlsh:homework> SELECT * FROM users_by_id WHERE name = 'Alice';
InvalidRequest: Error from server: code=2200 [Invalid query] message="Cannot execute this query as it might involve data filtering and thus may have unpredictable performance. If you want to execute this query despite the performance unpredictability, use ALLOW FILTERING"   
```

# Остановить одну из нод кластера и проверить, что операции чтения и записи продолжают работать. Убедиться, что данные остаются доступными.

```
> docker stop cassandra3
cassandra3

docker exec -it cassandra1 cqlsh
```

```
-- данный доступны после удаления кластера

cqlsh> USE homework;
cqlsh:homework> SELECT * FROM users_by_id;

 user_id                              | age | email          | name
--------------------------------------+-----+----------------+-------
 3e2a7135-9655-48f2-996d-3c264002b367 |  26 | alice@test.com | Alice

(1 rows)
```
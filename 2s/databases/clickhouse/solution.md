# Запуск ClickHouse

```
docker-compose up -d
```

```
-- проверка
> curl http://localhost:8123                         

StatusCode        : 200
StatusDescription : OK
Content           : <!DOCTYPE html>
                    <html>
                    <head>
                    ...
```

# Создание таблицы

```
CREATE TABLE trips
(
    trip_id UInt32,
    start_time DateTime,
    end_time DateTime,
    distance_km Float32,
    city String
)
ENGINE = MergeTree
ORDER BY trip_id;

CREATE TABLE trips
(
    `trip_id` UInt32,
    `start_time` DateTime,
    `end_time` DateTime,
    `distance_km` Float32,
    `city` String
)
ENGINE = MergeTree
ORDER BY trip_id

Query id: b7d01fb8-c2ad-4e2d-bbf8-5ce4622f5af9

Ok.

0 rows in set. Elapsed: 0.013 sec. 
```

# Наполнение данными

```
ab986b696ba3 :) INSERT INTO trips
SELECT
    number AS trip_id,

    now() - rand() % 100000 AS start_time,

    start_time + (rand() % 7200) AS end_time, -- до 2 часов поездка

    randUniform(1, 50) AS distance_km,

    arrayElement(
        ['Amsterdam', 'Berlin', 'Paris', 'Madrid', 'Rome'],
        (rand() % 5) + 1
    ) AS city

FROM numbers(1000000);

INSERT INTO trips SELECT
    number AS trip_id,
    now() - (rand() % 100000) AS start_time,
    start_time + (rand() % 7200) AS end_time,
    randUniform(1, 50) AS distance_km,
    arrayElement(['Amsterdam', 'Berlin', 'Paris', 'Madrid', 'Rome'], (rand() % 5) + 1) AS city
FROM numbers(1000000)

Query id: c6469642-1ec7-4aa7-9bb0-f59e3f72922f

Ok.

1000000 rows in set. Elapsed: 0.131 sec. Processed 1.00 million rows, 8.00 MB (7.63 million rows/s., 61.06 MB/s.)
Peak memory usage: 43.76 MiB.
```

### Проверка

```
ab986b696ba3 :) SELECT count() FROM trips;

SELECT count()
FROM trips

Query id: dee1a1e4-1f10-4022-a679-20880f55de80

   ┌─count()─┐
1. │ 1000000 │
   └─────────┘

1 row in set. Elapsed: 0.007 sec. 
```

# Написание аналитического запроса

```
ab986b696ba3 :) SELECT
    city,
    avg(distance_km) AS avg_distance,
    count() AS trip_count,
    max(end_time - start_time) AS max_duration_sec
FROM trips
GROUP BY city
ORDER BY trip_count DESC;

SELECT
    city,
    avg(distance_km) AS avg_distance,
    count() AS trip_count,
    max(end_time - start_time) AS max_duration_sec
FROM trips
GROUP BY city
ORDER BY trip_count DESC

Query id: fb953108-468c-4511-9ae0-90692661a4a1

   ┌─city──────┬───────avg_distance─┬─trip_count─┬─max_duration_sec─┐
1. │ Madrid    │ 25.504027826257225 │     200414 │             7198 │
2. │ Amsterdam │ 25.492922932209435 │     200257 │             7195 │
3. │ Berlin    │ 25.457873066788974 │     199976 │             7196 │
4. │ Rome      │  25.47059002306829 │     199883 │             7199 │
5. │ Paris     │  25.55823343899481 │     199470 │             7197 │
   └───────────┴────────────────────┴────────────┴──────────────────┘

5 rows in set. Elapsed: 0.024 sec. Processed 1.00 million rows, 21.00 MB (42.06 million rows/s., 883.39 MB/s.)
Peak memory usage: 10.47 MiB.
```
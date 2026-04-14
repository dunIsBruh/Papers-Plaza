## Выполнение задач

## Задание 1. Оптимизация простого запроса

1. Постройте план выполнения запроса до изменений.

```text
Seq Scan on store_checks  (cost=0.00..1880.07 rows=1 width=26) (actual time=4.986..4.989 rows=3 loops=1)
  Filter: ((sold_at >= '2025-02-14 00:00:00'::timestamp without time zone) AND (sold_at < '2025-02-15 00:00:00'::timestamp without time zone) AND (shop_id = 77))
  Rows Removed by Filter: 70001
  Buffers: shared hit=655
Planning Time: 0.093 ms
Execution Time: 5.012 ms
```

2.  Ответы на вопросы.
  - какой тип сканирования использован:
использован Seq Scan

  - какие из уже созданных индексов не помогают этому запросу:
не помогают этому запросу индексы *idx_store_checks_payment_type* и *idx_store_checks_total_sum_hash*

  - почему планировщик выбирает именно такой план:
эти индексы не относятся к части where и из-за того, что других индексов нет, он выбирает полное сканирование


3. Создайте индекс, который лучше подходит под этот запрос.

```sql
CREATE INDEX idx_store_checks_shop_id_hash ON store_checks USING hash (shop_id);
```

4. Повторно постройте план выполнения.

```text
Bitmap Heap Scan on store_checks  (cost=4.65..247.13 rows=1 width=26) (actual time=0.190..0.191 rows=3 loops=1)
  Recheck Cond: (shop_id = 77)
  Filter: ((sold_at >= '2025-02-14 00:00:00'::timestamp without time zone) AND (sold_at < '2025-02-15 00:00:00'::timestamp without time zone))
  Rows Removed by Filter: 89
  Heap Blocks: exact=89
  Buffers: shared hit=91
  ->  Bitmap Index Scan on idx_store_checks_shop_id_hash  (cost=0.00..4.65 rows=87 width=0) (actual time=0.040..0.041 rows=92 loops=1)
        Index Cond: (shop_id = 77)
        Buffers: shared hit=2
Planning:
  Buffers: shared hit=16
Planning Time: 0.251 ms
Execution Time: 0.213 ms
```

5. Кратко объясните, что изменилось в плане и почему.

Из-за использования hash индекса по shop_id планировщик выбрал Bitmap Heap Scan и время выполнения сократилось

6. Ответьте, нужно ли после создания индекса выполнять ANALYZE, и зачем.

Да, нужно. Нужно проверить, что индекс действительно улучшил время запроса.

---

## Задание 2. Анализ и улучшение JOIN-запроса


1. Постройте план выполнения запроса до изменений.

```text
Hash Join  (cost=690.02..1800.09 rows=724 width=27) (actual time=4.087..9.023 rows=819 loops=1)
  Hash Cond: (v.member_id = m.id)
  Buffers: shared hit=1081 read=31
  ->  Bitmap Heap Scan on club_visits v  (cost=232.70..1314.01 rows=10954 width=22) (actual time=1.368..4.809 rows=10998 loops=1)
        Recheck Cond: ((visit_at >= '2025-02-01 00:00:00'::timestamp without time zone) AND (visit_at < '2025-02-10 00:00:00'::timestamp without time zone))
        Heap Blocks: exact=917
        Buffers: shared hit=917 read=31
        ->  Bitmap Index Scan on idx_club_visits_visit_at  (cost=0.00..229.96 rows=10954 width=0) (actual time=1.278..1.279 rows=10998 loops=1)
              Index Cond: ((visit_at >= '2025-02-01 00:00:00'::timestamp without time zone) AND (visit_at < '2025-02-10 00:00:00'::timestamp without time zone))
              Buffers: shared read=31
  ->  Hash  (cost=439.00..439.00 rows=1466 width=13) (actual time=2.702..2.703 rows=1466 loops=1)
        Buckets: 2048  Batches: 1  Memory Usage: 85kB
        Buffers: shared hit=164
        ->  Seq Scan on club_members m  (cost=0.00..439.00 rows=1466 width=13) (actual time=0.012..2.323 rows=1466 loops=1)
              Filter: (member_level = 'premium'::text)
              Rows Removed by Filter: 20534
              Buffers: shared hit=164
Planning:
  Buffers: shared hit=79
Planning Time: 0.578 ms
Execution Time: 9.102 ms
```

2. Определите, какой тип JOIN использован:

Использовался тип HASH JOIN.

3. Объясните, почему планировщик выбрал именно этот тип JOIN.

Планировщик выбрал hash join, так как тут средние таблицы, используется условие равенства и нет подходящего индекса

4. Укажите, какие существующие индексы полезны слабо или не полезны для этого запроса.

Для этого запроса полезен *idx_club_visits_visit_at* и слабо полезен *idx_club_members_full_name*

5. Предложите и создайте одно улучшение, которое может ускорить запрос.



6. Повторно постройте план выполнения.



7. Кратко поясните, улучшился ли план и за счет чего.


8. Отдельно укажите, что означает преобладание shared hit или read в BUFFERS.

Преобладание shared hit или read в BUFFERS означает, что запрос больше обращается к кэшу или к памяти на диске. 
Shared hit эффективнее.


---

## Задание 3. MVCC и очистка


```sql
SELECT xmin, xmax, ctid, id, title, stock
FROM warehouse_items
ORDER BY id;

UPDATE warehouse_items
SET stock = stock - 2
WHERE id = 1;

SELECT xmin, xmax, ctid, id, title, stock
FROM warehouse_items
ORDER BY id;

DELETE FROM warehouse_items
WHERE id = 3;

SELECT xmin, xmax, ctid, id, title, stock
FROM warehouse_items
ORDER BY id;
```

1. Опишите, что изменилось после UPDATE с точки зрения xmin, xmax и ctid.

- xmin - увеличился (764 -> 825)
- xmax - не изменился
- ctid - был (0, 1), а стал (0, 4)

2. Объясните, почему в модели MVCC UPDATE не является простым "перезаписыванием" строки.

Потому что при UPDATE не происходит более тяжелого запроса по сравнению с помечанием, который впоследствии выполняется группой изменений, что быстрее одиночного обращения к памяти

3. Объясните, что произошло после DELETE и почему строка исчезла из обычного SELECT.

После DELETE планировщик пометил xmax номеров текущей транзакции, что показывает, что это dead tuple и его впоследствии можно очистить

4. Кратко сравните:
  - VACUUM:

механизм, помечающий запись как освобожденную

  - autovacuum:

vacuum, только автоматический (его запускает сам postgres)

  - VACUUM FULL.

Механизм, физически компактно пересобирающий таблицу и его индексы

5. Отдельно укажите, какой из этих механизмов может полностью блокировать таблицу:

VACUUM FULL


---

## Задание 4. Блокировки строк



1. Опишите, что происходит с DELETE и UPDATE в сессии B в двух экспериментах.



2. Объясните, чем FOR KEY SHARE отличается от FOR NO KEY UPDATE по смыслу и по силе блокировки:

FOR NO KEY UPDATE более строгая блокировка строки по сравнению с FOR KEY SHARE.
FOR NO KEY UPDATE не позволяет изменять строку, в то время как FOR KEY SHARE позволяет, но запрещает изменять ключ с которым он работает (гарантирует что он останется к концу транзакции)

3. Укажите, почему обычный SELECT без FOR KEY SHARE/FOR NO KEY UPDATE ведет себя иначе.
4. Кратко поясните, где в прикладных сценариях может использоваться FOR NO KEY UPDATE:

Его можно использовать тогда, когда нужно запретить изменение/удаление, но можно разрешается чтение по неключевому полю



---

## Задание 5. Секционирование и partition pruning



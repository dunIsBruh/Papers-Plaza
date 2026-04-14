## Решение заданий:

### Поднять Elasticsearch через Docker

```
docker run -p 9200:9200 -e "discovery.type=single-node" elasticsearch:7.17.22
```

### Создание индекса products

```
curl -X PUT "http://localhost:9200/products" \
-H "Content-Type: application/json" -d '{
    "mappings": {
        "properties": {
        "name":       { "type": "text" },
        "category":   { "type": "keyword" },
        "price":      { "type": "float" },
        "stock":      { "type": "integer" },
        "created_at": { "type": "date" }
        }
    }
}'
```

### Заполнение индекс тестовыми данными с помощью методов PUT или POST.

```
curl -X POST "http://localhost:9200/products/_doc?refresh=wait_for" \
-H "Content-Type: application/json" -d '{
"name": "Ноутбук ASUS VivoBook",
"category": "Электроника",
"price": 54990.00,
"stock": 15,
"created_at": "2025-10-10"
}'

curl -X POST "http://localhost:9200/products/_doc?refresh=wait_for" \
-H "Content-Type: application/json" -d '{
"name": "Беспроводные наушники Sony",
"category": "Аксессуары",
"price": 12990.00,
"stock": 42,
"created_at": "2025-11-05"
}'

curl -X POST "http://localhost:9200/products/_doc?refresh=wait_for" \
-H "Content-Type: application/json" -d '{
"name": "Монитор Dell 27\"",
"category": "Электроника",
"price": 28500.00,
"stock": 8,
"created_at": "2026-01-12"
}'

curl -X POST "http://localhost:9200/products/_doc?refresh=wait_for" \
-H "Content-Type: application/json" -d '{
"name": "Игровое кресло ThunderX",
"category": "Мебель",
"price": 18000.00,
"stock": 5,
"created_at": "2026-02-20"
}'
```

```
{"_index":"products","_type":"_doc","_id":"YHYEjZ0BythUOiQFMr9d","_version":1,"result":"created","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":0,"_primary_term":1}{"_index":"products","_type":"_doc","_id":"YXYEjZ0BythUOiQFNL-Q","_version":1,"result":"created","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":1,"_primary_term":1}{"_index":"products","_type":"_doc","_id":"YnYEjZ0BythUOiQFOL-Y","_version":1,"result":"created","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":2,"_primary_term":1}{"_index":"products","_type":"_doc","_id":"Y3YEjZ0BythUOiQFPL_Z","_version":1,"result":"created","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":3,"_primary_term":1}
```

### Проверка на наличие документов

```
curl -X GET "http://localhost:9200/products/_search?pretty"

-- ответ

{
    "took" : 17,
    "timed_out" : false,
    "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
},
"hits" : {
"total" : {
"value" : 4,
"relation" : "eq"
},
"max_score" : 1.0,
"hits" : [
    {
    "_index" : "products",
    "_type" : "_doc",
    "_id" : "YHYEjZ0BythUOiQFMr9d",
    "_score" : 1.0,
    "_source" : {
        "name" : "Ноутбук ASUS VivoBook",
        "category" : "Электроника",
        "price" : 54990.0,
        "stock" : 15,
        "created_at" : "2025-10-10"
        }
    },
    {
    "_index" : "products",
    "_type" : "_doc",
    "_id" : "YXYEjZ0BythUOiQFNL-Q",
    "_score" : 1.0,
    "_source" : {
        "name" : "Беспроводные наушники Sony",
        "category" : "Аксессуары",
        "price" : 12990.0,
        "stock" : 42,
        "created_at" : "2025-11-05"
        }
    },
    {
        "_index" : "products",
        "_type" : "_doc",
        "_id" : "YnYEjZ0BythUOiQFOL-Y",
        "_score" : 1.0,
        "_source" : {
            "name" : "Монитор Dell 27\"",
            "category" : "Электроника",
            "price" : 28500.0,
            "stock" : 8,
            "created_at" : "2026-01-12"
        }
    },
    {
        "_index" : "products",
        "_type" : "_doc",
        "_id" : "Y3YEjZ0BythUOiQFPL_Z",
        "_score" : 1.0,
        "_source" : {
            "name" : "Игровое кресло ThunderX",
            "category" : "Мебель",
            "price" : 18000.0,
            "stock" : 5,
            "created_at" : "2026-02-20"
        }
    }
]
}
}
```

### Добавление документ с указанным id

```
curl -X PUT "http://localhost:9200/products/_doc/1001?refresh=wait_for" 
-H "Content-Type: application/json" -d 
'{
    "name":"Клавиатура Logitech K380","
    category":"Аксессуары",
    "price":4500,"stock":20,
    "created_at":"2026-03-01"
}'

{"_index":"products","_type":"_doc","_id":"1001","_version":1,"result":"created","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":4,"_primary_term":1}
```

### Обновление документа

```
curl -X POST "http://localhost:9200/products/_doc/1001/_update?refresh=wait_for" 
-H "Content-Type: application/json" -d 
'{"doc":{"price":4200}}'


{"_index":"products","_type":"_doc","_id":"1001","_version":2,"result":"updated",
```

### Удаление документа

```
curl -X DELETE "http://localhost:9200/products/_doc/1001?refresh=wait_for"

{
    "_index":"products",
    "_type":"_doc",
    "_id":"1001",
    "_version":3,
    "result":"deleted",
    "_shards":
    {"total":2,"successful":1,"failed":0},
    "_seq_no":6,
    "_primary_term":1
}
```

## Запросы поиска

### Поиск по названию товара
Примечание: у меня некорректно работал query-поиск с кириллицей

```
curl -X GET "http://localhost:9200/products/_search?q=name:asus&pretty"
{
    "took" : 5,
    "timed_out" : false,
    "_shards" : {
        "total" : 1,
        "successful" : 1,
        "skipped" : 0,
        "failed" : 0
    },
    "hits" : {
    "total" : {
    "value" : 1,
    "relation" : "eq"
    },
    "max_score" : 1.2039728,
    "hits" : [
    {
        "_index" : "products",
        "_type" : "_doc",
        "_id" : "YHYEjZ0BythUOiQFMr9d",
        "_score" : 1.2039728,
        "_source" : {
            "name" : "Ноутбук ASUS VivoBook",
            "category" : "Электроника",
            "price" : 54990.0,
            "stock" : 15,
            "created_at" : "2025-10-10"
        }
    }
    ]
    }
}
```

### Запросы с использованием match


```
curl -X POST "http://localhost:9200/products/_search" -H "Content-Type: application/json" -d '{
    "query": {
        "match": {
            "name": "беспроводные наушники"
        }
    }
}'

{
    "took":50,
    "timed_out":false,
    "_shards":
        {"total":1,"successful":1,"skipped":0,"failed":0},"hits":{"total":{"value":1,"relation":"eq"},
        "max_score":2.7725885,
        "hits":[{"_index":"products","_type":"_doc","_id":"YXYEjZ0BythUOiQFNL-Q","_score":2.7725885,"_source":
        {
        "name": "Беспроводные наушники Sony",
        "category": "Аксессуары",
        "price": 12990.00,
        "stock": 42,
        "created_at": "2025-11-05"
        }
    }]}
}
```

### Запросы с использованием term
Работает только с keyword-полями или после анализа. У нас category задан как keyword.

```
curl -X POST "http://localhost:9200/products/_search" -H "Content-Type: application/json" -d '{
    "query": {
        "term": {
            "category": "Электроника"
        }
    }
}'


{"took":4,"timed_out":false,"_shards":{"total":1,"successful":1,"skipped":0,"failed":0},
"hits":
{"total":{"value":2,"relation":"eq"},"max_score":0.6931471,"hits":
    [{"_index":"products","_type":"_doc","_id":"YHYEjZ0BythUOiQFMr9d","_score":0.6931471,"_source":{
        "name": "Ноутбук ASUS VivoBook",
        "category": "Электроника",
        "price": 54990.00,
        "stock": 15,
        "created_at": "2025-10-10"}
    },
    {"_index":"products","_type":"_doc","_id":"YnYEjZ0BythUOiQFOL-Y","_score":0.6931471,"_source":{
        "name": "Монитор Dell 27\"",
        "category": "Электроника",
        "price": 28500.00,
        "stock": 8,
        "created_at": "2026-01-12"
    }}]
    }
}
```

### Запросы с использованием range

```
curl -X POST "http://localhost:9200/products/_search" -H "Content-Type: application/json" -d '{
    "query": {
        "range": {
            "price": {
                "gte": 10000,
                "lte": 30000
            }
        }
    }
}'


{"took":3,"timed_out":false,"_shards":{"total":1,"successful":1,"skipped":0,"failed":0},"hits":{"total":{"value":3,"relation":"eq"},"max_score":1.0,
"hits":
[{"_index":"products","_type":"_doc","_id":"YXYEjZ0BythUOiQFNL-Q","_score":1.0,"_source":{
    "name": "Беспроводные наушники Sony",
    "category": "Аксессуары",
    "price": 12990.00,
    "stock": 42,
    "created_at": "2025-11-05"
}},{"_index":"products","_type":"_doc","_id":"YnYEjZ0BythUOiQFOL-Y","_score":1.0,"_source":{
    "name": "Монитор Dell 27\"",
    "category": "Электроника",
    "price": 28500.00,
    "stock": 8,
    "created_at": "2026-01-12"
}},{"_index":"products","_type":"_doc","_id":"Y3YEjZ0BythUOiQFPL_Z","_score":1.0,"_source":{
    "name": "Игровое кресло ThunderX",
    "category": "Мебель",
    "price": 18000.00,
    "stock": 5,
    "created_at": "2026-02-20"
}}]}}
```

### Запросы с использованием bool с комбинацией условий

```
must = обязано совпадать, filter = совпадает, но не влияет на скор (быстрее), should = желательно.
```

```
curl -X POST "http://localhost:9200/products/_search" -H "Content-Type: application/json" -d '{
    "query": {
        "bool": {
            "must": [
                { "match": { "category": "Электроника" } }
            ],
            "filter": [
                { "range": { "price": { "lte": 40000 } } },
                { "range": { "stock": { "gte": 5 } } }
            ]
        }
    }
}'


{"took":4,"timed_out":false,"_shards":{"total":1,"successful":1,"skipped":0,"failed":0},"hits":{"total":{"value":1,"relation":"eq"},"max_score":0.6931471,
"hits":[{"_index":"products","_type":"_doc","_id":"YnYEjZ0BythUOiQFOL-Y","_score":0.6931471,"_source":{
    "name": "Монитор Dell 27\"",
    "category": "Электроника",
    "price": 28500.00,
    "stock": 8,
    "created_at": "2026-01-12"
}}]}}
```

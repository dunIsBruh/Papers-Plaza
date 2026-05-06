# Подготовка данных

```
from qdrant_client import QdrantClient
from qdrant_client.models import Distance, VectorParams, PointStruct, Filter, FieldCondition, Range, MatchValue
from sentence_transformers import SentenceTransformer
import datetime

def to_timestamp(date_str):
    return int(datetime.datetime.strptime(date_str, "%Y-%m-%d").timestamp())

# подключение
client = QdrantClient(url="http://localhost:6333")

# модель эмбеддингов (384 dim)
model = SentenceTransformer("all-MiniLM-L6-v2")  # 384 dims
```

```
collection_name = "articles"

client.recreate_collection(
    collection_name=collection_name,
    vectors_config=VectorParams(size=384, distance=Distance.COSINE)
)


articles = [
    {
        "id": 1,
        "title": "Running for beginners",
        "content": "Running is great for health and endurance training.",
        "author": "Alice",
        "category": "sport",
        "published_at": "2024-02-10",
        "views": 1200,
        "rating": 4.5
    },
    {
        "id": 2,
        "title": "AI in modern tech",
        "content": "Artificial intelligence transforms software development.",
        "author": "Bob",
        "category": "tech",
        "published_at": "2024-03-15",
        "views": 5000,
        "rating": 4.8
    },
    {
        "id": 3,
        "title": "Football tactics",
        "content": "Modern football strategies focus on pressing and possession.",
        "author": "Charlie",
        "category": "sport",
        "published_at": "2023-12-01",
        "views": 800,
        "rating": 3.9
    },
    {
        "id": 4,
        "title": "Tech news today",
        "content": "New smartphone released with advanced AI features.",
        "author": "David",
        "category": "tech",
        "published_at": "2024-01-20",
        "views": 2300,
        "rating": 4.1
    },
    {
        "id": 5,
        "title": "Sports nutrition",
        "content": "Proper diet improves athletic performance and recovery.",
        "author": "Eve",
        "category": "sport",
        "published_at": "2024-04-05",
        "views": 1500,
        "rating": 4.0
    }
]
```

# Поиск

```
points = []

for a in articles:
    vector = model.encode(a["title"] + " " + a["content"]).tolist()

    points.append(
        PointStruct(
            id=a["id"],
            vector=vector,
            payload=a
        )
    )

client.upsert(
    collection_name=collection_name,
    points=points
)

####

query = "бег и спорт"
query_vector = model.encode(query).tolist()

results = client.search(
    collection_name=collection_name,
    query_vector=query_vector,
    limit=3
)

results = client.search(
    collection_name=collection_name,
    query_vector=query_vector,
    query_filter=Filter(
        must=[
            FieldCondition(
                key="category",
                match=MatchValue(value="tech")
            ),
            FieldCondition(
                key="rating",
                range=Range(gte=4.0)
            )
        ]
    ),
    limit=10
)


####

results = client.search(
    collection_name=collection_name,
    query_vector=query_vector,
    query_filter=Filter(
        must=[
            FieldCondition(
                key="published_at",
                range=Range(gte=to_timestamp("2024-01-01"))
            ),
            FieldCondition(
                key="views",
                range=Range(gt=1000)
            )
        ]
    ),
    limit=10
)

####

results = client.search(
    collection_name=collection_name,
    query_vector=query_vector,
    query_filter=Filter(
        should=[
            FieldCondition(key="category", match=MatchValue(value="sport")),
            FieldCondition(key="category", match=MatchValue(value="tech"))
        ],
        must=[
            FieldCondition(key="rating", range=Range(gte=3.5)),
            FieldCondition(key="views", range=Range(gte=500, lte=5000))
        ]
    ),
    limit=10
)

for r in results:
    print(r.score, r.payload["title"])

```

```
-- results

0.10676515 Football tactics
0.0018406063 Sports nutrition

-0.028719109 AI in modern tech
-0.07125656 Running for beginners
-0.12245417 Tech news today
```

# Индексы и оптимизация

```
client.create_payload_index(
    collection_name=collection_name,
    field_name="category",
    field_schema="keyword"
)

client.create_payload_index(
    collection_name=collection_name,
    field_name="rating",
    field_schema="float"
)

client.create_payload_index(
    collection_name=collection_name,
    field_name="published_at",
    field_schema="integer"
)

client.create_payload_index(
    collection_name=collection_name,
    field_name="views",
    field_schema="integer"
)

####

import time

start = time.time()

client.search(
    collection_name=collection_name,
    query_vector=query_vector,
    query_filter=Filter(
        must=[
            FieldCondition(key="category", match=MatchValue(value="tech"))
        ]
    ),
    limit=10
)

print("Time:", time.time() - start)
```

```
Time: 0.007097721099853516
```
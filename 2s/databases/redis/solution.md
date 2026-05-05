# Запуск Redis

```
docker run -d --name redis -p 6379:6379 redis

Unable to find image 'redis:latest' locally
latest: Pulling from library/redis
d55df8e0f53d: Pull complete 
2b8951cd65b5: Pull complete 
9e0f42ff49e1: Pull complete 
14d3b17b0010: Pull complete 
3531af2bc2a9: Pull complete 
4f4fb700ef54: Pull complete 
97afe6025aa9: Pull complete 
f426aaaf8949: Download complete 
ff0fc1b2ba98: Download complete 
Digest: sha256:832d7785830f3f4b559300e6191fc914b15642c1935252338825cf4332200148
Status: Downloaded newer image for redis:latest
65d65e0795c72fc1f147813d8ac79443969e9cf6c5f6fc632302f1fbfca41ab8
```

```
docker ps

CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS                                         NAMES
65d65e0795c7   redis     "docker-entrypoint.s…"   42 seconds ago   Up 42 seconds   0.0.0.0:6379->6379/tcp, [::]:6379->6379/tcp   redis
```
```
redis-cli 
```

# Счётчик просмотров

```
-- инкрементирование счетчика
127.0.0.1:6379> INCR article:10:views
(integer) 1
127.0.0.1:6379> INCR article:10:views
(integer) 2
127.0.0.1:6379> INCR article:10:views
(integer) 3
127.0.0.1:6379> INCR article:10:views
(integer) 4

-- получения значения
127.0.0.1:6379> GET article:10:views
"4"
```

# Рейтинг статей

```
-- добавление статей со значениями
127.0.0.1:6379> ZADD articles:leaderboard 100 article:1
(integer) 1
127.0.0.1:6379> ZADD articles:leaderboard 250 article:2
(integer) 1
127.0.0.1:6379> ZADD articles:leaderboard 150 article:3
(integer) 1
127.0.0.1:6379> ZADD articles:leaderboard 25 article:4
(integer) 1

-- получение топ-3 по кол-ву очков без и с значениями очков
127.0.0.1:6379> ZREVRANGE articles:leaderboard 0 2
1) "article:2"
2) "article:3"
3) "article:1"

127.0.0.1:6379> ZREVRANGE articles:leaderboard 0 2 WITHSCORES
1) "article:2"
2) "250"
3) "article:3"
4) "150"
5) "article:1"
6) "100"

-- добавление статье 4 большого количества просмотров
127.0.0.1:6379> ZINCRBY articles:leaderboard 95000 article:4
"95025"

-- новый топ-3 с article:4 на первом месте
127.0.0.1:6379> ZREVRANGE articles:leaderboard 0 2 WITHSCORES
1) "article:4"
2) "95025"
3) "article:2"
4) "250"
5) "article:3"
6) "150"
```

# Ограничение действий пользователя

```
-- добавление лайков
127.0.0.1:6379> INCR user:1:likes
(integer) 1
127.0.0.1:6379> INCR user:1:likes
(integer) 2
127.0.0.1:6379> INCR user:1:likes
(integer) 3
127.0.0.1:6379> INCR user:1:likes
(integer) 4

-- добавление TTL = 60 секунд
127.0.0.1:6379> EXPIRE user:1:likes 60
(integer) 1
127.0.0.1:6379> GET user:1:likes
"4"

-- пока ключ "жив" - значение есть 
127.0.0.1:6379> TTL user:1:likes
(integer) 42
127.0.0.1:6379> GET user:1:likes
"4"

-- после 60 секунд значения больше нет
127.0.0.1:6379> TTL user:1:likes
(integer) -2
127.0.0.1:6379> GET user:1:likes
(nil)
```

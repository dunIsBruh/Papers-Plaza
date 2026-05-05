# Настроика docker-compose

### проверка

```
docker compose ps

-- output
NAME                 IMAGE                           COMMAND                  SERVICE     CREATED              STATUS              PORTS
influxdb3-core       influxdb:3-core                 "/usr/bin/entrypoint…"   influxdb3   About a minute ago   Up About a minute   0.0.0.0:8181->8181/tcp, [::]:8181->8181/tcp
influxdb3-explorer   influxdata/influxdb3-ui:1.7.0   "./entrypoint.sh --m…"   explorer    About a minute ago   Up About a minute   0.0.0.0:8888->8080/tcp, [::]:8888->8080/tcp
```

# Создание bucket mydb

```
> curl.exe -X POST "http://localhost:8181/api/v3/configure/database" -H "Content-Type: application/json" -H "Authorization: Bearer apiv3_0GJI8ukoMxKrGOll9jqm6i0Iktf9rkhq1G-5lJFFzb9wBEMqPxA-a6cJaRIhN5SxN6kKlRF_Lbwmjv9dWtcHvw" -d '{ "db": "mydb" }' 
```

# Вставка нескольких записей

```
> curl.exe -X POST "http://localhost:8181/api/v3/write_lp?db=mydb" -H "Authorization: Bearer apiv3_0GJI8ukoMxKrGOll9jqm6i0Iktf9rkhq1G-5lJFFzb9wBEMqPxA-a6cJaRIhN5SxN6kKlRF_Lbwmjv9dWtcHvw" --data-raw "temperature,location=room1 value=23"
> curl.exe -X POST "http://localhost:8181/api/v3/write_lp?db=mydb" -H "Authorization: Bearer apiv3_0GJI8ukoMxKrGOll9jqm6i0Iktf9rkhq1G-5lJFFzb9wBEMqPxA-a6cJaRIhN5SxN6kKlRF_Lbwmjv9dWtcHvw" --data-raw "temperature,location=room2 value=25"
```

# Выбор всех данных за последние 5 минут

```
SELECT * FROM temperature IN mydb WHERE time >= now() - interval '5 minutes'
```

![pic](./influxdb_pictures/select_with_5_min_interval.png)

### в данном запросе нет строк ответа, так как запись была сделана раньше

![pic](./influxdb_pictures/select_with_30_min_interval.png)

# Группировка SELECT по тегу location (например, среднее значение по комнатам)

```
SELECT location, avg(value) FROM temperature IN mydb WHERE time >= now() - interval '5 minutes' GROUP BY location
```

![pic](./influxdb_pictures/grouping_select.png)

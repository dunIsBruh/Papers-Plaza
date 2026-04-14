## Решение заданий:

### Подготовка к заданиям

```
docker run -d -p 27017:27017 mongo

docker exec -it boring_montalcini mongosh

use shopDB
```

### Задание 1.

```sql
db.products.insertMany([
    {
        name: "Смартфон-раскладушка X99",
        category: "Мобильные телефоны",
        price: 74990,
        inStock: true,
        manufacturer: {
            name: "Samsung",
            country: "Южная Корея"
        }
    },
    {
        name: "Ноутбук MacBook Air M3",
        category: "Компьютеры",
        price: 119990,
        inStock: true,
        manufacturer: {
            name: "Apple",
            country: "США"
        }
    },
    {
        name: "Беспроводные наушники WH-100XM2",
        category: "Аудиотехника",
        price: 9990,
        inStock: false,
        manufacturer: {
            name: "Sony",
            country: "Япония"
        }
    },
    {
        name: "Умная колонка Яндекс Станция Макс",
        category: "Умный дом",
        price: 16990,
        inStock: true,
        manufacturer: {
            name: "Яндекс",
            country: "Россия"
        }
    }
    ,
    {
        name: "IPhone 20",
        category: "Мобильные телефоны",
        price: 99000,
        inStock: false,
        manufacturer: {
            name: "Apple",
            country: "Iran"
        }
    }
])
```

```sql
-- ответ

acknowledged: true,
insertedIds: {
'0': ObjectId('69de61202b6449317944ba8d'),
'1': ObjectId('69de61202b6449317944ba8e'),
'2': ObjectId('69de61202b6449317944ba8f'),
'3': ObjectId('69de61202b6449317944ba90'),
'4': ObjectId('69de61202b6449317944ba91')
}
}
```


### Задание 2.

```sql
-- Запрос 1

db.products.find().pretty()


-- ответ

[
{
_id: ObjectId('69de61202b6449317944ba8d'),
name: 'Смартфон-раскладушка X99',
category: 'Мобильные телефоны',
price: 74990,
inStock: true,
manufacturer: { name: 'Samsung', country: 'Южная Корея' }
},
{
_id: ObjectId('69de61202b6449317944ba8e'),
name: 'Ноутбук MacBook Air M3',
category: 'Компьютеры',
price: 119990,
inStock: true,
manufacturer: { name: 'Apple', country: 'США' }
},
{
_id: ObjectId('69de61202b6449317944ba8f'),
name: 'Беспроводные наушники WH-100XM2',
category: 'Аудиотехника',
price: 9990,
inStock: false,
manufacturer: { name: 'Sony', country: 'Япония' }
},
{
_id: ObjectId('69de61202b6449317944ba90'),
name: 'Умная колонка Яндекс Станция Макс',
category: 'Умный дом',
price: 16990,
inStock: true,
manufacturer: { name: 'Яндекс', country: 'Россия' }
},
{
_id: ObjectId('69de61202b6449317944ba91'),
name: 'IPhone 20',
category: 'Мобильные телефоны',
price: 99000,
inStock: false,
manufacturer: { name: 'Apple', country: 'Iran' }
}
]
```

```sql
-- Запрос 2

db.products.find({ category: "Мобильные телефоны" }).pretty()


-- ответ

[
{
_id: ObjectId('69de61202b6449317944ba8d'),
name: 'Смартфон-раскладушка X99',
category: 'Мобильные телефоны',
price: 74990,
inStock: true,
manufacturer: { name: 'Samsung', country: 'Южная Корея' }
},
{
_id: ObjectId('69de61202b6449317944ba91'),
name: 'IPhone 20',
category: 'Мобильные телефоны',
price: 99000,
inStock: false,
manufacturer: { name: 'Apple', country: 'Iran' }
}
]
```

### Задание 3.

```sql
-- Запрос посложнее

db.products.find(
{
category: "Мобильные телефоны",
price: { $gt: 10000 }
},
{
_id: 0,
name: 1,
price: 1
}
).pretty()


-- ответ
[
{ name: 'Смартфон-раскладушка X99', price: 74990 },
{ name: 'IPhone 20', price: 99000 }
]
```
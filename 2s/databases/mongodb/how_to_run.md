создаём:

```
docker run -d -p 27017:27017 mongo
```

Подключение к базе внутри контейнера:

```
docker exec -it practical_ramanujan mongosh 
use demoDB
```

вставка документа:

```
db.products.insertOne({
  name: "Ноутбук Lenovo IdeaPad",
  category: "electronics",
  price: 65000,
  inStock: true,
  tags: ["ноутбук", "для учебы", "16GB RAM"],
  manufacturer: {
    name: "Lenovo",
    country: "China"
  }
})
```

посмотреть данные - все товары в наличии:

```
db.products.find({ inStock: true }).pretty()
```

вставка побольше:

```
db.products.insertMany([
  {
    name: "Смартфон Samsung Galaxy",
    category: "electronics",
    price: 48000,
    inStock: true,
    tags: ["смартфон", "Android", "128GB"],
    manufacturer: {
      name: "Samsung",
      country: "South Korea"
    }
  },
  {
    name: "Мышь Logitech",
    category: "accessories",
    price: 2500,
    inStock: true,
    tags: ["мышь", "USB"],
    manufacturer: {
      name: "Logitech",
      country: "Switzerland"
    }
  },
  {
    name: "Наушники Sony",
    category: "electronics",
    price: 7000,
    inStock: false,
    tags: ["наушники", "Bluetooth"],
    manufacturer: {
      name: "Sony",
      country: "Japan"
    }
  }
])
```

запрос посложнее - найти все товары из категории electronics, которые стоят больше 10000 и есть в наличии, при этом показать только название и цену:

```
db.products.find(
  {
    category: "electronics",
    price: { $gt: 10000 },
    inStock: true
  },
  {
    _id: 0,
    name: 1,
    price: 1
  }
).pretty()
```
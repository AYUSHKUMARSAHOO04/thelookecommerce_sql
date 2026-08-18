# Data Dictionary

Reference schema for `bigquery-public-data.thelook_ecommerce`, as used throughout this project. Each table's grain (what one row represents) is called out explicitly, since getting the grain right is the difference between a correct KPI and a silently wrong one.

---

## `users`
**Grain:** one row per registered customer.

| Column | Description |
|---|---|
| `id` | Primary key. Referenced by `orders.user_id`, `order_items.user_id`, `events.user_id`. |
| `first_name`, `last_name` | Customer name. |
| `email` | Customer email. |
| `age` | Customer age. |
| `gender` | Customer gender. |
| `state`, `street_address`, `postal_code`, `city`, `country` | Customer address fields. |
| `latitude`, `longitude` | Customer geolocation. |
| `traffic_source` | Acquisition / marketing channel that brought the customer in. |
| `created_at` | Account creation timestamp. |
| `user_geom` | Geography type for the user's location. |

---

## `orders`
**Grain:** one row per order.

| Column | Description |
|---|---|
| `order_id` | Primary key. |
| `user_id` | Foreign key → `users.id`. |
| `status` | Order status (e.g. Complete, Cancelled, Returned, Processing, Shipped). |
| `gender` | Gender associated with the order. |
| `created_at` | Order placement timestamp. |
| `returned_at` | Return timestamp, `null` if not returned. |
| `shipped_at` | Ship timestamp, `null` if not yet shipped. |
| `delivered_at` | Delivery timestamp, `null` if not yet delivered. |
| `num_of_item` | Number of items in the order. |

---

## `order_items`
**Grain:** one row per product line item within an order.

| Column | Description |
|---|---|
| `id` | Primary key. |
| `order_id` | Foreign key → `orders.order_id`. |
| `user_id` | Foreign key → `users.id`. |
| `product_id` | Foreign key → `products.id`. |
| `inventory_item_id` | Foreign key → `inventory_items.id`. |
| `status` | Item-level status. |
| `created_at`, `shipped_at`, `delivered_at`, `returned_at` | Item-level lifecycle timestamps. |
| `sale_price` | Actual price the item sold for. This is the revenue field used throughout the project — not `products.retail_price`. |

---

## `products`
**Grain:** one row per product (catalog-level, not physical inventory).

| Column | Description |
|---|---|
| `id` | Primary key. Referenced by `order_items.product_id`. |
| `cost` | Wholesale cost — used together with `sale_price` to compute profit. |
| `category` | Product category (e.g. Jeans, Outerwear). |
| `name` | Product name. |
| `brand` | Product brand. |
| `retail_price` | List price. |
| `department` | Department (Men/Women). |
| `sku` | Stock keeping unit. |
| `distribution_center_id` | Distribution center associated with the product record. |

---

## `inventory_items`
**Grain:** one row per physical inventory unit.

| Column | Description |
|---|---|
| `id` | Primary key. Referenced by `order_items.inventory_item_id`. |
| `product_id` | Foreign key → `products.id`. |
| `created_at` | Inventory intake timestamp. |
| `sold_at` | Sale timestamp, `null` if unsold — used for inventory sell-through analysis. |
| `cost` | Unit cost. |
| `product_category`, `product_name`, `product_brand`, `product_retail_price`, `product_department`, `product_sku` | Denormalized copies of the product attributes at the inventory-item level. |
| `product_distribution_center_id` | Foreign key → `distribution_centers.id`. |

---

## `distribution_centers`
**Grain:** one row per warehouse.

| Column | Description |
|---|---|
| `id` | Primary key. |
| `name` | Warehouse name. |
| `latitude`, `longitude` | Warehouse geolocation. |
| `distribution_center_geom` | Geography type for the warehouse location. |

---

## `events`
**Grain:** one row per website/app activity event.

| Column | Description |
|---|---|
| `id` | Primary key. |
| `user_id` | Foreign key → `users.id` (nullable for anonymous sessions). |
| `sequence_number` | Order of the event within a session. |
| `session_id` | Session identifier. |
| `created_at` | Event timestamp. |
| `ip_address` | Client IP. |
| `city`, `state`, `postal_code` | Event location fields. |
| `browser` | Client browser. |
| `traffic_source` | Traffic source associated with the session. |
| `uri` | Page/URI visited. |
| `event_type` | Type of event (e.g. product, cart, purchase, home). |

---

## Join map used throughout the project

```
users.id            = orders.user_id
orders.order_id      = order_items.order_id
products.id          = order_items.product_id
inventory_items.id   = order_items.inventory_item_id
distribution_centers.id = inventory_items.product_distribution_center_id
users.id            = events.user_id
```

No columns outside this schema (e.g. `payment_type`, `discount_code`) exist in the dataset and none are referenced anywhere in the project.

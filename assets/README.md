# Assets

Place for supporting images referenced by the README (e.g. an ERD export, a BigQuery screenshot, or a results chart) if you choose to add any. Nothing in this folder is required for the SQL to run it's purely for presentation.

```mermaid
erDiagram
    USERS ||--o{ ORDERS : places
    ORDERS ||--o{ ORDER_ITEMS : contains
    PRODUCTS ||--o{ ORDER_ITEMS : sold_as
    ORDER_ITEMS ||--|| INVENTORY_ITEMS : fulfilled_by
    DISTRIBUTION_CENTERS ||--o{ INVENTORY_ITEMS : stocks
    USERS ||--o{ EVENTS : generates

    USERS {
        int id PK
        string traffic_source
        timestamp created_at
    }
    ORDERS {
        int order_id PK
        int user_id FK
        string status
        timestamp created_at
        timestamp delivered_at
        timestamp returned_at
    }
    ORDER_ITEMS {
        int id PK
        int order_id FK
        int user_id FK
        int product_id FK
        int inventory_item_id FK
        numeric sale_price
    }
    PRODUCTS {
        int id PK
        string category
        string brand
        numeric cost
        numeric retail_price
    }
    INVENTORY_ITEMS {
        int id PK
        int product_id FK
        int product_distribution_center_id FK
        timestamp sold_at
    }
    DISTRIBUTION_CENTERS {
        int id PK
        string name
    }
    EVENTS {
        int id PK
        int user_id FK
        string event_type
        string traffic_source
    }
```

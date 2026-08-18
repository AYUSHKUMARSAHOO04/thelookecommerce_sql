# SQL Concepts Demonstrated

Every concept listed below is verified to be present in the project's SQL — nothing here is aspirational. Concepts are grouped by category with a representative question for reference.

## Core querying
- `SELECT`, `WHERE`, `DISTINCT` — foundational filtering and column selection
- `GROUP BY`, `HAVING` — aggregation and post-aggregation filtering (e.g. q16, q29, q43 filter out low-volume groups with `HAVING`)
- `ORDER BY`, `LIMIT` — result ordering and top-N extraction (e.g. q88, q89)

## Aggregation
- `COUNT`, `COUNT(DISTINCT ...)` — e.g. distinguishing `COUNT(*)` orders from `COUNT(DISTINCT order_id)` to avoid double-counting at the item grain
- `COUNTIF(...)` — conditional counting, used extensively for rate calculations (return rate, cancellation rate, conversion rate)
- `SUM`, `AVG`, `MIN`, `MAX`, `ROUND`
- `CASE WHEN ... THEN ... ELSE ... END` — conditional aggregation and business segmentation logic (customer segments, age bands, activity status)

## Query composition
- **CTEs (`WITH ... AS (...)`)** — used in nearly every multi-step query to separate raw aggregation from final shaping, rather than nesting subqueries
- **Subqueries** — scalar subqueries for revenue-contribution percentages (q8, q47, q88, q89)
- **Joins** — `JOIN` (inner) and `LEFT JOIN`, chained across up to four tables (`orders` → `order_items` → `inventory_items` → `distribution_centers`) for distribution-center analytics

## Window functions
- `OVER(...)`, `PARTITION BY` — ranking and comparisons within a group rather than globally
- `DENSE_RANK()` — top-N per category/month where ties should share a rank (q9, q25, q26)
- `ROW_NUMBER()` — top-N per group where exactly one row per rank is required (q63, q65, q66, q74, q87)
- `LAG()` — period-over-period comparison for month-over-month growth (q11, q24, q45)

## Date & time functions
- `DATE_TRUNC` — bucketing timestamps into calendar months for time-series analysis
- `DATE_DIFF`, `TIMESTAMP_DIFF` — recency and duration calculations (days since last order, delivery time, return time)
- `DATE_ADD`, `CURRENT_DATE()` — relative date arithmetic for recency segmentation
- `FORMAT_DATE`, `FORMAT_TIMESTAMP` — human-readable month labels for reporting output

## Safe / defensive SQL
- `SAFE_DIVIDE(...)` — used throughout instead of raw division to avoid divide-by-zero errors when a denominator (e.g. order count, customer count) could be zero
- `NULL` handling — explicit `IS NULL` / `IS NOT NULL` checks before computing delivery times, return times, and inventory sell-through, since these dates are legitimately absent for orders that haven't reached that stage yet

## Applied analytical patterns
- **Cohort-style analysis** — first-order-month logic to classify customers as new vs. repeat in a given month (q20–q24, q40)
- **RFM-style segmentation** — recency, frequency, and monetary value combined into named customer segments (q34, q36, q37–q39)
- **Revenue contribution / concentration** — percentage-of-total calculations for categories, traffic sources, and top customers/products (q8, q47, q88, q89)
- **Profitability decomposition** — `sale_price - cost` at the category, brand, product, and distribution-center level

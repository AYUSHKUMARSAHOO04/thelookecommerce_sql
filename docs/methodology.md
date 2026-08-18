# Methodology

How each of the 90 questions was approached, and the recurring lessons that shaped the SQL across the project.

## Approach

1. **Understand table grain.** Before writing anything, identify what one row means in each table involved — a customer, an order, an order line item, a physical inventory unit, or an event. Most incorrect SQL comes from aggregating at the wrong grain, not from syntax errors.
2. **Identify the actual business question.** Restate what's being asked in plain terms before touching SQL — e.g. "which categories have the highest return rate" is a rate question with a denominator, not a raw count question.
3. **Select the correct table(s).** Revenue lives in `order_items.sale_price`, not `products.retail_price`. Delivery/return timing lives in `orders`, not `order_items`, unless the question is explicitly item-level.
4. **Join using validated keys.** Only the relationships in the data dictionary's join map are used — no assumed or invented keys.
5. **Aggregate at the correct grain**, using CTEs to compute an intermediate aggregate before the final shaping step, rather than mixing aggregation levels in one pass.
6. **Apply business logic** (segmentation thresholds, date windows, status filters) explicitly and visibly, so the logic is auditable rather than buried in a single dense expression.
7. **Validate edge cases** — nulls, zero denominators, and low-sample groups — before trusting a result.
8. **Calculate the KPI**, rounding only in the final `SELECT`, not in intermediate CTEs, to avoid compounding rounding error.
9. **Interpret the result** in business terms, not just SQL output.

## Recurring lessons

**Order-level vs. item-level grain.** `orders` has one row per order; `order_items` has one row per product line. Counting orders from `order_items` without `DISTINCT order_id` inflates the order count by the average items-per-order — a common source of quietly wrong KPIs in this dataset.

**Customer-level vs. order-level aggregation.** Customer lifetime value, segmentation, and recency questions aggregate at the `user_id` level; average order value questions aggregate at the `order_id` level first, then average across orders. Averaging `sale_price` directly (item-level) instead of summing to order level first produces a different, incorrect number for AOV.

**Why `COUNT(DISTINCT order_id)` matters.** Any time `order_items` is joined into a question about orders (not line items), `COUNT(DISTINCT order_id)` is used instead of `COUNT(*)`, since a single order can contain multiple line items.

**Why AOV must be calculated at order level.** Average order value is the average of per-order totals, not the average line-item price. The project computes order totals in a CTE first, then averages those totals (see q05).

**Why return rate needs a clearly defined denominator.** "Return rate" is only meaningful with an explicit, stated denominator — total orders, orders above a minimum threshold, or orders within a time window. Several queries (q16, q17, q29, q32, q43, q61) add a `HAVING` clause with a minimum volume threshold specifically to avoid a 100% "return rate" on a group with one order.

**Why date fields must match the business definition.** `created_at`, `shipped_at`, `delivered_at`, and `returned_at` all exist in `orders`, and using the wrong one silently changes the meaning of a metric. Delivered-order revenue analysis explicitly filters on `delivered_at IS NOT NULL` rather than `created_at`, since the question is about fulfilled revenue, not placed revenue.

**Why `SAFE_DIVIDE` is used.** Any ratio with a data-dependent denominator (customers, orders, revenue) uses `SAFE_DIVIDE` instead of `/`, since a zero denominator is a realistic outcome for a low-volume group and should return `NULL`, not error out the whole query.

**Why ranking must sometimes be partitioned.** "Top products per category" and "top 3 per month" are meaningless without `PARTITION BY` — un-partitioned ranking would just return the global top N and ignore the per-group requirement. `DENSE_RANK()` is used where ties should share a position; `ROW_NUMBER()` is used where exactly one row per group is required regardless of ties.

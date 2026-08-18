-- =====================================================================
-- TheLook E-commerce SQL Business Analytics
-- Section: Inventory, Geography & Advanced Business KPIs
-- Dataset: bigquery-public-data.thelook_ecommerce
-- =====================================================================

-- q83: Which countries have the highest number of customers.
select country, count(*) as customers
from `bigquery-public-data.thelook_ecommerce.users`
group by country
order by customers desc;

-- q84: Which countries generate the highest revenue.
select u.country, count(distinct u.id) as customers, round(sum(oi.sale_price), 2) as revenue
from `bigquery-public-data.thelook_ecommerce.users` u
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on u.id = oi.user_id
group by u.country
order by revenue desc;

-- q85: What percentage of inventory items have been sold.
select count(*) as total_inventory, countif(sold_at is not null) as sold_items, round(safe_divide(countif(sold_at is not null) * 100, count(*)), 2) as sold_rate
from `bigquery-public-data.thelook_ecommerce.inventory_items`;

-- q86: Which product categories have the highest amount of unsold inventory.
select product_category, count(*) as unsold_items
from `bigquery-public-data.thelook_ecommerce.inventory_items`
where sold_at is null
group by product_category
order by unsold_items desc;

-- q87: What are the top three revenue-generating products within each product category.
with product_revenue as (
select p.category, p.name, sum(oi.sale_price) as revenue
from `bigquery-public-data.thelook_ecommerce.products` p
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on p.id = oi.product_id
group by p.category, p.name),
ranked as (
select category, name, revenue, row_number() over(
partition by category
order by revenue desc) as rank
from product_revenue)
select category, name, round(revenue, 2) as revenue
from ranked
where rank <= 3
order by category, rank;

-- q11: How has monthly delivered sales value changed over time.
with present_revenue as (
select date_trunc(delivered_at, month) as month, round(sum(sale_price),2) as monthly_revenue
from `bigquery-public-data.thelook_ecommerce.order_items`
where delivered_at is not null
group by month),
prev_revenue as (
select month, monthly_revenue, lag(monthly_revenue) over(
order by month) as prev_month_revenue
from present_revenue)
select format_timestamp('%B %Y', month) as months, monthly_revenue,prev_month_revenue, round(monthly_revenue - prev_month_revenue,2) as revenue_change, round(safe_divide(monthly_revenue - prev_month_revenue, prev_month_revenue) * 100,2) as mom_growth_percentage
from prev_revenue
order by month;


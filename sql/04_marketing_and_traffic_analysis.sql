-- =====================================================================
-- TheLook E-commerce SQL Business Analytics
-- Section: Marketing & Traffic Source Analysis
-- Dataset: bigquery-public-data.thelook_ecommerce
-- =====================================================================

-- q44: Which traffic sources bring the most customers and generate the most revenue.
with traffic_revenue as (
select u.traffic_source, count(distinct u.id) as customers, sum(oi.sale_price) as revenue
from `bigquery-public-data.thelook_ecommerce.users` u
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on u.id = oi.user_id
group by u.traffic_source)
select traffic_source, customers, round(revenue, 2) as total_revenue, round(safe_divide(revenue, customers), 2) as revenue_per_customer
from traffic_revenue
order by total_revenue desc;

-- q45: How does revenue from each traffic source change month-over-month.
with monthly_revenue as (
select date_trunc(date(oi.created_at), month) as month, u.traffic_source, sum(oi.sale_price) as revenue
from `bigquery-public-data.thelook_ecommerce.order_items` oi
  join `bigquery-public-data.thelook_ecommerce.users` u
  on oi.user_id = u.id
group by month, u.traffic_source),
growth as (
select month, traffic_source, revenue, lag(revenue) over(
partition by traffic_source
order by month) as prev_revenue
from monthly_revenue)
select format_date('%B %Y', month) as months, traffic_source, round(revenue, 2) as revenue, round(safe_divide(revenue - prev_revenue, prev_revenue) * 100, 2) as mom_growth
from growth
order by month, traffic_source;

-- q46: Which traffic sources generate the highest percentage of customers who place an order.
with source_customers as (
select u.traffic_source, count(distinct u.id) as customers, count(distinct o.user_id) as ordered_customers
from `bigquery-public-data.thelook_ecommerce.users` u
  left join `bigquery-public-data.thelook_ecommerce.orders` o
  on u.id = o.user_id
group by u.traffic_source)
select traffic_source, customers, ordered_customers, round(safe_divide(ordered_customers * 100, customers), 2) as conversion_rate
from source_customers
order by conversion_rate desc;

-- q47: What percentage of total revenue is contributed by each traffic source.
with source_revenue as (
select u.traffic_source, sum(oi.sale_price) as revenue
from `bigquery-public-data.thelook_ecommerce.users` u
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on u.id = oi.user_id
group by u.traffic_source)
select traffic_source, round(revenue, 2) as total_revenue, round(safe_divide(revenue * 100, (
select sum(sale_price)
from `bigquery-public-data.thelook_ecommerce.order_items`)), 2) as revenue_contribution
from source_revenue
order by revenue_contribution desc;

-- q48: Which traffic sources acquire the most new customers.
with first_order as (
select user_id, min(date(created_at)) as first_order_date
from `bigquery-public-data.thelook_ecommerce.orders`
group by user_id)
select u.traffic_source, count(*) as new_customers
from first_order fo
  join `bigquery-public-data.thelook_ecommerce.users` u
  on fo.user_id = u.id
group by u.traffic_source
order by new_customers desc;

-- q49: What is the average revenue generated per customer from each traffic source.
with source_revenue as (
select u.traffic_source, count(distinct u.id) as customers, sum(oi.sale_price) as revenue
from `bigquery-public-data.thelook_ecommerce.users` u
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on u.id = oi.user_id
group by u.traffic_source)
select traffic_source, customers, round(revenue, 2) as total_revenue, round(safe_divide(revenue, customers), 2) as revenue_per_customer
from source_revenue
order by revenue_per_customer desc;

-- q78: Which traffic sources generate the highest website activity.
with source_activity as (
select u.traffic_source, count(e.id) as total_events, count(distinct e.user_id) as active_users
from `bigquery-public-data.thelook_ecommerce.events` e
  join `bigquery-public-data.thelook_ecommerce.users` u
  on e.user_id = u.id
group by u.traffic_source)
select traffic_source, total_events, active_users, round(safe_divide(total_events, active_users), 2) as events_per_user
from source_activity
order by total_events desc;

-- q80: Which traffic sources bring the most engaged users to the website.
with source_users as (
select u.traffic_source, e.user_id, count(e.id) as events
from `bigquery-public-data.thelook_ecommerce.events` e
  join `bigquery-public-data.thelook_ecommerce.users` u
  on e.user_id = u.id
group by u.traffic_source, e.user_id)
select traffic_source, count(*) as active_users, sum(events) as total_events, round(avg(events), 2) as avg_events_per_user
from source_users
group by traffic_source
order by avg_events_per_user desc;


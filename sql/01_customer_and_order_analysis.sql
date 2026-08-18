-- =====================================================================
-- TheLook E-commerce SQL Business Analytics
-- Section: Customer & Order Fundamentals
-- Dataset: bigquery-public-data.thelook_ecommerce
-- =====================================================================

-- q01: Determine the total number of users in the e-commerce platform.
select count(*) as total_users
from `bigquery-public-data.thelook_ecommerce.users`;

-- q02: Calculate the total number of orders placed by customers.
select count(*) as total_orders
from `bigquery-public-data.thelook_ecommerce.orders`;

-- q03: Measure the number of customers who successfully converted into buyers (atleast one order).
select count(distinct user_id) as ordered_users
from `bigquery-public-data.thelook_ecommerce.orders`;

-- q04: Identify registered users who have not made any purchases.
select u.id
from `bigquery-public-data.thelook_ecommerce.users` u
  left join `bigquery-public-data.thelook_ecommerce.orders` o
  on u.id = o.user_id
where o.user_id is null;

-- q05: Calculate the average revenue generated per order.
with net_sales as (
select sum(sale_price) as total_sales
from `bigquery-public-data.thelook_ecommerce.order_items`
group by order_id)
select avg(total_sales) as aov
from net_sales;

-- q06: Identify the highest revenue-generating customers.
with top_revenue as (
select user_id, sum(sale_price) as total_sales
from `bigquery-public-data.thelook_ecommerce.order_items`
group by user_id),
customer_rank as (
select user_id, total_sales, dense_rank() over(
order by total_sales desc) as rank
from top_revenue)
select cr.user_id, u.first_name, u.last_name, cr.total_sales, cr.rank
from `bigquery-public-data.thelook_ecommerce.users` u
  join customer_rank cr
  on u.id = cr.user_id
where cr.rank <= 10
order by cr.rank;

-- q12: When did each customer place their most recent order, and how many days has it been since their last purchase.
with recent_order as (
select user_id, max(date(created_at)) as recent_orderdate
from `bigquery-public-data.thelook_ecommerce.orders`
group by user_id)
select user_id, recent_orderdate, date_diff(current_date(),recent_orderdate, day) as days_gap
from recent_order;

-- q17: For customers who have spent at least ₹500, what is their total revenue, number of orders, number of returned orders, and return rate.
select o.user_id, count(distinct o.order_id) as total_orders, round(sum(oi.sale_price),2) as total_revenue, count(distinct case when o.returned_at is not null then o.order_id end) as returned_orders, count(distinct case when o.returned_at is not null then o.order_id end)*100/count(distinct o.order_id) as return_rate_percentage
from `bigquery-public-data.thelook_ecommerce.orders` o
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on o.user_id = oi.user_id
group by o.user_id
having sum(oi.sale_price) >= 500 and count(distinct o.order_id) >= 3
order by return_rate_percentage desc;

-- q25: Finding the top 5 customers by revenue in each month.
with monthly_customer_revenue as (
select date_trunc(date(o.created_at), month) as month, o.user_id, sum(oi.sale_price) as revenue
from `bigquery-public-data.thelook_ecommerce.orders` o
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on o.order_id = oi.order_id
group by month, o.user_id),
ranked_customers as (
select month, user_id, revenue, dense_rank() over(
partition by month
order by revenue desc) as rank
from monthly_customer_revenue)
select format_date('%b %Y', month) as months, user_id, round(revenue, 2) as revenue, rank
from ranked_customers
where rank <= 5
order by month, rank;

-- q35: How many days has it been since each customer's most recent order.
with customer_orders as (
select user_id, max(date(created_at)) as last_order_date
from `bigquery-public-data.thelook_ecommerce.orders`
group by user_id)
select user_id, last_order_date, date_diff(current_date(), last_order_date, day) as days_since_last_order
from customer_orders
order by days_since_last_order desc;

-- q81: How does the average number of items per order change month-over-month.
with monthly_orders as (
select date_trunc(date(created_at), month) as month, count(*) as orders, sum(num_of_item) as items
from `bigquery-public-data.thelook_ecommerce.orders`
group by month)
select format_date('%B %Y', month) as months, orders, items, round(safe_divide(items, orders), 2) as avg_items_per_order
from monthly_orders
order by month;

-- q82: What percentage of orders contain more than one item.
select count(*) as total_orders, countif(num_of_item > 1) as multi_item_orders, round(safe_divide(countif(num_of_item > 1) * 100, count(*)), 2) as multi_item_order_rate
from `bigquery-public-data.thelook_ecommerce.orders`;


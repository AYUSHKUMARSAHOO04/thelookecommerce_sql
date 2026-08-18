-- =====================================================================
-- TheLook E-commerce SQL Business Analytics
-- Section: Returns, Delivery & Distribution Center Operations
-- Dataset: bigquery-public-data.thelook_ecommerce
-- =====================================================================

-- q13: No. of days does it take, on average, for an order to be delivered after it is placed.
select count(created_at)
from `bigquery-public-data.thelook_ecommerce.orders`;
select count(delivered_at)
from `bigquery-public-data.thelook_ecommerce.orders`
where delivered_at is not null;
with delivery_details as (
select user_id, order_id, created_at as order_placed, delivered_at as delivery_placed
from `bigquery-public-data.thelook_ecommerce.orders`
where delivered_at is not null
order by user_id) , hours_gap as (
select user_id, order_id, order_placed, delivery_placed, round(timestamp_diff(delivery_placed, order_placed, hour),2) as hours_taken
from delivery_details)
select round(avg(hours_taken/24),2) as avg_delivery_days
from hours_gap;

-- q14: For returned orders, what is the average number of days between delivery and return.
select count(returned_at)
from `bigquery-public-data.thelook_ecommerce.orders`
where returned_at is not null;
select count(delivered_at)
from `bigquery-public-data.thelook_ecommerce.orders`
where delivered_at is not null;
with delivery_details as (
select user_id, order_id, returned_at as order_returned, delivered_at as delivery_placed
from `bigquery-public-data.thelook_ecommerce.orders`
where returned_at is not null and delivered_at is not null
order by user_id) , hours_gap as (
select user_id, order_id, order_returned, delivery_placed, round(timestamp_diff(order_returned, delivery_placed, hour),2) as hours_taken
from delivery_details)
select round(avg(hours_taken/24),2) as avg_delivery_days
from hours_gap;

-- q15: Percentage of orders are being returned.
with order_details as (
select count(order_id) as total_orders, countif(returned_at is not null) as returned_orders
from `bigquery-public-data.thelook_ecommerce.orders`)
select total_orders, returned_orders, round(returned_orders*100 / total_orders,2) as return_rate_percentage
from order_details;

-- q16: For each customer who has placed at least one order, what percentage of their orders were returned.
select user_id, count(*) as total_orders, countif(returned_at is not null) as returned_orders, countif(returned_at is not null)*100/count(*) as return_rate_percentage
from `bigquery-public-data.thelook_ecommerce.orders`
group by user_id
having total_orders >= 3
order by return_rate_percentage desc;

-- q27: Which products have the highest return rate.
with product_orders as (
select oi.product_id, p.name as product_name, count(distinct o.order_id) as total_orders, count(distinct case when o.returned_at is not null then o.order_id end) as returned_orders
from `bigquery-public-data.thelook_ecommerce.orders` o
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on o.order_id = oi.order_id
  join `bigquery-public-data.thelook_ecommerce.products` p
  on oi.product_id = p.id
group by oi.product_id, p.name)
select product_id, product_name, total_orders, returned_orders, round(safe_divide(returned_orders * 100, total_orders), 2) as return_rate_percentage
from product_orders
where total_orders >= 5
order by return_rate_percentage desc;

-- q28: Which distribution center generates the highest revenue.
with center_revenue as (
select dc.id as center_id, dc.name as center_name, sum(oi.sale_price) as revenue
from `bigquery-public-data.thelook_ecommerce.order_items` oi
  join `bigquery-public-data.thelook_ecommerce.inventory_items` ii
  on oi.inventory_item_id = ii.id
  join `bigquery-public-data.thelook_ecommerce.distribution_centers` dc
  on ii.product_distribution_center_id = dc.id
group by dc.id, dc.name)
select center_id, center_name, round(revenue, 2) as total_revenue
from center_revenue
order by total_revenue desc;

-- q29: Which product categories have the highest return rate.
with category_orders as (
select p.category, count(distinct o.order_id) as total_orders, count(distinct case when o.returned_at is not null then o.order_id end) as returned_orders
from `bigquery-public-data.thelook_ecommerce.orders` o
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on o.order_id = oi.order_id
  join `bigquery-public-data.thelook_ecommerce.products` p
  on oi.product_id = p.id
group by p.category)
select category, total_orders, returned_orders, round(safe_divide(returned_orders * 100, total_orders), 2) as return_rate_percentage
from category_orders
where total_orders >= 100
order by return_rate_percentage desc;

-- q30: Which distribution centers have the longest average delivery time.
with delivery_details as (
select dc.id as center_id, dc.name as center_name,timestamp_diff(o.delivered_at, o.created_at, hour) / 24.0 as delivery_days
from `bigquery-public-data.thelook_ecommerce.orders` o
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on o.order_id = oi.order_id
  join `bigquery-public-data.thelook_ecommerce.inventory_items` ii
  on oi.inventory_item_id = ii.id
  join `bigquery-public-data.thelook_ecommerce.distribution_centers` dc
  on ii.product_distribution_center_id = dc.id
where o.delivered_at is not null)
select center_id, center_name, round(avg(delivery_days),2) as avg_delivery_days
from delivery_details
group by center_id, center_name
order by avg_delivery_days desc;

-- q32: Which product brands have the highest return rate.
with brand_orders as (
select p.brand, count(distinct o.order_id) as total_orders, count(distinct case when o.returned_at is not null then o.order_id end) as returned_orders
from `bigquery-public-data.thelook_ecommerce.orders` o
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on o.order_id = oi.order_id
  join `bigquery-public-data.thelook_ecommerce.products` p
  on oi.product_id = p.id
group by p.brand)
select brand, total_orders, returned_orders, round(safe_divide(returned_orders * 100, total_orders), 2) as return_rate_percentage
from brand_orders
where total_orders >= 100
order by return_rate_percentage desc;

-- q42: What percentage of orders were cancelled each month.
with monthly_orders as (
select date_trunc(date(created_at), month) as month, count(*) as total_orders, countif(status = 'Cancelled') as cancelled_orders
from `bigquery-public-data.thelook_ecommerce.orders`
group by month)
select format_date('%B %Y', month) as months, total_orders, cancelled_orders, round(safe_divide(cancelled_orders * 100, total_orders), 2) as cancellation_rate
from monthly_orders
order by month;

-- q43: Which product categories have the highest order cancellation rate.
with category_orders as (
select p.category, count(distinct o.order_id) as total_orders, count(distinct case when o.status = 'Cancelled' then o.order_id end) as cancelled_orders
from `bigquery-public-data.thelook_ecommerce.orders` o
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on o.order_id = oi.order_id
  join `bigquery-public-data.thelook_ecommerce.products` p
  on oi.product_id = p.id
group by p.category)
select category, total_orders, cancelled_orders, round(safe_divide(cancelled_orders * 100, total_orders), 2) as cancellation_rate
from category_orders
where total_orders >= 100
order by cancellation_rate desc;

-- q58: Which distribution centers generate the highest revenue.
with center_revenue as (
select dc.id, dc.name, sum(oi.sale_price) as revenue
from `bigquery-public-data.thelook_ecommerce.distribution_centers` dc
  join `bigquery-public-data.thelook_ecommerce.inventory_items` ii
  on dc.id = ii.product_distribution_center_id
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on ii.id = oi.inventory_item_id
group by dc.id, dc.name)
select name, round(revenue, 2) as total_revenue
from center_revenue
order by total_revenue desc;

-- q59: Which distribution centers handle the highest number of orders.
with center_orders as (
select dc.id, dc.name, count(distinct oi.order_id) as total_orders
from `bigquery-public-data.thelook_ecommerce.distribution_centers` dc
  join `bigquery-public-data.thelook_ecommerce.inventory_items` ii
  on dc.id = ii.product_distribution_center_id
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on ii.id = oi.inventory_item_id
group by dc.id, dc.name)
select name, total_orders
from center_orders
order by total_orders desc;

-- q60: Which distribution centers have the highest average order value.
with center_orders as (
select dc.id, dc.name, oi.order_id, sum(oi.sale_price) as order_value
from `bigquery-public-data.thelook_ecommerce.distribution_centers` dc
  join `bigquery-public-data.thelook_ecommerce.inventory_items` ii
  on dc.id = ii.product_distribution_center_id
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on ii.id = oi.inventory_item_id
group by dc.id, dc.name, oi.order_id)
select name, count(*) as total_orders, round(avg(order_value), 2) as avg_order_value
from center_orders
group by name
order by avg_order_value desc;

-- q61: Which distribution centers have the highest order return rate.
with center_orders as (
select dc.id, dc.name, oi.order_id, max(o.returned_at) as returned_at
from `bigquery-public-data.thelook_ecommerce.distribution_centers` dc
  join `bigquery-public-data.thelook_ecommerce.inventory_items` ii
  on dc.id = ii.product_distribution_center_id
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on ii.id = oi.inventory_item_id
  join `bigquery-public-data.thelook_ecommerce.orders` o
  on oi.order_id = o.order_id
group by dc.id, dc.name, oi.order_id)
select name, count(*) as total_orders, countif(returned_at is not null) as returned_orders, round(safe_divide(countif(returned_at is not null) * 100, count(*)), 2) as return_rate
from center_orders
group by name
having total_orders >= 100
order by return_rate desc;

-- q62: Which distribution centers have the fastest average delivery time.
with delivery_details as (
select dc.name, o.order_id, o.created_at, o.delivered_at
from `bigquery-public-data.thelook_ecommerce.distribution_centers` dc
  join `bigquery-public-data.thelook_ecommerce.inventory_items` ii
  on dc.id = ii.product_distribution_center_id
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on ii.id = oi.inventory_item_id
  join `bigquery-public-data.thelook_ecommerce.orders` o
  on oi.order_id = o.order_id
where o.delivered_at is not null),
order_delivery as (
select name, order_id, timestamp_diff(max(delivered_at), min(created_at), hour) / 24.0 as delivery_days
from delivery_details
group by name, order_id)
select name, count(*) as orders, round(avg(delivery_days), 2) as avg_delivery_days
from order_delivery
group by name
having orders >= 100
order by avg_delivery_days desc;

-- q63: Which product categories generate the most revenue from each distribution center.
with category_revenue as (
select dc.name as distribution_center, p.category, sum(oi.sale_price) as net_revenue
from `bigquery-public-data.thelook_ecommerce.distribution_centers` dc
  join `bigquery-public-data.thelook_ecommerce.inventory_items` ii
  on dc.id = ii.product_distribution_center_id
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on ii.id = oi.inventory_item_id
  join `bigquery-public-data.thelook_ecommerce.products` p
  on oi.product_id = p.id
group by dc.name, p.category),
ranking as (
select distribution_center, category, net_revenue, row_number() over(
partition by distribution_center
order by net_revenue desc) as rank
from category_revenue)
select distribution_center, category, round(net_revenue, 2) as total_revenue
from ranking
where rank = 1
order by total_revenue desc;

-- q64: Which product categories generate the net revenue from each distribution center.
with category_revenue as (
select dc.name as distribution_center, p.category, sum(oi.sale_price) as revenue
from `bigquery-public-data.thelook_ecommerce.distribution_centers` dc
  join `bigquery-public-data.thelook_ecommerce.inventory_items` ii
  on dc.id = ii.product_distribution_center_id
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on ii.id = oi.inventory_item_id
  join `bigquery-public-data.thelook_ecommerce.products` p
  on oi.product_id = p.id
group by dc.name, p.category)
select distribution_center, category, round(revenue, 2) as total_revenue
from category_revenue
order by distribution_center, total_revenue desc;

-- q65: Which product category generates the most revenue for each distribution center.
with category_revenue as (
select dc.name as distribution_center, p.category, sum(oi.sale_price) as revenue
from `bigquery-public-data.thelook_ecommerce.distribution_centers` dc
  join `bigquery-public-data.thelook_ecommerce.inventory_items` ii
  on dc.id = ii.product_distribution_center_id
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on ii.id = oi.inventory_item_id
  join `bigquery-public-data.thelook_ecommerce.products` p
  on oi.product_id = p.id
group by dc.name, p.category),
ranked as (
select distribution_center, category, revenue, row_number() over(
partition by distribution_center
order by revenue desc) as rank
from category_revenue)
select distribution_center, category, round(revenue, 2) as revenue
from ranked
where rank = 1
order by revenue desc;

-- q66: Which individual product generates the highest revenue for each distribution center.
with product_revenue as (
select dc.name as distribution_center, p.name as product, sum(oi.sale_price) as revenue
from `bigquery-public-data.thelook_ecommerce.distribution_centers` dc
  join `bigquery-public-data.thelook_ecommerce.inventory_items` ii
  on dc.id = ii.product_distribution_center_id
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on ii.id = oi.inventory_item_id
  join `bigquery-public-data.thelook_ecommerce.products` p
  on oi.product_id = p.id
group by dc.name, p.name),
ranked as (
select distribution_center, product, revenue, row_number() over(
partition by distribution_center
order by revenue desc) as rank
from product_revenue)
select distribution_center, product, round(revenue, 2) as revenue
from ranked
where rank = 1
order by revenue desc;

-- q68: Which products have the highest return rate.
with product_orders as (
select p.id, p.name, count(distinct o.order_id) as total_orders, count(distinct case when o.returned_at is not null then o.order_id end) as returned_orders
from `bigquery-public-data.thelook_ecommerce.products` p
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on p.id = oi.product_id
  join `bigquery-public-data.thelook_ecommerce.orders` o
  on oi.order_id = o.order_id
group by p.id, p.name)
select name, total_orders, returned_orders, round(safe_divide(returned_orders * 100, total_orders), 2) as return_rate
from product_orders
where total_orders >= 50
order by return_rate desc;


-- 1) Determine the total number of users in the e-commerce platform.
select count(*) as total_users from `bigquery-public-data.thelook_ecommerce.users`;

-- 2) Calculate the total number of orders placed by customers.
select count(*) as total_orders from `bigquery-public-data.thelook_ecommerce.orders`;

-- 3) Measure the number of customers who successfully converted into buyers (atleast one order).
select count(distinct user_id) as ordered_users from `bigquery-public-data.thelook_ecommerce.orders`;

-- 4) Identify registered users who have not made any purchases.
select u.id from `bigquery-public-data.thelook_ecommerce.users` u left join `bigquery-public-data.thelook_ecommerce.orders` o on u.id = o.user_id where o.user_id is null;

-- 5) Calculate the average revenue generated per order.
with net_sales as (select sum(sale_price) as total_sales from `bigquery-public-data.thelook_ecommerce.order_items` group by order_id)
select avg(total_sales) as aov from net_sales;

-- 6) Identify the highest revenue-generating customers.
with top_revenue as (select user_id, sum(sale_price) as total_sales from `bigquery-public-data.thelook_ecommerce.order_items` group by user_id),
customer_rank as (select user_id, total_sales, dense_rank() over(order by total_sales desc) as rank from top_revenue)
select cr.user_id, u.first_name, u.last_name, cr.total_sales, cr.rank from `bigquery-public-data.thelook_ecommerce.users` u join customer_rank cr on u.id = cr.user_id
where cr.rank <= 10 order by cr.rank;

-- 7) Analyze category-wise revenue contribution to identify the highest-performing product categories.
select p.category, sum(oi.sale_price) as total_sales from `bigquery-public-data.thelook_ecommerce.products` p join `bigquery-public-data.thelook_ecommerce.order_items` oi on p.id = oi.product_id group by p.category order by total_sales desc;

-- 8) Calculate each category's contribution to total company revenue.
with category_revenue as (SELECT p.category, SUM(oi.sale_price) AS total_sales FROM `bigquery-public-data.thelook_ecommerce.products` p JOIN `bigquery-public-data.thelook_ecommerce.order_items` oi ON p.id = oi.product_id GROUP BY p.category) select category, round(total_sales,2), round(total_sales*100/(select sum(sale_price) from `bigquery-public-data.thelook_ecommerce.order_items`),2) as revenue_contribution_percentage from category_revenue order by revenue_contribution_percentage desc;

-- 9)  Rank products by revenue inside each category to identify the best-selling products.
with abcd as (select p.category, p.name, sum(oi.sale_price) as revenue, dense_rank() over(partition by p.category order by sum(oi.sale_price) desc) as rank from `bigquery-public-data.thelook_ecommerce.products` p join `bigquery-public-data.thelook_ecommerce.order_items` oi on p.id = oi.product_id group by p.category, p.name ) select category, name, revenue, rank from abcd where rank <=3;

-- 10) Compare customer segments based on purchase frequency and revenue contribution.
WITH customer_summary AS ( SELECT user_id, COUNT(DISTINCT order_id) AS total_orders,SUM(sale_price) AS total_revenue FROM `bigquery-public-data.thelook_ecommerce.order_items` GROUP BY user_id)
SELECT CASE WHEN total_orders = 1 THEN 'One-time Customer' ELSE 'Repeat Customer' END AS customer_type, COUNT(*) AS number_of_customers, ROUND(SUM(total_revenue),2) AS total_revenue, ROUND(AVG(total_revenue),2) AS avg_revenue_per_customer FROM customer_summary GROUP BY customer_type;

-- 11) How has monthly delivered sales value changed over time.
with present_revenue as (select DATE_TRUNC(delivered_at, MONTH) as month, round(sum(sale_price),2) as monthly_revenue from `bigquery-public-data.thelook_ecommerce.order_items` where delivered_at is not null GROUP BY month), prev_revenue as (select month, monthly_revenue, lag(monthly_revenue) over(order by month) as prev_month_revenue from present_revenue)
select format_timestamp('%B %Y', month) AS months, monthly_revenue,prev_month_revenue, round(monthly_revenue - prev_month_revenue,2) as revenue_change, round(SAFE_DIVIDE(monthly_revenue - prev_month_revenue, prev_month_revenue) * 100,2) as MoM_growth_percentage from prev_revenue order by month;

-- 12) When did each customer place their most recent order, and how many days has it been since their last purchase.
with recent_order as (select user_id, max(date(created_at)) as recent_orderdate from `bigquery-public-data.thelook_ecommerce.orders` group by user_id) select user_id, recent_orderdate, date_diff(current_date(),recent_orderdate, day) as days_gap from recent_order;

-- 13) No. of days does it take, on average, for an order to be delivered after it is placed.
select count(created_at) from `bigquery-public-data.thelook_ecommerce.orders`;
select count(delivered_at) from `bigquery-public-data.thelook_ecommerce.orders` where delivered_at is not null;

with delivery_details as (select user_id, order_id, created_at as order_placed, delivered_at as delivery_placed from `bigquery-public-data.thelook_ecommerce.orders` where delivered_at is not null order by user_id) , hours_gap as (select user_id, order_id, order_placed, delivery_placed, round(timestamp_diff(delivery_placed, order_placed, hour),2) as hours_taken from delivery_details) select round(avg(hours_taken/24),2) as avg_delivery_days from hours_gap;

-- 14) For returned orders, what is the average number of days between delivery and return.
select count(returned_at) from `bigquery-public-data.thelook_ecommerce.orders` where returned_at is not null;
select count(delivered_at) from `bigquery-public-data.thelook_ecommerce.orders` where delivered_at is not null;

with delivery_details as (select user_id, order_id, returned_at as order_returned, delivered_at as delivery_placed from `bigquery-public-data.thelook_ecommerce.orders` where returned_at is not null and delivered_at is not null order by user_id) , hours_gap as (select user_id, order_id, order_returned, delivery_placed, round(timestamp_diff(order_returned, delivery_placed, hour),2) as hours_taken from delivery_details) select round(avg(hours_taken/24),2) as avg_delivery_days from hours_gap;

-- 15) Percentage of orders are being returned.
with order_details as (select count(order_id) as total_orders, countif(returned_at is not null) as returned_orders from `bigquery-public-data.thelook_ecommerce.orders`) select total_orders, returned_orders, round(returned_orders*100 / total_orders,2) as return_rate_percentage from order_details;

-- 16) For each customer who has placed at least one order, what percentage of their orders were returned.
select user_id, count(*) as total_orders, countif(returned_at is not null) as returned_orders, countif(returned_at is not null)*100/count(*) as return_rate_percentage from `bigquery-public-data.thelook_ecommerce.orders` group by user_id having total_orders >= 3 order by return_rate_percentage desc;

-- 17) For customers who have spent at least ₹500, what is their total revenue, number of orders, number of returned orders, and return rate.
select o.user_id, count(distinct o.order_id) as total_orders, round(sum(oi.sale_price),2) as total_revenue, count(distinct case when o.returned_at is not null then o.order_id end) as returned_orders, count(distinct case when o.returned_at is not null then o.order_id end)*100/count(distinct o.order_id) as return_rate_percentage from `bigquery-public-data.thelook_ecommerce.orders` o join `bigquery-public-data.thelook_ecommerce.order_items` oi on o.user_id = oi.user_id group by o.user_id having sum(oi.sale_price) >= 500 and count(distinct o.order_id) >= 3 order by return_rate_percentage desc;

-- 18) No. of customers fall into each revenue segment, and how much revenue does each segment generate.
with customer_details as (select user_id, sum(sale_price) as total_revenue from `bigquery-public-data.thelook_ecommerce.order_items` group by user_id), segments as (select case when total_revenue < 200 then 'Low Value' when total_revenue < 500 THEN 'Medium Value' when total_revenue < 1000 then 'High Value' else 'VIP' end as customer_segment, user_id, total_revenue from customer_details) select customer_segment, count(*) as customers, round(sum(total_revenue),2) as net_revenue, round(avg(total_revenue),2) as avg_revenue, round(count(*)*100/(select count(*) from segments),2) as customer_share_percentage from segments group by customer_segment order by case customer_segment when 'Low Value' then 1 when 'Medium Value' then 2 when 'High Value' then 3 when 'VIP' then 4 end;

-- 19) For each month, how many unique customers placed orders and how much revenue did they generate.
with customer_details as (select date_trunc(date(o.created_at),month) as month, count(distinct o.user_id) as active_customers, sum(oi.sale_price) as monthly_revenue from `bigquery-public-data.thelook_ecommerce.orders` o join `bigquery-public-data.thelook_ecommerce.order_items` oi on o.order_id = oi.order_id group by month order by month) select format_date('%B %Y', month) AS months, active_customers, round(monthly_revenue,2) as monthly_sales,round(monthly_revenue/active_customers,2) as revenue_per_customer from customer_details;

-- 20) For each month, how many customers were new customers and how many were repeat customers.
with first_order as (select user_id, min(date(created_at)) as first_order_date from `bigquery-public-data.thelook_ecommerce.orders` group by user_id), customer_month as (select distinct o.user_id, date_trunc(date(o.created_at),month) as order_month,date_trunc(fo.first_order_date, month) as first_order_month from `bigquery-public-data.thelook_ecommerce.orders` o join first_order fo on o.user_id = fo.user_id) select format_date('%B %Y', order_month) as months, countif(order_month = first_order_month) AS new_customers, countif(order_month > first_order_month) AS repeat_customers, count(*)as total_active_customers from customer_month
group by order_month order by order_month;

-- 21) For each month, how much revenue was generated by new vs repeat customers.
with first_order as (select user_id, date_trunc(date(min(created_at)),month) as first_month from `bigquery-public-data.thelook_ecommerce.orders` group by user_id), customer_orders as (select o.user_id, date_trunc(date(o.created_at),month) as order_month, fo.first_month, oi.sale_price from `bigquery-public-data.thelook_ecommerce.orders` o join first_order fo on o.user_id = fo.user_id join `bigquery-public-data.thelook_ecommerce.order_items` oi on o.order_id = oi.order_id) select format_date('%B %Y', order_month) as months,round(sum(case when order_month = first_month then sale_price else 0 end),2) AS new_customer_revenue, round(sum(case when order_month > first_month then sale_price else 0 end),2) AS repeat_customer_revenue,round(sum(sale_price),2) AS total_revenue from customer_orders group by order_month order by order_month;

-- 22) For each month, how much is the average order value for new vs repeat customers.
with first_order as (select user_id, date_trunc(date(min(created_at)), month) as first_month from `bigquery-public-data.thelook_ecommerce.orders` group by user_id), order_details as (select o.order_id, o.user_id, date_trunc(date(o.created_at), month) as order_month, fo.first_month, sum(oi.sale_price) as order_value from `bigquery-public-data.thelook_ecommerce.orders` o join first_order fo on o.user_id = fo.user_id join `bigquery-public-data.thelook_ecommerce.order_items` oi on o.order_id = oi.order_id group by o.order_id, o.user_id, order_month, fo.first_month) select format_date('%b %Y', order_month) as month, round(safe_divide(sum(case when order_month = first_month then order_value else 0 end), count(distinct case when order_month = first_month then order_id end)), 2) as new_customer_aov, round(safe_divide(sum(case when order_month > first_month then order_value else 0 end), count(distinct case when order_month > first_month then order_id end)), 2) as repeat_customer_aov from order_details group by order_month order by order_month;

-- 23) How much out of active customers each month were repeat customers.
with first_order as (select user_id, date_trunc(date(min(created_at)), month) as first_month from `bigquery-public-data.thelook_ecommerce.orders` group by user_id), customer_month as (select distinct o.user_id, date_trunc(date(o.created_at), month) as order_month, fo.first_month from `bigquery-public-data.thelook_ecommerce.orders` o join first_order fo on o.user_id = fo.user_id)
select format_date('%b %Y', order_month) as month, count(*) as active_customers, countif(order_month > first_month) as repeat_customers, round(safe_divide(countif(order_month > first_month) * 100, count(*)), 2) as repeat_customer_rate from customer_month
group by order_month order by order_month;

-- 24) How did new and repeat customer revenue change month-over-month.
with first_order as (select user_id, date_trunc(date(min(created_at)), month) as first_month from `bigquery-public-data.thelook_ecommerce.orders` group by user_id), monthly_revenue as (select date_trunc(date(o.created_at), month) as month, sum(case when date_trunc(date(o.created_at), month) = fo.first_month then oi.sale_price else 0 end) as new_revenue, sum(case when date_trunc(date(o.created_at), month) > fo.first_month then oi.sale_price else 0 end) as repeat_revenue from `bigquery-public-data.thelook_ecommerce.orders` o join first_order fo on o.user_id = fo.user_id join `bigquery-public-data.thelook_ecommerce.order_items` oi on o.order_id = oi.order_id group by month), growth as (select month, new_revenue, repeat_revenue, lag(new_revenue) over(order by month) as prev_new_revenue, lag(repeat_revenue) over(order by month) as prev_repeat_revenue from monthly_revenue)
select format_date('%b %Y', month) as months, round(new_revenue, 2) as new_revenue, round(repeat_revenue, 2) as repeat_revenue,round(safe_divide(new_revenue - prev_new_revenue, prev_new_revenue) * 100, 2) as new_revenue_mom, round(safe_divide(repeat_revenue - prev_repeat_revenue, prev_repeat_revenue) * 100, 2) as repeat_revenue_mom from growth order by month;

-- 25) Finding the top 5 customers by revenue in each month.
with monthly_customer_revenue as (select date_trunc(date(o.created_at), month) as month, o.user_id, sum(oi.sale_price) as revenue from `bigquery-public-data.thelook_ecommerce.orders` o join `bigquery-public-data.thelook_ecommerce.order_items` oi on o.order_id = oi.order_id group by month, o.user_id),ranked_customers as (select month, user_id, revenue, dense_rank() over(partition by month order by revenue desc) as rank from monthly_customer_revenue)
select format_date('%b %Y', month) as months, user_id, round(revenue, 2) as revenue, rank from ranked_customers where rank <= 5 order by month, rank;

-- 26) Which product generated the highest revenue in each month.
with monthly_product_revenue as (select date_trunc(date(o.created_at), month) as month, oi.product_id, sum(oi.sale_price) as revenue from `bigquery-public-data.thelook_ecommerce.orders` o join `bigquery-public-data.thelook_ecommerce.order_items` oi on o.order_id = oi.order_id group by month, oi.product_id), ranked_products as (select month, product_id, revenue, dense_rank() over(partition by month order by revenue desc) as rank from monthly_product_revenue)
select format_date('%b %Y', month) as months, product_id, round(revenue, 2) as revenue, rank from ranked_products where rank = 1 order by month;

-- 27) Which products have the highest return rate.
with product_orders as (select oi.product_id, p.name as product_name, count(distinct o.order_id) as total_orders, count(distinct case when o.returned_at is not null then o.order_id end) as returned_orders from `bigquery-public-data.thelook_ecommerce.orders` o join `bigquery-public-data.thelook_ecommerce.order_items` oi on o.order_id = oi.order_id join `bigquery-public-data.thelook_ecommerce.products` p on oi.product_id = p.id group by oi.product_id, p.name)
select product_id, product_name, total_orders, returned_orders, round(safe_divide(returned_orders * 100, total_orders), 2) as return_rate_percentage from product_orders where total_orders >= 5 order by return_rate_percentage desc;

-- 28) Which distribution center generates the highest revenue.
with center_revenue as (select dc.id as center_id, dc.name as center_name, sum(oi.sale_price) as revenue from `bigquery-public-data.thelook_ecommerce.order_items` oi join `bigquery-public-data.thelook_ecommerce.inventory_items` ii on oi.inventory_item_id = ii.id join `bigquery-public-data.thelook_ecommerce.distribution_centers` dc on ii.product_distribution_center_id = dc.id group by dc.id, dc.name)
select center_id, center_name, round(revenue, 2) as total_revenue from center_revenue order by total_revenue desc;

-- 29) Which product categories have the highest return rate.
with category_orders as (select p.category, count(distinct o.order_id) as total_orders, count(distinct case when o.returned_at is not null then o.order_id end) as returned_orders from `bigquery-public-data.thelook_ecommerce.orders` o join `bigquery-public-data.thelook_ecommerce.order_items` oi on o.order_id = oi.order_id join `bigquery-public-data.thelook_ecommerce.products` p on oi.product_id = p.id group by p.category)
select category, total_orders, returned_orders, round(safe_divide(returned_orders * 100, total_orders), 2) as return_rate_percentage
from category_orders where total_orders >= 100 order by return_rate_percentage desc;

-- 30) Which distribution centers have the longest average delivery time.
with delivery_details as (select dc.id as center_id, dc.name as center_name,timestamp_diff(o.delivered_at, o.created_at, hour) / 24.0 as delivery_days from `bigquery-public-data.thelook_ecommerce.orders` o join `bigquery-public-data.thelook_ecommerce.order_items` oi on o.order_id = oi.order_id join `bigquery-public-data.thelook_ecommerce.inventory_items` ii on oi.inventory_item_id = ii.id join `bigquery-public-data.thelook_ecommerce.distribution_centers` dc on ii.product_distribution_center_id = dc.id where o.delivered_at is not null)
select center_id, center_name, round(avg(delivery_days),2) as avg_delivery_days
from delivery_details group by center_id, center_name order by avg_delivery_days desc;

-- 31) Which product brands generate the most revenue.
with brand_revenue as (select p.brand, sum(oi.sale_price) as revenue from `bigquery-public-data.thelook_ecommerce.order_items` oi join `bigquery-public-data.thelook_ecommerce.products` p on oi.product_id = p.id group by p.brand)
select brand, round(revenue, 2) as total_revenue from brand_revenue order by total_revenue desc;

-- 32) Which product brands have the highest return rate.
with brand_orders as (select p.brand, count(distinct o.order_id) as total_orders, count(distinct case when o.returned_at is not null then o.order_id end) as returned_orders from `bigquery-public-data.thelook_ecommerce.orders` o join `bigquery-public-data.thelook_ecommerce.order_items` oi on o.order_id = oi.order_id join `bigquery-public-data.thelook_ecommerce.products` p on oi.product_id = p.id group by p.brand)
select brand, total_orders, returned_orders, round(safe_divide(returned_orders * 100, total_orders), 2) as return_rate_percentage from brand_orders where total_orders >= 100 order by return_rate_percentage desc;

-- 33) Which product categories have the highest average order value.
with category_orders as (select p.category, o.order_id, sum(oi.sale_price) as order_value from `bigquery-public-data.thelook_ecommerce.orders` o join `bigquery-public-data.thelook_ecommerce.order_items` oi on o.order_id = oi.order_id join `bigquery-public-data.thelook_ecommerce.products` p on oi.product_id = p.id group by p.category, o.order_id)
select category, round(avg(order_value), 2) as avg_order_value from category_orders group by category order by avg_order_value desc;

-- 34) How does purchase frequency vary across customer segments.
with customer_orders as (select user_id, count(distinct order_id) as total_orders from `bigquery-public-data.thelook_ecommerce.orders` group by user_id)
select case when total_orders = 1 then 'one-time' when total_orders between 2 and 3 then 'occasional' when total_orders between 4 and 6 then 'frequent' else 'loyal' end as customer_segment, count(*) as customers, round(avg(total_orders), 2) as avg_orders_per_customer from customer_orders group by customer_segment order by avg_orders_per_customer desc;

-- 35) How many days has it been since each customer's most recent order.
with customer_orders as (select user_id, max(date(created_at)) as last_order_date from `bigquery-public-data.thelook_ecommerce.orders` group by user_id)
select user_id, last_order_date, date_diff(current_date(), last_order_date, day) as days_since_last_order from customer_orders order by days_since_last_order desc;

-- 36) Which customers are high-value, loyal, recently active, or at risk.
with customer_summary as (select o.user_id, max(date(o.created_at)) as last_order_date, count(distinct o.order_id) as total_orders, sum(oi.sale_price) as total_revenue from `bigquery-public-data.thelook_ecommerce.orders` o join `bigquery-public-data.thelook_ecommerce.order_items` oi on o.order_id = oi.order_id group by o.user_id)
select user_id, date_diff(current_date(), last_order_date, day) as days_since_last_order, total_orders, round(total_revenue, 2) as total_revenue,case when date_diff(current_date(), last_order_date, day) <= 30 and total_orders >= 5 and total_revenue >= 500 then 'high value active' when date_diff(current_date(), last_order_date, day) <= 90 and total_orders >= 3 then 'loyal' when date_diff(current_date(), last_order_date, day) > 180 then 'at risk' else 'standard' end as customer_segment from customer_summary;

-- 37) How many customers are active, at risk, or inactive based on their most recent order.
with customer_orders as (select user_id, max(date(created_at)) as last_order_date from `bigquery-public-data.thelook_ecommerce.orders` group by user_id)
select case when date_diff(current_date(), last_order_date, day) <= 180 then 'active' when date_diff(current_date(), last_order_date, day) <= 550 then 'at risk' else 'inactive' end as customer_status, count(*) as customers from customer_orders group by customer_status order by customers desc;

-- 38) How much historical revenue came from active, at-risk, and inactive customers.
with customer_summary as (select o.user_id, max(date(o.created_at)) as last_order_date, sum(oi.sale_price) as total_revenue from `bigquery-public-data.thelook_ecommerce.orders` o join `bigquery-public-data.thelook_ecommerce.order_items` oi on o.order_id = oi.order_id group by o.user_id)
select case when date_diff(current_date(), last_order_date, day) <= 180 then 'active' when date_diff(current_date(), last_order_date, day) <= 550 then 'at risk' else 'inactive' end as customer_status, count(*) as customers, round(sum(total_revenue), 2) as revenue from customer_summary group by customer_status order by revenue desc;

-- 39) What is the average lifetime revenue generated by customers in each activity segment.
with customer_summary as (select o.user_id, max(date(o.created_at)) as last_order_date, sum(oi.sale_price) as total_revenue from `bigquery-public-data.thelook_ecommerce.orders` o join `bigquery-public-data.thelook_ecommerce.order_items` oi on o.order_id = oi.order_id group by o.user_id)
select case when date_diff(current_date(), last_order_date, day) <= 180 then 'active' when date_diff(current_date(), last_order_date, day) <= 550 then 'at risk' else 'inactive' end as customer_status, count(*) as customers, round(avg(total_revenue), 2) as avg_customer_lifetime_value, round(sum(total_revenue), 2) as total_revenue from customer_summary group by customer_status order by avg_customer_lifetime_value desc;

-- 40) What percentage of customers acquired in each month made another purchase within 30 days.
with first_order as (select user_id, min(date(created_at)) as first_order_date from `bigquery-public-data.thelook_ecommerce.orders` group by user_id), customer_orders as (select f.user_id, f.first_order_date, date_trunc(f.first_order_date, month) as acquired_month, date(o.created_at) as order_date from first_order f join `bigquery-public-data.thelook_ecommerce.orders` o on f.user_id = o.user_id)
select format_date('%B %Y', acquired_month) as acquired_months, count(distinct user_id) as customers_acquired, format_date('%B %Y', date_add(acquired_month, interval 1 month)) as next_month, count(distinct case when date_diff(order_date, first_order_date, day) between 1 and 30 then user_id end) as retention_nxt30_days, round(safe_divide(count(distinct case when date_diff(order_date, first_order_date, day) between 1 and 30 then user_id end) * 100, count(distinct user_id)), 2) as retention_rate from customer_orders group by acquired_month order by acquired_month;

-- 41) What is the average number of days between purchases for repeat customers.
with customer_orders as (select user_id, date(created_at) as order_date, lag(date(created_at)) over(partition by user_id order by created_at) as previous_order_date  from `bigquery-public-data.thelook_ecommerce.orders`)
select round(avg(date_diff(order_date, previous_order_date, day)), 2) as avg_days_between_orders from customer_orders where previous_order_date is not null;

-- 42) What percentage of orders were cancelled each month.
with monthly_orders as (select date_trunc(date(created_at), month) as month, count(*) as total_orders, countif(status = 'Cancelled') as cancelled_orders from `bigquery-public-data.thelook_ecommerce.orders` group by month)
select format_date('%B %Y', month) as months, total_orders, cancelled_orders, round(safe_divide(cancelled_orders * 100, total_orders), 2) as cancellation_rate
from monthly_orders order by month;

-- 43) Which product categories have the highest order cancellation rate.
with category_orders as (select p.category, count(distinct o.order_id) as total_orders, count(distinct case when o.status = 'Cancelled' then o.order_id end) as cancelled_orders from `bigquery-public-data.thelook_ecommerce.orders` o join `bigquery-public-data.thelook_ecommerce.order_items` oi on o.order_id = oi.order_id join `bigquery-public-data.thelook_ecommerce.products` p on oi.product_id = p.id group by p.category)
select category, total_orders, cancelled_orders, round(safe_divide(cancelled_orders * 100, total_orders), 2) as cancellation_rate from category_orders where total_orders >= 100 order by cancellation_rate desc;

-- 44) Which traffic sources bring the most customers and generate the most revenue.
with traffic_revenue as (select u.traffic_source, count(distinct u.id) as customers, sum(oi.sale_price) as revenue from `bigquery-public-data.thelook_ecommerce.users` u join `bigquery-public-data.thelook_ecommerce.order_items` oi on u.id = oi.user_id group by u.traffic_source)
select traffic_source, customers, round(revenue, 2) as total_revenue, round(safe_divide(revenue, customers), 2) as revenue_per_customer from traffic_revenue
order by total_revenue desc;

-- 45) How does revenue from each traffic source change month-over-month.
with monthly_revenue as (select date_trunc(date(oi.created_at), month) as month, u.traffic_source, sum(oi.sale_price) as revenue from `bigquery-public-data.thelook_ecommerce.order_items` oi join `bigquery-public-data.thelook_ecommerce.users` u on oi.user_id = u.id group by month, u.traffic_source),
growth as (select month, traffic_source, revenue, lag(revenue) over(partition by traffic_source order by month) as prev_revenue from monthly_revenue)
select format_date('%B %Y', month) as months, traffic_source, round(revenue, 2) as revenue, round(safe_divide(revenue - prev_revenue, prev_revenue) * 100, 2) as mom_growth from growth order by month, traffic_source;

-- 46) Which traffic sources generate the highest percentage of customers who place an order.
with source_customers as (select u.traffic_source, count(distinct u.id) as customers, count(distinct o.user_id) as ordered_customers from `bigquery-public-data.thelook_ecommerce.users` u left join `bigquery-public-data.thelook_ecommerce.orders` o on u.id = o.user_id group by u.traffic_source)
select traffic_source, customers, ordered_customers, round(safe_divide(ordered_customers * 100, customers), 2) as conversion_rate from source_customers
order by conversion_rate desc;

-- 47) What percentage of total revenue is contributed by each traffic source.
with source_revenue as (select u.traffic_source, sum(oi.sale_price) as revenue from `bigquery-public-data.thelook_ecommerce.users` u join `bigquery-public-data.thelook_ecommerce.order_items` oi on u.id = oi.user_id group by u.traffic_source)
select traffic_source, round(revenue, 2) as total_revenue, round(safe_divide(revenue * 100, (select sum(sale_price) from `bigquery-public-data.thelook_ecommerce.order_items`)), 2) as revenue_contribution from source_revenue order by revenue_contribution desc;

-- 48) Which traffic sources acquire the most new customers.
with first_order as ( select user_id, min(date(created_at)) as first_order_date from `bigquery-public-data.thelook_ecommerce.orders` group by user_id)
select u.traffic_source, count(*) as new_customers from first_order fo join `bigquery-public-data.thelook_ecommerce.users` u on fo.user_id = u.id group by u.traffic_source order by new_customers desc;

-- 49) What is the average revenue generated per customer from each traffic source.
with source_revenue as (select u.traffic_source, count(distinct u.id) as customers, sum(oi.sale_price) as revenue from `bigquery-public-data.thelook_ecommerce.users` u join `bigquery-public-data.thelook_ecommerce.order_items` oi on u.id = oi.user_id group by u.traffic_source)
select traffic_source, customers, round(revenue, 2) as total_revenue, round(safe_divide(revenue, customers), 2) as revenue_per_customer from source_revenue order by revenue_per_customer desc;

-- 50) Which customer gender generates the highest revenue and average revenue per customer.
with gender_revenue as (select u.gender, count(distinct u.id) as customers, sum(oi.sale_price) as revenue from `bigquery-public-data.thelook_ecommerce.users` u join `bigquery-public-data.thelook_ecommerce.order_items` oi on u.id = oi.user_id group by u.gender)
select gender, customers, round(revenue, 2) as total_revenue, round(safe_divide(revenue, customers), 2) as revenue_per_customer from gender_revenue order by total_revenue desc;

-- 51) Which customer age groups generate the most revenue and revenue per customer.
with age_revenue as (select case when u.age < 25 then 'under 25' when u.age between 25 and 34 then '25-34' when u.age between 35 and 44 then '35-44' when u.age between 45 and 54 then '45-54' else '55+' end as age_group, count(distinct u.id) as customers, sum(oi.sale_price) as revenue from `bigquery-public-data.thelook_ecommerce.users` u join `bigquery-public-data.thelook_ecommerce.order_items` oi on u.id = oi.user_id group by age_group)
select age_group, customers, round(revenue, 2) as total_revenue, round(safe_divide(revenue, customers), 2) as revenue_per_customer from age_revenue order by age_group;

-- 52) Which product departments generate the highest revenue and revenue per customer.
with department_revenue as (select p.department, count(distinct oi.user_id) as customers, sum(oi.sale_price) as revenue from `bigquery-public-data.thelook_ecommerce.products` p join `bigquery-public-data.thelook_ecommerce.order_items` oi on p.id = oi.product_id group by p.department)
select department, customers, round(revenue, 2) as total_revenue, round(safe_divide(revenue, customers), 2) as revenue_per_customer from department_revenue order by total_revenue desc;

-- 53) Which product categories have the largest discount between retail price and actual selling price.
with category_price as (select p.category, avg(p.retail_price) as retail_price, avg(oi.sale_price) as sale_price from `bigquery-public-data.thelook_ecommerce.products` p join `bigquery-public-data.thelook_ecommerce.order_items` oi on p.id = oi.product_id group by p.category)
select category, round(retail_price, 2) as avg_retail_price, round(sale_price, 2) as avg_sale_price, round(retail_price - sale_price, 2) as avg_discount, round(safe_divide((retail_price - sale_price) * 100, retail_price), 2) as discount_percentage from category_price order by discount_percentage desc;

-- 54) Which product categories generate the highest profit and profit margin.
with category_profit as (  select p.category, sum(oi.sale_price) as revenue, sum(oi.sale_price - p.cost) as profit from `bigquery-public-data.thelook_ecommerce.products` p join `bigquery-public-data.thelook_ecommerce.order_items` oi on p.id = oi.product_id group by p.category)
select category, round(revenue, 2) as revenue, round(profit, 2) as profit, round(safe_divide(profit * 100, revenue), 2) as profit_margin from category_profit
order by profit desc;

-- 55) Which individual products generate the highest profit.
with product_profit as (select p.id, p.name, p.category, p.brand, sum(oi.sale_price) as revenue, sum(oi.sale_price - p.cost) as profit from `bigquery-public-data.thelook_ecommerce.products` p join `bigquery-public-data.thelook_ecommerce.order_items` oi on p.id = oi.product_id group by p.id, p.name, p.category, p.brand)
select name, category, brand, round(revenue, 2) as total_revenue, round(profit, 2) as total_profit from product_profit order by total_profit desc;

-- 56) Which products have the highest profit margin.
with product_profit as (select p.id, p.name, p.category, p.brand, sum(oi.sale_price) as revenue, sum(oi.sale_price - p.cost) as profit from `bigquery-public-data.thelook_ecommerce.products` p join `bigquery-public-data.thelook_ecommerce.order_items` oi on p.id = oi.product_id group by p.id, p.name, p.category, p.brand)
select name, category, brand, round(revenue, 2) as total_revenue, round(profit, 2) as total_profit, round(safe_divide(profit * 100, revenue), 2) as profit_margin
from product_profit where revenue > 0 order by profit_margin desc;

-- 57) Which products have high sales volume but relatively low profit margins.
with product_details as (select p.id, p.name, p.category, count(oi.id) as units_sold, sum(oi.sale_price) as revenue, sum(oi.sale_price - p.cost) as profit from `bigquery-public-data.thelook_ecommerce.products` p join `bigquery-public-data.thelook_ecommerce.order_items` oi on p.id = oi.product_id group by p.id, p.name, p.category)
select name, category, units_sold, round(revenue, 2) as revenue, round(profit, 2) as profit, round(safe_divide(profit * 100, revenue), 2) as profit_margin from product_details where units_sold >= 10 order by profit_margin asc;

-- 58) Which distribution centers generate the highest revenue.
with center_revenue as (select dc.id, dc.name, sum(oi.sale_price) as revenue from `bigquery-public-data.thelook_ecommerce.distribution_centers` dc join `bigquery-public-data.thelook_ecommerce.inventory_items` ii on dc.id = ii.product_distribution_center_id join `bigquery-public-data.thelook_ecommerce.order_items` oi on ii.id = oi.inventory_item_id group by dc.id, dc.name)
select name, round(revenue, 2) as total_revenue from center_revenue order by total_revenue desc;

-- 59) Which distribution centers handle the highest number of orders.
with center_orders as (select dc.id, dc.name, count(distinct oi.order_id) as total_orders from `bigquery-public-data.thelook_ecommerce.distribution_centers` dc join `bigquery-public-data.thelook_ecommerce.inventory_items` ii on dc.id = ii.product_distribution_center_id join `bigquery-public-data.thelook_ecommerce.order_items` oi on ii.id = oi.inventory_item_id group by dc.id, dc.name)
select name, total_orders from center_orders order by total_orders desc;

-- 60) Which distribution centers have the highest average order value.
with center_orders as (select dc.id, dc.name, oi.order_id, sum(oi.sale_price) as order_value from `bigquery-public-data.thelook_ecommerce.distribution_centers` dc  join `bigquery-public-data.thelook_ecommerce.inventory_items` ii on dc.id = ii.product_distribution_center_id join `bigquery-public-data.thelook_ecommerce.order_items` oi on ii.id = oi.inventory_item_id group by dc.id, dc.name, oi.order_id)
select name, count(*) as total_orders, round(avg(order_value), 2) as avg_order_value from center_orders group by name order by avg_order_value desc;

-- 61) Which distribution centers have the highest order return rate.
with center_orders as (select dc.id, dc.name, oi.order_id, max(o.returned_at) as returned_at from `bigquery-public-data.thelook_ecommerce.distribution_centers` dc  join `bigquery-public-data.thelook_ecommerce.inventory_items` ii on dc.id = ii.product_distribution_center_id join `bigquery-public-data.thelook_ecommerce.order_items` oi on ii.id = oi.inventory_item_id join `bigquery-public-data.thelook_ecommerce.orders` o on oi.order_id = o.order_id group by dc.id, dc.name, oi.order_id)
select name, count(*) as total_orders, countif(returned_at is not null) as returned_orders, round(safe_divide(countif(returned_at is not null) * 100, count(*)), 2) as return_rate from center_orders group by name having total_orders >= 100 order by return_rate desc;

-- 62) Which distribution centers have the fastest average delivery time.
with delivery_details as ( select dc.name, o.order_id, o.created_at, o.delivered_at from `bigquery-public-data.thelook_ecommerce.distribution_centers` dc join `bigquery-public-data.thelook_ecommerce.inventory_items` ii on dc.id = ii.product_distribution_center_id join `bigquery-public-data.thelook_ecommerce.order_items` oi on ii.id = oi.inventory_item_id join `bigquery-public-data.thelook_ecommerce.orders` o on oi.order_id = o.order_id where o.delivered_at is not null),
order_delivery as ( select name, order_id, timestamp_diff(max(delivered_at), min(created_at), hour) / 24.0 as delivery_days from delivery_details group by name, order_id)
select name, count(*) as orders, round(avg(delivery_days), 2) as avg_delivery_days from order_delivery group by name having orders >= 100 order by avg_delivery_days desc;

-- 63) Which product categories generate the most revenue from each distribution center.
with category_revenue as (select dc.name as distribution_center, p.category, sum(oi.sale_price) as net_revenue from `bigquery-public-data.thelook_ecommerce.distribution_centers` dc join `bigquery-public-data.thelook_ecommerce.inventory_items` ii on dc.id = ii.product_distribution_center_id join `bigquery-public-data.thelook_ecommerce.order_items` oi on ii.id = oi.inventory_item_id join `bigquery-public-data.thelook_ecommerce.products` p on oi.product_id = p.id group by dc.name, p.category), ranking as (select distribution_center, category, net_revenue, row_number() over(partition by distribution_center order by net_revenue desc) as rank from category_revenue)
select distribution_center, category, round(net_revenue, 2) as total_revenue from ranking where rank = 1 order by total_revenue desc;

-- 64) Which product categories generate the net revenue from each distribution center.
with category_revenue as ( select dc.name as distribution_center, p.category, sum(oi.sale_price) as revenue from `bigquery-public-data.thelook_ecommerce.distribution_centers` dc join `bigquery-public-data.thelook_ecommerce.inventory_items` ii on dc.id = ii.product_distribution_center_id join `bigquery-public-data.thelook_ecommerce.order_items` oi on ii.id = oi.inventory_item_id join `bigquery-public-data.thelook_ecommerce.products` p on oi.product_id = p.id group by dc.name, p.category)
select distribution_center, category, round(revenue, 2) as total_revenue from category_revenue order by distribution_center, total_revenue desc;

-- 65) Which product category generates the most revenue for each distribution center.
with category_revenue as (select dc.name as distribution_center, p.category, sum(oi.sale_price) as revenue from `bigquery-public-data.thelook_ecommerce.distribution_centers` dc join `bigquery-public-data.thelook_ecommerce.inventory_items` ii on dc.id = ii.product_distribution_center_id join `bigquery-public-data.thelook_ecommerce.order_items` oi on ii.id = oi.inventory_item_id join `bigquery-public-data.thelook_ecommerce.products` p on oi.product_id = p.id group by dc.name, p.category), ranked as (select distribution_center, category, revenue, row_number() over(partition by distribution_center order by revenue desc) as rank from category_revenue)
select distribution_center, category, round(revenue, 2) as revenue from ranked where rank = 1 order by revenue desc;

-- 66) Which individual product generates the highest revenue for each distribution center.
with product_revenue as (select dc.name as distribution_center, p.name as product, sum(oi.sale_price) as revenue from `bigquery-public-data.thelook_ecommerce.distribution_centers` dc join `bigquery-public-data.thelook_ecommerce.inventory_items` ii on dc.id = ii.product_distribution_center_id join `bigquery-public-data.thelook_ecommerce.order_items` oi on ii.id = oi.inventory_item_id join `bigquery-public-data.thelook_ecommerce.products` p on oi.product_id = p.id group by dc.name, p.name), ranked as (select distribution_center, product, revenue, row_number() over(partition by distribution_center order by revenue desc) as rank from product_revenue)
select distribution_center, product, round(revenue, 2) as revenue from ranked where rank = 1 order by revenue desc;

-- 67) Which distribution center generates the highest total profit.
with center_profit as (select dc.name as distribution_center, sum(oi.sale_price - p.cost) as profit from `bigquery-public-data.thelook_ecommerce.distribution_centers` dc join `bigquery-public-data.thelook_ecommerce.inventory_items` ii on dc.id = ii.product_distribution_center_id join `bigquery-public-data.thelook_ecommerce.order_items` oi on ii.id = oi.inventory_item_id join `bigquery-public-data.thelook_ecommerce.products` p on oi.product_id = p.id group by dc.name)
select distribution_center, round(profit, 2) as total_profit from center_profit order by total_profit desc limit 1;

-- 68) Which products have the highest return rate.
with product_orders as (select p.id, p.name, count(distinct o.order_id) as total_orders, count(distinct case when o.returned_at is not null then o.order_id end) as returned_orders from `bigquery-public-data.thelook_ecommerce.products` p join `bigquery-public-data.thelook_ecommerce.order_items` oi on p.id = oi.product_id join `bigquery-public-data.thelook_ecommerce.orders` o on oi.order_id = o.order_id group by p.id, p.name)
select name, total_orders, returned_orders, round(safe_divide(returned_orders * 100, total_orders), 2) as return_rate from product_orders where total_orders >= 50
order by return_rate desc;

-- 69) Which products have the highest number of units sold.
select p.name, p.category, p.brand, count(oi.id) as units_sold from `bigquery-public-data.thelook_ecommerce.products` p join `bigquery-public-data.thelook_ecommerce.order_items` oi on p.id = oi.product_id group by p.name, p.category, p.brand order by units_sold desc;

-- 70) Which products have high sales volume but generate relatively low total profit.
with product_details as (select p.name, p.category, count(oi.id) as units_sold, sum(oi.sale_price - p.cost) as profit from `bigquery-public-data.thelook_ecommerce.products` p join `bigquery-public-data.thelook_ecommerce.order_items` oi on p.id = oi.product_id group by p.name, p.category)
select name, category, units_sold, round(profit, 2) as total_profit from product_details where units_sold >= 50 order by total_profit;

-- 71) Which brands have the highest number of products sold.
select p.brand, count(oi.id) as units_sold, round(sum(oi.sale_price), 2) as revenue from `bigquery-public-data.thelook_ecommerce.products` p join `bigquery-public-data.thelook_ecommerce.order_items` oi on p.id = oi.product_id group by p.brand order by units_sold desc;

-- 72) Which brands generate the highest total profit.
with brand_profit as (select p.brand, sum(oi.sale_price) as revenue, sum(oi.sale_price - p.cost) as profit from `bigquery-public-data.thelook_ecommerce.products` p  join `bigquery-public-data.thelook_ecommerce.order_items` oi on p.id = oi.product_id group by p.brand)
select brand, round(revenue, 2) as total_revenue, round(profit, 2) as total_profit from brand_profit order by total_profit desc;

-- 73) Which brands have the highest profit margin.
with brand_profit as (select p.brand, sum(oi.sale_price) as revenue, sum(oi.sale_price - p.cost) as profit from `bigquery-public-data.thelook_ecommerce.products` p  join `bigquery-public-data.thelook_ecommerce.order_items` oi on p.id = oi.product_id group by p.brand)
select brand, round(revenue, 2) as total_revenue, round(profit, 2) as total_profit, round(safe_divide(profit * 100, revenue), 2) as profit_margin from brand_profit
where revenue > 0 order by profit_margin desc;

-- 74) Which brand generates the highest revenue within each product category.
with brand_revenue as (select p.category, p.brand, sum(oi.sale_price) as revenue from `bigquery-public-data.thelook_ecommerce.products` p join `bigquery-public-data.thelook_ecommerce.order_items` oi on p.id = oi.product_id group by p.category, p.brand),
ranked as ( select category, brand, revenue, row_number() over(partition by category order by revenue desc) as rank from brand_revenue)
select category, brand, round(revenue, 2) as total_revenue from ranked where rank = 1 order by total_revenue desc;

-- 75) Which product categories have the highest sales volume and revenue.
select p.category, count(oi.id) as units_sold, round(sum(oi.sale_price), 2) as total_revenue, round(safe_divide(sum(oi.sale_price), count(oi.id)), 2) as revenue_per_unit from `bigquery-public-data.thelook_ecommerce.products` p join `bigquery-public-data.thelook_ecommerce.order_items` oi on p.id = oi.product_id
group by p.category order by units_sold desc;

-- 76) Which product categories have the highest profit margin.
with category_profit as (select p.category, sum(oi.sale_price) as revenue, sum(oi.sale_price - p.cost) as profit from `bigquery-public-data.thelook_ecommerce.products` p join `bigquery-public-data.thelook_ecommerce.order_items` oi on p.id = oi.product_id group by p.category)
select category, round(revenue, 2) as total_revenue, round(profit, 2) as total_profit, round(safe_divide(profit * 100, revenue), 2) as profit_margin from category_profit where revenue > 0 order by profit_margin desc;

-- 77) Which types of website events are performed most frequently by users.
select event_type, count(*) as total_events, count(distinct user_id) as unique_users from `bigquery-public-data.thelook_ecommerce.events` group by event_type
order by total_events desc;

-- 78) Which traffic sources generate the highest website activity.
with source_activity as (select u.traffic_source, count(e.id) as total_events, count(distinct e.user_id) as active_users from `bigquery-public-data.thelook_ecommerce.events` e join `bigquery-public-data.thelook_ecommerce.users` u on e.user_id = u.id group by u.traffic_source)
select traffic_source, total_events, active_users, round(safe_divide(total_events, active_users), 2) as events_per_user from source_activity order by total_events desc;

-- 79) Which types of website activities have the highest user engagement.
select event_type, count(*) as total_events, count(distinct user_id) as active_users, round(safe_divide(count(*), count(distinct user_id)), 2) as events_per_user
from `bigquery-public-data.thelook_ecommerce.events` where user_id is not null group by event_type order by total_events desc;

-- 80) Which traffic sources bring the most engaged users to the website.
with source_users as (select u.traffic_source, e.user_id, count(e.id) as events from `bigquery-public-data.thelook_ecommerce.events` e join `bigquery-public-data.thelook_ecommerce.users` u on e.user_id = u.id group by u.traffic_source, e.user_id)
select traffic_source, count(*) as active_users, sum(events) as total_events, round(avg(events), 2) as avg_events_per_user from source_users group by traffic_source
order by avg_events_per_user desc;

-- 81) How does the average number of items per order change month-over-month.
with monthly_orders as (select date_trunc(date(created_at), month) as month, count(*) as orders, sum(num_of_item) as items from `bigquery-public-data.thelook_ecommerce.orders` group by month)
select format_date('%B %Y', month) as months, orders, items, round(safe_divide(items, orders), 2) as avg_items_per_order from monthly_orders order by month;

-- 82) What percentage of orders contain more than one item.
select count(*) as total_orders, countif(num_of_item > 1) as multi_item_orders, round(safe_divide(countif(num_of_item > 1) * 100, count(*)), 2) as multi_item_order_rate from `bigquery-public-data.thelook_ecommerce.orders`;

-- 83) Which countries have the highest number of customers.
select country, count(*) as customers from `bigquery-public-data.thelook_ecommerce.users` group by country order by customers desc;

-- 84) Which countries generate the highest revenue.
select u.country, count(distinct u.id) as customers, round(sum(oi.sale_price), 2) as revenue from `bigquery-public-data.thelook_ecommerce.users` u join `bigquery-public-data.thelook_ecommerce.order_items` oi on u.id = oi.user_id group by u.country order by revenue desc;

-- 85) What percentage of inventory items have been sold.
select count(*) as total_inventory, countif(sold_at is not null) as sold_items, round(safe_divide(countif(sold_at is not null) * 100, count(*)), 2) as sold_rate
from `bigquery-public-data.thelook_ecommerce.inventory_items`;

-- 86) Which product categories have the highest amount of unsold inventory.
select product_category, count(*) as unsold_items from `bigquery-public-data.thelook_ecommerce.inventory_items` where sold_at is null group by product_category
order by unsold_items desc;

-- 87) What are the top three revenue-generating products within each product category.
with product_revenue as (select p.category, p.name, sum(oi.sale_price) as revenue from `bigquery-public-data.thelook_ecommerce.products` p join `bigquery-public-data.thelook_ecommerce.order_items` oi on p.id = oi.product_id group by p.category, p.name),
ranked as (select category, name, revenue, row_number() over(partition by category order by revenue desc) as rank from product_revenue)
select category, name, round(revenue, 2) as revenue from ranked where rank <= 3 order by category, rank;

-- 88) What percentage of total revenue is generated by the top 10 products.
with product_revenue as (select p.name, sum(oi.sale_price) as revenue from `bigquery-public-data.thelook_ecommerce.products` p join `bigquery-public-data.thelook_ecommerce.order_items` oi on p.id = oi.product_id group by p.name), top_products as (select revenue from product_revenue order by revenue desc limit 10)
select round(safe_divide(sum(revenue) * 100,(select sum(sale_price) from `bigquery-public-data.thelook_ecommerce.order_items`)), 2) as top_10_revenue_contribution
from top_products;

-- 89) What percentage of total revenue is generated by the top 10 customers.
with customer_revenue as (select user_id, sum(sale_price) as revenue from `bigquery-public-data.thelook_ecommerce.order_items` group by user_id),
top_customers as (select revenue from customer_revenue order by revenue desc limit 10)
select round(safe_divide(sum(revenue) * 100,(select sum(sale_price) from `bigquery-public-data.thelook_ecommerce.order_items`)), 2)  as top_10_customer_revenue_share
from top_customers;

-- 90) Which product category generates the highest revenue, profit, and number of units sold.
with category_details as (select p.category, count(oi.id) as units_sold, sum(oi.sale_price) as revenue, sum(oi.sale_price - p.cost) as profit from `bigquery-public-data.thelook_ecommerce.products` p join `bigquery-public-data.thelook_ecommerce.order_items` oi on p.id = oi.product_id group by p.category)
select category, units_sold, round(revenue, 2) as revenue, round(profit, 2) as profit, round(safe_divide(profit * 100, revenue), 2) as profit_margin
from category_details order by revenue desc;
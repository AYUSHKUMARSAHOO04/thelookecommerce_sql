-- =====================================================================
-- TheLook E-commerce SQL Business Analytics
-- Section: Revenue & Product Analytics
-- Dataset: bigquery-public-data.thelook_ecommerce
-- =====================================================================

-- q07: Analyze category-wise revenue contribution to identify the highest-performing product categories.
select p.category, sum(oi.sale_price) as total_sales
from `bigquery-public-data.thelook_ecommerce.products` p
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on p.id = oi.product_id
group by p.category
order by total_sales desc;

-- q08: Calculate each category's contribution to total company revenue.
with category_revenue as (
select p.category, sum(oi.sale_price) as total_sales
from `bigquery-public-data.thelook_ecommerce.products` p
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on p.id = oi.product_id
group by p.category)
select category, round(total_sales,2), round(total_sales*100/(
select sum(sale_price)
from `bigquery-public-data.thelook_ecommerce.order_items`),2) as revenue_contribution_percentage
from category_revenue
order by revenue_contribution_percentage desc;

-- q09: Rank products by revenue inside each category to identify the best-selling products.
with abcd as (
select p.category, p.name, sum(oi.sale_price) as revenue, dense_rank() over(
partition by p.category
order by sum(oi.sale_price) desc) as rank
from `bigquery-public-data.thelook_ecommerce.products` p
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on p.id = oi.product_id
group by p.category, p.name )
select category, name, revenue, rank
from abcd
where rank <=3;

-- q26: Which product generated the highest revenue in each month.
with monthly_product_revenue as (
select date_trunc(date(o.created_at), month) as month, oi.product_id, sum(oi.sale_price) as revenue
from `bigquery-public-data.thelook_ecommerce.orders` o
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on o.order_id = oi.order_id
group by month, oi.product_id),
ranked_products as (
select month, product_id, revenue, dense_rank() over(
partition by month
order by revenue desc) as rank
from monthly_product_revenue)
select format_date('%b %Y', month) as months, product_id, round(revenue, 2) as revenue, rank
from ranked_products
where rank = 1
order by month;

-- q31: Which product brands generate the most revenue.
with brand_revenue as (
select p.brand, sum(oi.sale_price) as revenue
from `bigquery-public-data.thelook_ecommerce.order_items` oi
  join `bigquery-public-data.thelook_ecommerce.products` p
  on oi.product_id = p.id
group by p.brand)
select brand, round(revenue, 2) as total_revenue
from brand_revenue
order by total_revenue desc;

-- q33: Which product categories have the highest average order value.
with category_orders as (
select p.category, o.order_id, sum(oi.sale_price) as order_value
from `bigquery-public-data.thelook_ecommerce.orders` o
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on o.order_id = oi.order_id
  join `bigquery-public-data.thelook_ecommerce.products` p
  on oi.product_id = p.id
group by p.category, o.order_id)
select category, round(avg(order_value), 2) as avg_order_value
from category_orders
group by category
order by avg_order_value desc;

-- q50: Which customer gender generates the highest revenue and average revenue per customer.
with gender_revenue as (
select u.gender, count(distinct u.id) as customers, sum(oi.sale_price) as revenue
from `bigquery-public-data.thelook_ecommerce.users` u
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on u.id = oi.user_id
group by u.gender)
select gender, customers, round(revenue, 2) as total_revenue, round(safe_divide(revenue, customers), 2) as revenue_per_customer
from gender_revenue
order by total_revenue desc;

-- q51: Which customer age groups generate the most revenue and revenue per customer.
with age_revenue as (
select case when u.age < 25 then 'under 25' when u.age between 25 and 34 then '25-34' when u.age between 35 and 44 then '35-44' when u.age between 45 and 54 then '45-54' else '55+' end as age_group, count(distinct u.id) as customers, sum(oi.sale_price) as revenue
from `bigquery-public-data.thelook_ecommerce.users` u
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on u.id = oi.user_id
group by age_group)
select age_group, customers, round(revenue, 2) as total_revenue, round(safe_divide(revenue, customers), 2) as revenue_per_customer
from age_revenue
order by age_group;

-- q52: Which product departments generate the highest revenue and revenue per customer.
with department_revenue as (
select p.department, count(distinct oi.user_id) as customers, sum(oi.sale_price) as revenue
from `bigquery-public-data.thelook_ecommerce.products` p
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on p.id = oi.product_id
group by p.department)
select department, customers, round(revenue, 2) as total_revenue, round(safe_divide(revenue, customers), 2) as revenue_per_customer
from department_revenue
order by total_revenue desc;

-- q69: Which products have the highest number of units sold.
select p.name, p.category, p.brand, count(oi.id) as units_sold
from `bigquery-public-data.thelook_ecommerce.products` p
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on p.id = oi.product_id
group by p.name, p.category, p.brand
order by units_sold desc;

-- q71: Which brands have the highest number of products sold.
select p.brand, count(oi.id) as units_sold, round(sum(oi.sale_price), 2) as revenue
from `bigquery-public-data.thelook_ecommerce.products` p
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on p.id = oi.product_id
group by p.brand
order by units_sold desc;

-- q74: Which brand generates the highest revenue within each product category.
with brand_revenue as (
select p.category, p.brand, sum(oi.sale_price) as revenue
from `bigquery-public-data.thelook_ecommerce.products` p
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on p.id = oi.product_id
group by p.category, p.brand),
ranked as (
select category, brand, revenue, row_number() over(
partition by category
order by revenue desc) as rank
from brand_revenue)
select category, brand, round(revenue, 2) as total_revenue
from ranked
where rank = 1
order by total_revenue desc;

-- q75: Which product categories have the highest sales volume and revenue.
select p.category, count(oi.id) as units_sold, round(sum(oi.sale_price), 2) as total_revenue, round(safe_divide(sum(oi.sale_price), count(oi.id)), 2) as revenue_per_unit
from `bigquery-public-data.thelook_ecommerce.products` p
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on p.id = oi.product_id
group by p.category
order by units_sold desc;

-- q88: What percentage of total revenue is generated by the top 10 products.
with product_revenue as (
select p.name, sum(oi.sale_price) as revenue
from `bigquery-public-data.thelook_ecommerce.products` p
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on p.id = oi.product_id
group by p.name),
top_products as (
select revenue
from product_revenue
order by revenue desc limit 10)
select round(safe_divide(sum(revenue) * 100,(
select sum(sale_price)
from `bigquery-public-data.thelook_ecommerce.order_items`)), 2) as top_10_revenue_contribution
from top_products;

-- q89: What percentage of total revenue is generated by the top 10 customers.
with customer_revenue as (
select user_id, sum(sale_price) as revenue
from `bigquery-public-data.thelook_ecommerce.order_items`
group by user_id),
top_customers as (
select revenue
from customer_revenue
order by revenue desc limit 10)
select round(safe_divide(sum(revenue) * 100,(
select sum(sale_price)
from `bigquery-public-data.thelook_ecommerce.order_items`)), 2) as top_10_customer_revenue_share
from top_customers;


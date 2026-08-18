-- =====================================================================
-- TheLook E-commerce SQL Business Analytics
-- Section: Pricing & Profitability
-- Dataset: bigquery-public-data.thelook_ecommerce
-- =====================================================================

-- q53: Which product categories have the largest discount between retail price and actual selling price.
with category_price as (
select p.category, avg(p.retail_price) as retail_price, avg(oi.sale_price) as sale_price
from `bigquery-public-data.thelook_ecommerce.products` p
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on p.id = oi.product_id
group by p.category)
select category, round(retail_price, 2) as avg_retail_price, round(sale_price, 2) as avg_sale_price, round(retail_price - sale_price, 2) as avg_discount, round(safe_divide((retail_price - sale_price) * 100, retail_price), 2) as discount_percentage
from category_price
order by discount_percentage desc;

-- q54: Which product categories generate the highest profit and profit margin.
with category_profit as (
select p.category, sum(oi.sale_price) as revenue, sum(oi.sale_price - p.cost) as profit
from `bigquery-public-data.thelook_ecommerce.products` p
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on p.id = oi.product_id
group by p.category)
select category, round(revenue, 2) as revenue, round(profit, 2) as profit, round(safe_divide(profit * 100, revenue), 2) as profit_margin
from category_profit
order by profit desc;

-- q55: Which individual products generate the highest profit.
with product_profit as (
select p.id, p.name, p.category, p.brand, sum(oi.sale_price) as revenue, sum(oi.sale_price - p.cost) as profit
from `bigquery-public-data.thelook_ecommerce.products` p
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on p.id = oi.product_id
group by p.id, p.name, p.category, p.brand)
select name, category, brand, round(revenue, 2) as total_revenue, round(profit, 2) as total_profit
from product_profit
order by total_profit desc;

-- q56: Which products have the highest profit margin.
with product_profit as (
select p.id, p.name, p.category, p.brand, sum(oi.sale_price) as revenue, sum(oi.sale_price - p.cost) as profit
from `bigquery-public-data.thelook_ecommerce.products` p
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on p.id = oi.product_id
group by p.id, p.name, p.category, p.brand)
select name, category, brand, round(revenue, 2) as total_revenue, round(profit, 2) as total_profit, round(safe_divide(profit * 100, revenue), 2) as profit_margin
from product_profit
where revenue > 0
order by profit_margin desc;

-- q57: Which products have high sales volume but relatively low profit margins.
with product_details as (
select p.id, p.name, p.category, count(oi.id) as units_sold, sum(oi.sale_price) as revenue, sum(oi.sale_price - p.cost) as profit
from `bigquery-public-data.thelook_ecommerce.products` p
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on p.id = oi.product_id
group by p.id, p.name, p.category)
select name, category, units_sold, round(revenue, 2) as revenue, round(profit, 2) as profit, round(safe_divide(profit * 100, revenue), 2) as profit_margin
from product_details
where units_sold >= 10
order by profit_margin asc;

-- q67: Which distribution center generates the highest total profit.
with center_profit as (
select dc.name as distribution_center, sum(oi.sale_price - p.cost) as profit
from `bigquery-public-data.thelook_ecommerce.distribution_centers` dc
  join `bigquery-public-data.thelook_ecommerce.inventory_items` ii
  on dc.id = ii.product_distribution_center_id
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on ii.id = oi.inventory_item_id
  join `bigquery-public-data.thelook_ecommerce.products` p
  on oi.product_id = p.id
group by dc.name)
select distribution_center, round(profit, 2) as total_profit
from center_profit
order by total_profit desc limit 1;

-- q70: Which products have high sales volume but generate relatively low total profit.
with product_details as (
select p.name, p.category, count(oi.id) as units_sold, sum(oi.sale_price - p.cost) as profit
from `bigquery-public-data.thelook_ecommerce.products` p
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on p.id = oi.product_id
group by p.name, p.category)
select name, category, units_sold, round(profit, 2) as total_profit
from product_details
where units_sold >= 50
order by total_profit;

-- q72: Which brands generate the highest total profit.
with brand_profit as (
select p.brand, sum(oi.sale_price) as revenue, sum(oi.sale_price - p.cost) as profit
from `bigquery-public-data.thelook_ecommerce.products` p
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on p.id = oi.product_id
group by p.brand)
select brand, round(revenue, 2) as total_revenue, round(profit, 2) as total_profit
from brand_profit
order by total_profit desc;

-- q73: Which brands have the highest profit margin.
with brand_profit as (
select p.brand, sum(oi.sale_price) as revenue, sum(oi.sale_price - p.cost) as profit
from `bigquery-public-data.thelook_ecommerce.products` p
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on p.id = oi.product_id
group by p.brand)
select brand, round(revenue, 2) as total_revenue, round(profit, 2) as total_profit, round(safe_divide(profit * 100, revenue), 2) as profit_margin
from brand_profit
where revenue > 0
order by profit_margin desc;

-- q76: Which product categories have the highest profit margin.
with category_profit as (
select p.category, sum(oi.sale_price) as revenue, sum(oi.sale_price - p.cost) as profit
from `bigquery-public-data.thelook_ecommerce.products` p
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on p.id = oi.product_id
group by p.category)
select category, round(revenue, 2) as total_revenue, round(profit, 2) as total_profit, round(safe_divide(profit * 100, revenue), 2) as profit_margin
from category_profit
where revenue > 0
order by profit_margin desc;

-- q90: Which product category generates the highest revenue, profit, and number of units sold.
with category_details as (
select p.category, count(oi.id) as units_sold, sum(oi.sale_price) as revenue, sum(oi.sale_price - p.cost) as profit
from `bigquery-public-data.thelook_ecommerce.products` p
  join `bigquery-public-data.thelook_ecommerce.order_items` oi
  on p.id = oi.product_id
group by p.category)
select category, units_sold, round(revenue, 2) as revenue, round(profit, 2) as profit, round(safe_divide(profit * 100, revenue), 2) as profit_margin
from category_details
order by revenue desc;


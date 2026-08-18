# Selected Query Results

Raw exported outputs for the 41 business questions selected into the executive decision-analysis layer, in original question order. Each table is sourced verbatim from `thelookecommerece_output.txt`. Tables with more than 15 rows are capped at the top 15 (by the query's own ordering) with a pointer to the full SQL query for the complete result.

For narrative interpretation of these numbers, see [`business_insights.md`](business_insights.md) and [`decision_analysis.md`](decision_analysis.md). For why the other 49 of 90 questions aren't repeated here, see [`result_index.md`](result_index.md).

---

## Q1. Determine the total number of users in the e-commerce platform

*Customer & Order Fundamentals · `sql/01_customer_and_order_analysis.sql`*

**total_users:** 100000


## Q2. Calculate the total number of orders placed by customers

*Customer & Order Fundamentals · `sql/01_customer_and_order_analysis.sql`*

**total_orders:** 124771


## Q3. Measure the number of customers who successfully converted into buyers (atleast one order)

*Customer & Order Fundamentals · `sql/01_customer_and_order_analysis.sql`*

**ordered_users:** 79948


## Q5. Calculate the average revenue generated per order

*Customer & Order Fundamentals · `sql/01_customer_and_order_analysis.sql`*

**aov:** 86.47


## Q6. Identify the highest revenue-generating customers

*Customer & Order Fundamentals · `sql/01_customer_and_order_analysis.sql`*

| user_id | first_name | last_name | total_sales | rank |
|---|---|---|---|---|
| 62719 | Timothy | Gutierrez | 2003.81 | 1 |
| 49568 | Scott | Silva | 1545.5 | 2 |
| 48479 | David | Hansen | 1517.45 | 3 |
| 64065 | Brianna | Myers | 1452.8 | 4 |
| 16804 | Nicholas | Harris | 1426.63 | 5 |
| 17729 | Stephanie | Mckinney | 1423.99 | 6 |
| 10377 | Lisa | Gallegos | 1419.86 | 7 |
| 5857 | Mario | Lester | 1414.52 | 8 |
| 66946 | Michael | Wright | 1412.66 | 9 |
| 30981 | Roy | Frost | 1411.95 | 10 |

## Q8. Calculate each category's contribution to total company revenue

*Revenue & Product Analytics · `sql/02_revenue_and_product_analysis.sql`*

| category | f0_ | revenue_contribution_percentage |
|---|---|---|
| Outerwear & Coats | 1343290.37 | 12.45 |
| Jeans | 1243365.44 | 11.52 |
| Sweaters | 837873.73 | 7.77 |
| Fashion Hoodies & Sweatshirts | 651563.63 | 6.04 |
| Suits & Sport Coats | 645708.74 | 5.98 |
| Swim | 631759.29 | 5.86 |
| Sleep & Lounge | 550660.01 | 5.1 |
| Shorts | 512803.19 | 4.75 |
| Tops & Tees | 497015.31 | 4.61 |
| Active | 470900.94 | 4.36 |
| Dresses | 459505.57 | 4.26 |
| Intimates | 445501.26 | 4.13 |
| Pants | 426292.75 | 3.95 |
| Accessories | 413220.7 | 3.83 |
| Blazers & Jackets | 288621.31 | 2.68 |

*Showing top 15 of 26 rows. Full result: `sql/02_revenue_and_product_analysis.sql`.*

## Q9. Rank products by revenue inside each category to identify the best-selling products

*Revenue & Product Analytics · `sql/02_revenue_and_product_analysis.sql`*

| category | name | revenue | rank |
|---|---|---|---|
| Accessories | Costa Del Mar - Blackfin - Camo Frame-580 Green Mirror Glass Polarized Lenses | 3367.0 | 1 |
| Accessories | Tom Ford Marko FT0144 Sunglasses - 18V Shiny Rhodium (Blue Lens) - 58mm | 2973.5 | 2 |
| Accessories | New Ray Ban RB 4179 601/9A Black Men Women Plastic Sunglasses | 2941.9 | 3 |
| Active | The North Face Denali Down Womens Jacket 2013 | 9933.0 | 1 |
| Active | The North Face Apex Bionic Soft Shell Jacket - Men's | 9030.0 | 2 |
| Active | ASCIS Cushion Low Socks (Pack of 3) | 9030.0 | 2 |
| Active | Canada Goose Women's Solaris | 8340.0 | 3 |
| Blazers & Jackets | MiH Jeans Women's Aztec Jacket | 5940.0 | 1 |
| Blazers & Jackets | Rebecca Minkoff Women's Becky Jacket | 4574.1 | 2 |
| Blazers & Jackets | Anne Klein Collection Women's Shawl Collar Jacket | 4037.12 | 3 |
| Clothing Sets | Ulla Popken Plus Size Floral 3-Piece Pant Set | 1690.0 | 1 |
| Clothing Sets | Ulla Popken Plus Size 3-Piece Duster and Pants Set | 1113.0 | 2 |
| Clothing Sets | Scrunch Cloth Pants Set / Regular - Only Sale Color(s) Cardinal Strawberry | 1032.0 | 3 |
| Dresses | Parker Women's Beaded Shift Dress | 5500.0 | 1 |
| Dresses | IGIGI by Yuliya Raquel Plus Size Kandinsky Gown | 5200.0 | 2 |

*Showing top 15 of 80 rows. Full result: `sql/02_revenue_and_product_analysis.sql`.*

## Q10. Compare customer segments based on purchase frequency and revenue contribution

*Customer Segmentation & Retention · `sql/03_customer_retention_analysis.sql`*

| customer_type | number_of_customers | total_revenue | avg_revenue_per_customer |
|---|---|---|---|
| Repeat Customer | 29851 | 6462519.26 | 216.49 |
| One-time Customer | 50097 | 4326274.35 | 86.36 |

## Q11. How has monthly delivered sales value changed over time

*Inventory, Geography & Advanced Business KPIs · `sql/08_inventory_and_advanced_analysis.sql`*

| months | monthly_revenue | prev_month_revenue | revenue_change | MoM_growth_percentage |
|---|---|---|---|---|
| January 2019 | 24.99 |  |  |  |
| February 2019 | 879.27 | 24.99 | 854.28 | 3418.49 |
| March 2019 | 955.22 | 879.27 | 75.95 | 8.64 |
| April 2019 | 1682.77 | 955.22 | 727.55 | 76.17 |
| May 2019 | 1476.9 | 1682.77 | -205.87 | -12.23 |
| June 2019 | 2715.62 | 1476.9 | 1238.72 | 83.87 |
| July 2019 | 1668.14 | 2715.62 | -1047.48 | -38.57 |
| August 2019 | 3016.86 | 1668.14 | 1348.72 | 80.85 |
| September 2019 | 4339.5 | 3016.86 | 1322.64 | 43.84 |
| October 2019 | 5396.92 | 4339.5 | 1057.42 | 24.37 |
| November 2019 | 5555.63 | 5396.92 | 158.71 | 2.94 |
| December 2019 | 5389.84 | 5555.63 | -165.79 | -2.98 |
| January 2020 | 5803.35 | 5389.84 | 413.51 | 7.67 |
| February 2020 | 5421.5 | 5803.35 | -381.85 | -6.58 |
| March 2020 | 10029.52 | 5421.5 | 4608.02 | 85.0 |

*Showing top 15 of 92 rows. Full result: `sql/08_inventory_and_advanced_analysis.sql`.*

## Q13. No. of days does it take, on average, for an order to be delivered after it is placed

*Returns, Delivery & Distribution Center Operations · `sql/06_distribution_and_operations_analysis.sql`*

**avg_delivery_days:** 3.98


## Q14. For returned orders, what is the average number of days between delivery and return

*Returns, Delivery & Distribution Center Operations · `sql/06_distribution_and_operations_analysis.sql`*

**avg_delivery_days:** 1.48


## Q15. Percentage of orders are being returned

*Returns, Delivery & Distribution Center Operations · `sql/06_distribution_and_operations_analysis.sql`*

| total_orders | returned_orders | return_rate_percentage |
|---|---|---|
| 124771 | 12270 | 9.83 |

## Q18. No. of customers fall into each revenue segment, and how much revenue does each segment generate

*Customer Segmentation & Retention · `sql/03_customer_retention_analysis.sql`*

| customer_segment | customers | net_revenue | avg_revenue | customer_share_percentage |
|---|---|---|---|---|
| Low Value | 62784 | 4896187.49 | 77.98 | 78.53 |
| Medium Value | 15190 | 4533140.53 | 298.43 | 19.0 |
| High Value | 1813 | 1177051.68 | 649.23 | 2.27 |
| VIP | 161 | 182413.91 | 1133.01 | 0.2 |

## Q20. For each month, how many customers were new customers and how many were repeat customers

*Customer Segmentation & Retention · `sql/03_customer_retention_analysis.sql`*

| months | new_customers | repeat_customers | total_active_customers |
|---|---|---|---|
| January 2019 | 5 | 0 | 5 |
| February 2019 | 15 | 0 | 15 |
| March 2019 | 41 | 0 | 41 |
| April 2019 | 40 | 0 | 40 |
| May 2019 | 63 | 2 | 65 |
| June 2019 | 81 | 3 | 84 |
| July 2019 | 97 | 1 | 98 |
| August 2019 | 108 | 1 | 109 |
| September 2019 | 106 | 8 | 114 |
| October 2019 | 138 | 8 | 146 |
| November 2019 | 146 | 7 | 153 |
| December 2019 | 162 | 8 | 170 |
| January 2020 | 184 | 14 | 198 |
| February 2020 | 190 | 9 | 199 |
| March 2020 | 225 | 10 | 235 |

*Showing top 15 of 92 rows. Full result: `sql/03_customer_retention_analysis.sql`.*

## Q23. How much out of active customers each month were repeat customers

*Customer Segmentation & Retention · `sql/03_customer_retention_analysis.sql`*

| month | active_customers | repeat_customers | repeat_customer_rate |
|---|---|---|---|
| Jan 2019 | 5 | 0 | 0.0 |
| Feb 2019 | 15 | 0 | 0.0 |
| Mar 2019 | 41 | 0 | 0.0 |
| Apr 2019 | 40 | 0 | 0.0 |
| May 2019 | 65 | 2 | 3.08 |
| Jun 2019 | 84 | 3 | 3.57 |
| Jul 2019 | 98 | 1 | 1.02 |
| Aug 2019 | 109 | 1 | 0.92 |
| Sep 2019 | 114 | 8 | 7.02 |
| Oct 2019 | 146 | 8 | 5.48 |
| Nov 2019 | 153 | 7 | 4.58 |
| Dec 2019 | 170 | 8 | 4.71 |
| Jan 2020 | 198 | 14 | 7.07 |
| Feb 2020 | 199 | 9 | 4.52 |
| Mar 2020 | 235 | 10 | 4.26 |

*Showing top 15 of 92 rows. Full result: `sql/03_customer_retention_analysis.sql`.*

## Q28. Which distribution center generates the highest revenue

*Returns, Delivery & Distribution Center Operations · `sql/06_distribution_and_operations_analysis.sql`*

| center_id | center_name | total_revenue |
|---|---|---|
| 3 | Houston TX | 1603654.75 |
| 1 | Memphis TN | 1407327.41 |
| 2 | Chicago IL | 1324708.77 |
| 8 | Mobile AL | 1222627.41 |
| 7 | Philadelphia PA | 1077510.3 |
| 4 | Los Angeles CA | 955758.97 |
| 6 | Port Authority of New York/New Jersey NY/NJ | 934174.49 |
| 10 | Savannah GA | 810316.09 |
| 5 | New Orleans LA | 800021.94 |
| 9 | Charleston SC | 652693.47 |

## Q29. Which product categories have the highest return rate

*Returns, Delivery & Distribution Center Operations · `sql/06_distribution_and_operations_analysis.sql`*

| category | total_orders | returned_orders | return_rate_percentage |
|---|---|---|---|
| Suits | 990 | 107 | 10.81 |
| Maternity | 4912 | 527 | 10.73 |
| Clothing Sets | 206 | 22 | 10.68 |
| Socks & Hosiery | 3670 | 385 | 10.49 |
| Pants | 6947 | 728 | 10.48 |
| Jeans | 12254 | 1259 | 10.27 |
| Suits & Sport Coats | 5003 | 513 | 10.25 |
| Skirts | 2055 | 208 | 10.12 |
| Tops & Tees | 11534 | 1167 | 10.12 |
| Outerwear & Coats | 8927 | 897 | 10.05 |
| Shorts | 10717 | 1068 | 9.97 |
| Blazers & Jackets | 3126 | 310 | 9.92 |
| Underwear | 7408 | 729 | 9.84 |
| Sleep & Lounge | 10879 | 1062 | 9.76 |
| Swim | 10855 | 1056 | 9.73 |

*Showing top 15 of 26 rows. Full result: `sql/06_distribution_and_operations_analysis.sql`.*

## Q30. Which distribution centers have the longest average delivery time

*Returns, Delivery & Distribution Center Operations · `sql/06_distribution_and_operations_analysis.sql`*

| center_id | center_name | avg_delivery_days |
|---|---|---|
| 8 | Mobile AL | 4.01 |
| 6 | Port Authority of New York/New Jersey NY/NJ | 4.0 |
| 1 | Memphis TN | 4.0 |
| 4 | Los Angeles CA | 3.98 |
| 7 | Philadelphia PA | 3.98 |
| 9 | Charleston SC | 3.97 |
| 2 | Chicago IL | 3.96 |
| 10 | Savannah GA | 3.96 |
| 5 | New Orleans LA | 3.96 |
| 3 | Houston TX | 3.96 |

## Q34. How does purchase frequency vary across customer segments

*Customer Segmentation & Retention · `sql/03_customer_retention_analysis.sql`*

| customer_segment | customers | avg_orders_per_customer |
|---|---|---|
| frequent | 5028 | 4.0 |
| occasional | 24823 | 2.2 |
| one-time | 50097 | 1.0 |

## Q37. How many customers are active, at risk, or inactive based on their most recent order

*Customer Segmentation & Retention · `sql/03_customer_retention_analysis.sql`*

| customer_status | customers |
|---|---|
| inactive | 31541 |
| active | 25284 |
| at risk | 23123 |

## Q38. How much historical revenue came from active, at-risk, and inactive customers

*Customer Segmentation & Retention · `sql/03_customer_retention_analysis.sql`*

| customer_status | customers | revenue |
|---|---|---|
| active | 25284 | 3901401.67 |
| inactive | 31541 | 3634119.18 |
| at risk | 23123 | 3253272.75 |

## Q39. What is the average lifetime revenue generated by customers in each activity segment

*Customer Segmentation & Retention · `sql/03_customer_retention_analysis.sql`*

| customer_status | customers | avg_customer_lifetime_value | total_revenue |
|---|---|---|---|
| active | 25284 | 154.3 | 3901401.67 |
| at risk | 23123 | 140.69 | 3253272.75 |
| inactive | 31541 | 115.22 | 3634119.18 |

## Q44. Which traffic sources bring the most customers and generate the most revenue

*Marketing & Traffic Source Analysis · `sql/04_marketing_and_traffic_analysis.sql`*

| traffic_source | customers | total_revenue | revenue_per_customer |
|---|---|---|---|
| Search | 55958 | 7511909.39 | 134.24 |
| Organic | 11882 | 1630590.73 | 137.23 |
| Facebook | 4823 | 653884.95 | 135.58 |
| Email | 3963 | 546029.35 | 137.78 |
| Display | 3322 | 446379.19 | 134.37 |

## Q46. Which traffic sources generate the highest percentage of customers who place an order

*Marketing & Traffic Source Analysis · `sql/04_marketing_and_traffic_analysis.sql`*

| traffic_source | customers | ordered_customers | conversion_rate |
|---|---|---|---|
| Display | 4093 | 3322 | 81.16 |
| Organic | 14756 | 11882 | 80.52 |
| Search | 70027 | 55958 | 79.91 |
| Email | 5006 | 3963 | 79.17 |
| Facebook | 6118 | 4823 | 78.83 |

## Q47. What percentage of total revenue is contributed by each traffic source

*Marketing & Traffic Source Analysis · `sql/04_marketing_and_traffic_analysis.sql`*

| traffic_source | total_revenue | revenue_contribution |
|---|---|---|
| Search | 7511909.39 | 69.63 |
| Organic | 1630590.73 | 15.11 |
| Facebook | 653884.95 | 6.06 |
| Email | 546029.35 | 5.06 |
| Display | 446379.19 | 4.14 |

## Q50. Which customer gender generates the highest revenue and average revenue per customer

*Revenue & Product Analytics · `sql/02_revenue_and_product_analysis.sql`*

| gender | customers | total_revenue | revenue_per_customer |
|---|---|---|---|
| M | 40162 | 5763242.6 | 143.5 |
| F | 39786 | 5025551.01 | 126.31 |

## Q51. Which customer age groups generate the most revenue and revenue per customer

*Revenue & Product Analytics · `sql/02_revenue_and_product_analysis.sql`*

| age_group | customers | total_revenue | revenue_per_customer |
|---|---|---|---|
| 25-34 | 13502 | 1828577.01 | 135.43 |
| 35-44 | 13503 | 1827719.16 | 135.36 |
| 45-54 | 13633 | 1855580.06 | 136.11 |
| 55+ | 21599 | 2897830.6 | 134.17 |
| under 25 | 17711 | 2379086.77 | 134.33 |

## Q54. Which product categories generate the highest profit and profit margin

*Pricing & Profitability · `sql/05_profitability_analysis.sql`*

| category | revenue | profit | profit_margin |
|---|---|---|---|
| Outerwear & Coats | 1343290.37 | 746552.14 | 55.58 |
| Jeans | 1243365.44 | 577774.72 | 46.47 |
| Sweaters | 837873.73 | 434559.04 | 51.86 |
| Suits & Sport Coats | 645708.74 | 386746.31 | 59.89 |
| Fashion Hoodies & Sweatshirts | 651563.63 | 312304.1 | 47.93 |
| Swim | 631759.29 | 309185.71 | 48.94 |
| Sleep & Lounge | 550660.01 | 285231.31 | 51.8 |
| Active | 470900.94 | 273482.43 | 58.08 |
| Shorts | 512803.19 | 256096.2 | 49.94 |
| Dresses | 459505.57 | 252090.04 | 54.86 |
| Accessories | 413220.7 | 247328.62 | 59.85 |
| Pants | 426292.75 | 230518.68 | 54.08 |
| Tops & Tees | 497015.31 | 219125.73 | 44.09 |
| Intimates | 445501.26 | 208888.43 | 46.89 |
| Blazers & Jackets | 288621.31 | 179026.18 | 62.03 |

*Showing top 15 of 26 rows. Full result: `sql/05_profitability_analysis.sql`.*

## Q61. Which distribution centers have the highest order return rate

*Returns, Delivery & Distribution Center Operations · `sql/06_distribution_and_operations_analysis.sql`*

| name | total_orders | returned_orders | return_rate |
|---|---|---|---|
| Charleston SC | 15688 | 1584 | 10.1 |
| Los Angeles CA | 16632 | 1662 | 9.99 |
| Savannah GA | 11785 | 1172 | 9.94 |
| Memphis TN | 22719 | 2243 | 9.87 |
| Houston TX | 21517 | 2115 | 9.83 |
| Philadelphia PA | 16105 | 1583 | 9.83 |
| Mobile AL | 17480 | 1714 | 9.81 |
| Port Authority of New York/New Jersey NY/NJ | 15621 | 1519 | 9.72 |
| New Orleans LA | 12650 | 1228 | 9.71 |
| Chicago IL | 22455 | 2167 | 9.65 |

## Q71. Which brands have the highest number of products sold

*Revenue & Product Analytics · `sql/02_revenue_and_product_analysis.sql`*

| brand | units_sold | revenue |
|---|---|---|
| Allegra K | 6013 | 86082.25 |
| Calvin Klein | 3222 | 199100.96 |
| Carhartt | 2490 | 179550.26 |
| Hanes | 1962 | 38908.05 |
| Volcom | 1885 | 110440.86 |
| Nautica | 1770 | 74361.77 |
| Quiksilver | 1729 | 101020.55 |
| Levi's | 1581 | 79749.12 |
| Diesel | 1561 | 211996.6 |
| Tommy Hilfiger | 1559 | 123616.51 |
| Columbia | 1543 | 106447.61 |
| Dockers | 1527 | 61496.3 |
| Hurley | 1423 | 74066.98 |
| Wrangler | 1242 | 52865.67 |
| Speedo | 1217 | 63640.58 |

*Showing top 15 of 2752 rows. Full result: `sql/02_revenue_and_product_analysis.sql`.*

## Q72. Which brands generate the highest total profit

*Pricing & Profitability · `sql/05_profitability_analysis.sql`*

| brand | total_revenue | total_profit |
|---|---|---|
| Diesel | 211996.6 | 105956.89 |
| Calvin Klein | 199100.96 | 105798.59 |
| Carhartt | 179550.26 | 95733.63 |
| True Religion | 182741.39 | 87312.65 |
| 7 For All Mankind | 171836.44 | 81942.85 |
| Tommy Hilfiger | 123616.51 | 68257.73 |
| Columbia | 106447.61 | 57757.8 |
| The North Face | 104902.91 | 57422.05 |
| Ray-Ban | 93851.68 | 54473.99 |
| Volcom | 110440.86 | 53993.72 |
| Oakley | 91376.9 | 50466.65 |
| Jones New York | 88998.24 | 49193.89 |
| Joe's Jeans | 102326.28 | 48857.39 |
| Orvis | 91699.0 | 48423.62 |
| Quiksilver | 101020.55 | 46611.06 |

*Showing top 15 of 2752 rows. Full result: `sql/05_profitability_analysis.sql`.*

## Q73. Which brands have the highest profit margin

*Pricing & Profitability · `sql/05_profitability_analysis.sql`*

| brand | total_revenue | total_profit | profit_margin |
|---|---|---|---|
| CTR Specialties | 245.0 | 162.68 | 66.4 |
| Voom | 356.0 | 236.03 | 66.3 |
| Iisli | 392.32 | 259.32 | 66.1 |
| Material Girl | 96.24 | 63.42 | 65.9 |
| Aris A | 319.96 | 208.93 | 65.3 |
| NygÃ¥rd Collection | 396.0 | 258.19 | 65.2 |
| RAY&LI | 249.95 | 162.72 | 65.1 |
| Sheer Delights | 139.9 | 90.8 | 64.9 |
| HodoHome Loungewear | 539.88 | 350.38 | 64.9 |
| Brighton | 245.0 | 158.76 | 64.8 |
| Libian | 145.0 | 93.96 | 64.8 |
| White Lotus | 49.75 | 32.24 | 64.8 |
| X-Loop | 38.43 | 24.9 | 64.8 |
| VH Apparel - Whatever It Takes Charity | 39.96 | 25.85 | 64.7 |
| Alan Sloane | 96.0 | 62.11 | 64.7 |

*Showing top 15 of 2752 rows. Full result: `sql/05_profitability_analysis.sql`.*

## Q77. Which types of website events are performed most frequently by users

*Events & User Engagement · `sql/07_events_and_engagement_analysis.sql`*

| event_type | total_events | unique_users |
|---|---|---|
| product | 843421 | 79948 |
| cart | 593693 | 79948 |
| department | 593472 | 79948 |
| purchase | 180919 | 79948 |
| cancel | 125117 | 0 |
| home | 87485 | 63121 |

## Q82. What percentage of orders contain more than one item

*Customer & Order Fundamentals · `sql/01_customer_and_order_analysis.sql`*

| total_orders | multi_item_orders | multi_item_order_rate |
|---|---|---|
| 124771 | 37286 | 29.88 |

## Q83. Which countries have the highest number of customers

*Inventory, Geography & Advanced Business KPIs · `sql/08_inventory_and_advanced_analysis.sql`*

| country | customers |
|---|---|
| China | 33802 |
| United States | 22434 |
| Brasil | 14563 |
| South Korea | 5414 |
| France | 4819 |
| United Kingdom | 4598 |
| Germany | 4164 |
| Spain | 4062 |
| Japan | 2471 |
| Australia | 2145 |
| Belgium | 1296 |
| Poland | 221 |
| Colombia | 8 |
| Deutschland | 3 |

## Q84. Which countries generate the highest revenue

*Inventory, Geography & Advanced Business KPIs · `sql/08_inventory_and_advanced_analysis.sql`*

| country | customers | revenue |
|---|---|---|
| China | 27001 | 3658844.72 |
| United States | 17890 | 2422871.56 |
| Brasil | 11601 | 1555125.14 |
| South Korea | 4376 | 583520.56 |
| France | 3896 | 526815.59 |
| United Kingdom | 3665 | 490108.82 |
| Germany | 3299 | 445770.99 |
| Spain | 3284 | 441936.76 |
| Japan | 1961 | 261872.9 |
| Australia | 1743 | 232740.37 |
| Belgium | 1051 | 142829.75 |
| Poland | 172 | 24617.26 |
| Colombia | 6 | 1121.31 |
| Deutschland | 3 | 617.87 |

## Q85. What percentage of inventory items have been sold

*Inventory, Geography & Advanced Business KPIs · `sql/08_inventory_and_advanced_analysis.sql`*

| total_inventory | sold_items | sold_rate |
|---|---|---|
| 488373 | 180919 | 37.05 |

## Q86. Which product categories have the highest amount of unsold inventory

*Inventory, Geography & Advanced Business KPIs · `sql/08_inventory_and_advanced_analysis.sql`*

| product_category | unsold_items |
|---|---|
| Intimates | 22509 |
| Jeans | 21620 |
| Tops & Tees | 20287 |
| Fashion Hoodies & Sweatshirts | 20141 |
| Swim | 18851 |
| Sleep & Lounge | 18840 |
| Shorts | 18752 |
| Sweaters | 18724 |
| Accessories | 16785 |
| Outerwear & Coats | 15701 |
| Active | 15316 |
| Underwear | 13120 |
| Pants | 12204 |
| Socks | 10791 |
| Dresses | 9192 |

*Showing top 15 of 26 rows. Full result: `sql/08_inventory_and_advanced_analysis.sql`.*

## Q88. What percentage of total revenue is generated by the top 10 products

*Revenue & Product Analytics · `sql/02_revenue_and_product_analysis.sql`*

**top_10_revenue_contribution:** 1.23


## Q89. What percentage of total revenue is generated by the top 10 customers

*Revenue & Product Analytics · `sql/02_revenue_and_product_analysis.sql`*

**top_10_customer_revenue_share:** 0.14


## Q90. Which product category generates the highest revenue, profit, and number of units sold

*Pricing & Profitability · `sql/05_profitability_analysis.sql`*

| category | units_sold | revenue | profit | profit_margin |
|---|---|---|---|---|
| Outerwear & Coats | 9137 | 1343290.37 | 746552.14 | 55.58 |
| Jeans | 12691 | 1243365.44 | 577774.72 | 46.47 |
| Sweaters | 11047 | 837873.73 | 434559.04 | 51.86 |
| Fashion Hoodies & Sweatshirts | 11851 | 651563.63 | 312304.1 | 47.93 |
| Suits & Sport Coats | 5121 | 645708.74 | 386746.31 | 59.89 |
| Swim | 11147 | 631759.29 | 309185.71 | 48.94 |
| Sleep & Lounge | 11172 | 550660.01 | 285231.31 | 51.8 |
| Shorts | 11009 | 512803.19 | 256096.2 | 49.94 |
| Tops & Tees | 11886 | 497015.31 | 219125.73 | 44.09 |
| Active | 9018 | 470900.94 | 273482.43 | 58.08 |
| Dresses | 5397 | 459505.57 | 252090.04 | 54.86 |
| Intimates | 13236 | 445501.26 | 208888.43 | 46.89 |
| Pants | 7190 | 426292.75 | 230518.68 | 54.08 |
| Accessories | 9905 | 413220.7 | 247328.62 | 59.85 |
| Blazers & Jackets | 3183 | 288621.31 | 179026.18 | 62.03 |

*Showing top 15 of 26 rows. Full result: `sql/05_profitability_analysis.sql`.*

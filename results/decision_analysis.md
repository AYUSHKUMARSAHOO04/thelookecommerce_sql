# Decision Analysis

Full supporting detail behind the [Executive Summary](executive_summary.md) and [Business Insights](business_insights.md), organized by analytical domain. All figures are sourced directly from the exported query results.

## Revenue & Growth Analysis

**Long-term trend.** Monthly revenue grew from $24.99 in January 2019 (the first month with any recorded activity) to $172,918.49 in July 2026 — a sustained, multi-year growth trend with normal month-to-month volatility along the way (typical MoM swings of roughly ±10–20%, both positive and negative, are visible throughout).

**Recent momentum.** The trailing 12 months (September 2025 – August 2026) show consistent sequential growth, with revenue roughly 2.5x higher at the end of the window than the start.

**Observation requiring validation — August 2026.** The most recent month, August 2026, shows monthly revenue of $251,480.37, a 45.43% increase over July 2026's $172,918.49. This is the largest single-month percentage jump anywhere in the 92-month series apart from the very first data month (when the base was near zero). Two additional signals in the same month reinforce that this is worth validating rather than treating as an established trend:
- The repeat-customer rate fell sharply in August 2026 (29.78%) versus July 2026 (45.22%) and the trailing months (43–45% range), even as new-customer volume rose.
- The dataset's August 2026 activity is a partial month relative to the point this analysis was produced, which can distort month-over-month comparisons independent of any underlying business change.

**The SQL analysis identifies the trend but does not establish causality.** No promotional calendar, marketing spend, or campaign data exists in this dataset to explain the increase. This should be treated as an observation requiring validation, not a confirmed acceleration in the business.

### Monthly revenue — last 12 months

| Month | Revenue |
|---|---|
| September 2025 | $85,722.57 |
| October 2025 | $95,622.00 |
| November 2025 | $93,711.37 |
| December 2025 | $96,813.87 |
| January 2026 | $107,011.76 |
| February 2026 | $93,477.08 |
| March 2026 | $117,549.10 |
| April 2026 | $121,184.98 |
| May 2026 | $144,969.41 |
| June 2026 | $149,866.10 |
| July 2026 | $172,918.49 |
| August 2026 | $251,480.37 |

Full 92-month series available via `sql/01_customer_and_order_analysis.sql` (q11).

---

## Customer & Retention Analysis

### Repeat vs. one-time customers

| Customer Type | Customers | Total Revenue | Avg. Revenue/Customer |
|---|---|---|---|
| Repeat Customer | 29,851 | $6,462,519.26 | $216.49 |
| One-time Customer | 50,097 | $4,326,274.35 | $86.36 |

### Customer value segmentation (RFM-style)

| Segment | Customers | Net Revenue | Avg. Revenue/Customer | % of Customer Base |
|---|---|---|---|---|
| Low Value | 62,784 | $4,896,187.49 | $77.98 | 78.53% |
| Medium Value | 15,190 | $4,533,140.53 | $298.43 | 19.0% |
| High Value | 1,813 | $1,177,051.68 | $649.23 | 2.27% |
| VIP | 161 | $182,413.91 | $1,133.01 | 0.2% |

### Customer purchase-frequency segmentation

| Segment | Customers | Avg. Orders/Customer |
|---|---|---|
| Frequent | 5,028 | 4.0 |
| Occasional | 24,823 | 2.2 |
| One-Time | 50,097 | 1.0 |

### Customer lifecycle status (active / at-risk / inactive)

| Status | Customers | Avg. Customer Lifetime Value | Total Revenue |
|---|---|---|---|
| Active | 25,284 | $154.30 | $3,901,401.67 |
| At Risk | 23,123 | $140.69 | $3,253,272.75 |
| Inactive | 31,541 | $115.22 | $3,634,119.18 |

Customer lifecycle status is defined at the SQL layer (see `sql/03_customer_retention_analysis.sql`, q37–q39) based on recency of last order.

---

## Category & Product Analysis

### Revenue by category (all 26 categories)

| Category | Revenue | % of Total Revenue |
|---|---|---|
| Outerwear & Coats | $1,343,290.37 | 12.45% |
| Jeans | $1,243,365.44 | 11.52% |
| Sweaters | $837,873.73 | 7.77% |
| Fashion Hoodies & Sweatshirts | $651,563.63 | 6.04% |
| Suits & Sport Coats | $645,708.74 | 5.98% |
| Swim | $631,759.29 | 5.86% |
| Sleep & Lounge | $550,660.01 | 5.1% |
| Shorts | $512,803.19 | 4.75% |
| Tops & Tees | $497,015.31 | 4.61% |
| Active | $470,900.94 | 4.36% |
| Dresses | $459,505.57 | 4.26% |
| Intimates | $445,501.26 | 4.13% |
| Pants | $426,292.75 | 3.95% |
| Accessories | $413,220.70 | 3.83% |
| Blazers & Jackets | $288,621.31 | 2.68% |
| Maternity | $258,801.56 | 2.4% |
| Underwear | $208,866.69 | 1.94% |
| Pants & Capris | $191,993.11 | 1.78% |
| Plus | $162,605.84 | 1.51% |
| Socks | $123,951.07 | 1.15% |
| Suits | $114,052.19 | 1.06% |
| Skirts | $108,092.54 | 1.0% |
| Leggings | $80,430.85 | 0.75% |
| Socks & Hosiery | $63,399.15 | 0.59% |
| Jumpsuits & Rompers | $40,088.43 | 0.37% |
| Clothing Sets | $18,429.93 | 0.17% |

### Top 10 brands by revenue

| Brand | Revenue | Profit | Profit Margin |
|---|---|---|---|
| Diesel | $211,996.60 | $105,956.89 | 49.98% |
| Calvin Klein | $199,100.96 | $105,798.59 | 53.14% |
| True Religion | $182,741.39 | $87,312.65 | 47.78% |
| Carhartt | $179,550.26 | $95,733.63 | 53.32% |
| 7 For All Mankind | $171,836.44 | $81,942.85 | 47.69% |
| Tommy Hilfiger | $123,616.51 | $68,257.73 | 55.22% |
| Volcom | $110,440.86 | $53,993.72 | 48.89% |
| Columbia | $106,447.61 | $57,757.80 | 54.26% |
| The North Face | $104,902.91 | $57,422.05 | 54.74% |
| Joe's Jeans | $102,326.28 | $48,857.39 | 47.75% |

Full brand-level results (2,752 brands) available via `sql/02_revenue_and_product_analysis.sql` (q71–q73) and `sql/05_profitability_analysis.sql`; excluded here per the [Output Selection Methodology](result_index.md).

### Top 10 highest-revenue customers

| Rank | Customer | Total Sales |
|---|---|---|
| 1 | Timothy Gutierrez (ID 62719) | $2,003.81 |
| 2 | Scott Silva (ID 49568) | $1,545.50 |
| 3 | David Hansen (ID 48479) | $1,517.45 |
| 4 | Brianna Myers (ID 64065) | $1,452.80 |
| 5 | Nicholas Harris (ID 16804) | $1,426.63 |
| 6 | Stephanie Mckinney (ID 17729) | $1,423.99 |
| 7 | Lisa Gallegos (ID 10377) | $1,419.86 |
| 8 | Mario Lester (ID 5857) | $1,414.52 |
| 9 | Michael Wright (ID 66946) | $1,412.66 |
| 10 | Roy Frost (ID 30981) | $1,411.95 |

---

## Profitability

Company-wide: **$5,601,351.63 profit** on **$10,788,793.60 revenue** — a **51.92% margin**.

### Revenue, profit, and margin by category (sorted by margin, high to low)

| Category | Units Sold | Revenue | Profit | Margin |
|---|---|---|---|---|
| Blazers & Jackets | 3,183 | $288,621.31 | $179,026.18 | 62.03% |
| Skirts | 2,070 | $108,092.54 | $65,106.14 | 60.23% |
| Suits & Sport Coats | 5,121 | $645,708.74 | $386,746.31 | 59.89% |
| Accessories | 9,905 | $413,220.70 | $247,328.62 | 59.85% |
| Socks & Hosiery | 3,744 | $63,399.15 | $37,932.74 | 59.83% |
| Active | 9,018 | $470,900.94 | $273,482.43 | 58.08% |
| Maternity | 5,051 | $258,801.56 | $144,659.45 | 55.9% |
| Outerwear & Coats | 9,137 | $1,343,290.37 | $746,552.14 | 55.58% |
| Dresses | 5,397 | $459,505.57 | $252,090.04 | 54.86% |
| Pants | 7,190 | $426,292.75 | $230,518.68 | 54.08% |
| Underwear | 7,718 | $208,866.69 | $110,678.29 | 52.99% |
| Sweaters | 11,047 | $837,873.73 | $434,559.04 | 51.86% |
| Sleep & Lounge | 11,172 | $550,660.01 | $285,231.31 | 51.8% |
| Shorts | 11,009 | $512,803.19 | $256,096.20 | 49.94% |
| Plus | 4,352 | $162,605.84 | $81,057.25 | 49.85% |
| Swim | 11,147 | $631,759.29 | $309,185.71 | 48.94% |
| Fashion Hoodies & Sweatshirts | 11,851 | $651,563.63 | $312,304.10 | 47.93% |
| Pants & Capris | 3,478 | $191,993.11 | $90,775.39 | 47.28% |
| Intimates | 13,236 | $445,501.26 | $208,888.43 | 46.89% |
| Jumpsuits & Rompers | 923 | $40,088.43 | $18,773.12 | 46.83% |
| Jeans | 12,691 | $1,243,365.44 | $577,774.72 | 46.47% |
| Tops & Tees | 11,886 | $497,015.31 | $219,125.73 | 44.09% |
| Leggings | 3,078 | $80,430.85 | $32,078.26 | 39.88% |
| Socks | 6,315 | $123,951.07 | $49,212.48 | 39.7% |
| Suits | 994 | $114,052.19 | $45,198.01 | 39.63% |
| Clothing Sets | 206 | $18,429.93 | $6,970.86 | 37.82% |

**Revenue leaders are not always margin leaders.** Outerwear & Coats (#1 by revenue) sits at 55.58% margin — solid, but ranked 8th of 26 by margin. Blazers & Jackets (62.03%), Skirts (60.23%), and Suits & Sport Coats (59.89%) all out-margin the top-revenue category.

---

## Marketing & Traffic Analysis

### Traffic source performance

| Traffic Source | Customers | Ordered | Conversion Rate | Revenue | Revenue Contribution | Revenue/Customer |
|---|---|---|---|---|---|---|
| Search | 70,027 | 55,958 | 79.91% | $7,511,909.39 | 69.63% | $134.24 |
| Organic | 14,756 | 11,882 | 80.52% | $1,630,590.73 | 15.11% | $137.23 |
| Facebook | 6,118 | 4,823 | 78.83% | $653,884.95 | 6.06% | $135.58 |
| Email | 5,006 | 3,963 | 79.17% | $546,029.35 | 5.06% | $137.78 |
| Display | 4,093 | 3,322 | 81.16% | $446,379.19 | 4.14% | $134.37 |

**No marketing spend or advertising cost data exists in this dataset.** All figures above describe revenue contribution, customer acquisition volume, and conversion — not marketing ROI or customer acquisition cost, which would require spend data not present in `bigquery-public-data.thelook_ecommerce`.

---

## Operations Analysis

### Delivery time definitions

Two distinct delivery-time metrics were computed and should not be conflated:
- **Order-to-delivery time** (`created_at` → `delivered_at`): **3.98 days** average, across all delivered orders.
- **Delivery-to-return time** (`delivered_at` → `returned_at`, for returned orders only): **1.48 days** average.

### Distribution center performance

| Distribution Center | Total Revenue | Avg. Delivery Days | Return Rate |
|---|---|---|---|
| Houston TX | $1,603,654.75 | 3.96 | 9.83% |
| Memphis TN | $1,407,327.41 | 4.0 | 9.87% |
| Chicago IL | $1,324,708.77 | 3.96 | 9.65% |
| Mobile AL | $1,222,627.41 | 4.01 | 9.81% |
| Philadelphia PA | $1,077,510.30 | 3.98 | 9.83% |
| Los Angeles CA | $955,758.97 | 3.98 | 9.99% |
| Port Authority of New York/New Jersey NY/NJ | $934,174.49 | 4.0 | 9.72% |
| Savannah GA | $810,316.09 | 3.96 | 9.94% |
| New Orleans LA | $800,021.94 | 3.96 | 9.71% |
| Charleston SC | $652,693.47 | 3.97 | 10.1% |

**Delivery speed is not a meaningful differentiator between centers** — the range across all 10 centers is 3.96–4.01 days. Revenue and return-rate performance vary more; Houston TX leads on revenue, and Charleston SC has the highest return rate (10.10%) against a platform average of 9.83%.

### Return rate — category detail (highest and lowest 5 of 26)

Platform-wide: **12,270 of 124,771 orders returned (9.83%)**.

**Highest return rate:**

| Category | Total Orders | Returned Orders | Return Rate |
|---|---|---|---|
| Suits | 990 | 107 | 10.81% |
| Maternity | 4,912 | 527 | 10.73% |
| Clothing Sets | 206 | 22 | 10.68% |
| Socks & Hosiery | 3,670 | 385 | 10.49% |
| Pants | 6,947 | 728 | 10.48% |

**Lowest return rate:**

| Category | Total Orders | Returned Orders | Return Rate |
|---|---|---|---|
| Dresses | 5,244 | 500 | 9.53% |
| Intimates | 12,439 | 1,179 | 9.48% |
| Pants & Capris | 3,427 | 324 | 9.45% |
| Jumpsuits & Rompers | 917 | 84 | 9.16% |
| Accessories | 9,677 | 880 | 9.09% |

Full 26-category return-rate table available via `sql/06_distribution_and_operations_analysis.sql` (q29).

---

## Inventory Analysis

**Sell-through rate: 37.05%** — 180,919 of 488,373 total inventory units sold.

### Categories with the largest unsold inventory

| Category | Unsold Units |
|---|---|
| Intimates | 22,509 |
| Jeans | 21,620 |
| Tops & Tees | 20,287 |
| Fashion Hoodies & Sweatshirts | 20,141 |
| Swim | 18,851 |

This dataset does not include inventory intake dates relative to today, so it's not possible to distinguish genuinely slow-moving stock from recently-received stock that simply hasn't sold yet. Consider reviewing replenishment/markdown strategy for the categories above once inventory age is available.

---

## Concentration Analysis

- **Top 10 products' revenue contribution:** 1.23%
- **Top 10 customers' revenue share:** 0.14%

**Opportunity:** because concentration is low at the individual level, the business is not exposed to the loss of any single customer or product in a way that would materially move total revenue.

**Risk:** the inverse of low concentration is that there's no small, high-leverage group to focus retention or merchandising effort on — value is spread across segments (see Insight 3 in [`business_insights.md`](business_insights.md)) rather than individuals.

---

## Supporting Analysis: Demographics & Engagement

### Revenue by gender

| Gender | Customers | Revenue | Revenue/Customer |
|---|---|---|---|
| Male | 40,162 | $5,763,242.60 | $143.50 |
| Female | 39,786 | $5,025,551.01 | $126.31 |

### Revenue by age group

| Age Group | Customers | Revenue | Revenue/Customer |
|---|---|---|---|
| 25-34 | 13,502 | $1,828,577.01 | $135.43 |
| 35-44 | 13,503 | $1,827,719.16 | $135.36 |
| 45-54 | 13,633 | $1,855,580.06 | $136.11 |
| 55+ | 21,599 | $2,897,830.60 | $134.17 |
| under 25 | 17,711 | $2,379,086.77 | $134.33 |

Revenue per customer is broadly consistent across age groups (a narrow $134–$136 band for all groups except 55+ at $134.17), suggesting age is not a strong differentiator of customer value on this platform.

### Event engagement by type

| Event Type | Total Events | Unique Users |
|---|---|---|
| Product | 843,421 | 79,948 |
| Cart | 593,693 | 79,948 |
| Department | 593,472 | 79,948 |
| Purchase | 180,919 | 79,948 |
| Cancel | 125,117 | 0 |
| Home | 87,485 | 63,121 |

### Multi-item orders

37,286 of 124,771 orders (29.88%) contain more than one item — meaning roughly 7 in 10 orders are single-item purchases.

### Revenue by country (top 5 of 14)

| Country | Customers | Revenue |
|---|---|---|
| China | 27,001 | $3,658,844.72 |
| United States | 17,890 | $2,422,871.56 |
| Brasil | 11,601 | $1,555,125.14 |
| South Korea | 4,376 | $583,520.56 |
| France | 3,896 | $526,815.59 |

---

## Data Quality & Validation Notes

The following were checked before drawing conclusions, per the project's validation methodology:

- **Total revenue was cross-validated across seven independent breakdowns** (customer type, value segment, category, lifecycle status, traffic source, country, and category profitability) — all seven independently sum to $10,788,793.60, confirming internal consistency of the exported data.
- **Total ordered-customer count was cross-validated across six independent breakdowns** (traffic source, gender, value segment, frequency segment, lifecycle status, country) — all six sum to 79,948, confirming consistency.
- **August 2026 revenue and repeat-rate figures are flagged as an observation requiring validation** (see [Revenue & Growth Analysis](#revenue--growth-analysis)) rather than corrected or excluded, per this project's methodology of not silently altering source data.
- **Two distinct "avg_delivery_days" metrics exist in the source questions (q13 and q14)** with different definitions (order-to-delivery vs. delivery-to-return); both are reported separately above rather than merged, to avoid conflating two different operational metrics.
- **Return rate and cancellation rate are distinct metrics** computed from different order-status fields; category-level cancellation rates (available via `sql/06_distribution_and_operations_analysis.sql`, q43) range from 14.45% to 19.42% and are notably higher than return rates — these should not be added together or conflated.
- **Return causes are not present in the dataset.** Any explanation for *why* returns or cancellations occur would be speculation; this document deliberately avoids assigning a cause.
- **The dataset is not perfectly clean** — a small number of product-name fields in the long-tail product-level output (q57) contain encoding artifacts (stray non-breaking-space characters). This does not affect any numeric figure reported here.

---

## Recommended Actions

A prioritized, evidence-based recommendation table derived from the analysis above is maintained separately in [`recommended_actions.md`](recommended_actions.md).
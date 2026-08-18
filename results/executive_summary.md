# Executive Summary

All figures below are taken directly from the exported BigQuery query results in `thelookecommerece_output.txt` and cross-validated for internal consistency (see [Data Quality Notes](decision_analysis.md#data-quality--validation-notes)). No figure in this document is estimated, modeled, or invented.

## Headline KPIs

| KPI | Value |
|---|---|
| Total registered users | 100,000 |
| Total orders | 124,771 |
| Customers who placed at least one order | 79,948 |
| Customer conversion rate (ordered ÷ registered) | 79.95% |
| Total revenue (all order items) | $10,788,793.60 |
| Total profit (revenue − cost) | $5,601,351.63 |
| Overall profit margin | 51.92% |
| Average order value (AOV) | $86.47 |
| Overall return rate | 9.83% (12,270 of 124,771 orders) |
| Multi-item order rate | 29.88% (37,286 of 124,771 orders) |
| Repeat customers | 29,851 (37.3% of ordered customers) |
| Repeat customer avg. revenue/customer | $216.49 |
| One-time customer avg. revenue/customer | $86.36 |
| Top revenue category | Outerwear & Coats — $1,343,290.37 (12.45% of revenue) |
| Top revenue traffic source | Search — $7,511,909.39 (69.63% of revenue) |
| Inventory sell-through rate | 37.05% (180,919 of 488,373 units) |
| Top-10 customers' share of total revenue | 0.14% |
| Top-10 products' share of total revenue | 1.23% |

## What This Tells Us

**The business converts at a high rate.** Roughly 4 in 5 registered users have placed at least one order (79.95%), which is a strong conversion baseline against which future acquisition efforts can be measured.

**Revenue is not customer-concentrated.** The top 10 customers by revenue account for only 0.14% of total revenue, and the top 10 products account for only 1.23%. This is a broad-based, long-tail revenue base rather than one dependent on a handful of customers or SKUs — a structural strength, discussed further under [Concentration Analysis](decision_analysis.md#concentration-analysis).

**Repeat customers are worth roughly 2.5x a one-time customer.** Repeat customers average $216.49 in revenue versus $86.36 for one-time customers — a gap large enough to make retention economically significant. See [Business Insights](business_insights.md) for the full evidence-based writeup.

**Category revenue is moderately concentrated at the top.** Outerwear & Coats and Jeans together account for 23.97% of total revenue (12.45% + 11.52%), while the remaining ~24 categories share the rest — see [Product & Category Analysis](decision_analysis.md#category--product-analysis).

**Profitability tracks revenue reasonably closely, but not perfectly.** The company-wide margin is 51.92%, but individual categories range from 37.82% (Clothing Sets) to 62.03% (Blazers & Jackets) — a meaningful spread covered in [Profitability](decision_analysis.md#profitability).

**Recent monthly revenue shows a sharp, unusual jump in the most recent data month.** This is flagged explicitly as an observation requiring validation, not treated as an established trend — see [Revenue & Growth Analysis](decision_analysis.md#revenue--growth-analysis).

For the full evidence-based write-up behind each of these points, see [`business_insights.md`](business_insights.md) and [`decision_analysis.md`](decision_analysis.md). For a question-by-question map of what was and wasn't exported to this layer, see [`result_index.md`](result_index.md).

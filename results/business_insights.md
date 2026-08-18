# Business Insights

Ten major, evidence-based findings drawn directly from the exported query results, ranked by business importance. Every number below is taken from `thelookecommerece_output.txt`; where a percentage or share is computed here from two exported figures, the underlying components are shown alongside it.

---

## 1. Repeat customers are worth roughly 2.5x a one-time customer

**Finding:** Repeat customers generate substantially more revenue per customer than one-time customers.

**Evidence:**
- Repeat Customer: 29,851 customers · $6,462,519.26 revenue · $216.49 avg. revenue/customer
- One-time Customer: 50,097 customers · $4,326,274.35 revenue · $86.36 avg. revenue/customer

**Interpretation:** A customer who returns for a second order is worth roughly 2.5x what a one-time buyer is worth, on average.

**Business Impact:** Even though one-time customers outnumber repeat customers by a wide margin (50,097 vs. 29,851), repeat customers already contribute 59.9% of total revenue ($6,462,519.26 of $10,788,793.60) from just 37.3% of ordered customers.

**Recommended Action:** Prioritize retention initiatives, post-purchase engagement, and repeat-purchase campaigns aimed at converting first-time buyers into repeat buyers.

---

## 2. Revenue is broad-based, not concentrated in a handful of customers or products

**Finding:** No small group of customers or products is driving disproportionate revenue.

**Evidence:**
- Top 10 products' revenue contribution: 1.23%
- Top 10 customers' share of total revenue: 0.14%

**Interpretation:** Revenue is spread across a very large base of customers and products rather than a small set of "whale" accounts or hero SKUs. Even the single most concentrated of the two measures — the top 10 products — accounts for barely more than 1% of total revenue.

**Business Impact:**
- **Opportunity:** high-value customers and top products can be identified and protected without the business being structurally dependent on them.
- **Risk:** the flip side of diversification is that there is no small, easily-targetable group whose retention alone would materially move total revenue — retention and merchandising strategy need to work at scale, not through a handful of VIP accounts.

**Recommended Action:** Treat customer and product concentration as healthy in absolute terms, but pair this with the segment-level concentration in Insight 3, where value is concentrated by *segment* even though it isn't concentrated by *individual*.

---

## 3. A small "VIP" segment is disproportionately valuable relative to its size

**Finding:** The VIP customer segment is a tiny fraction of the customer base but contributes a share of revenue nearly 8.5x its population share.

**Evidence (customer value segments):**

| Segment | Customers | % of Customers | Net Revenue | % of Revenue | Avg. Revenue/Customer |
|---|---|---|---|---|---|
| Low Value | 62,784 | 78.53% | $4,896,187.49 | 45.38% | $77.98 |
| Medium Value | 15,190 | 19.00% | $4,533,140.53 | 42.02% | $298.43 |
| High Value | 1,813 | 2.27% | $1,177,051.68 | 10.91% | $649.23 |
| VIP | 161 | 0.20% | $182,413.91 | 1.69% | $1,133.01 |

**Interpretation:** VIP customers (0.20% of the ordered base) generate 1.69% of revenue — roughly 8.5x their proportional share — at an average revenue per customer 14.5x that of the Low Value segment.

**Business Impact:** Losing even a small number of VIP or High Value customers would have an outsized revenue impact relative to their headcount, even though (per Insight 2) no single customer individually dominates revenue.

**Recommended Action:** Consider a dedicated retention/relationship program for the High Value and VIP segments (1,974 customers combined), distinct from broader repeat-purchase campaigns aimed at the Low/Medium Value base.

---

## 4. Category revenue is moderately top-heavy

**Finding:** Two categories account for nearly a quarter of total revenue.

**Evidence:** Outerwear & Coats (12.45%, $1,343,290.37) and Jeans (11.52%, $1,243,365.44) together contribute 23.97% of total revenue, while the remaining 24 categories share the other 76.03%.

**Interpretation:** Revenue has a clear top tier of two categories, but is not a "single-category" business — the drop-off after Jeans is gradual (Sweaters at 7.77%), not a cliff.

**Business Impact:** Outerwear & Coats and Jeans function as the business's core revenue drivers; a disruption to either (supply, pricing, competition) would have a proportionally larger effect than a disruption to any other single category.

**Recommended Action:** Protect inventory availability and marketing support for Outerwear & Coats and Jeans as primary revenue drivers, while continuing to invest in the broader catalog rather than over-indexing on the top two.

---

## 5. Search dominates revenue but converts slightly worse than smaller channels

**Finding:** Search is by far the largest traffic source by revenue and customer volume, but has a marginally lower conversion rate than every channel except Facebook.

**Evidence:**

| Traffic Source | Customers | Ordered Customers | Conversion Rate | Revenue | Revenue Contribution |
|---|---|---|---|---|---|
| Display | 4,093 | 3,322 | 81.16% | $446,379.19 | 4.14% |
| Organic | 14,756 | 11,882 | 80.52% | $1,630,590.73 | 15.11% |
| Search | 70,027 | 55,958 | 79.91% | $7,511,909.39 | 69.63% |
| Email | 5,006 | 3,963 | 79.17% | $546,029.35 | 5.06% |
| Facebook | 6,118 | 4,823 | 78.83% | $653,884.95 | 6.06% |

**Interpretation:** Search drives 69.63% of all revenue and 79.91% of visiting customers convert — a strong absolute performance — but its conversion rate is not the platform's best; Display and Organic both convert at a marginally higher rate on much smaller volume.

**Business Impact:** Because Search is so large, even a small conversion-rate improvement there would move more absolute revenue than a much larger percentage-point improvement on any smaller channel.

**Recommended Action:** Investigate whether Search's slightly lower conversion rate reflects lower purchase intent in that channel's traffic mix; this dataset does not contain marketing spend, so no ROI or cost-per-acquisition conclusion can be drawn — only revenue and conversion patterns.

---

## 6. Profitability varies meaningfully by category, independent of revenue rank

**Finding:** Profit margin is not simply proportional to revenue — some lower-revenue categories are the most profitable per dollar of sales.

**Evidence:**
- Highest margin: Blazers & Jackets — 62.03% margin ($288,621.31 revenue, $179,026.18 profit) — despite ranking only 15th of 26 categories by revenue.
- Lowest margin: Clothing Sets — 37.82% margin ($18,429.93 revenue, $6,970.86 profit) — also the lowest-revenue category.
- Company-wide margin: 51.92% ($5,601,351.63 profit on $10,788,793.60 revenue).

**Interpretation:** Revenue leadership and margin leadership are different things in this catalog. Outerwear & Coats, the #1 revenue category, sits at a middling 55.58% margin — solid, but below Blazers & Jackets, Skirts (60.23%), and Suits & Sport Coats (59.89%).

**Business Impact:** A category-level revenue ranking alone would understate the relative value of high-margin, lower-volume categories like Blazers & Jackets and Skirts.

**Recommended Action:** When prioritizing merchandising or marketing investment, weigh margin alongside revenue rank rather than revenue alone — see the full category profitability table in [`decision_analysis.md`](decision_analysis.md#profitability).

---

## 7. Return rates are consistent across categories — no single outlier

**Finding:** Category-level return rates cluster tightly around the platform average, with no dramatic outlier.

**Evidence:** Across all 26 categories, return rates range from 9.09% (Accessories) to 10.81% (Suits) — a spread of only 1.72 percentage points around the platform-wide return rate of 9.83%.

**Interpretation:** Returns are a broad, structural characteristic of the business (roughly 1 in 10 orders) rather than a problem concentrated in a specific category.

**Business Impact:** There is no single category whose returns, if fixed, would materially move the overall return rate — this argues against a category-specific return-reduction initiative and for a platform-wide one.

**Recommended Action:** Given the narrow spread, further investigation into *why* customers return items (a reason field is not present in this dataset) would likely yield more value than category-specific interventions. Further investigation is required to determine the underlying cause.

---

## 8. Distribution centers are operationally similar in delivery speed, but Houston TX leads on revenue and Charleston SC has the highest return rate

**Finding:** Delivery-time performance is nearly uniform across distribution centers, while revenue and return-rate performance vary more.

**Evidence:**
- Delivery time range across all 10 centers: 3.96–4.01 days (essentially flat).
- Revenue leader: Houston TX — $1,603,654.75.
- Highest return rate: Charleston SC — 10.10% (1,584 of 15,688 orders).
- Lowest return rate: Chicago IL — 9.65% (2,167 of 22,455 orders).

**Interpretation:** Delivery speed is not a meaningful differentiator between centers — every center delivers in essentially the same ~4 days — but revenue volume and return rate do vary center to center.

**Business Impact:** Since delivery time doesn't explain the return-rate difference between Charleston SC and Chicago IL, the driver of that gap is not visible in this dataset.

**Recommended Action:** Consider reviewing Charleston SC's order/return handling process, while noting that the 0.45-point gap versus the lowest-return center is modest and would benefit from a longer observation window before concluding it's a structural issue.

---

## 9. Inventory sell-through is well below half

**Finding:** Only about a third of all inventory received has actually sold.

**Evidence:** 180,919 of 488,373 total inventory units sold — a 37.05% sell-through rate. The five categories with the largest unsold counts are Intimates (22,509), Jeans (21,620), Tops & Tees (20,287), Fashion Hoodies & Sweatshirts (20,141), and Swim (18,851).

**Interpretation:** Roughly 63% of inventory intake sits unsold at the time of this analysis. Some of this reflects inventory that simply hasn't sold *yet* rather than inventory that never will — the dataset does not contain inventory age or a "still in active catalog" flag, so a permanent-overstock conclusion cannot be drawn from this figure alone.

**Business Impact:** A sell-through rate this low, sustained over time, would represent significant tied-up capital and warehousing cost — but confirming that requires knowing how long this inventory has been on hand, which isn't available in this output.

**Recommended Action:** Consider reviewing replenishment and markdown strategy for the highest-unsold categories, particularly Intimates and Jeans, once inventory age data is available to distinguish "slow-moving" from "recently received."

---

## 10. The most recent month's revenue is a sharp outlier and requires validation before being treated as a trend

**Finding:** Monthly revenue climbed steadily for years, then jumped unusually sharply in the final data month.

**Evidence:** Monthly revenue rose from $172,918.49 (July 2026) to $251,480.37 (August 2026) — a 45.43% month-over-month increase, the largest MoM jump in the entire 92-month series apart from the very first data month. By comparison, prior-year same-period growth (July 2025 → August 2025) was 16.13%. The repeat-customer rate for August 2026 also dropped sharply, from 45.22% (July 2026) to 29.78%, even as new-customer count rose from 3,046 to 4,100.

**Interpretation:** This is an unusual pattern — a large revenue spike accompanied by a falling repeat-customer rate is not the typical signature of organic growth acceleration. Because this analysis was run mid-month (the data spans through August 2026, a partial month relative to when this analysis was produced), the August figure may also reflect an incomplete-month artifact rather than a genuine trend.

**Business Impact:** If treated uncritically, this figure would overstate recent momentum in an executive report.

**Recommended Action:** Flag for validation before using in any forward-looking revenue narrative. The SQL analysis identifies the trend but does not establish causality — do not assume a cause (promotion, data pipeline issue, partial-month effect) without further investigation. See [Revenue & Growth Analysis](decision_analysis.md#revenue--growth-analysis) for the full monthly series.

---

For the complete supporting tables behind each of these insights, see [`decision_analysis.md`](decision_analysis.md).

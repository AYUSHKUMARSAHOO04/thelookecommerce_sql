# Results — Decision Analysis Layer

While 90 SQL business questions were developed and are all runnable in `sql/`, this folder contains the curated **decision-analysis layer**: the subset of outputs that are concise, decision-relevant, and useful for executive interpretation, along with the business insights and recommendations built on top of them.

## Contents

| File | What it contains |
|---|---|
| [`executive_summary.md`](executive_summary.md) | ~15 headline KPIs and a top-level read of business performance |
| [`business_insights.md`](business_insights.md) | 10 major findings, each with Finding → Evidence → Interpretation → Business Impact → Recommended Action |
| [`decision_analysis.md`](decision_analysis.md) | Full supporting tables by domain (revenue, customer, product, profitability, marketing, operations, inventory, concentration) plus data-quality notes |
| [`recommended_actions.md`](recommended_actions.md) | Prioritized recommendation table tying evidence to suggested next steps |
| [`selected_query_results.md`](selected_query_results.md) | Raw exported output for each of the 41 questions used in the executive layer, in question order |
| [`result_index.md`](result_index.md) | All 90 questions mapped to output availability, decision relevance, and whether each was used in the executive layer |
| [`TheLook_Ecommerce_Decision_Analysis.xlsx`](TheLook_Ecommerce_Decision_Analysis.xlsx) | Excel workbook version of the KPI dashboard and supporting tables, for offline review |

## Output Selection Methodology

Although 90 SQL business questions were developed and analyzed, this decision-analysis layer focuses on outputs that are concise, decision-relevant, and useful for executive interpretation. Several queries — particularly per-product and per-brand breakdowns — return thousands of rows and were intentionally excluded from this layer to avoid noise. This is a deliberate curation decision, not missing work: every one of the 90 questions has a complete, working, documented query in `sql/`. See [`result_index.md`](result_index.md) for the full question-by-question breakdown of what is and isn't included here.

## Reproducing results

1. Open the [BigQuery console](https://console.cloud.google.com/bigquery) (a free-tier / sandbox project works, since this dataset is public).
2. Open a new SQL workspace.
3. Copy any query from `sql/` — each is fully qualified against `bigquery-public-data.thelook_ecommerce` and runs standalone.
4. Run and review the output directly in BigQuery, or export to CSV/Sheets for further analysis.

No project-specific setup, credentials, or environment variables are required — the dataset is public and the queries are self-contained.

**Note on reproducibility:** `bigquery-public-data.thelook_ecommerce` updates over time, so re-running these queries today will not return exactly the figures in this decision-analysis layer — those figures are a snapshot taken from a specific export. The SQL logic itself, however, remains valid against the live dataset.

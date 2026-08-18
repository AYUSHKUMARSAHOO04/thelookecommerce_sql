-- =====================================================================
-- TheLook E-commerce SQL Business Analytics
-- Section: Events & User Engagement
-- Dataset: bigquery-public-data.thelook_ecommerce
-- =====================================================================

-- q77: Which types of website events are performed most frequently by users.
select event_type, count(*) as total_events, count(distinct user_id) as unique_users
from `bigquery-public-data.thelook_ecommerce.events`
group by event_type
order by total_events desc;

-- q79: Which types of website activities have the highest user engagement.
select event_type, count(*) as total_events, count(distinct user_id) as active_users, round(safe_divide(count(*), count(distinct user_id)), 2) as events_per_user
from `bigquery-public-data.thelook_ecommerce.events`
where user_id is not null
group by event_type
order by total_events desc;


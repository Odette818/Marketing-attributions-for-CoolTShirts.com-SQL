#Check the number of distinct Utm_campaigns
SELECT COUNT(DISTINCT utm_campaign) AS 'total_campaigns'
FROM page_visits;

#Check the number of distinct utm_sources
SELECT COUNT(DISTINCT utm_source) AS 'total_sources'
FROM page_visits;

#Check how utm_campaigns and utm_sources are related
SELECT DISTINCT utm_campaign, utm_source
FROM page_visits;

#Check the names of website pages
SELECT DISTINCT page_name
FROM page_visits;

#Check for how many of the first touches each campaign is responsible for
WITH first_touch AS (
  SELECT user_id,
   MIN(timestamp) AS 'first_touch_at'
  FROM page_visits
  GROUP BY 1
)
SELECT ft.user_id, ft.first_touch_at, pv.utm_campaign, pv.utm_source, COUNT(ft.first_touch_at) AS 'total'
FROM first_touch AS 'ft'
JOIN page_visits AS 'pv'
 ON ft.user_id = pv.user_id AND ft.first_touch_at = pv.timestamp
GROUP BY pv.utm_campaign
ORDER BY total DESC;

#Count distinct users that make a purchase
SELECT COUNT(DISTINCT user_id)
FROM page_visits
WHERE page_name = '4 - purchase';

#Check for how many of the last touches each campaign is reponsible for
WITH last_touch AS (
  SELECT user_id, 
   MAX(timestamp) AS 'last_touch_at'
FROM page_visits
GROUP BY user_id
)
SELECT lt.user_id, lt.last_touch_at, pv.utm_campaign, pv.utm_source, COUNT(lt.last_touch_at) AS 'total'
FROM last_touch AS 'lt'
JOIN page_visits AS 'pv'
 ON lt.user_id = pv.user_id AND lt.last_touch_at = pv.timestamp
GROUP BY pv.utm_campaign
ORDER BY total DESC;

#Check for how many of the last touches on the purchase web page each campaign is responsible for
WITH last_touch AS (
  SELECT user_id, 
   MAX(timestamp) AS 'last_touch_at'
FROM page_visits
WHERE page_name = '4 - purchase'
GROUP BY user_id
)
SELECT lt.user_id, lt.last_touch_at, pv.utm_campaign, pv.utm_source, COUNT(lt.last_touch_at) AS 'total'
FROM last_touch AS 'lt'
JOIN page_visits AS 'pv'
 ON lt.user_id = pv.user_id AND lt.last_touch_at = pv.timestamp
GROUP BY pv.utm_campaign
ORDER BY total DESC;

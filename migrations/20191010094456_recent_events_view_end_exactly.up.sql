--- replace old with new view
BEGIN;
DROP VIEW protected.recent_events;
CREATE VIEW protected.recent_events AS SELECT * FROM eventzimmer.events WHERE starts_at >= current_timestamp - interval '3 hours' AND starts_at < (date_trunc('month', current_timestamp::date) + interval '2 month')::date;
COMMIT;

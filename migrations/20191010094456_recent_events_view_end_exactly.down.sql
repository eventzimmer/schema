--- undo transaction
BEGIN;
DROP VIEW protected.recent_events;
CREATE VIEW protected.recent_events AS SELECT * FROM eventzimmer.events WHERE starts_at >= current_timestamp - interval '3 hours' AND starts_at <= current_timestamp + interval '60 days';
COMMIT;

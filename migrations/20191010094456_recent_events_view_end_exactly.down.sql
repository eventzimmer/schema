--- undo transaction
CREATE OR REPLACE VIEW protected.recent_events AS SELECT * FROM eventzimmer.events AS events WHERE events.starts_at >= current_timestamp - interval '3 hours' AND events.starts_at <= current_timestamp + interval '60 days';

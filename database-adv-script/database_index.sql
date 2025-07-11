-- SQL INDEX commands to create appropriate indexes for those the required column.
CREATE INDEX idx_booking_property_id ON Booking (property_id);
CREATE INDEX idx_booking_user_id ON Booking (user_id);
CREATE INDEX idx_booking_dates ON Booking (start_date, end_date); -- Composite index for date range queries
CREATE INDEX idx_booking_status ON Booking (status);

-- Indexes for Property table
CREATE INDEX idx_property_host_id ON Property (host_id);
CREATE INDEX idx_property_location ON Property (location);
CREATE INDEX idx_property_pricepernight ON Property (pricepernight);

-- Indexes for Users table
CREATE INDEX idx_user_role ON Users (role);
CREATE INDEX idx_user_created_at ON Users (created_at);

-- Measure query performance before and after adding indexes
EXPLAIN ANALYZE
SELECT *
FROM Booking
WHERE user_id = 'user_id';
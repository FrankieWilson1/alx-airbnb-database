-- Initial Database Indexing Script

-- Objective: Create essential indexes on frequently queried columns to improve
-- database read performance and optimize common lookups, filtering, and join operations.
-- These indexes are fundamental for a well-performing relational database.

-- =============================================================================
-- Indexes for the 'Booking' table
-- =============================================================================

-- Index on 'property_id':
-- Optimizes JOIN operations between Booking and Property tables (ON B.property_id = P.property_id).
-- Also improves performance for queries that filter bookings by a specific property.
CREATE INDEX idx_booking_property_id ON Booking (property_id);

-- Index on 'user_id':
-- Optimizes JOIN operations between Booking and Users tables (ON B.user_id = U.user_id).
-- Also speeds up queries that retrieve bookings made by a specific user.
CREATE INDEX idx_booking_user_id ON Booking (user_id);

-- Composite index on 'start_date' and 'end_date':
-- Highly effective for date range queries (e.g., WHERE start_date >= '...' AND end_date <= '...').
-- The order of columns (start_date first) is crucial for queries that filter by start_date alone
-- or by both dates.
CREATE INDEX idx_booking_dates ON Booking (start_date, end_date);

-- Index on 'status':
-- Improves performance for queries that filter bookings by their status (e.g., WHERE status = 'confirmed').
-- Also benefits grouping or ordering results by status.
CREATE INDEX idx_booking_status ON Booking (status);

-- =============================================================================
-- Indexes for the 'Property' table
-- =============================================================================

-- Index on 'host_id':
-- Optimizes lookups and JOIN operations related to properties owned by a specific host.
CREATE INDEX idx_property_host_id ON Property (host_id);

-- Index on 'location':
-- Speeds up queries that filter properties by their geographical location.
CREATE INDEX idx_property_location ON Property (location);

-- Index on 'pricepernight':
-- Improves performance for queries that filter properties based on their price
-- (e.g., WHERE pricepernight >= 100) or sort them by price.
CREATE INDEX idx_property_pricepernight ON Property (pricepernight);

-- =============================================================================
-- Indexes for the 'Users' table
-- =============================================================================

-- Index on 'role':
-- Optimizes queries that filter or group users by their assigned role (e.g., 'guest', 'host', 'admin').
CREATE INDEX idx_user_role ON Users (role);

-- Index on 'created_at':
-- Improves performance for queries filtering or sorting users based on their account creation date.
CREATE INDEX idx_user_created_at ON Users (created_at);


-- =============================================================================
-- Performance Measurement Example
-- =============================================================================
-- After creating the indexes, use EXPLAIN ANALYZE (for PostgreSQL) or EXPLAIN (for MySQL/MariaDB)
-- to observe the query plan. You should see "Index Scan" (or similar) instead of "Seq Scan"
-- on the 'user_id' column for this query, indicating the index is being effectively utilized,
-- leading to reduced query cost and faster execution.

EXPLAIN ANALYZE
SELECT *
FROM Booking
WHERE user_id = '00000000-0000-0000-0000-000000000001'; -- IMPORTANT: A dummy UUID
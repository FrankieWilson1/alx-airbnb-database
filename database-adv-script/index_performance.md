# Database Indexing Guide and Performance Analysis

This document outlines the strategy for creating SQL indexes on the `Users`, `Booking`, and `Property` tables to improve query performance, along with instructions on how to measure the impact of these indexes.

## 1. Identified High-Usage Columns

Based on common application usage patterns (e.g., filtering, joining, ordering data), the following columns have been identified as candidates for indexing:

### `Booking` Table
* `property_id`: Frequently used in `JOIN` operations to the `Property` table and `WHERE` clauses to find bookings for a specific property.
* `user_id`: Heavily utilized in `JOIN` operations to the `Users` table and `WHERE` clauses to find bookings made by a particular user.
* `start_date`, `end_date`: Essential for date range queries (e.g., finding bookings within a specific period). A composite index is highly beneficial here.
* `status`: Used for filtering bookings by their current state (e.g., 'confirmed', 'pending', 'cancelled').

### `Property` Table
* `host_id`: Used in `JOIN` operations to the `Users` table (if `host_id` refers to a user) or for retrieving properties managed by a specific host.
* `location`: A primary filter for users searching for properties.
* `pricepernight`: Frequently used for filtering properties within a price range and for sorting search results.

### `Users` Table
* `role`: Used for filtering users by their assigned role (e.g., 'guest', 'host', 'admin').
* `created_at`: Common for sorting users by their registration date or filtering by creation period.

## 2. SQL `CREATE INDEX` Commands

Below are the SQL commands to create the appropriate indexes for the identified columns. You can save these commands in a file named `database_index.sql`.

```sql

-- Indexes for Booking table
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


-- Sample Query 1: Find all bookings made by a specific user
SELECT *
FROM Booking
WHERE user_id = [EXISTING_USER_ID]; -- Replace [EXISTING_USER_ID] with an actual ID from your Users table

-- Sample Query 2: Find properties in a specific location within a price range, sorted by price
SELECT *
FROM Property
WHERE location = 'New York' AND pricepernight BETWEEN 100 AND 500
ORDER BY pricepernight ASC;

-- Sample Query 3: Find bookings within a specific date range
SELECT *
FROM Booking
WHERE start_date >= '2023-01-01' AND end_date <= '2023-01-31';

-- Sample Query 4: Find all bookings and property details associated with a specific host
SELECT B.*, P.name AS property_name, U.customer_name AS user_name
FROM Booking B
JOIN Property P ON B.property_id = P.property_id
JOIN Users U ON B.user_id = U.user_id
WHERE P.host_id = [EXISTING_HOST_ID]; -- Replace [EXISTING_HOST_ID] with an actual host ID
```

## 3. Measure query performance before and after adding indexes using `EXPLAIN` or `ANALYZE`.

1. Ensure no indexes exist (for these specific columns): If you've previously run CREATE INDEX commands, you might need to drop them before this step to get a true 'before' picture.

Example: ```DROP INDEX idx_booking_user_id ON Booking; (Syntax may vary slightly by database).```
2. Run EXPLAIN (or EXPLAIN ANALYZE) on each sample query: Prepend the EXPLAIN command to each of your sample queries.

For PostgreSQL (recommended for detailed analysis):
```
EXPLAIN ANALYZE
SELECT *
FROM Booking
WHERE user_id = 1;
```

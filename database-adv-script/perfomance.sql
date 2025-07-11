-- performance.sql - Complex Query for Performance Analysis and Monitoring

-- Objective: Retrieve confirmed bookings for a specific date range,
-- along with user details, property details, and payment details.
-- This query is designed to simulate a frequently used application query
-- and is used as a baseline for ongoing performance analysis.
-- Analyze its execution plan using EXPLAIN ANALYZE to identify inefficiencies.

EXPLAIN ANALYZE -- Use EXPLAIN for MySQL to see the execution plan details
SELECT
    B.booking_id,
    B.start_date,
    B.total_price,
    U.user_id,
    U.first_name AS user_name,
    U.email,
    P.property_id,
    P.name AS property_name,
    P.location AS property_location,
    P.pricepernight,
    Py.payment_id,
    Py.created_at AS payment_date,
    Py.status AS payment_status
FROM
    Booking B
INNER JOIN
    Users U ON B.user_id = U.user_id
INNER JOIN
    Property P ON B.property_id = P.property_id
INNER JOIN
    Payment Py ON B.booking_id = Py.booking_id
WHERE
    B.status = 'confirmed' -- Example filter: only confirmed bookings
    AND B.start_date >= '2024-01-01' -- Example date range start
    AND B.start_date < '2025-01-01';  -- Example date range end (e.g., for year 2024 bookings)
-- Demonstrating SQL Aggregations and Window Functions

-- Objective: This script showcases how to use SQL aggregate functions (like COUNT)
-- with the GROUP BY clause for summarizing data, and how to apply window functions
-- for ranking and more advanced analytical purposes.

-- =============================================================================
-- 1. Aggregation: Total Number of Bookings Made by Each User
--    This query calculates the total count of bookings for every user.
--    It utilizes the COUNT() aggregate function in conjunction with the GROUP BY clause
--    to summarize booking data per user.
--    A LEFT JOIN is intentionally used to ensure that all users are included in the
--    result set, even those who have not made any bookings. For such users,
--    'total_bookings_made' will correctly show as 0.
-- =============================================================================
SELECT
    U.user_id,
    U.first_name AS user_name,
    COUNT(B.booking_id) AS total_bookings_made -- Counts individual booking IDs. For NULLs from LEFT JOIN, COUNT returns 0.
FROM
    User U
LEFT JOIN -- Uses LEFT JOIN to ensure all users are listed, including those with zero bookings.
    Booking B ON U.user_id = B.user_id
GROUP BY
    U.user_id,
    user_name -- Grouping by the user's ID and name to get a count per unique user.
ORDER BY
    total_bookings_made DESC, -- Orders the result by the number of bookings from highest to lowest.
    user_name ASC;            -- Provides a secondary sort by user name alphabetically for tie-breaking.


-- =============================================================================
-- 2. Window Functions: Ranking Properties Based on Total Bookings Received
--    This query demonstrates the power of Common Table Expressions (CTEs)
--    combined with window functions (ROW_NUMBER() and RANK()) to rank properties.
--    It first calculates the total bookings for each property using aggregation
--    within a CTE, and then applies ranking functions over that aggregated data.
-- =============================================================================
WITH PropertyBookingCounts AS (
    -- This Common Table Expression (CTE) first calculates the total number of bookings
    -- received by each property.
    SELECT
        P.property_id,
        P.name AS property_name,
        COUNT(B.booking_id) AS total_booking_recieved -- Aggregates the count of bookings per property.
    FROM
        Property P
    LEFT JOIN -- Ensures that all properties are included, even if they have 0 bookings.
        Booking B ON P.property_id = B.property_id
    GROUP BY
        P.property_id,
        P.name
)
SELECT
    property_id,
    property_name,
    total_booking_recieved,
    ROW_NUMBER() OVER (
        -- ROW_NUMBER() assigns a unique, sequential integer to each row within the result set
        -- based on the specified order. If two rows have the same 'total_booking_recieved',
        -- their row numbers will still be different (arbitrarily assigned).
        ORDER BY
            total_booking_recieved DESC
    ) AS row_num_rank,
    RANK() OVER (
        -- RANK() assigns a rank to each row. If multiple rows have the same value for the
        -- ORDER BY columns (i.e., ties), they will receive the same rank, and the next
        -- rank in the sequence will be skipped (e.g., 1, 2, 2, 4).
        ORDER BY
            total_booking_recieved DESC
    ) AS rank_with_ties
FROM
    PropertyBookingCounts -- Selects from the aggregated results of the CTE.
ORDER BY
    total_booking_recieved DESC,
    property_name ASC;
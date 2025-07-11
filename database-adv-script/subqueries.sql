-- Demonstrating SQL Subqueries (Non-Correlated and Correlated)

-- Objective: This script illustrates two main types of SQL subqueries:
-- non-correlated subqueries (which execute independently of the outer query)
-- and correlated subqueries (which depend on values from the outer query).
-- Subqueries are powerful tools for breaking down complex data retrieval
-- tasks into smaller, more manageable parts.

-- =============================================================================
-- 1. Non-Correlated Subquery
--    A non-correlated subquery is a self-contained query that does not rely
--    on any values from the outer query. It executes completely on its own,
--    and its result set (or a single value) is then used by the outer query.
--    This example finds all properties that have an average review rating greater than 4.0.
-- =============================================================================
SELECT
    P.property_id,
    P.name AS property_name -- Selects property ID and name from the main table
FROM
    Property P
WHERE
    P.property_id IN ( -- The outer query filters properties whose IDs are present in the subquery's result.
        -- This subquery executes first, independently.
        -- It calculates the average rating for each property and returns the IDs
        -- of properties that meet the specified rating criteria.
        SELECT
            R.property_id
        FROM
            Reviews R -- Assuming 'Reviews' is the table name for consistency
        GROUP BY
            R.property_id
        HAVING
            AVG(R.rating) > 4.0 -- Filters groups where the average rating is greater than 4.0
    );


-- =============================================================================
-- 2. Correlated Subquery
--    A correlated subquery is dependent on the outer query for its values.
--    It executes once for *each row* processed by the outer query. This means
--    the subquery is re-evaluated for every candidate row from the outer query.
--    This example finds users who have made more than 3 bookings.
-- =============================================================================
SELECT
    U.user_id,
    U.first_name,
    U.last_name
FROM
    User U -- This is the outer query, processing users one by one.
WHERE
    ( -- The subquery below is correlated; it runs for each 'U' (user) from the outer query.
        SELECT
            COUNT(B.booking_id) -- Counts the number of bookings.
        FROM
            Booking B
        WHERE B.user_id = U.user_id -- This is the correlation condition: it links the inner query's 'user_id'
                                    -- to the outer query's current 'user_id' (U.user_id).
    ) > 3; -- The outer query filters for users where the count returned by the subquery is greater than 3.
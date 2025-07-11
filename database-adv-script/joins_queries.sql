-- Demonstrating Different SQL JOIN Operations

-- Objective: Showcase the behavior and results of INNER JOIN, LEFT JOIN, and FULL OUTER JOIN
-- using common table relationships (Users to Booking, Property to Reviews).

-- =============================================================================
-- 1. INNER JOIN
--    Retrieves rows where there is a match in both tables based on the join condition.
--    Rows that do not have a match in both tables are excluded from the result set.
-- =============================================================================
SELECT
    U.user_id,
    U.first_name,
    U.last_name,
    B.booking_id,
    B.start_date,
    B.end_date,
    B.total_price
FROM
    Users U
INNER JOIN
    Booking B ON U.user_id = B.user_id;


-- =============================================================================
-- 2. LEFT JOIN (or LEFT OUTER JOIN)
--    Returns all rows from the 'left' table (the first table mentioned in the FROM clause)
--    and the matching rows from the 'right' table.
--    If there's no match in the 'right' table, NULL values are returned for the
--    columns from the 'right' table.
--    Useful for getting all primary entities (e.g., all Properties) and their
--    related data (e.g., Reviews), even if the related data doesn't exist.
-- =============================================================================
SELECT
    P.property_id,
    P.name AS property_name, -- Alias 'name' to 'property_name' for clarity in results
    R.review_id,
    R.rating,
    R.comment
FROM
    Property P
LEFT JOIN
    Review R ON P.property_id = R.property_id
ORDER BY
    P.name ASC,
    R.created_at DESC;


-- =============================================================================
-- 3. FULL OUTER JOIN
--    Returns all rows when there is a match in either the left (first) or the right (second) table.
--    If a row in the left table has no match in the right table, the columns from the right table
--    will have NULLs. Conversely, if a row in the right table has no match in the left table,
--    the columns from the left table will have NULLs.
--    Useful for finding mismatches or seeing the complete combined set from both tables.
-- =============================================================================
SELECT
    U.user_id,
    U.first_name,
    U.last_name,
    B.booking_id,
    B.start_date,
    B.end_date,
    B.total_price
FROM
    Users U
FULL OUTER JOIN
    Booking B ON U.user_id = B.user_id;
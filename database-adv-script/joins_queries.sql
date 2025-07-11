-- Inner JOIN
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
    INNER JOIN Booking B ON U.user_id = B.user_id

-- LEFT JOIN
SELECT
    p.property_id,
    p.name AS property_name,
    -- Gives property_name as alias to name fro clarity
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

-- FULL OUTER JOIN
SELECT
    U.user_id,
    U.first_name,
    U.last_name,
    B.booking_id,
    B.start_date,
    B.end_date,
    B.total_price
FROM
    Users U FULL
    OUTER JOIN Booking B ON U.user_id = B.user_id
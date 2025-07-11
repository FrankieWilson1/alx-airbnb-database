-- Non-Correlated Subquery
SELECT
    Property.property_id,
    Property.name AS property_name
FROM
    Property
WHERE
    Property.property_id IN (
        SELECT
            Review.property_id
        FROM
            Review
        GROUP BY
            Review.property_id
        HAVING
            AVG(Review.rating) > 4.0
    );


-- Correlated Subquery
SELECT
    u.user_id,
    u.first_name,
    u.last_name
FROM
    Users U
WHERE
    (
        SELECT
            COUNT(B.booking_id)
        FROM
            Booking B
        WHERE B.user_id = U.user_id

    ) > 3;
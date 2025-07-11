-- A query to find the total number of bookings made by each user, using the COUNT function and GROUP BY clause.
SELECT
    U.user_id,
    U.first_name AS user_name,
    COUNT(B.booking_id) AS total_bookings_made
FROM
    Users U
    LEFT JOIN -- To iclude users who have zero bookings.
    Booking B ON U.user_id = B.user_id
GROUP BY
    U.user_id,
    user_name
ORDER BY
    total_bookings_made DESC,
    user_name;

-- rank properties based on the total number of bookings they have received.
WITH PropertyBookingCounts AS (
    -- Calculates total bookings per property using aggregation
    SELECT
        P.property_id,
        P.name AS property_name,
        COUNT(B.booking_id) AS total_booking_recieved
    FROM
        Property P
        LEFT JOIN -- Include properties with 0 bookings using left join
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
        ORDER BY
            total_booking_recieved DESC
    ) AS row_num_rank,
    RANK() OVER (
        ORDER BY
            total_booking_recieved DESC
    ) AS rank_with_ties
FROM
    PropertyBookingCounts
ORDER BY
    total_booking_recieved DESC,
    property_name;
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
    User U ON B.user_id = U.user_id
INNER JOIN
    Property P ON B.property_id = P.property_id
INNER JOIN
    Payment PY ON B.booking_id = Py.booking_id;
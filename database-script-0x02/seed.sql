/*
The following SQL populates the database with sample data.
The UUIDs used are manually provided for demonstration purposes.
*/

-- Inserting into a User with 'guest' role.
INSERT INTO User (user_id, first_name, last_name, email, password_hash, phone_number, role)
VALUES (
    '00000000-0000-0000-0000-000000000001', -- Example UUID for Frank (Guest)
    'Frank',
    'Williams',
    'myEmail@gmail.com',
    'hashed_password_for_user_frank', -- Placeholder for an actual hashed password
    '+123-456-789', -- Example phone number (standardized format)
    'guest'
);

-- Inserting into a User with 'host' role (host for the property)
INSERT INTO User (user_id, first_name, last_name, email, password_hash, phone_number, role)
VALUES (
    '00000000-0000-0000-0000-000000000002', -- Example UUID for Alice (Host)
    'Alice',
    'Johnson',
    'alice@gmail.com',
    'hashed_password_for_user_alice', -- Placeholder for an actual hashed password
    '+123-456-333',
    'host'
);

-- Inserting into the Property table
INSERT INTO Property (property_id, host_id, name, description, location, pricepernight)
VALUES (
    '00000000-0000-0000-0000-00000000000a',
    '00000000-0000-0000-0000-000000000002', -- IMPORTANT: This is Alice's user_id (the host)
    'Beautiful Downtown Apartment',
    'a very nice and beautiful building for a family of 2 and above, featuring modern amenities and city views.',
    'New York, NY',
    44.99
);

-- Inserting into the Booking table
INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status)
VALUES (
    '00000000-0000-0000-0000-00000000000Z', -- UUID for the booking
    '00000000-0000-0000-0000-00000000000a', -- IMPORTANT: This is the property_id of the 'Beautiful Downtown Appartment'
    '00000000-0000-0000-0000-000000000001', -- IMPORTANT: This is Frank's user_id (the guest booking)
    '2025-07-25', -- Start date (standard YYYY-MM-DD format)
    '2025-07-30', -- End date
    224.99, -- total_price (44.99 * 5)
    'confirmed' -- Status for the booking
);

-- Inserting into Payment table
INSERT INTO Payment (payment_id, booking_id, amount, payment_method)
VALUES (
    '00000000-0000-0000-0000-00000000000T', -- UUID for the payment
    '00000000-0000-0000-0000-00000000000Z', -- IMPORTANT: This is the booking_id from the Booking table
    44.99, -- Amount should match total_price from Booking
    'credit_card' -- payment method
);

-- Inserting into Review table
INSERT INTO Review (review_id, property_id, user_id, rating, comment)
VALUES (
    '00000000-0000-0000-0000-00000000000X', -- UUID for the review
    '00000000-0000-0000-0000-00000000000a', -- IMPORTANT: this is the property_id of the 'Property'
    '00000000-0000-0000-0000-000000000001', -- IMPORTANT: this is Frank's user_id (the guest reviewing)
    3.0, -- Rating
    'This is a very nice property, I am going to try it some days'
);


-- Inserting into Message table
INSERT INTO Message (message_id, sender_id, recipient_id, message_body)
VALUES (
    '00000000-0000-0000-0000-00000000000V', -- UUID for the message
    '00000000-0000-0000-0000-000000000001', -- IMPORTANT: Frank's user_id (the sender)
    '00000000-0000-0000-0000-000000000002', -- IMPORTANT: Alice's user_id (the recipient)
    'Hi, does this property include a pent house?'
);

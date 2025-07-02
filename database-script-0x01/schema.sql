/*
The following SQL fefines the schema for alx-airbnb-like database,
specifying the entities (tables), their attributes (columns),
data types, constraints, and indexes for optimal performance and data integrity.
*/

-- Table: Users
CREATE TABLE User (
    user_id UUID PRIMARY KEY,                       -- Unique identifier for each user.
    first_name VARCHAR(150) NOT NULL,
    last_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,             -- User's email, must be unique for login purposes.
    password_hash VARCHAR(255) NOT NULL,            -- Stores the hashed_password. Increased size for mordern hasing algorithms.
    phone_number VARCHAR(50),
    role ENUM('guest', 'host', 'admin') NOT NULL,   -- Defines the user's privilege level.
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Indexes for Users table
CREATE INDEX idx_user_role ON Users (role);             -- For filtering users by their role
CREATE INDEX idx_user_created_at ON Users (created_at); -- For sorting users by creation date

-- Table: Property
CREATE TABLE Property (
    property_id UUID PRIMARY KEY,
    host_id UUID NOT NULL, -- Foreign Key
    name VARCHAR(100) NOT NULL,
    description TEXT,
    location VARCHAR(100) NOT NULL,
    pricepernight DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (host_id) REFERENCES Users(user_id)
);

-- Indexes for Property table
CREATE INDEX idx_property_host_id ON Property (host_id); -- Speeds up joins to Users table
CREATE INDEX idx_property_location ON Property (location); -- For searching properties by location
CREATE INDEX idx_property_pricepernight ON Property (pricepernight); -- For filtering/sorting by price

-- Table: Booking
CREATE TABLE Booking (
    booking_id UUID PRIMARY KEY,
    property_id UUID NOT NULL, -- Foreign Key
    user_id UUID NOT NULL,     -- Foreign Key (user who made the booking)
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (property_id) REFERENCES Property(property_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Indexes for Booking table
CREATE INDEX idx_booking_property_id ON Booking (property_id); -- Speeds up joins to Property table
CREATE INDEX idx_booking_user_id ON Booking (user_id);       -- Speeds up joins to Users table
CREATE INDEX idx_booking_dates ON Booking (start_date, end_date); -- For date range queries (composite index)
CREATE INDEX idx_booking_status ON Booking (status);         -- For filtering bookings by status

-- Table: Payment
CREATE TABLE Payment (
    payment_id UUID PRIMARY KEY,
    booking_id UUID NOT NULL, -- Foreign Key
    amount DECIMAL(10, 2) NOT NULL,
    payment_method ENUM('credit_card', 'paypal', 'stripe') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

-- Indexes for Payment table
CREATE INDEX idx_payment_booking_id ON Payment (booking_id); -- Speeds up joins to Booking table

-- Table: Review
CREATE TABLE Review (
    review_id UUID PRIMARY KEY,
    property_id UUID NOT NULL, -- Foreign Key
    user_id UUID NOT NULL,     -- Foreign Key (user who wrote the review)
    rating DECIMAL(2, 1) NOT NULL CHECK (rating >= 1.0 AND rating <= 5.0),
    comment TEXT, -- TEXT columns generally not indexed directly for full text search (requires special indexes)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (property_id) REFERENCES Property(property_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
    -- Optional: UNIQUE (property_id, user_id) if a user can only review a property once
);

-- Indexes for Review table
CREATE INDEX idx_review_property_id ON Review (property_id); -- Speeds up joins to Property table
CREATE INDEX idx_review_user_id ON Review (user_id);       -- Speeds up joins to Users table
CREATE INDEX idx_review_rating ON Review (rating);         -- For filtering/sorting by rating

-- Table: Message
CREATE TABLE Message (
    message_id UUID PRIMARY KEY,
    sender_id UUID NOT NULL,   -- Foreign Key
    recipient_id UUID NOT NULL, -- Foreign Key
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (sender_id) REFERENCES Users(user_id),
    FOREIGN KEY (recipient_id) REFERENCES Users(user_id)
);

-- Indexes for Message table
CREATE INDEX idx_message_sender_id ON Message (sender_id);     -- Speeds up finding messages sent by a user
CREATE INDEX idx_message_recipient_id ON Message (recipient_id); -- Speeds up finding messages received by a user
CREATE INDEX idx_message_sent_at ON Message (sent_at);         -- For ordering messages in a conversation
CREATE INDEX idx_message_conversation ON Message (sender_id, recipient_id, sent_at); -- For specific conversation threads
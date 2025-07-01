# Database Specification - AirBnb

## Introduction

This document outlines the database schema design for an AirBnB-like application. It details the entities, their attributes, and the relationships between them, providing a foundational blueprint for the application's data storage.

## Entities and Attributes

This section describes each core entity (table) in the database and its corresponding attributes (columns), including data types, constraints, and special properties.

### User

-   **`user_id`**: Primary Key, UUID, Indexed
-   **`first_name`**: VARCHAR, NOT NULL
-   **`last_name`**: VARCHAR, NOT NULL
-   **`email`**: VARCHAR, UNIQUE, NOT NULL
-   **`password_hash`**: VARCHAR, NOT NULL
-   **`phone_number`**: VARCHAR, NULL
-   **`role`**: ENUM (`guest`, `host`, `admin`), NOT NULL
-   **`created_at`**: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

### Property

-   **`property_id`**: Primary Key, UUID, Indexed
-   **`host_id`**: Foreign Key, references `User(user_id)`
-   **`name`**: VARCHAR, NOT NULL
-   **`description`**: TEXT, NOT NULL
-   **`location`**: VARCHAR, NOT NULL
-   **`price_per_night`**: DECIMAL, NOT NULL  *(Suggested change for consistency: `price_per_night` instead of `pricepernight`)*
-   **`created_at`**: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP
-   **`updated_at`**: TIMESTAMP, ON UPDATE CURRENT_TIMESTAMP

### Booking *(Note: You had this section twice. I've kept one.)*

-   **`booking_id`**: Primary Key, UUID, Indexed
-   **`property_id`**: Foreign Key, references `Property(property_id)`
-   **`user_id`**: Foreign Key, references `User(user_id)`
-   **`start_date`**: DATE, NOT NULL
-   **`end_date`**: DATE, NOT NULL
-   **`total_price`**: DECIMAL, NOT NULL
-   **`status`**: ENUM (`pending`, `confirmed`, `canceled`), NOT NULL
-   **`created_at`**: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

### Payment

-   **`payment_id`**: Primary Key, UUID, Indexed
-   **`booking_id`**: Foreign Key, references `Booking(booking_id)`
-   **`amount`**: DECIMAL, NOT NULL
-   **`payment_date`**: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP
-   **`payment_method`**: ENUM (`credit_card`, `paypal`, `stripe`), NOT NULL

### Review

-   **`review_id`**: Primary Key, UUID, Indexed
-   **`property_id`**: Foreign Key, references `Property(property_id)`
-   **`user_id`**: Foreign Key, references `User(user_id)`
-   **`rating`**: INTEGER, CHECK: `rating >= 1 AND rating <= 5`, NOT NULL
-   **`comment`**: TEXT, NOT NULL
-   **`created_at`**: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

### Message

-   **`message_id`**: Primary Key, UUID, Indexed
-   **`sender_id`**: Foreign Key, references `User(user_id)`
-   **`recipient_id`**: Foreign Key, references `User(user_id)`
-   **`message_body`**: TEXT, NOT NULL
-   **`sent_at`**: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

## Visual Representation

Below is a visual diagram illustrating the entities and their relationships within the database schema.

![AirBnB Database Diagram](https://github.com/user-attachments/assets/03b648a1-bcf4-432a-bfd1-3690bd3a903e)

## Relationship Overview

This section details the relationships between the different entities, explaining the purpose of each entity and how they connect to form the complete database structure.

### 1. User Entity

-   **Purpose**: Stores information about all users of the platform, who can act as either guests, hosts, or administrators.
-   **Key Attributes**: `user_id` (Primary Key, unique identifier), `email` (unique, for login), `first_name`, `last_name`, `password_hash`, `phone_number`, `role` (defines user type).

### 2. Property Entity

-   **Purpose**: Stores details about properties available for rent.
-   **Key Attributes**: `property_id` (Primary Key, unique identifier), `name`, `description`, `location`, `price_per_night`.
-   **Relationship with User (Host)**:
    -   **Type**: One-to-Many (1:M)
    -   **Description**: An individual User (specifically, one with a 'host' role) can list many Properties. Each Property is hosted by one specific User.
    -   **Implementation**: `Property.host_id` (Foreign Key) references `User.user_id`.

### 3. Booking Entity

-   **Purpose**: Records each instance of a user booking a specific property for a period. This acts as a crucial junction table.
-   **Key Attributes**: `booking_id` (Primary Key), `start_date`, `end_date`, `total_price`, `status` (pending, confirmed, canceled).
-   **Relationships**:
    -   **User (Booker) to Booking**:
        -   **Type**: One-to-Many (1:M)
        -   **Description**: A User can make many Bookings. Each Booking is made by one specific User.
        -   **Implementation**: `Booking.user_id` (Foreign Key) references `User.user_id`.
    -   **Property to Booking**:
        -   **Type**: One-to-Many (1:M)
        -   **Description**: A Property can have many Bookings (over different dates). Each Booking is for one specific Property.
        -   **Implementation**: `Booking.property_id` (Foreign Key) references `Property.property_id`.

### 4. Payment Entity

-   **Purpose**: Stores details about payments made for bookings.
-   **Key Attributes**: `payment_id` (Primary Key), `amount`, `payment_method`.
-   **Relationship with Booking**:
    -   **Type**: One-to-Many (1:M)
    -   **Description**: A Booking can be associated with many Payments (e.g., for installments), or at least one. Each Payment is for one specific Booking.
    -   **Implementation**: `Payment.booking_id` (Foreign Key) references `Booking.booking_id`.

### 5. Review Entity

-   **Purpose**: Stores user-generated reviews for properties.
-   **Key Attributes**: `review_id` (Primary Key), `rating` (a numerical score), `comment`.
-   **Relationships**:
    -   **User (Reviewer) to Review**:
        -   **Type**: One-to-Many (1:M)
        -   **Description**: A User can write many Reviews. Each Review is written by one specific User.
        -   **Implementation**: `Review.user_id` (Foreign Key) references `User.user_id`.
    -   **Property to Review**:
        -   **Type**: One-to-Many (1:M)
        -   **Description**: A Property can receive many Reviews. Each Review is for one specific Property.
        -   **Implementation**: `Review.property_id` (Foreign Key) references `Property.property_id`.

### 6. Message Entity

-   **Purpose**: Stores records of direct messages exchanged between users.
-   **Key Attributes**: `message_id` (Primary Key), `message_body`, `sent_at`.
-   **Relationships**:
    -   **User (Sender) to Message**:
        -   **Type**: One-to-Many (1:M)
        -   **Description**: A User can be the sender of many Messages. Each Message has one sender.
        -   **Implementation**: `Message.sender_id` (Foreign Key) references `User.user_id`.
    -   **User (Recipient) to Message**:
        -   **Type**: One-to-Many (1:M)
        -   **Description**: A User can be the recipient of many Messages. Each Message has one recipient.
        -   **Implementation**: `Message.recipient_id` (Foreign Key) references `User.user_id`.

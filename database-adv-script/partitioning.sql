-- 1. Drop the existing Booking table if it exists
DROP TABLE IF EXISTS Booking CASCADE;

-- 2. Create the main partitioned Booking table
--    This table itself will not store data directly, but acts as a container for partitions.
CREATE TABLE Booking (
    booking_id UUID NOT NULL,
    user_id UUID NOT NULL,
    property_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (booking_id, start_date)
) PARTITION BY RANGE (start_date);

--    Each partition defines a specific range for the start_date column.
-- Partition for bookings in 2023
CREATE TABLE booking_2023 PARTITION OF Booking
FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

-- Partition for bookings in 2024
CREATE TABLE booking_2024 PARTITION OF Booking
FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

-- Partition for bookings in 2025
CREATE TABLE booking_2025 PARTITION OF Booking
FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

-- 4. Add Foreign Key Constraints to the main partitioned table
--    (These will implicitly apply to all child partitions)
ALTER TABLE Booking ADD CONSTRAINT fk_user
FOREIGN KEY (user_id) REFERENCES Users (user_id);

ALTER TABLE Booking ADD CONSTRAINT fk_property
FOREIGN KEY (property_id) REFERENCES Property (property_id);

-- Insert some sample data into the partitioned table
--    Rows will automatically be directed to the correct partition based on start_date.
INSERT INTO Booking (booking_id, user_id, property_id, start_date, end_date, status, total_price, created_at) VALUES
('00000000-0000-0000-0000-0000000000xa', '00000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-00000000000a', '2023-01-10', '2023-01-15', 'confirmed', 150.00, '2022-12-01'),
('00000000-0000-0000-0000-0000000000xb', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-00000000000b', '2024-03-01', '2024-03-05', 'pending', 200.00, '2024-02-01'),
('00000000-0000-0000-0000-0000000000xc', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-00000000000b', '2023-02-20', '2023-02-25', 'confirmed', 75.50, '2023-01-10'),
('00000000-0000-0000-0000-0000000000xb', '00000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-00000000000a', '2025-06-15', '2025-06-20', 'confirmed', 300.00, '2025-05-01'),
('00000000-0000-0000-0000-0000000000xd', '00000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-00000000000b', '2024-07-01', '2024-07-07', 'cancelled', 120.00, '2024-06-01'),
('00000000-0000-0000-0000-0000000000xf', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-00000000000a', '2023-11-10', '2023-11-15', 'pending', 50.00, '2023-10-01'), -- User ID 5 might not exist
('00000000-0000-0000-0000-0000000000xk', '00000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-00000000000a', '2025-01-20', '2025-01-25', 'confirmed', 100.00, '2024-12-01');

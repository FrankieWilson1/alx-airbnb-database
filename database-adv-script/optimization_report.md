# Query Performance Analysis and Refactoring Guide

## Objective

This guide outlines the process of identifying performance bottlenecks in a complex SQL query and refactoring it to improve execution time. We will use the `EXPLAIN` command to analyze the query plan before and after optimization.

## Initial Complex Query

The initial query aims to retrieve all bookings along with their associated user details, property details, and payment details. This requires joining four tables: `Booking`, `Users`, `Property`, and `Payment`.

**Query saved as `performance.sql` (Initial Version):**

```sql
-- Initial Complex Query for Performance Analysis

SELECT
    B.booking_id,
    B.property_id,
    B.status,
    B.start_date,
    B.end_date, -- Corrected from B.start_date, B.start_date in previous input
    B.created_at,
    B.total_price,
    U.user_id,
    U.first_name,
    U.last_name,
    U.phone_number,
    U.roles,
    U.email,
    P.property_id,
    P.name AS property_name,
    P.location AS property_location,
    P.description,
    P.created_at,
    P.pricepernight,
    Py.payment_id,
    Py.booking_id,
    Py.amount AS payment_amount,
    Py.created_at AS payment_date, -- Assuming 'created_at' in Payments table is the payment date
    Py.payment_method
FROM
    Booking B
INNER JOIN
    User U ON B.user_id = U.user_id
INNER JOIN
    Property P ON B.property_id = P.property_id
INNER JOIN
    Payment Py ON B.booking_id = Py.booking_id;
```

## Analysis of Initial Query's `EXPLAIN` Output
To analyze the qeury's performance, I used the `EXPLAIN ANALYZE` command.

```SQL
EXPLAIN ANALYZE -- Use EXPLAIN for MySQL
SELECT
    -- ... (My initial query from above)
FROM
    Booking B
INNER JOIN
    Users U ON B.user_id = U.user_id
INNER JOIN
    Property P ON B.property_id = P.property_id
INNER JOIN
    Payment Py ON B.booking_id = Py.booking_id;
```

** Observed `EXPLAIN ANALYZE` Output:
```
"Hash Join  (cost=17.85..40.55 rows=920 width=1728)"
"  Hash Cond: (py.booking_id = b.booking_id)"
"  ->  Seq Scan on payment py  (cost=0.00..19.20 rows=920 width=60)"  <-- Identified Bottleneck
"  ->  Hash  (cost=17.83..17.83 rows=1 width=1664)"
"        ->  Nested Loop  (cost=0.29..17.83 rows=1 width=1664)"
"              ->  Nested Loop  (cost=0.14..9.56 rows=1 width=1156)"
"                    ->  Seq Scan on booking b  (cost=0.00..1.01 rows=1 width=80)"
"                    ->  Index Scan using users_pkey on users u  (cost=0.14..8.16 rows=1 width=1092)"
"                          Index Cond: (user_id = b.user_id)"
"              ->  Index Scan using property_pkey on property p  (cost=0.14..8.16 rows=1 width=508)"
"                    Index Cond: (property_id = b.property_id)"
```
### Identification of Inefficiencies:

By analyzing the `EXPLAIN` plan (reading from the innermost operations upwards):

* **`Seq Scan on payment py` (cost=0.00..19.20 rows=920 width=60):** This is the **primary bottleneck**. A "Sequential Scan" (full table scan) on the `Payment` table indicates that the database is reading every single row of the `Payment` table to find matches for the join condition (`py.booking_id = b.booking_id`). With 920 rows in the `Payment` table (and potentially many more in a production environment), this operation is highly inefficient. It strongly suggests a missing index on the `payment.booking_id` column.

* **`Seq Scan on booking b` (cost=0.00..1.01 rows=1 width=80):** While also a sequential scan, the `rows=1` indicates that your `Booking` table is very small in this test environment. For such a small table, a full scan might be deemed efficient by the optimizer. However, if `Booking` were a large table, this would also be an inefficiency, suggesting a need for an index on `booking_id` (if it's not a primary key) or on columns used in potential `WHERE` clauses for this table.

* **`Hash Join` (final operation):** While `Hash Join` can be efficient for large joins, its performance is severely hampered if one of its inputs (in this case, the `Payment` table) requires a full table scan.

**Conclusion:** The most critical area for optimization is the `Payment` table's access method, which is currently performing a full table scan for every join operation.

### Refactoring Strategy and Proposed Changes

The core strategy for optimizing this query focuses on addressing the identified `Sequential Scan` inefficiency by introducing appropriate indexing.

#### Primary Optimization: Add Missing Index

The most impactful change is to create an index on the `booking_id` column of the `Payment` table. This column is used directly in the `INNER JOIN` condition (`Py ON B.booking_id = Py.booking_id`), making it a critical candidate for indexing.


### New index to be added
```
CREATE INDEX idx_payment_booking_id ON Payment (booking_id);

```
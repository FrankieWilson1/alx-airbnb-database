# Database Schema Script (`schema.sql`)

This directory contains `schema.sql`, a SQL script that defines the complete database structure for the alx-AirBnB-like application.

## Purpose

The `schema.sql` script is responsible for:
* Creating all necessary tables (`Users`, `Property`, `Booking`, `Payment`, `Review`, `Message`).
* Defining their respective columns, data types, and constraints (Primary Keys, Foreign Keys, NOT NULL, UNIQUE, CHECK).
* Establishing relationships between tables to ensure data integrity.
* Setting up indexes to optimize common query patterns and improve database performance.
* Including specific configurations for UUID generation and `updated_at` timestamps (for PostgreSQL).

## Schema Overview

For a detailed breakdown of each table, its columns, and relationships, please refer directly to the comments within the `schema.sql` file.
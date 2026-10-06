CREATE DATABASE restaurant_db;

USE restaurant_db;

CREATE TABLE Restaurant (
    restaurant_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(200) NOT NULL,
    phone VARCHAR(30)
);

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(30)
);

CREATE TABLE RestaurantTable (
    table_id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_id INT NOT NULL,
    table_number INT NOT NULL,
    capacity INT NOT NULL,

    FOREIGN KEY (restaurant_id)
        REFERENCES Restaurant(restaurant_id),

    UNIQUE (restaurant_id, table_number)
);

CREATE TABLE Booking (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    table_id INT NOT NULL,
    booking_date DATE NOT NULL,
    booking_time TIME NOT NULL,
    number_of_guests INT NOT NULL,

    FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id),

    FOREIGN KEY (table_id)
        REFERENCES RestaurantTable(table_id)
);

-- ============================================
-- TEST DATA
-- ============================================

-- Restaurant
INSERT INTO Restaurant
(name, address, phone)
VALUES
('Bella Italia', 'Main Street 10, Aarhus', '+45 12345678');


-- Customers
INSERT INTO Customer
(first_name, last_name, email, phone)
VALUES
('John', 'Smith', 'john.smith@example.com', '+45 11111111'),
('Emma', 'Johnson', 'emma.johnson@example.com', '+45 22222222'),
('Michael', 'Brown', 'michael.brown@example.com', '+45 33333333'),
('Sophie', 'Williams', 'sophie.williams@example.com', '+45 44444444'),
('Oliver', 'Jones', 'oliver.jones@example.com', '+45 55555555');


-- Restaurant tables
INSERT INTO RestaurantTable
(restaurant_id, table_number, capacity)
VALUES
(1, 1, 2),
(1, 2, 2),
(1, 3, 4),
(1, 4, 4),
(1, 5, 6),
(1, 6, 6),
(1, 7, 8);


-- Bookings
INSERT INTO Booking
(customer_id, table_id, booking_date, booking_time, number_of_guests)
VALUES
(1, 3, '2026-10-10', '18:00:00', 4),
(1, 5, '2026-10-15', '19:00:00', 5),
(2, 1, '2026-10-11', '17:30:00', 2),
(2, 4, '2026-10-18', '20:00:00', 4),
(3, 2, '2026-10-12', '18:30:00', 2),
(4, 6, '2026-10-15', '19:30:00', 6),
(5, 7, '2026-10-20', '20:00:00', 7),
(3, 3, '2026-10-22', '18:00:00', 3);

-- ============================================
-- QUERY 1
-- Get a list of all tables in the restaurant
-- ============================================

SELECT
    table_id,
    table_number,
    capacity
FROM RestaurantTable
ORDER BY table_number;

-- ============================================
-- QUERY 2
-- Get all bookings for a given customer
-- ordered by date
-- ============================================

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    b.booking_id,
    b.booking_date,
    b.booking_time,
    rt.table_number,
    b.number_of_guests
FROM Booking b
JOIN Customer c
    ON b.customer_id = c.customer_id
JOIN RestaurantTable rt
    ON b.table_id = rt.table_id
WHERE b.customer_id = 1
ORDER BY b.booking_date, b.booking_time;

-- ============================================
-- QUERY 3
-- Get all bookings for a given table
-- including customer information
-- for a specific date
-- ============================================

SELECT
    b.booking_id,
    rt.table_number,
    b.booking_date,
    b.booking_time,
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.phone,
    b.number_of_guests
FROM Booking b
JOIN Customer c
    ON b.customer_id = c.customer_id
JOIN RestaurantTable rt
    ON b.table_id = rt.table_id
WHERE b.table_id = 3
  AND b.booking_date = '2026-10-10'
ORDER BY b.booking_time;
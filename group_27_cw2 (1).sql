 -- Creating the database tables

 -- Table for each car
CREATE TABLE cars (
    car_id SERIAL PRIMARY KEY,
    car_registration VARCHAR(10) UNIQUE NOT NULL,
    car_make VARCHAR(50) NOT NULL,
    car_model VARCHAR(50) NOT NULL,
    car_colour VARCHAR(15)
);

-- Table for each customer
CREATE TABLE customers (
    cust_id SERIAL PRIMARY KEY,
    cust_first_name VARCHAR(100) NOT NULL,
    cust_last_name VARCHAR(100) NOT NULL,
    cust_addr1 VARCHAR(150) NOT NULL,
    cust_addr2 VARCHAR(150),
    cust_city VARCHAR(100) NOT NULL,
    cust_postcode VARCHAR(20) NOT NULL,
    cust_number VARCHAR(15) NOT NULL UNIQUE,
    cust_home_number VARCHAR(15),
    cust_email VARCHAR(150) UNIQUE
);

-- Table for each department within the company
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL
);

-- Table for each staff member within the company
CREATE TABLE staff (
    staff_id SERIAL PRIMARY KEY,
    department_id INT NOT NULL,
    manager BOOL NOT NULL,
    staff_first_name VARCHAR(100) NOT NULL,
    staff_last_name VARCHAR(100) NOT NULL,
    staff_phone_number VARCHAR(15) NOT NULL UNIQUE,
    staff_email VARCHAR(150) UNIQUE,
    staff_addr1 VARCHAR(150) NOT NULL,
    staff_addr2 VARCHAR(150),
    staff_city VARCHAR(50) NOT NULL,
    staff_postcode VARCHAR(20) NOT NULL,

    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Table for each service type offered by the company
CREATE TABLE service_type (
    service_type_id SERIAL PRIMARY KEY,
    service_name VARCHAR(50) NOT NULL
);

-- Table for each service provided to a car
CREATE TABLE service_car (
    service_id SERIAL PRIMARY KEY,
    car_id INT NOT NULL,
    service_type_id INT NOT NULL,
    service_date DATE NOT NULL,
    service_time TIME NOT NULL,
    service_cost DECIMAL(8,2) NOT NULL,
    service_started BOOL NOT NULL,
    service_completed BOOL NOT NULL,
    service_notes VARCHAR(200),

    FOREIGN KEY (car_id) REFERENCES cars(car_id),
    FOREIGN KEY (service_type_id) REFERENCES service_type(service_type_id)
);

-- Table for what services a staff member is able to perform
CREATE TABLE staff_ability (
    staff_id INT NOT NULL,
    service_type_id INT NOT NULL,
    
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
    FOREIGN KEY (service_type_id) REFERENCES service_type(service_type_id)
);

-- Table for what services a staff member is assigned
CREATE TABLE staff_service (
    staff_id INT NOT NULL,
    service_id INT NOT NULL,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
    FOREIGN KEY (service_id) REFERENCES service_car(service_id)
);

-- Table for appointments made by customers
CREATE TABLE appointments(
    appointment_id SERIAL PRIMARY KEY,
    service_id INT NOT NULL,
    data_n_time DATE NOT NULL,

    FOREIGN KEY (service_id) REFERENCES service_car(service_id)
);

-- Table for customer reviews of appointments
CREATE TABLE cust_review (
    review_id SERIAL PRIMARY KEY,
    cust_id INT NOT NULL,
    appointment_id INT NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment VARCHAR(200),

    FOREIGN KEY (cust_id) REFERENCES customers(cust_id),
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);

-- Table for payment methods accepted by the company
CREATE TABLE payment_methods(
    payment_type_id SERIAL PRIMARY KEY,
    payment_type_name VARCHAR(50) NOT NULL
);

-- Table for payments made by customers
CREATE TABLE payments(
    payment_id SERIAL PRIMARY KEY,
    service_id INT NOT NULL,
    payment_type_id INT NOT NULL,
    cust_id INT NOT NULL,
    amount_paid DECIMAL(8,2) NOT NULL,
    account_number VARCHAR(20),
    sort_code VARCHAR(20),
    reference VARCHAR(30),

    FOREIGN KEY (service_id) REFERENCES service_car(service_id),
    FOREIGN KEY (cust_id) REFERENCES customers(cust_id),
    FOREIGN KEY (payment_type_id) REFERENCES payment_methods(payment_type_id)
);

-- Intersection table between customers and cars. Each customer can have multiple cars
-- and each car can be owned by multiple customers
CREATE TABLE cust_car(
    cust_id INT NOT NULL,
    car_id INT NOT NULL,

    FOREIGN KEY (cust_id) REFERENCES customers(cust_id),
    FOREIGN KEY (car_id) REFERENCES cars(car_id)
);

-- Inserting data into the tables
INSERT INTO cars (car_registration, car_make, car_model, car_colour)
VALUES
('ABC123', 'Toyota', 'Corolla', 'Blue'),
('DEF456', 'Honda', 'Civic', 'Silver'),
('GHI789', 'Ford', 'Mustang', 'Red'),
('JKL012', 'Chevrolet', 'Camaro', 'Magenta'),
('MNO345', 'Nissan', 'Altima', 'Orange'),
('PQR678', 'BMW', 'X5', 'Silver'),
('STU901', 'Audi', 'A4', 'Red'),
('VWX234', 'Mercedes-Benz', 'C-Class', 'Yellow'),
('YZA567', 'Tesla', 'Model 3', 'White'),
('BCD890', 'Hyundai', 'Elantra', 'White');

INSERT INTO customers (cust_first_name, cust_last_name, cust_addr1, cust_addr2, cust_city, cust_postcode, cust_number, cust_home_number, cust_email)
VALUES
('John', 'Doe', '123 Main St', 'Apt 4', 'New York', '10001', '1234567890', NULL, 'john.doe@example.com'),
('Jane', 'Smith', '456 Elm St', NULL, 'Los Angeles', '90001', '2345678901', '1234567890', 'jane.smith@example.com'),
('Alice', 'Johnson', '789 Oak St', 'Suite 12', 'Chicago', '60601', '3456789012', NULL, 'alice.johnson@example.com'),
('Bob', 'Brown', '321 Pine St', NULL, 'Houston', '77001', '4567890123', '2345678901', 'bob.brown@example.com'),
('Charlie', 'Davis', '654 Maple St', 'Apt 7', 'Phoenix', '85001', '5678901234', NULL, 'charlie.davis@example.com'),
('Eve', 'Wilson', '987 Cedar St', NULL, 'Philadelphia', '19019', '6789012345', '3456789012', 'eve.wilson@example.com'),
('Frank', 'Moore', '159 Birch St', 'Unit 3', 'San Antonio', '78201', '7890123456', NULL, 'frank.moore@example.com'),
('Grace', 'Taylor', '753 Walnut St', NULL, 'San Diego', '92101', '8901234567', '4567890123', 'grace.taylor@example.com'),
('Henry', 'Anderson', '852 Cherry St', 'Apt 9', 'Dallas', '75201', '9012345678', NULL, 'henry.anderson@example.com'),
( 'Ivy', 'Thomas', '456 Spruce St', NULL, 'San Jose', '95101', '0123456789', '5678901234', 'ivy.thomas@example.com');

INSERT INTO departments (department_name)
VALUES
('Sales'),
('Customer Service'),
('Maintenance'),
('Finance'),
('Human Resources'),
('IT'),
('Marketing'),
('Operations'),
('Quality Assurance'),
('Research and Development');

INSERT INTO payment_methods (payment_type_name)
VALUES
('Credit Card'),
('Debit Card'),
('Cash'),
('Bank Transfer'),
('PayPal'),
('Apple Pay'),
('Google Pay'),
('Cheque'),
('Cryptocurrency'),
('Direct Debit');

INSERT INTO service_type(service_name)
VALUES
('Oil Change'),
('MOT'),
('Brakes'),
('Steering Alignment'),
('Tyre Rotation'),
('Tyres'),
('Battery Replacement'),
('Yearly'),
('Suspension'),
('Light Replacement');

INSERT INTO staff (department_id, manager, staff_first_name, staff_last_name, staff_phone_number, staff_email, staff_addr1, staff_addr2, staff_city, staff_postcode)
VALUES
(1, true, 'John', 'Doe', '1234567890', 'john.doe@example.com', '123 Main St', 'Apt 4', 'New York', '10001'),
(2, false, 'Jane', 'Smith', '2345678901', 'jane.smith@example.com', '456 Elm St', NULL, 'Los Angeles', '90001'),
(2, true, 'Alice', 'Johnson', '3456789012', 'alice.johnson@example.com', '789 Oak St', 'Suite 12', 'Chicago', '60601'),
(3, false, 'Bob', 'Brown', '4567890123', 'bob.brown@example.com', '321 Pine St', NULL, 'Houston', '77001'),
(1, false, 'Charlie', 'Davis', '5678901234', 'charlie.davis@example.com', '654 Maple St', 'Apt 7', 'Phoenix', '85001'),
(6, true, 'Eve', 'Wilson', '6789012345', 'eve.wilson@example.com', '987 Cedar St', NULL, 'Philadelphia', '19019'),
(6, false, 'Frank', 'Moore', '7890123456', 'frank.moore@example.com', '159 Birch St', 'Unit 3', 'San Antonio', '78201'),
(8, false, 'Grace', 'Taylor', '8901234567', 'grace.taylor@example.com', '753 Walnut St', NULL, 'San Diego', '92101'),
(5, true, 'Henry', 'Anderson', '9012345678', 'henry.anderson@example.com', '852 Cherry St', 'Apt 9', 'Dallas', '75201'),
(4, false, 'Ivy', 'Thomas', '0123456789', 'ivy.thomas@example.com', '456 Spruce St', NULL, 'San Jose', '95101');

INSERT INTO cust_car (cust_id, car_id)
VALUES
(1, 5),
(2, 4),
(2, 9),
(3, 2),
(4, 1),
(5, 3),
(6, 6),
(6, 7),
(7, 8);

INSERT INTO service_car (car_id, service_type_id, service_date, service_time, service_cost, service_started, service_completed, service_notes)
VALUES
(1, 1, '2023-10-01', '09:00:00', 50.00, true, true, 'Regular maintenance'),
(2, 2, '2023-10-02', '10:00:00', 30.00, true, false, 'Tire rotation needed'),
(3, 3, '2023-10-03', '11:00:00', 100.00, false, false, 'Brake pads worn out'),
(4, 4, '2023-10-04', '12:00:00', 200.00, true, true, 'Engine running smoothly'),
(5, 5, '2023-10-05', '13:00:00', 150.00, false, false, 'Battery replaced'),
(6, 6, '2023-10-06', '14:00:00', 300.00, true, false, 'Windshield cracked'),
(7, 7, '2023-10-07', '15:00:00', 500.00, false, false, 'Transmission issue'),
(8, 8, '2023-10-08', '16:00:00', 250.00, true, true, 'AC fixed'),
(9, 9, '2023-10-09', '17:00:00', 400.00, false, false, 'Exhaust system repaired'),
(10, 10, '2023-10-10', '18:00:00', 350.00, true, false, 'Suspension checked');

INSERT INTO appointments (service_id, data_n_time)
VALUES
(1,  '2023-10-01 09:00:00'),
(2,  '2023-10-02 10:00:00'),
(3,  '2023-10-03 11:00:00'),
(4,  '2023-10-04 12:00:00'),
(5,  '2023-10-05 13:00:00'),
(6,  '2023-10-06 14:00:00'),
(7,  '2023-10-07 15:00:00'),
(8,  '2023-10-08 16:00:00'),
(9,  '2023-10-09 17:00:00'),
(10, '2023-10-10 18:00:00');

INSERT INTO cust_review (cust_id, appointment_id, rating, comment)
VALUES
(1, 1, '5', 'Great service!'),
(2, 2, '4', 'Quick and efficient'),
(3, 3, '3', 'Could be better'),
(4, 4, '5', 'Excellent work'),
(5, 5, '2', 'Took too long'),
(6, 6, '5', 'Very professional'),
(7, 7, '4', 'Good experience'),
(8, 8, '5', 'Highly recommend'),
(9, 9, '3', 'Average service'),
(10, 10, '4', 'Satisfied with the work');

INSERT INTO payments (service_id, cust_id, payment_type_id, amount_paid, account_number, sort_code, reference)
VALUES
(1, 1, 1, 50.00, '12345678', '12-34-56', 'Oil Change'),
(2, 2, 1,30.00, '23456789', '23-45-67', 'Tire Rotation'),
(3, 3, 2, 100.00, '34567890', '34-56-78', 'Brake Inspection'),
(4, 4, 2, 200.00, '45678901', '45-67-89', 'Engine Tune-Up'),
(5, 5, 4, 150.00, '56789012', '56-78-90', 'Battery Replacement'),
(6, 6, 4, 300.00, '67890123', '67-89-01', 'Windshield Replacement'),
(7, 7, 8, 500.00, '78901234', '78-90-12', 'Transmission Repair'),
(8, 8, 4, 250.00, '89012345', '89-01-23', 'AC Repair'),
(9, 9, 4, 400.00, '90123456', '90-12-34', 'Exhaust System Repair'),
(10, 10, 4, 350.00, '01234567', '01-23-45', 'Suspension Repair');

INSERT INTO staff_ability(staff_id, service_type_id)
VALUES
(1, 1),
(1, 5),
(2, 2),
(2, 3),
(2, 7),
(3, 9),
(4, 6),
(4, 7),
(5, 1),
(5, 3),
(5, 4),
(6, 10),
(6, 8),
(7, 3),
(8, 2),
(9, 9),
(9, 2),
(10, 1);

INSERT INTO staff_service(staff_id, service_id)
VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 2),
(2, 2),
(5, 3),
(6, 3),
(7, 4),
(2, 4),
(2, 5),
(1, 5),
(8, 5),
(9, 6),
(10, 6),
(3, 7),
(6, 8),
(1, 9),
(2, 10);

-- Creating indexes for the tables
CREATE INDEX idx_car_registration ON cars(car_registration);
CREATE INDEX idx_staff_dept ON staff(department_id);
CREATE INDEX idx_staff_last_name ON staff(staff_last_name);
CREATE INDEX idx_service_type ON service_car(service_type_id);
CREATE INDEX idx_service_date ON service_car(service_date);
CREATE INDEX idx_cust_last_name ON customers(cust_last_name);
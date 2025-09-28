-- Sample data for Ice Cream Truck Business
-- Run this after creating the icecream_schema.sql to populate with sample records

-- Insert Ice Cream Trucks
INSERT INTO ice_cream_trucks (truck_name, truck_color, license_plate, driver_name, phone_number, current_location, route_name, capacity_gallons) VALUES
('Sweet Dreams Mobile', 'Pink & White', 'DREAM01', 'Sarah Johnson', '555-ICE-001', 'Central Park', 'Downtown Route', 60),
('Frosty Fun Express', 'Blue & Yellow', 'FROST02', 'Mike Rodriguez', '555-ICE-002', 'University Campus', 'Campus Route', 50),
('Cool Treats Cruiser', 'Rainbow', 'COOL123', 'Emily Chen', '555-ICE-003', 'Riverside Mall', 'Shopping Route', 70),
('Arctic Adventure', 'White & Silver', 'ARTIC4', 'David Wilson', '555-ICE-004', 'Sunset Beach', 'Beach Route', 45);

-- Insert Ice Cream Products
INSERT INTO ice_cream_products (product_name, product_type, flavor, description, price, cost, calories, contains_nuts, contains_dairy, is_sugar_free, seasonal) VALUES
-- Scooped Ice Cream
('Single Scoop Cone', 'scoop', 'Vanilla', 'Classic vanilla ice cream in a waffle cone', 3.50, 1.20, 180, FALSE, TRUE, FALSE, FALSE),
('Double Scoop Cone', 'scoop', 'Chocolate', 'Rich chocolate ice cream, two scoops', 5.50, 2.00, 320, FALSE, TRUE, FALSE, FALSE),
('Triple Berry Scoop', 'scoop', 'Mixed Berry', 'Strawberry, blueberry, and raspberry swirl', 4.25, 1.80, 210, FALSE, TRUE, FALSE, TRUE),
('Mint Chip Delight', 'scoop', 'Mint Chocolate Chip', 'Cool mint with chocolate chips', 4.00, 1.60, 195, FALSE, TRUE, FALSE, FALSE),
('Cookies & Cream', 'scoop', 'Cookies and Cream', 'Vanilla with crushed chocolate cookies', 4.50, 1.90, 240, FALSE, TRUE, FALSE, FALSE),

-- Ice Cream Bars
('Chocolate Fudge Bar', 'bar', 'Chocolate', 'Rich chocolate ice cream with fudge coating', 2.75, 0.95, 160, FALSE, TRUE, FALSE, FALSE),
('Strawberry Fruit Bar', 'bar', 'Strawberry', 'Real fruit ice cream bar', 2.25, 0.80, 120, FALSE, TRUE, FALSE, TRUE),
('Nutty Buddy Bar', 'bar', 'Vanilla', 'Vanilla ice cream with peanut coating', 3.25, 1.10, 200, TRUE, TRUE, FALSE, FALSE),

-- Ice Cream Sandwiches
('Classic Ice Cream Sandwich', 'sandwich', 'Vanilla', 'Vanilla ice cream between chocolate cookies', 3.00, 1.00, 170, FALSE, TRUE, FALSE, FALSE),
('Neapolitan Sandwich', 'sandwich', 'Neapolitan', 'Three flavors in one sandwich', 3.75, 1.30, 190, FALSE, TRUE, FALSE, FALSE),

-- Specialty Items
('Banana Split Sundae', 'sundae', 'Mixed', 'Three scoops with banana, nuts, and toppings', 8.99, 3.50, 450, TRUE, TRUE, FALSE, FALSE),
('Hot Fudge Sundae', 'sundae', 'Vanilla', 'Vanilla ice cream with hot fudge and whipped cream', 5.99, 2.20, 320, FALSE, TRUE, FALSE, FALSE),
('Chocolate Milkshake', 'shake', 'Chocolate', 'Thick chocolate milkshake with whipped cream', 4.75, 1.80, 280, FALSE, TRUE, FALSE, FALSE),
('Strawberry Shake', 'shake', 'Strawberry', 'Fresh strawberry milkshake', 4.75, 1.70, 260, FALSE, TRUE, FALSE, TRUE),

-- Sugar-Free Options
('Sugar-Free Vanilla', 'scoop', 'Vanilla', 'Diabetic-friendly vanilla ice cream', 4.25, 2.00, 140, FALSE, TRUE, TRUE, FALSE),
('Sugar-Free Chocolate', 'scoop', 'Chocolate', 'Rich chocolate without the sugar', 4.25, 2.10, 150, FALSE, TRUE, TRUE, FALSE);

-- Insert Truck Inventory
INSERT INTO truck_inventory (truck_id, product_id, current_stock, max_capacity, reorder_level) VALUES
-- Sweet Dreams Mobile (truck_id = 1)
(1, 1, 45, 60, 15), (1, 2, 30, 40, 10), (1, 3, 25, 35, 8), (1, 6, 20, 30, 8),
(1, 9, 15, 25, 5), (1, 11, 8, 15, 3), (1, 13, 12, 20, 5),

-- Frosty Fun Express (truck_id = 2)
(2, 1, 35, 50, 12), (2, 4, 28, 40, 10), (2, 5, 32, 45, 12), (2, 7, 18, 25, 6),
(2, 10, 10, 20, 4), (2, 14, 15, 25, 6), (2, 15, 8, 15, 4),

-- Cool Treats Cruiser (truck_id = 3)
(3, 2, 40, 55, 15), (3, 3, 30, 40, 10), (3, 6, 25, 35, 8), (3, 8, 22, 30, 8),
(3, 11, 10, 18, 4), (3, 12, 12, 20, 5), (3, 16, 6, 12, 3),

-- Arctic Adventure (truck_id = 4)
(4, 1, 25, 40, 10), (4, 5, 20, 35, 8), (4, 7, 15, 25, 6), (4, 9, 12, 20, 5),
(4, 13, 18, 30, 8), (4, 14, 10, 18, 4);

-- Insert Customers
INSERT INTO ice_cream_customers (first_name, last_name, email, phone_number, birth_date, favorite_flavor, loyalty_points, total_purchases) VALUES
('Emma', 'Watson', 'emma.watson@email.com', '555-1001', '1990-04-15', 'Mint Chocolate Chip', 125, 8),
('Liam', 'Johnson', 'liam.j@email.com', '555-1002', '1985-09-22', 'Chocolate', 250, 15),
('Olivia', 'Brown', 'olivia.brown@email.com', '555-1003', '1992-12-08', 'Strawberry', 75, 5),
('Noah', 'Davis', 'noah.davis@email.com', '555-1004', '1988-06-30', 'Vanilla', 180, 12),
('Sophia', 'Miller', 'sophia.miller@email.com', '555-1005', '1995-03-17', 'Cookies and Cream', 95, 6),
('Jackson', 'Wilson', 'jackson.w@email.com', '555-1006', '1987-11-25', 'Mixed Berry', 320, 20),
('Isabella', 'Moore', 'isabella.moore@email.com', '555-1007', '1993-08-14', 'Chocolate', 45, 3),
('Lucas', 'Taylor', 'lucas.taylor@email.com', '555-1008', '1991-01-28', 'Vanilla', 210, 14);

-- Insert Truck Routes
INSERT INTO truck_routes (truck_id, route_name, day_of_week, start_time, end_time, location_name, location_address, estimated_duration_minutes) VALUES
-- Sweet Dreams Mobile Routes
(1, 'Morning Park Route', 'Monday', '10:00:00', '12:00:00', 'Central Park', '123 Park Avenue', 120),
(1, 'Afternoon School Route', 'Monday', '15:00:00', '17:00:00', 'Elementary School', '456 School St', 120),
(1, 'Morning Park Route', 'Tuesday', '10:00:00', '12:00:00', 'Central Park', '123 Park Avenue', 120),
(1, 'Evening Festival', 'Friday', '18:00:00', '21:00:00', 'Town Square', '789 Main St', 180),

-- Frosty Fun Express Routes
(2, 'Campus Morning', 'Monday', '11:00:00', '14:00:00', 'University Campus', '100 College Ave', 180),
(2, 'Campus Afternoon', 'Tuesday', '11:00:00', '14:00:00', 'University Campus', '100 College Ave', 180),
(2, 'Business District', 'Wednesday', '12:00:00', '15:00:00', 'Downtown Plaza', '200 Business Blvd', 180),

-- Cool Treats Cruiser Routes
(3, 'Mall Circuit', 'Wednesday', '12:00:00', '16:00:00', 'Riverside Mall', '300 Shopping Way', 240),
(3, 'Mall Circuit', 'Thursday', '12:00:00', '16:00:00', 'Riverside Mall', '300 Shopping Way', 240),
(3, 'Weekend Special', 'Saturday', '10:00:00', '18:00:00', 'Festival Grounds', '400 Event Plaza', 480),

-- Arctic Adventure Routes
(4, 'Beach Morning', 'Friday', '10:00:00', '14:00:00', 'Sunset Beach', '500 Ocean Drive', 240),
(4, 'Beach Afternoon', 'Saturday', '14:00:00', '19:00:00', 'Sunset Beach', '500 Ocean Drive', 300),
(4, 'Beach Weekend', 'Sunday', '11:00:00', '18:00:00', 'Sunset Beach', '500 Ocean Drive', 420);

-- Insert Sample Orders
INSERT INTO ice_cream_orders (truck_id, customer_id, order_location, subtotal, tax_amount, total_amount, payment_method, order_status, loyalty_points_earned) VALUES
(1, 1, 'Central Park', 7.50, 0.60, 8.10, 'card', 'completed', 8),
(2, 2, 'University Campus', 12.25, 0.98, 13.23, 'cash', 'completed', 13),
(3, 3, 'Riverside Mall', 5.75, 0.46, 6.21, 'mobile', 'completed', 6),
(1, 4, 'Central Park', 15.99, 1.28, 17.27, 'card', 'completed', 17),
(4, 5, 'Sunset Beach', 8.50, 0.68, 9.18, 'cash', 'completed', 9);

-- Insert Order Items
INSERT INTO ice_cream_order_items (order_id, product_id, quantity, unit_price, item_total) VALUES
-- Order 1: Emma Watson
(1, 4, 2, 4.00, 8.00),

-- Order 2: Liam Johnson
(2, 2, 1, 5.50, 5.50),
(2, 6, 2, 2.75, 5.50),
(2, 13, 1, 4.75, 4.75),

-- Order 3: Olivia Brown
(3, 7, 2, 2.25, 4.50),
(3, 1, 1, 3.50, 3.50),

-- Order 4: Noah Davis
(4, 11, 1, 8.99, 8.99),
(4, 12, 1, 5.99, 5.99),
(4, 1, 2, 3.50, 7.00),

-- Order 5: Sophia Miller
(5, 5, 1, 4.50, 4.50),
(5, 9, 1, 3.00, 3.00),
(5, 1, 1, 3.50, 3.50);

-- Insert Sample Reviews
INSERT INTO ice_cream_reviews (truck_id, product_id, customer_id, order_id, rating, review_title, review_text, is_verified) VALUES
(1, 4, 1, 1, 5, 'Perfect Mint Chip!', 'The mint chocolate chip was absolutely perfect - not too sweet and great chunks of chocolate. Driver was super friendly too!', TRUE),
(2, 2, 2, 2, 4, 'Good but pricey', 'Double scoop was delicious but I think it is a bit overpriced for the portion size.', TRUE),
(3, 7, 3, 3, 5, 'Amazing strawberry bars', 'These taste like real strawberries, not artificial flavor. Will definitely order again!', TRUE),
(1, 11, 4, 4, 5, 'Best banana split ever!', 'Huge portion and everything was fresh. The hot fudge was the perfect temperature.', TRUE),
(4, 5, 5, 5, 4, 'Great cookies and cream', 'Really good flavor, lots of cookie pieces. Truck was easy to find at the beach.', TRUE);

-- Insert Daily Sales Summary
INSERT INTO daily_sales (sale_date, truck_id, total_orders, total_revenue, total_costs, weather_condition, temperature_f) VALUES
('2024-09-20', 1, 15, 187.50, 75.00, 'Sunny', 78),
('2024-09-20', 2, 22, 264.80, 105.60, 'Sunny', 78),
('2024-09-20', 3, 18, 201.75, 80.70, 'Partly Cloudy', 75),
('2024-09-20', 4, 12, 142.40, 56.96, 'Sunny', 82),
('2024-09-21', 1, 18, 223.20, 89.28, 'Sunny', 80),
('2024-09-21', 2, 25, 312.50, 125.00, 'Sunny', 80),
('2024-09-21', 3, 20, 245.00, 98.00, 'Sunny', 81),
('2024-09-21', 4, 16, 192.60, 77.04, 'Sunny', 85);
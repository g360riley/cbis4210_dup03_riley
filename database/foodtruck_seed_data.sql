-- Sample data for Food Truck Management System
-- Run this after creating the foodtruck_schema.sql to populate with sample records

-- Insert Food Trucks
INSERT INTO food_trucks (truck_name, cuisine_type, location, phone_number, license_plate, owner_name, operating_hours) VALUES
('Taco Libre', 'Mexican', 'Downtown Plaza', '555-0101', 'TACO123', 'Maria Rodriguez', 'Mon-Fri: 11am-3pm, 5pm-9pm'),
('Burger Boulevard', 'American', 'University Campus', '555-0102', 'BURG456', 'Mike Johnson', 'Mon-Sun: 11am-9pm'),
('Noodle Nirvana', 'Asian Fusion', 'Business District', '555-0103', 'NOOD789', 'David Chen', 'Tue-Sat: 12pm-8pm'),
('Pizza Paradise', 'Italian', 'Park Avenue', '555-0104', 'PIZZ321', 'Antonio Rossi', 'Wed-Sun: 4pm-10pm'),
('BBQ Boss', 'BBQ', 'Sports Complex', '555-0105', 'BBQU654', 'Jake Williams', 'Thu-Sun: 12pm-9pm');

-- Insert Customers
INSERT INTO customers (first_name, last_name, email, phone_number) VALUES
('Sarah', 'Thompson', 'sarah.t@email.com', '555-1001'),
('Michael', 'Davis', 'mike.davis@email.com', '555-1002'),
('Jessica', 'Wilson', 'j.wilson@email.com', '555-1003'),
('Robert', 'Brown', 'rob.brown@email.com', '555-1004'),
('Emily', 'Garcia', 'emily.g@email.com', '555-1005'),
('James', 'Miller', 'james.miller@email.com', '555-1006'),
('Ashley', 'Jones', 'ashley.jones@email.com', '555-1007'),
('Daniel', 'Martinez', 'dan.martinez@email.com', '555-1008');

-- Insert Menu Items for Taco Libre (truck_id = 1)
INSERT INTO menu_items (truck_id, item_name, description, price, category, prep_time_minutes) VALUES
(1, 'Carnitas Tacos', 'Slow-cooked pork with onions and cilantro (3 tacos)', 12.99, 'Tacos', 5),
(1, 'Chicken Burrito', 'Grilled chicken with rice, beans, and fresh salsa', 9.99, 'Burritos', 8),
(1, 'Veggie Quesadilla', 'Cheese and grilled vegetables in flour tortilla', 8.50, 'Quesadillas', 6),
(1, 'Guac and Chips', 'Fresh guacamole with tortilla chips', 6.99, 'Sides', 3),
(1, 'Horchata', 'Traditional rice and cinnamon drink', 3.50, 'Beverages', 2);

-- Insert Menu Items for Burger Boulevard (truck_id = 2)
INSERT INTO menu_items (truck_id, item_name, description, price, category, prep_time_minutes) VALUES
(2, 'Classic Cheeseburger', 'Beef patty with cheese, lettuce, tomato, onion', 11.99, 'Burgers', 10),
(2, 'BBQ Bacon Burger', 'Beef patty with BBQ sauce, bacon, and onion rings', 13.99, 'Burgers', 12),
(2, 'Crispy Chicken Sandwich', 'Fried chicken breast with pickles and mayo', 10.99, 'Sandwiches', 8),
(2, 'Sweet Potato Fries', 'Crispy sweet potato fries with aioli', 5.99, 'Sides', 7),
(2, 'Chocolate Milkshake', 'Rich chocolate milkshake with whipped cream', 4.99, 'Beverages', 4);

-- Insert Menu Items for Noodle Nirvana (truck_id = 3)
INSERT INTO menu_items (truck_id, item_name, description, price, category, prep_time_minutes) VALUES
(3, 'Pad Thai', 'Stir-fried rice noodles with tamarind sauce and peanuts', 10.99, 'Noodles', 8),
(3, 'Ramen Bowl', 'Rich pork broth with noodles, egg, and vegetables', 12.99, 'Soups', 12),
(3, 'Chicken Teriyaki Bowl', 'Grilled chicken over rice with teriyaki sauce', 9.99, 'Rice Bowls', 10),
(3, 'Spring Rolls', 'Fresh vegetables wrapped in rice paper (4 pieces)', 6.99, 'Appetizers', 5),
(3, 'Thai Iced Tea', 'Sweet and creamy Thai-style iced tea', 3.99, 'Beverages', 3);

-- Insert Orders
INSERT INTO orders (truck_id, customer_id, total_amount, order_status, special_instructions) VALUES
(1, 1, 22.98, 'completed', 'Extra spicy please'),
(2, 2, 18.98, 'completed', 'No onions on burger'),
(3, 3, 16.98, 'ready', 'Extra sauce on the side'),
(1, 4, 15.49, 'preparing', NULL),
(2, 5, 23.97, 'pending', 'Well done burger');

-- Insert Order Items
INSERT INTO order_items (order_id, item_id, quantity, unit_price, item_total) VALUES
-- Order 1: Taco Libre
(1, 1, 1, 12.99, 12.99),
(1, 4, 1, 6.99, 6.99),
(1, 5, 1, 3.50, 3.50),

-- Order 2: Burger Boulevard
(2, 6, 1, 11.99, 11.99),
(2, 9, 1, 5.99, 5.99),

-- Order 3: Noodle Nirvana
(3, 11, 1, 10.99, 10.99),
(3, 15, 1, 3.99, 3.99),

-- Order 4: Taco Libre
(4, 2, 1, 9.99, 9.99),
(4, 3, 1, 8.50, 8.50),

-- Order 5: Burger Boulevard
(5, 7, 1, 13.99, 13.99),
(5, 9, 1, 5.99, 5.99),
(5, 10, 1, 4.99, 4.99);

-- Insert Reviews
INSERT INTO reviews (truck_id, customer_id, order_id, rating, review_text, is_verified) VALUES
(1, 1, 1, 5, 'Amazing carnitas tacos! Best food truck in town.', TRUE),
(2, 2, 2, 4, 'Great burger, but took a bit longer than expected.', TRUE),
(3, 3, 3, 5, 'Authentic flavors and generous portions. Highly recommend!', TRUE),
(1, 4, NULL, 4, 'Good food overall, friendly staff.', FALSE),
(2, 5, NULL, 3, 'Burger was okay, fries were cold.', FALSE);
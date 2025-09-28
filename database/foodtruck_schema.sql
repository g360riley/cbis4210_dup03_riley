-- Food Truck Management System Database Schema
-- Custom database schema for managing food trucks, menu items, orders, and customers

-- Food Trucks Table
CREATE TABLE food_trucks (
    truck_id INT AUTO_INCREMENT PRIMARY KEY,
    truck_name VARCHAR(100) NOT NULL,
    cuisine_type VARCHAR(50) NOT NULL,
    location VARCHAR(200),
    phone_number VARCHAR(20),
    license_plate VARCHAR(15) UNIQUE,
    owner_name VARCHAR(100) NOT NULL,
    operating_hours VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Menu Items Table
CREATE TABLE menu_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    truck_id INT NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    category VARCHAR(50) NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    prep_time_minutes INT DEFAULT 10,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (truck_id) REFERENCES food_trucks(truck_id) ON DELETE CASCADE
);

-- Customers Table
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Orders Table
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    truck_id INT NOT NULL,
    customer_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    order_status ENUM('pending', 'preparing', 'ready', 'completed', 'cancelled') DEFAULT 'pending',
    special_instructions TEXT,
    estimated_ready_time TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (truck_id) REFERENCES food_trucks(truck_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE SET NULL
);

-- Order Items Table (Many-to-Many relationship between orders and menu items)
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(10, 2) NOT NULL,
    item_total DECIMAL(10, 2) NOT NULL,
    special_requests TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES menu_items(item_id) ON DELETE CASCADE
);

-- Reviews Table
CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    truck_id INT NOT NULL,
    customer_id INT,
    order_id INT,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (truck_id) REFERENCES food_trucks(truck_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE SET NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE SET NULL
);

-- Indexes for better query performance
CREATE INDEX idx_food_trucks_cuisine ON food_trucks (cuisine_type);
CREATE INDEX idx_food_trucks_location ON food_trucks (location);
CREATE INDEX idx_food_trucks_active ON food_trucks (is_active);

CREATE INDEX idx_menu_items_truck ON menu_items (truck_id);
CREATE INDEX idx_menu_items_category ON menu_items (category);
CREATE INDEX idx_menu_items_available ON menu_items (is_available);

CREATE INDEX idx_customers_email ON customers (email);
CREATE INDEX idx_customers_name ON customers (last_name, first_name);

CREATE INDEX idx_orders_truck ON orders (truck_id);
CREATE INDEX idx_orders_customer ON orders (customer_id);
CREATE INDEX idx_orders_date ON orders (order_date);
CREATE INDEX idx_orders_status ON orders (order_status);

CREATE INDEX idx_order_items_order ON order_items (order_id);
CREATE INDEX idx_order_items_item ON order_items (item_id);

CREATE INDEX idx_reviews_truck ON reviews (truck_id);
CREATE INDEX idx_reviews_customer ON reviews (customer_id);
CREATE INDEX idx_reviews_rating ON reviews (rating);
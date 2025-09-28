-- Ice Cream Truck Business Database Schema
-- Comprehensive database for managing ice cream truck operations

-- Ice Cream Trucks Table
CREATE TABLE ice_cream_trucks (
    truck_id INT AUTO_INCREMENT PRIMARY KEY,
    truck_name VARCHAR(100) NOT NULL,
    truck_color VARCHAR(50),
    license_plate VARCHAR(15) UNIQUE,
    driver_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20),
    current_location VARCHAR(200),
    route_name VARCHAR(100),
    capacity_gallons INT DEFAULT 50,
    is_operational BOOLEAN DEFAULT TRUE,
    last_maintenance_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Ice Cream Flavors/Products Table
CREATE TABLE ice_cream_products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    product_type ENUM('scoop', 'bar', 'sandwich', 'cone', 'sundae', 'shake') NOT NULL,
    flavor VARCHAR(100),
    description TEXT,
    price DECIMAL(8, 2) NOT NULL,
    cost DECIMAL(8, 2),
    calories INT,
    contains_nuts BOOLEAN DEFAULT FALSE,
    contains_dairy BOOLEAN DEFAULT TRUE,
    is_sugar_free BOOLEAN DEFAULT FALSE,
    is_available BOOLEAN DEFAULT TRUE,
    seasonal BOOLEAN DEFAULT FALSE,
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Truck Inventory - What products each truck carries
CREATE TABLE truck_inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    truck_id INT NOT NULL,
    product_id INT NOT NULL,
    current_stock INT DEFAULT 0,
    max_capacity INT DEFAULT 100,
    reorder_level INT DEFAULT 20,
    last_restocked TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (truck_id) REFERENCES ice_cream_trucks(truck_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES ice_cream_products(product_id) ON DELETE CASCADE,
    UNIQUE KEY unique_truck_product (truck_id, product_id)
);

-- Customers Table
CREATE TABLE ice_cream_customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(20),
    birth_date DATE,
    favorite_flavor VARCHAR(100),
    loyalty_points INT DEFAULT 0,
    total_purchases INT DEFAULT 0,
    total_spent DECIMAL(10, 2) DEFAULT 0.00,
    allergies TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Orders Table
CREATE TABLE ice_cream_orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    truck_id INT NOT NULL,
    customer_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    order_location VARCHAR(200),
    subtotal DECIMAL(10, 2) NOT NULL,
    tax_amount DECIMAL(10, 2) DEFAULT 0.00,
    total_amount DECIMAL(10, 2) NOT NULL,
    payment_method ENUM('cash', 'card', 'mobile', 'loyalty') DEFAULT 'cash',
    order_status ENUM('pending', 'preparing', 'ready', 'completed', 'cancelled') DEFAULT 'pending',
    special_requests TEXT,
    loyalty_points_earned INT DEFAULT 0,
    loyalty_points_used INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (truck_id) REFERENCES ice_cream_trucks(truck_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES ice_cream_customers(customer_id) ON DELETE SET NULL
);

-- Order Items Table
CREATE TABLE ice_cream_order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(8, 2) NOT NULL,
    item_total DECIMAL(8, 2) NOT NULL,
    special_instructions TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES ice_cream_orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES ice_cream_products(product_id) ON DELETE CASCADE
);

-- Truck Routes/Schedules Table
CREATE TABLE truck_routes (
    route_id INT AUTO_INCREMENT PRIMARY KEY,
    truck_id INT NOT NULL,
    route_name VARCHAR(100) NOT NULL,
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    location_name VARCHAR(100) NOT NULL,
    location_address VARCHAR(200),
    estimated_duration_minutes INT DEFAULT 60,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (truck_id) REFERENCES ice_cream_trucks(truck_id) ON DELETE CASCADE
);

-- Customer Reviews Table
CREATE TABLE ice_cream_reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    truck_id INT,
    product_id INT,
    customer_id INT,
    order_id INT,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    review_title VARCHAR(100),
    review_text TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_verified BOOLEAN DEFAULT FALSE,
    helpful_votes INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (truck_id) REFERENCES ice_cream_trucks(truck_id) ON DELETE SET NULL,
    FOREIGN KEY (product_id) REFERENCES ice_cream_products(product_id) ON DELETE SET NULL,
    FOREIGN KEY (customer_id) REFERENCES ice_cream_customers(customer_id) ON DELETE SET NULL,
    FOREIGN KEY (order_id) REFERENCES ice_cream_orders(order_id) ON DELETE SET NULL
);

-- Daily Sales Summary Table
CREATE TABLE daily_sales (
    sale_date DATE NOT NULL,
    truck_id INT NOT NULL,
    total_orders INT DEFAULT 0,
    total_revenue DECIMAL(10, 2) DEFAULT 0.00,
    total_costs DECIMAL(10, 2) DEFAULT 0.00,
    weather_condition VARCHAR(50),
    temperature_f INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (sale_date, truck_id),
    FOREIGN KEY (truck_id) REFERENCES ice_cream_trucks(truck_id) ON DELETE CASCADE
);

-- Indexes for better performance
CREATE INDEX idx_trucks_operational ON ice_cream_trucks (is_operational);
CREATE INDEX idx_trucks_location ON ice_cream_trucks (current_location);

CREATE INDEX idx_products_type ON ice_cream_products (product_type);
CREATE INDEX idx_products_available ON ice_cream_products (is_available);
CREATE INDEX idx_products_seasonal ON ice_cream_products (seasonal);

CREATE INDEX idx_inventory_truck ON truck_inventory (truck_id);
CREATE INDEX idx_inventory_product ON truck_inventory (product_id);
CREATE INDEX idx_inventory_stock ON truck_inventory (current_stock);

CREATE INDEX idx_customers_email ON ice_cream_customers (email);
CREATE INDEX idx_customers_points ON ice_cream_customers (loyalty_points);

CREATE INDEX idx_orders_truck ON ice_cream_orders (truck_id);
CREATE INDEX idx_orders_customer ON ice_cream_orders (customer_id);
CREATE INDEX idx_orders_date ON ice_cream_orders (order_date);
CREATE INDEX idx_orders_status ON ice_cream_orders (order_status);

CREATE INDEX idx_routes_truck ON truck_routes (truck_id);
CREATE INDEX idx_routes_day ON truck_routes (day_of_week);
CREATE INDEX idx_routes_active ON truck_routes (is_active);

CREATE INDEX idx_reviews_truck ON ice_cream_reviews (truck_id);
CREATE INDEX idx_reviews_product ON ice_cream_reviews (product_id);
CREATE INDEX idx_reviews_rating ON ice_cream_reviews (rating);

CREATE INDEX idx_sales_date ON daily_sales (sale_date);
CREATE INDEX idx_sales_truck ON daily_sales (truck_id);
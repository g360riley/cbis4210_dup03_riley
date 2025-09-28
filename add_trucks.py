#!/usr/bin/env python3
"""
Script to add 20 more ice cream trucks to the database
"""
import pymysql
import pymysql.cursors
import os
from dotenv import load_dotenv

load_dotenv()

# Additional truck data
additional_trucks = [
    ('Vanilla Dream', 'Sky Blue', 'VAN123', 'Sarah Johnson', '555-0101', 'Downtown Plaza', 'City Center Route', 75),
    ('Chocolate Paradise', 'Dark Brown', 'CHO456', 'Mike Wilson', '555-0102', 'Riverside Park', 'Park Circuit', 60),
    ('Strawberry Bliss', 'Pink', 'STR789', 'Emily Chen', '555-0103', 'School District', 'Educational Route', 80),
    ('Mint Magic', 'Light Green', 'MIN012', 'David Rodriguez', '555-0104', 'Shopping Center', 'Mall Route', 65),
    ('Cookie Craze', 'Orange', 'COO345', 'Lisa Thompson', '555-0105', 'Neighborhood Streets', 'Residential Route', 70),
    ('Caramel Cloud', 'Golden', 'CAR678', 'James Martinez', '555-0106', 'Beach Boardwalk', 'Coastal Route', 55),
    ('Berry Burst', 'Purple', 'BER901', 'Amanda Davis', '555-0107', 'City Park', 'Recreation Route', 75),
    ('Fudge Fantasy', 'Dark Blue', 'FUD234', 'Robert Lee', '555-0108', 'Business District', 'Corporate Route', 80),
    ('Peach Perfect', 'Peach', 'PEA567', 'Jennifer White', '555-0109', 'Community Center', 'Community Route', 60),
    ('Rocky Road Runner', 'Gray', 'ROC890', 'Christopher Brown', '555-0110', 'Sports Complex', 'Athletic Route', 85),
    ('Neapolitan Nights', 'Tri-Color', 'NEA123', 'Michelle Garcia', '555-0111', 'Festival Grounds', 'Event Route', 70),
    ('Sundae Supreme', 'Red', 'SUN456', 'Kevin Anderson', '555-0112', 'Library District', 'Educational Route', 65),
    ('Banana Split Special', 'Yellow', 'BAN789', 'Rachel Miller', '555-0113', 'Farmers Market', 'Market Route', 75),
    ('Pistachio Paradise', 'Light Green', 'PIS012', 'Daniel Taylor', '555-0114', 'University Campus', 'Campus Route', 80),
    ('Coconut Cruiser', 'White', 'COC345', 'Ashley Moore', '555-0115', 'Suburb Streets', 'Suburban Route', 70),
    ('Mango Madness', 'Orange-Yellow', 'MAN678', 'Brandon Jackson', '555-0116', 'Tourist Area', 'Tourism Route', 65),
    ('Blackberry Breeze', 'Dark Purple', 'BLA901', 'Stephanie Thomas', '555-0117', 'Hospital District', 'Medical Route', 60),
    ('Lemon Lime Delight', 'Bright Yellow', 'LEM234', 'Matthew Harris', '555-0118', 'School Zone', 'Education Route', 75),
    ('Peppermint Patrol', 'Red and White', 'PEP567', 'Nicole Clark', '555-0119', 'Office Complex', 'Business Route', 85),
    ('Toffee Twist', 'Light Brown', 'TOF890', 'Andrew Lewis', '555-0120', 'Shopping Mall', 'Retail Route', 70),
    ('Blueberry Bonanza', 'Deep Blue', 'BLU123', 'Samantha Walker', '555-0121', 'Park Avenue', 'Avenue Route', 80),
    ('Cinnamon Swirl', 'Brown', 'CIN456', 'Tyler Hall', '555-0122', 'Metro Station', 'Transit Route', 65)
]

def add_trucks_to_database():
    """Add additional trucks to the database"""
    try:
        # Connect to database
        connection = pymysql.connect(
            host=os.getenv('DB_HOST'),
            user=os.getenv('DB_USER'),
            password=os.getenv('DB_PASSWORD'),
            database=os.getenv('DB_NAME'),
            cursorclass=pymysql.cursors.DictCursor
        )

        print("Connected to database successfully!")

        with connection.cursor() as cursor:
            # Insert additional trucks
            insert_query = '''
                INSERT INTO ice_cream_trucks (truck_name, truck_color, license_plate, driver_name,
                                            phone_number, current_location, route_name, capacity_gallons)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            '''

            for truck in additional_trucks:
                try:
                    cursor.execute(insert_query, truck)
                    print(f"Added truck: {truck[0]}")
                except Exception as e:
                    print(f"Error adding truck {truck[0]}: {e}")

            connection.commit()
            print(f"Successfully added {len(additional_trucks)} trucks to the database!")

            # Show total count
            cursor.execute("SELECT COUNT(*) as total FROM ice_cream_trucks")
            result = cursor.fetchone()
            print(f"Total trucks in database: {result['total']}")

    except Exception as e:
        print(f"Database operation failed: {e}")
    finally:
        if 'connection' in locals():
            connection.close()
            print("Database connection closed")

if __name__ == "__main__":
    add_trucks_to_database()
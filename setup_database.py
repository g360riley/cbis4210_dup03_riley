#!/usr/bin/env python3
"""
Database setup script to create tables and load seed data
"""
import pymysql
import pymysql.cursors
import os
from dotenv import load_dotenv

load_dotenv()

def execute_sql_file(cursor, filename):
    """Execute SQL commands from a file"""
    print(f"Executing {filename}...")
    try:
        with open(filename, 'r', encoding='utf-8') as file:
            sql_content = file.read()

        # Split by semicolon and execute each statement
        statements = [stmt.strip() for stmt in sql_content.split(';') if stmt.strip()]

        for statement in statements:
            if statement:
                try:
                    cursor.execute(statement)
                    print(f"Executed statement successfully")
                except Exception as e:
                    print(f"Error executing statement: {e}")
                    print(f"Statement: {statement[:100]}...")

    except Exception as e:
        print(f"Error reading {filename}: {e}")

def main():
    """Main setup function"""
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
            # Create tables
            execute_sql_file(cursor, 'database/icecream_schema.sql')
            connection.commit()
            print("Schema created successfully!")

            # Load seed data
            if os.path.exists('database/icecream_seed_data.sql'):
                execute_sql_file(cursor, 'database/icecream_seed_data.sql')
                connection.commit()
                print("Seed data loaded successfully!")
            else:
                print("No seed data file found")

    except Exception as e:
        print(f"Database setup failed: {e}")
    finally:
        if 'connection' in locals():
            connection.close()
            print("Database connection closed")

if __name__ == "__main__":
    main()
# Database Setup

This directory contains the database structure and data for Sweet Dreams Ice Cream business management system.

## Files

- `icecream_schema.sql` - Ice cream business database table definitions
- `icecream_seed_data.sql` - Sample ice cream business data for testing
- `foodtruck_schema.sql` - Food truck database tables
- `foodtruck_seed_data.sql` - Sample food truck data

## Setup Instructions

### 1. Prerequisites
- MySQL server installed and running
- Database created (you can name it anything)
- Database credentials configured in your `.env` file

### 2. Create Database Structure
Run the ice cream schema file to create the required tables:

```bash
mysql -h [host] -u [username] -p [database_name] < database/icecream_schema.sql
```

Or using your database management tool, execute the contents of `icecream_schema.sql`.

### 3. Load Sample Data (Optional)
To populate the database with sample records for testing:

```bash
mysql -h [host] -u [username] -p [database_name] < database/icecream_seed_data.sql
```

## Database Structure

The ice cream business database includes tables for:
- Ice cream trucks and fleet management
- Product catalog and inventory
- Customer management
- Order tracking and sales
- Route management
- Driver information

## Notes

- The schema includes helpful indexes for common query patterns
- Timestamps are automatically managed by MySQL
- Sample data includes realistic ice cream business data

## Environment Variables

Make sure your `.env` file contains the correct database connection information:

```
DB_HOST=your_database_host
DB_USER=your_database_user
DB_PASSWORD=your_database_password
DB_NAME=your_database_name
```
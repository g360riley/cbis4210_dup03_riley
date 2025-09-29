from flask import Blueprint, render_template, request, redirect, url_for, flash, jsonify
from app.db_connect import get_db
from datetime import datetime, date

business = Blueprint('business', __name__)

@business.route('/', methods=['GET'])
def dashboard():
    db = get_db()
    cursor = db.cursor()

    cursor.execute('''
        SELECT COUNT(*) as total_trucks FROM ice_cream_trucks WHERE is_operational = TRUE
    ''')
    truck_stats = cursor.fetchone()

    cursor.execute('''
        SELECT COUNT(*) as total_products FROM ice_cream_products WHERE is_available = TRUE
    ''')
    product_stats = cursor.fetchone()

    cursor.execute('''
        SELECT COUNT(*) as total_customers FROM ice_cream_customers
    ''')
    customer_stats = cursor.fetchone()

    cursor.execute('''
        SELECT COALESCE(SUM(total_revenue), 0) as total_revenue
        FROM daily_sales
        WHERE sale_date >= CURDATE() - INTERVAL 7 DAY
    ''')
    revenue_stats = cursor.fetchone()

    cursor.execute('''
        SELECT ict.*,
               COUNT(DISTINCT ti.product_id) as products_count,
               COALESCE(ds.total_revenue, 0) as today_revenue
        FROM ice_cream_trucks ict
        LEFT JOIN truck_inventory ti ON ict.truck_id = ti.truck_id
        LEFT JOIN daily_sales ds ON ict.truck_id = ds.truck_id AND ds.sale_date = CURDATE()
        WHERE ict.is_operational = TRUE
        GROUP BY ict.truck_id
        ORDER BY ict.truck_name
    ''')
    active_trucks = cursor.fetchall()

    return render_template('business/dashboard.html',
                         truck_stats=truck_stats,
                         product_stats=product_stats,
                         customer_stats=customer_stats,
                         revenue_stats=revenue_stats,
                         active_trucks=active_trucks)

@business.route('/trucks', methods=['GET', 'POST'])
def show_trucks():
    db = get_db()
    cursor = db.cursor()

    # Handle POST request to add a new truck
    if request.method == 'POST':
        truck_name = request.form['truck_name']
        truck_color = request.form['truck_color']
        license_plate = request.form['license_plate']
        driver_name = request.form['driver_name']
        phone_number = request.form['phone_number']
        current_location = request.form['current_location']
        route_name = request.form['route_name']
        capacity_gallons = int(request.form['capacity_gallons'])

        try:
            cursor.execute('''
                INSERT INTO ice_cream_trucks (truck_name, truck_color, license_plate, driver_name,
                                            phone_number, current_location, route_name, capacity_gallons)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            ''', (truck_name, truck_color, license_plate, driver_name, phone_number,
                  current_location, route_name, capacity_gallons))
            db.commit()
            flash('Ice cream truck added successfully!', 'success')
            return redirect(url_for('business.show_trucks'))
        except Exception as e:
            flash(f'Error adding truck: {str(e)}', 'error')

    cursor.execute('''
        SELECT ict.*,
               COUNT(DISTINCT ti.product_id) as inventory_count,
               COUNT(DISTINCT tr.route_id) as route_count,
               COALESCE(AVG(icr.rating), 0) as avg_rating
        FROM ice_cream_trucks ict
        LEFT JOIN truck_inventory ti ON ict.truck_id = ti.truck_id AND ti.current_stock > 0
        LEFT JOIN truck_routes tr ON ict.truck_id = tr.truck_id AND tr.is_active = TRUE
        LEFT JOIN ice_cream_reviews icr ON ict.truck_id = icr.truck_id
        GROUP BY ict.truck_id
        ORDER BY ict.truck_name
    ''')

    trucks = cursor.fetchall()
    return render_template('business/trucks.html', trucks=trucks)

@business.route('/trucks/add', methods=['GET', 'POST'])
def add_truck():
    if request.method == 'POST':
        truck_name = request.form['truck_name']
        truck_color = request.form['truck_color']
        license_plate = request.form['license_plate']
        driver_name = request.form['driver_name']
        phone_number = request.form['phone_number']
        current_location = request.form['current_location']
        route_name = request.form['route_name']
        capacity_gallons = int(request.form['capacity_gallons'])

        db = get_db()
        cursor = db.cursor()

        try:
            cursor.execute('''
                INSERT INTO ice_cream_trucks (truck_name, truck_color, license_plate, driver_name,
                                            phone_number, current_location, route_name, capacity_gallons)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            ''', (truck_name, truck_color, license_plate, driver_name, phone_number,
                  current_location, route_name, capacity_gallons))
            db.commit()
            flash('Ice cream truck added successfully!', 'success')
            return redirect(url_for('business.show_trucks'))
        except Exception as e:
            flash(f'Error adding truck: {str(e)}', 'error')

    return render_template('business/add_truck.html')

@business.route('/trucks/update/<int:truck_id>', methods=['POST'])
def update_truck(truck_id):
    db = get_db()
    cursor = db.cursor()

    truck_name = request.form['truck_name']
    truck_color = request.form['truck_color']
    license_plate = request.form['license_plate']
    driver_name = request.form['driver_name']
    phone_number = request.form['phone_number']
    current_location = request.form['current_location']
    route_name = request.form['route_name']
    capacity_gallons = int(request.form['capacity_gallons'])

    try:
        cursor.execute('''
            UPDATE ice_cream_trucks SET truck_name = %s, truck_color = %s, license_plate = %s,
                                      driver_name = %s, phone_number = %s, current_location = %s,
                                      route_name = %s, capacity_gallons = %s
            WHERE truck_id = %s
        ''', (truck_name, truck_color, license_plate, driver_name, phone_number,
              current_location, route_name, capacity_gallons, truck_id))
        db.commit()
        flash('Ice cream truck updated successfully!', 'success')
    except Exception as e:
        flash(f'Error updating truck: {str(e)}', 'error')

    return redirect(url_for('business.show_trucks'))

@business.route('/trucks/delete/<int:truck_id>', methods=['POST'])
def delete_truck(truck_id):
    db = get_db()
    cursor = db.cursor()

    try:
        cursor.execute('DELETE FROM ice_cream_trucks WHERE truck_id = %s', (truck_id,))
        db.commit()
        flash('Ice cream truck deleted successfully!', 'success')
    except Exception as e:
        flash(f'Error deleting truck: {str(e)}', 'error')

    return redirect(url_for('business.show_trucks'))

@business.route('/trucks/<int:truck_id>')
def truck_details(truck_id):
    db = get_db()
    cursor = db.cursor()

    cursor.execute('SELECT * FROM ice_cream_trucks WHERE truck_id = %s', (truck_id,))
    truck = cursor.fetchone()

    if not truck:
        flash('Ice cream truck not found', 'error')
        return redirect(url_for('business.show_trucks'))

    cursor.execute('''
        SELECT ti.*, icp.product_name, icp.product_type, icp.flavor, icp.price
        FROM truck_inventory ti
        JOIN ice_cream_products icp ON ti.product_id = icp.product_id
        WHERE ti.truck_id = %s
        ORDER BY icp.product_type, icp.product_name
    ''', (truck_id,))
    inventory = cursor.fetchall()

    cursor.execute('''
        SELECT tr.*
        FROM truck_routes tr
        WHERE tr.truck_id = %s AND tr.is_active = TRUE
        ORDER BY FIELD(tr.day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'), tr.start_time
    ''', (truck_id,))
    routes = cursor.fetchall()

    cursor.execute('''
        SELECT ico.*, icc.first_name, icc.last_name
        FROM ice_cream_orders ico
        LEFT JOIN ice_cream_customers icc ON ico.customer_id = icc.customer_id
        WHERE ico.truck_id = %s
        ORDER BY ico.order_date DESC
        LIMIT 10
    ''', (truck_id,))
    recent_orders = cursor.fetchall()

    return render_template('business/truck_details.html',
                         truck=truck, inventory=inventory, routes=routes, recent_orders=recent_orders)

@business.route('/products')
def show_products():
    db = get_db()
    cursor = db.cursor()

    product_type = request.args.get('type', '')
    search_query = request.args.get('search', '')

    where_conditions = ['1=1']
    params = []

    if product_type:
        where_conditions.append('product_type = %s')
        params.append(product_type)

    if search_query:
        where_conditions.append('(product_name LIKE %s OR flavor LIKE %s)')
        params.extend([f'%{search_query}%', f'%{search_query}%'])

    cursor.execute(f'''
        SELECT icp.*,
               COUNT(DISTINCT ti.truck_id) as available_trucks,
               COALESCE(AVG(icr.rating), 0) as avg_rating,
               COUNT(DISTINCT icr.review_id) as review_count
        FROM ice_cream_products icp
        LEFT JOIN truck_inventory ti ON icp.product_id = ti.product_id AND ti.current_stock > 0
        LEFT JOIN ice_cream_reviews icr ON icp.product_id = icr.product_id
        WHERE {' AND '.join(where_conditions)}
        GROUP BY icp.product_id
        ORDER BY icp.product_type, icp.product_name
    ''', params)

    products = cursor.fetchall()

    cursor.execute('SELECT DISTINCT product_type FROM ice_cream_products ORDER BY product_type')
    product_types = cursor.fetchall()

    return render_template('business/products.html',
                         products=products, product_types=product_types,
                         current_type=product_type, search_query=search_query)

@business.route('/products/add', methods=['GET', 'POST'])
def add_product():
    if request.method == 'POST':
        product_name = request.form['product_name']
        product_type = request.form['product_type']
        flavor = request.form['flavor']
        description = request.form['description']
        price = float(request.form['price'])
        cost = float(request.form.get('cost', 0))
        calories = int(request.form.get('calories', 0))
        contains_nuts = 'contains_nuts' in request.form
        contains_dairy = 'contains_dairy' in request.form
        is_sugar_free = 'is_sugar_free' in request.form
        seasonal = 'seasonal' in request.form

        db = get_db()
        cursor = db.cursor()

        try:
            cursor.execute('''
                INSERT INTO ice_cream_products (product_name, product_type, flavor, description, price, cost,
                                              calories, contains_nuts, contains_dairy, is_sugar_free, seasonal)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            ''', (product_name, product_type, flavor, description, price, cost, calories,
                  contains_nuts, contains_dairy, is_sugar_free, seasonal))
            db.commit()
            flash('Ice cream product added successfully!', 'success')
            return redirect(url_for('business.show_products'))
        except Exception as e:
            flash(f'Error adding product: {str(e)}', 'error')

    return render_template('business/add_product.html')

@business.route('/orders')
def show_orders():
    status_filter = request.args.get('status', '')

    db = get_db()
    cursor = db.cursor()

    where_condition = '1=1'
    params = []

    if status_filter:
        where_condition = 'ico.order_status = %s'
        params.append(status_filter)

    cursor.execute(f'''
        SELECT ico.*, ict.truck_name, ict.driver_name, icc.first_name, icc.last_name,
               COUNT(icoi.order_item_id) as item_count
        FROM ice_cream_orders ico
        JOIN ice_cream_trucks ict ON ico.truck_id = ict.truck_id
        LEFT JOIN ice_cream_customers icc ON ico.customer_id = icc.customer_id
        LEFT JOIN ice_cream_order_items icoi ON ico.order_id = icoi.order_id
        WHERE {where_condition}
        GROUP BY ico.order_id
        ORDER BY ico.order_date DESC
    ''', params)

    orders = cursor.fetchall()

    return render_template('business/orders.html', orders=orders, current_status=status_filter)

@business.route('/orders/<int:order_id>')
def order_details(order_id):
    db = get_db()
    cursor = db.cursor()

    cursor.execute('''
        SELECT ico.*, ict.truck_name, ict.driver_name, icc.first_name, icc.last_name, icc.email, icc.phone_number
        FROM ice_cream_orders ico
        JOIN ice_cream_trucks ict ON ico.truck_id = ict.truck_id
        LEFT JOIN ice_cream_customers icc ON ico.customer_id = icc.customer_id
        WHERE ico.order_id = %s
    ''', (order_id,))

    order = cursor.fetchone()

    if not order:
        flash('Order not found', 'error')
        return redirect(url_for('business.show_orders'))

    cursor.execute('''
        SELECT icoi.*, icp.product_name, icp.flavor, icp.product_type
        FROM ice_cream_order_items icoi
        JOIN ice_cream_products icp ON icoi.product_id = icp.product_id
        WHERE icoi.order_id = %s
    ''', (order_id,))

    order_items = cursor.fetchall()

    return render_template('business/order_details.html', order=order, order_items=order_items)

@business.route('/customers')
def show_customers():
    db = get_db()
    cursor = db.cursor()

    cursor.execute('''
        SELECT icc.*,
               COUNT(DISTINCT ico.order_id) as order_count,
               COALESCE(SUM(ico.total_amount), 0) as total_spent,
               MAX(ico.order_date) as last_order_date
        FROM ice_cream_customers icc
        LEFT JOIN ice_cream_orders ico ON icc.customer_id = ico.customer_id
        GROUP BY icc.customer_id
        ORDER BY total_spent DESC
    ''')

    customers = cursor.fetchall()
    return render_template('business/customers.html', customers=customers)

@business.route('/analytics')
def analytics():
    db = get_db()
    cursor = db.cursor()

    cursor.execute('''
        SELECT DATE(sale_date) as date, SUM(total_revenue) as daily_revenue,
               SUM(total_orders) as daily_orders, AVG(temperature_f) as avg_temp
        FROM daily_sales
        WHERE sale_date >= CURDATE() - INTERVAL 30 DAY
        GROUP BY DATE(sale_date)
        ORDER BY sale_date DESC
    ''')
    daily_stats = cursor.fetchall()

    cursor.execute('''
        SELECT ict.truck_name, SUM(ds.total_revenue) as truck_revenue,
               SUM(ds.total_orders) as truck_orders
        FROM daily_sales ds
        JOIN ice_cream_trucks ict ON ds.truck_id = ict.truck_id
        WHERE ds.sale_date >= CURDATE() - INTERVAL 30 DAY
        GROUP BY ds.truck_id, ict.truck_name
        ORDER BY truck_revenue DESC
    ''')
    truck_performance = cursor.fetchall()

    cursor.execute('''
        SELECT icp.product_name, icp.flavor, COUNT(icoi.order_item_id) as times_ordered,
               SUM(icoi.quantity) as total_quantity
        FROM ice_cream_order_items icoi
        JOIN ice_cream_products icp ON icoi.product_id = icp.product_id
        JOIN ice_cream_orders ico ON icoi.order_id = ico.order_id
        WHERE ico.order_date >= CURDATE() - INTERVAL 30 DAY
        GROUP BY icoi.product_id
        ORDER BY times_ordered DESC
        LIMIT 10
    ''')
    popular_products = cursor.fetchall()

    return render_template('business/analytics.html',
                         daily_stats=daily_stats,
                         truck_performance=truck_performance,
                         popular_products=popular_products)

@business.route('/api/trucks/locations')
def api_truck_locations():
    db = get_db()
    cursor = db.cursor()

    cursor.execute('''
        SELECT truck_id, truck_name, current_location, driver_name, phone_number
        FROM ice_cream_trucks
        WHERE is_operational = TRUE AND current_location IS NOT NULL
    ''')

    trucks = cursor.fetchall()
    return jsonify(trucks)

@business.route('/api/products/<int:truck_id>')
def api_truck_products(truck_id):
    db = get_db()
    cursor = db.cursor()

    cursor.execute('''
        SELECT icp.*, ti.current_stock
        FROM ice_cream_products icp
        JOIN truck_inventory ti ON icp.product_id = ti.product_id
        WHERE ti.truck_id = %s AND ti.current_stock > 0 AND icp.is_available = TRUE
        ORDER BY icp.product_type, icp.product_name
    ''', (truck_id,))

    products = cursor.fetchall()
    return jsonify(products)
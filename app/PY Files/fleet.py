from flask import Blueprint, render_template, request, redirect, url_for, flash, jsonify
from app.db_connect import get_db

fleet = Blueprint('fleet', __name__)

@fleet.route('/', methods=['GET'])
def show_food_trucks():
    db = get_db()
    cursor = db.cursor()

    cursor.execute('''
        SELECT ft.*,
               COUNT(DISTINCT mi.item_id) as menu_count,
               COUNT(DISTINCT o.order_id) as order_count,
               AVG(r.rating) as avg_rating
        FROM food_trucks ft
        LEFT JOIN menu_items mi ON ft.truck_id = mi.truck_id
        LEFT JOIN orders o ON ft.truck_id = o.truck_id
        LEFT JOIN reviews r ON ft.truck_id = r.truck_id
        WHERE ft.is_active = TRUE
        GROUP BY ft.truck_id
        ORDER BY ft.truck_name
    ''')

    food_trucks = cursor.fetchall()
    return render_template('foodtrucks/index.html', food_trucks=food_trucks)

@fleet.route('/add', methods=['GET', 'POST'])
def add_food_truck():
    if request.method == 'POST':
        truck_name = request.form['truck_name']
        cuisine_type = request.form['cuisine_type']
        location = request.form['location']
        phone_number = request.form['phone_number']
        license_plate = request.form['license_plate']
        owner_name = request.form['owner_name']
        operating_hours = request.form['operating_hours']

        db = get_db()
        cursor = db.cursor()

        try:
            cursor.execute('''
                INSERT INTO food_trucks (truck_name, cuisine_type, location, phone_number,
                                       license_plate, owner_name, operating_hours)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
            ''', (truck_name, cuisine_type, location, phone_number, license_plate, owner_name, operating_hours))
            db.commit()
            flash('Food truck added successfully!', 'success')
            return redirect(url_for('foodtrucks.show_food_trucks'))
        except Exception as e:
            flash(f'Error adding food truck: {str(e)}', 'error')

    return render_template('foodtrucks/add.html')

@fleet.route('/truck/<int:truck_id>')
def truck_details(truck_id):
    db = get_db()
    cursor = db.cursor()

    cursor.execute('SELECT * FROM food_trucks WHERE truck_id = %s', (truck_id,))
    truck = cursor.fetchone()

    if not truck:
        flash('Food truck not found', 'error')
        return redirect(url_for('foodtrucks.show_food_trucks'))

    cursor.execute('''
        SELECT * FROM menu_items
        WHERE truck_id = %s AND is_available = TRUE
        ORDER BY category, item_name
    ''', (truck_id,))
    menu_items = cursor.fetchall()

    cursor.execute('''
        SELECT o.*, c.first_name, c.last_name
        FROM orders o
        LEFT JOIN customers c ON o.customer_id = c.customer_id
        WHERE o.truck_id = %s
        ORDER BY o.order_date DESC
        LIMIT 10
    ''', (truck_id,))
    recent_orders = cursor.fetchall()

    cursor.execute('''
        SELECT r.*, c.first_name, c.last_name
        FROM reviews r
        LEFT JOIN customers c ON r.customer_id = c.customer_id
        WHERE r.truck_id = %s
        ORDER BY r.review_date DESC
    ''', (truck_id,))
    reviews = cursor.fetchall()

    return render_template('foodtrucks/details.html',
                         truck=truck, menu_items=menu_items,
                         recent_orders=recent_orders, reviews=reviews)

@fleet.route('/menu/<int:truck_id>')
def manage_menu(truck_id):
    db = get_db()
    cursor = db.cursor()

    cursor.execute('SELECT * FROM food_trucks WHERE truck_id = %s', (truck_id,))
    truck = cursor.fetchone()

    if not truck:
        flash('Food truck not found', 'error')
        return redirect(url_for('foodtrucks.show_food_trucks'))

    cursor.execute('SELECT * FROM menu_items WHERE truck_id = %s ORDER BY category, item_name', (truck_id,))
    menu_items = cursor.fetchall()

    return render_template('foodtrucks/menu.html', truck=truck, menu_items=menu_items)

@fleet.route('/menu/add/<int:truck_id>', methods=['POST'])
def add_menu_item(truck_id):
    item_name = request.form['item_name']
    description = request.form['description']
    price = float(request.form['price'])
    category = request.form['category']
    prep_time = int(request.form['prep_time_minutes'])

    db = get_db()
    cursor = db.cursor()

    try:
        cursor.execute('''
            INSERT INTO menu_items (truck_id, item_name, description, price, category, prep_time_minutes)
            VALUES (%s, %s, %s, %s, %s, %s)
        ''', (truck_id, item_name, description, price, category, prep_time))
        db.commit()
        flash('Menu item added successfully!', 'success')
    except Exception as e:
        flash(f'Error adding menu item: {str(e)}', 'error')

    return redirect(url_for('foodtrucks.manage_menu', truck_id=truck_id))

@fleet.route('/orders')
def show_orders():
    db = get_db()
    cursor = db.cursor()

    cursor.execute('''
        SELECT o.*, ft.truck_name, c.first_name, c.last_name,
               COUNT(oi.order_item_id) as item_count
        FROM orders o
        JOIN food_trucks ft ON o.truck_id = ft.truck_id
        LEFT JOIN customers c ON o.customer_id = c.customer_id
        LEFT JOIN order_items oi ON o.order_id = oi.order_id
        GROUP BY o.order_id
        ORDER BY o.order_date DESC
    ''')

    orders = cursor.fetchall()
    return render_template('foodtrucks/orders.html', orders=orders)

@fleet.route('/order/<int:order_id>')
def order_details(order_id):
    db = get_db()
    cursor = db.cursor()

    cursor.execute('''
        SELECT o.*, ft.truck_name, c.first_name, c.last_name, c.email, c.phone_number
        FROM orders o
        JOIN food_trucks ft ON o.truck_id = ft.truck_id
        LEFT JOIN customers c ON o.customer_id = c.customer_id
        WHERE o.order_id = %s
    ''', (order_id,))

    order = cursor.fetchone()

    if not order:
        flash('Order not found', 'error')
        return redirect(url_for('foodtrucks.show_orders'))

    cursor.execute('''
        SELECT oi.*, mi.item_name, mi.description
        FROM order_items oi
        JOIN menu_items mi ON oi.item_id = mi.item_id
        WHERE oi.order_id = %s
    ''', (order_id,))

    order_items = cursor.fetchall()

    return render_template('foodtrucks/order_details.html', order=order, order_items=order_items)

@fleet.route('/update_order_status/<int:order_id>', methods=['POST'])
def update_order_status(order_id):
    new_status = request.form['order_status']

    db = get_db()
    cursor = db.cursor()

    try:
        cursor.execute('UPDATE orders SET order_status = %s WHERE order_id = %s', (new_status, order_id))
        db.commit()
        flash(f'Order status updated to {new_status}', 'success')
    except Exception as e:
        flash(f'Error updating order status: {str(e)}', 'error')

    return redirect(url_for('foodtrucks.order_details', order_id=order_id))

@fleet.route('/customers')
def show_customers():
    db = get_db()
    cursor = db.cursor()

    cursor.execute('''
        SELECT c.*,
               COUNT(DISTINCT o.order_id) as order_count,
               COALESCE(SUM(o.total_amount), 0) as total_spent,
               MAX(o.order_date) as last_order_date
        FROM customers c
        LEFT JOIN orders o ON c.customer_id = o.customer_id
        GROUP BY c.customer_id
        ORDER BY total_spent DESC
    ''')

    customers = cursor.fetchall()
    return render_template('foodtrucks/customers.html', customers=customers)

@fleet.route('/api/trucks', methods=['GET'])
def api_trucks():
    db = get_db()
    cursor = db.cursor()

    cursor.execute('SELECT * FROM food_trucks WHERE is_active = TRUE ORDER BY truck_name')
    trucks = cursor.fetchall()

    return jsonify(trucks)

@fleet.route('/api/menu/<int:truck_id>', methods=['GET'])
def api_menu(truck_id):
    db = get_db()
    cursor = db.cursor()

    cursor.execute('SELECT * FROM menu_items WHERE truck_id = %s AND is_available = TRUE ORDER BY category, item_name', (truck_id,))
    menu_items = cursor.fetchall()

    return jsonify(menu_items)
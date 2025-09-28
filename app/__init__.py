from flask import Flask, g
from .app_factory import create_app
from .db_connect import close_db, get_db

app = create_app()
app.secret_key = 'your-secret'  # Replace with an environment

# Register Blueprints
import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), 'PY Files'))
from fleet import fleet
from business import business

app.register_blueprint(fleet, url_prefix='/fleet')
app.register_blueprint(business, url_prefix='/business')

from . import routes

@app.before_request
def before_request():
    g.db = get_db()
    if g.db is None:
        print("Warning: Database connection unavailable. Some features may not work.")

# Setup database connection teardown
@app.teardown_appcontext
def teardown_db(exception=None):
    close_db(exception)
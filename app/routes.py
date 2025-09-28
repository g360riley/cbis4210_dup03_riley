from flask import render_template, redirect, url_for
from . import app

@app.route('/')
def index():
    return redirect(url_for('business.dashboard'))

@app.route('/about')
def about():
    return render_template('about.html')

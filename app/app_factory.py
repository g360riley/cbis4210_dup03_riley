from flask import Flask
import os

def create_app():
    # Get the directory of the current file (app_factory.py)
    current_dir = os.path.dirname(os.path.abspath(__file__))
    template_dir = os.path.join(current_dir, 'HTML Files')

    app = Flask(__name__, template_folder=template_dir)
    return app
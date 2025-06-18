from flask import Flask
from flask_cors import CORS, cross_origin
import logging

app = Flask(__name__)
CORS(app)

app.logger.setLevel(logging.DEBUG)
file_handler = logging.FileHandler('clientes_requests.log')
file_handler.setLevel(logging.DEBUG)
formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
file_handler.setFormatter(formatter)
app.logger.addHandler(file_handler)
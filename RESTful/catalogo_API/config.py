from app import app
from flaskext.mysql import MySQL

mysql = MySQL()
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = '' # LEMBRAR DE COLOCAR A SENHA
app.config['MYSQL_DATABASE_DB'] = 'db_catalogo'
app.config['MYSQL_DATABASE_HOST'] = 'localhost'
mysql.init_app(app)
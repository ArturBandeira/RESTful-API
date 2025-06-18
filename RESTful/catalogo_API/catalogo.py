import pymysql
from app import app
from config import mysql
from flask import jsonify, request
from auth import auth

@app.route('/create/adicionar_clientes_produtos', methods = ['POST'])
@auth.login_required
def adicionar_clientes_produtos():
    try:        
        _json  =  request.json
        _id_cli  =  _json['id_cliente']
        _id_prod =  _json['id_produto']
        if _id_cli and _id_prod and request.method == 'POST':
            conn = mysql.connect()
            cursor = conn.cursor(pymysql.cursors.DictCursor)
            sqlQuery = "CALL adicionar_clientes_produtos (%s, %s);"
            bindData = (_id_cli, _id_prod)
            cursor.execute(sqlQuery, bindData)
            conn.commit()
            response = jsonify('Relacao adicionada!')
            response.status_code = 200
            return response
        else:
            return showMessage()
    except Exception as e:
        print(e)
    finally:
        cursor.close()
        conn.close()

@app.route('/delete/apagar_clientes_produtos', methods = ['DELETE'])
@auth.login_required
def apagar_clientes_produtos():
    try:
        _json = request.json
        _id_cli   = _json['id_cliente']
        _id_prod =  _json['id_produto']
        conn  = mysql.connect()
        cursor = conn.cursor()
        cursor.execute("CALL apagar_clientes_produtos (%s,%s)", (_id_cli, _id_prod,))
        conn.commit()
        response = jsonify('Relacao apagada!')
        response.status_code = 200
        return response
    except Exception as e:
        print(e)
    finally:
        cursor.close()
        conn.close()

@app.route('/update/atualizar_clientes_produtos', methods = ['PUT'])
@auth.login_required
def atualizar_produtos_clientes():
    try:
        _json = request.json
        _id = _json['id']
        _id_cli   = _json['id_cliente']
        _id_prod =  _json['id_produto']
        conn  = mysql.connect()
        cursor = conn.cursor()
        cursor.execute("CALL atualizar_clientes_produtos (%s,%s,%s)", (_id, _id_cli, _id_prod,))
        conn.commit()
        response = jsonify('Relacao atualizada!')
        response.status_code = 200
        return response
    except Exception as e:
        print(e)
    finally:
        cursor.close()
        conn.close()
        

@app.route('/read/ler_produtos_do_cliente', methods = ['GET'])
@auth.login_required
def ler_produtos_do_cliente():
    try:
        _json = request.json
        _id   = _json['id']
        if _id and request.method == 'GET':
            conn = mysql.connect()
            cursor = conn.cursor(pymysql.cursors.DictCursor)
            cursor.execute("CALL ler_produtos_do_cliente (%s)", (_id,))
            empRow = cursor.fetchall()
            response = jsonify(empRow)
            response.status_code = 200
            return response
        else:
            return showMessage()
    except Exception as e:
        print(e)
    finally:
        cursor.close()
        conn.close()

@app.route('/read/ler_clientes_do_produto', methods = ['GET'])
@auth.login_required
def ler_clientes_do_produto():
    try:
        _json = request.json
        _id   = _json['id']
        if _id and request.method == 'GET':
            conn = mysql.connect()
            cursor = conn.cursor(pymysql.cursors.DictCursor)
            cursor.execute("CALL ler_clientes_do_produto (%s)", (_id,))
            empRow = cursor.fetchall()
            response = jsonify(empRow)
            response.status_code = 200
            return response
        else:
            return showMessage()
    except Exception as e:
        print(e)
    finally:
        cursor.close()
        conn.close()

@app.before_request
def log_request_info():
    app.logger.debug(f"Request Headers: {request.headers}")
    if request.method in ['POST', 'PUT']:
        app.logger.debug(f"Request Body: {request.get_data(as_text=True)}")

@app.after_request
def log_response_info(response):
    app.logger.debug(f"Response Status Code: {response.status_code}")
    app.logger.debug(f"Response Headers: {response.headers}")
    return response

@app.errorhandler(404)
def showMessage(error=None):
    message = {
        'status': 404,
        'message': 'Record not found at requested url: ' + request.url,
    }
    response = jsonify(message)
    response.status_code = 404
    return response
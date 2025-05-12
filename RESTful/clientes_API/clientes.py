import pymysql
from app import app
from config import mysql
from flask import jsonify, request
from auth import auth

@app.route('/create/adicionar_cliente', methods=['POST'])
@auth.login_required
def adicionar_cliente():
    try:        
        _json  =  request.json
        _nome  =  _json['nome']
        _idade =  _json['idade']
        _cpf   =  _json['cpf']
        _email =  _json['email']
        if _nome and _idade and _cpf and _email and request.method == 'POST':
            conn = mysql.connect()
            cursor = conn.cursor(pymysql.cursors.DictCursor)
            sqlQuery = "CALL adicionar_cliente (%s, %s, %s, %s);"
            bindData = (_nome, _idade, _cpf, _email)
            cursor.execute(sqlQuery, bindData)
            conn.commit()
            response = jsonify('Employee added successfully!')
            response.status_code = 200
            return response
        else:
            return showMessage()
    except Exception as e:
        print(e)
    finally:
        cursor.close()
        conn.close()

@app.route('/read/ler_cliente', methods=['GET'])
@auth.login_required
def ler_cliente():
    try:
        _json = request.json
        _id   = _json['id']
        if _id and request.method == 'GET':
            conn = mysql.connect()
            cursor = conn.cursor(pymysql.cursors.DictCursor)
            cursor.execute("CALL ler_cliente (%s)", (_id,))
            empRow = cursor.fetchone()
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

@app.route('/read/ler_clientes', methods=['GET'])
@auth.login_required
def ler_clientes():
    try:
        if request.method == 'GET':
            conn = mysql.connect()
            cursor = conn.cursor(pymysql.cursors.DictCursor)
            cursor.execute("CALL db_clientes.ler_clientes ()")
            empRows = cursor.fetchall()
            response = jsonify(empRows)
            response.status_code = 200
            return response
        else:
            return showMessage()
    except Exception as e:
        print(e)
    finally:
        cursor.close()
        conn.close()

@app.route('/update/atualiza_cliente', methods=['PUT'])
@auth.login_required
def atualizar_cliente():
    try:
        _json  = request.json
        _id    = _json['id']
        _nome  = _json['nome']
        _idade = _json['idade']
        _cpf   = _json['cpf']
        _email = _json['email']
        if _id and _nome and _idade and _cpf and _email and request.method == 'PUT':
            conn = mysql.connect()
            cursor = conn.cursor()
            sqlQuery = "CALL atualizar_cliente (%s, %s, %s, %s, %s)"
            bindData = (_id, _nome, _idade, _cpf, _email)
            cursor.execute(sqlQuery, bindData)
            conn.commit()
            response = jsonify('Cliente atualizado!')
            response.status_code = 200
            return response
        else:
            return showMessage()
    except Exception as e:
        print(e)
    finally:
        cursor.close()
        conn.close()

@app.route('/delete/apagar_cliente', methods=['DELETE'])
@auth.login_required
def apagar_cliente():
    try:
        _json = request.json
        _id   = _json['id']
        conn  = mysql.connect()
        cursor = conn.cursor()
        cursor.execute("CALL apagar_cliente (%s)", (_id,))
        conn.commit()
        response = jsonify('Cliente apagado!')
        response.status_code = 200
        return response
    except Exception as e:
        print(e)
    finally:
        cursor.close()
        conn.close()

@app.errorhandler(404)
def showMessage(error=None):
    message = {
        'status': 404,
        'message': 'Record not found at requested url: ' + request.url,
    }
    response = jsonify(message)
    response.status_code = 404
    return response
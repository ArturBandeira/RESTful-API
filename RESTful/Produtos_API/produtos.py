import pymysql
from app import app
from config import mysql
from flask import jsonify, request
from auth import auth

@app.route('/create/adicionar_produto', methods=['POST'])
@auth.login_required
def adicionar_produto():
    try:        
        _json  =  request.json
        _nome  =  _json['nome']
        _velocidade =  _json['velocidade']
        _preco   =  _json['preco']
        _disponibilidade =  _json['disponibilidade']
        if _nome and _velocidade and _preco and _disponibilidade and request.method == 'POST':
            conn = mysql.connect()
            cursor = conn.cursor(pymysql.cursors.DictCursor)
            sqlQuery = "CALL adicionar_produto (%s, %s, %s, %s);"
            bindData = (_nome, _velocidade, _preco, _disponibilidade)
            cursor.execute(sqlQuery, bindData)
            conn.commit()
            response = jsonify('Produto adicionado!')
            response.status_code = 200
            return response
        else:
            return showMessage()
    except Exception as e:
        print(e)
    finally:
        cursor.close()
        conn.close()

@app.route('/read/ler_produto', methods=['GET'])
@auth.login_required
def ler_produto():
    try:
        _json = request.json
        _id   = _json['id']
        if _id and request.method == 'GET':
            conn = mysql.connect()
            cursor = conn.cursor(pymysql.cursors.DictCursor)
            cursor.execute("CALL ler_produto (%s)", (_id,))
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

@app.route('/read/ler_produtos', methods=['GET'])
@auth.login_required
def ler_produtos():
    try:
        if request.method == 'GET':
            conn = mysql.connect()
            cursor = conn.cursor(pymysql.cursors.DictCursor)
            cursor.execute("CALL ler_produtos ()")
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

@app.route('/update/atualizar_produto', methods=['PUT'])
@auth.login_required
def atualizar_produto():
    try:
        _json  = request.json
        _id    = _json['id']
        _nome  = _json['nome']
        _velocidade = _json['velocidade']
        _preco   = _json['preco']
        _disponibilidade = _json['disponibilidade']
        if _id and _nome and _velocidade and _preco and _disponibilidade and request.method == 'PUT':
            conn = mysql.connect()
            cursor = conn.cursor()
            sqlQuery = "CALL atualizar_produto (%s, %s, %s, %s, %s)"
            bindData = (_id, _nome, _velocidade, _preco, _disponibilidade)
            cursor.execute(sqlQuery, bindData)
            conn.commit()
            response = jsonify('Produto atualizado!')
            response.status_code = 200
            return response
        else:
            return showMessage()
    except Exception as e:
        print(e)
    finally:
        cursor.close()
        conn.close()

@app.route('/delete/apagar_produto', methods=['DELETE'])
@auth.login_required
def apagar_produto():
    try:
        _json = request.json
        _id   = _json['id']
        conn  = mysql.connect()
        cursor = conn.cursor()
        cursor.execute("CALL apagar_produto (%s)", (_id,))
        conn.commit()
        response = jsonify('Produto apagado!')
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
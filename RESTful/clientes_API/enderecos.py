import pymysql
from app import app
from config import mysql
from flask import jsonify, request
from auth import auth

@app.route('/create/adicionar_endereco', methods=['POST'])
@auth.login_required
def adicionar_endereco():
    try:
        _json    = request.json
        _user_id = _json['user_id']
        _cep     = _json['cep']
        _cidade  = _json['cidade']
        _rua     = _json['rua']
        _numero  = _json['numero']
        _ap      = _json['ap']
        if _user_id and _cep and _cidade and _rua and _numero and _ap and request.method == 'POST':
            conn = mysql.connect()
            cursor = conn.cursor(pymysql.cursors.DictCursor)
            sqlQuery = "CALL adicionar_endereco (%s, %s, %s, %s, %s, %s)"
            bindData = (_user_id, _cep, _cidade, _rua, _numero, _ap)
            cursor.execute(sqlQuery, bindData)
            conn.commit()
            response = jsonify('Endereco adicionado!')
            response.status_code = 200
            return response
        else:
            return showMessage()
    except Exception as e:
        print(e)
    finally:
        cursor.close()
        conn.close()

@app.route('/read/ler_endereco', methods=['GET'])
@auth.login_required
def ler_endereco():
    try:
        _json = request.json
        _id   = _json['id']
        if _id and request.method == 'GET':
            conn = mysql.connect()
            cursor = conn.cursor(pymysql.cursors.DictCursor)
            cursor.execute("CALL ler_endereco (%s)", (_id,))
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

@app.route('/read/ler_enderecos', methods=['GET'])
@auth.login_required
def ler_enderecos():
    try:
        if request.method == 'GET':
            conn = mysql.connect()
            cursor = conn.cursor(pymysql.cursors.DictCursor)
            cursor.execute("CALL ler_enderecos ()")
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

@app.route('/update/atualiza_endereco', methods=['PUT'])
@auth.login_required
def atualizar_endereco():
    try:
        _json   = request.json
        _id     = _json['id']
        _cep    = _json['cep']
        _cidade = _json['cidade']
        _rua    = _json['rua']
        _numero = _json['numero']
        _ap     = _json['ap']
        if _id and _cep and _cidade and _rua and _numero and _ap and request.method == 'PUT':
            conn = mysql.connect()
            cursor = conn.cursor(pymysql.cursors.DictCursor)
            sqlQuery = "CALL atualizar_endereco (%s, %s, %s, %s, %s, %s)"
            bindData = (_id, _cep, _cidade, _rua, _numero, _ap)
            cursor.execute(sqlQuery, bindData)
            conn.commit()
            response = jsonify('Endereco atualizado!')
            response.status_code = 200
            return response
        else:
            return showMessage()
    except Exception as e:
        print(e)
    finally:
        cursor.close()
        conn.close()

@app.route('/delete/apagar_endereco', methods=['DELETE'])
@auth.login_required
def apagar_endereco():
    try:
        _json = request.json
        _id   = _json['id']
        conn  = mysql.connect()
        cursor = conn.cursor()
        cursor.execute("CALL apagar_endereco (%s)", (_id,))
        conn.commit()
        response = jsonify('Endereco apagado!')
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
import pymysql
from app import app
from config import mysql
from flask import jsonify
from flask import flash, request

@app.route('/create/adicionar_cliente', methods=['POST'])
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
            respone = jsonify('Employee added successfully!')
            respone.status_code = 200
            return respone
        else:
            return showMessage()
    except Exception as e:
        print(e)
    finally:
        cursor.close() 
        conn.close()          

@app.route('/create/adicionar_endereco', methods=['POST'])
def adicionar_endereco():
    try:        
        _json  =  request.json
        _user_id  =  _json['user_id']
        _cep =  _json['cep']
        _cidade   =  _json['cidade']
        _rua =  _json['rua']
        _numero =  _json['numero']
        _ap = _json['ap']	
        if _user_id and _cep and _cidade and _rua and _numero and _ap and request.method == 'POST':
            conn = mysql.connect()
            cursor = conn.cursor(pymysql.cursors.DictCursor)		
            sqlQuery = "CALL adicionar_endereco (%s, %s, %s, %s, %s, %s)"
            bindData = (_user_id, _cep, _cidade, _rua, _numero, _ap)            
            cursor.execute(sqlQuery, bindData)
            conn.commit()
            respone = jsonify('Endereco adicionado!')
            respone.status_code = 200
            return respone
        else:
            return showMessage()
    except Exception as e:
        print(e)
    finally:
        cursor.close() 
        conn.close()       
 
@app.route('/read/ler_cliente', methods = ['GET'])
def ler_cliente():
    try:
        _json  =  request.json
        _id  =  _json['id']
        if _id and request.method == 'GET':
            conn = mysql.connect()
            cursor = conn.cursor(pymysql.cursors.DictCursor)
            cursor.execute("CALL ler_cliente (%s)", _id)
            empRow = cursor.fetchone()
            respone = jsonify(empRow)
            respone.status_code = 200
        return respone
    except Exception as e:
        print(e)
    finally:
        cursor.close() 
        conn.close() 

@app.route('/read/ler_clientes', methods = ['GET'])
def ler_clientes():
    try:
        if request.method == 'GET':
            conn = mysql.connect()
            cursor = conn.cursor(pymysql.cursors.DictCursor)
            cursor.execute("CALL ler_clientes ()")
            empRow = cursor.fetchall()
            respone = jsonify(empRow)
            respone.status_code = 200
        return respone
    except Exception as e:
        print(e)
    finally:
        cursor.close() 
        conn.close() 

@app.route('/read/ler_endereco', methods = ['GET'])
def ler_endereco():
    try:
        _json  =  request.json
        _id  =  _json['id']
        if _id and request.method == 'GET':
            conn = mysql.connect()
            cursor = conn.cursor(pymysql.cursors.DictCursor)
            cursor.execute("CALL ler_endereco (%s)", (_id,))
            empRow = cursor.fetchone()
            respone = jsonify(empRow)
            respone.status_code = 200
        return respone
    except Exception as e:
        print(e)
    finally:
        cursor.close() 
        conn.close()

@app.route('/read/ler_enderecos', methods = ['GET'])
def ler_enderecos():
    try:
        if request.method == 'GET':
            conn = mysql.connect()
            cursor = conn.cursor(pymysql.cursors.DictCursor)
            cursor.execute("CALL ler_enderecos ()")
            empRow = cursor.fetchone()
            respone = jsonify(empRow)
            respone.status_code = 200
        return respone
    except Exception as e:
        print(e)
    finally:
        cursor.close() 
        conn.close() 

@app.route('/update/atualiza_cliente', methods=['PUT'])
def atualizar_cliente():
    try:
        _json = request.json
        _id = _json['id']
        _nome = _json['nome']
        _idade = _json['idade']
        _cpf = _json['cpf']
        _email = _json['email']
        if _id and _nome and _idade and _cpf and _email and request.method == 'PUT':			
            sqlQuery = "CALL atualizar_cliente (%s,%s, %s, %s, %s)"
            bindData = (_id, _nome, _idade, _cpf, _email)
            conn = mysql.connect()
            cursor = conn.cursor()
            cursor.execute(sqlQuery, bindData)
            conn.commit()
            respone = jsonify('Cliente atualizado!')
            respone.status_code = 200
            return respone
        else:
            return showMessage()
    except Exception as e:
        print(e)
    finally:
        cursor.close() 
        conn.close() 

@app.route('/update/atualiza_endereco', methods=['PUT'])
def atualizar_endereco():
    try:        
        _json  =  request.json
        _id  =  _json['id']
        _cep =  _json['cep']
        _cidade   =  _json['cidade']
        _rua =  _json['rua']
        _numero =  _json['numero']
        _ap = _json['ap']	
        if _id and _cep and _cidade and _rua and _numero and _ap and request.method == 'PUT':
            conn = mysql.connect()
            cursor = conn.cursor(pymysql.cursors.DictCursor)		
            sqlQuery = "CALL atualizar_endereco (%s, %s, %s, %s, %s, %s)"
            bindData = (_id, _cep, _cidade, _rua, _numero, _ap)            
            cursor.execute(sqlQuery, bindData)
            conn.commit()
            respone = jsonify('Endereco atualizado!')
            respone.status_code = 200
            return respone
        else:
            return showMessage()
    except Exception as e:
        print(e)
    finally:
        cursor.close() 
        conn.close()     

@app.route('/delete/apagar_cliente', methods=['DELETE'])
def apagar_cliente():
    try:
        _json  =  request.json
        _id  =  _json['id']
        conn = mysql.connect()
        cursor = conn.cursor()
        cursor.execute("CALL apagar_cliente (%s)", (_id))
        conn.commit()
        respone = jsonify('Cliente apagado!')
        respone.status_code = 200
        return respone
    except Exception as e:
        print(e)
    finally:
        cursor.close() 
        conn.close()

@app.route('/delete/apagar_endereco', methods=['DELETE'])
def apagar_endereco():
    try:
        _json  =  request.json
        _id  =  _json['id']
        conn = mysql.connect()
        cursor = conn.cursor()
        cursor.execute("CALL apagar_endereco (%s)", (_id,))
        conn.commit()
        respone = jsonify('Endereco apagado!')
        respone.status_code = 200
        return respone
    except Exception as e:
        print(e)
    finally:
        cursor.close() 
        conn.close()
       
@app.errorhandler(404)
def showMessage(error=None):
    message = {
        'status': 404,
        'message': 'Record not found: ' + request.url,
    }
    respone = jsonify(message)
    respone.status_code = 404
    return respone
        
if __name__ == "__main__":
    app.run()
import pymysql
from app import app
from config import mysql
from flask import jsonify
from flask import flash, request

@app.route('/create', methods=['POST'])
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
     
 
@app.route('/read', methods = ['GET'])
def emp_details(nome_cliente):
    try:
        _json  =  request.json
        _nome  =  _json['nome']
        if _nome and request.method == '':
            conn = mysql.connect()
            cursor = conn.cursor(pymysql.cursors.DictCursor)
            cursor.execute("CALL ler_cliente (%s)", _nome)
            empRow = cursor.fetchone()
            respone = jsonify(empRow)
            respone.status_code = 200
        return respone
    except Exception as e:
        print(e)
    finally:
        cursor.close() 
        conn.close() 

@app.route('/update', methods=['PUT'])
def atualizar_cliente():
    try:
        _json = request.json
        _nome = _json['nome']
        _idade = _json['idade']
        _cpf = _json['cpf']
        _email = _json['email']
        if _nome and _idade and _cpf and _email and request.method == 'PUT':			
            sqlQuery = "CALL atualizar_cliente (%s, %s, %s, %s)"
            bindData = (_nome, _idade, _cpf, _email)
            conn = mysql.connect()
            cursor = conn.cursor()
            cursor.execute(sqlQuery, bindData)
            conn.commit()
            respone = jsonify('Employee updated successfully!')
            respone.status_code = 200
            return respone
        else:
            return showMessage()
    except Exception as e:
        print(e)
    finally:
        cursor.close() 
        conn.close() 

@app.route('/delete/', methods=['DELETE'])
def apagar_cliente(nome_cliente):
	try:
		conn = mysql.connect()
		cursor = conn.cursor()
		cursor.execute("CALL apagar_cliente (%s)", (nome_cliente,))
		conn.commit()
		respone = jsonify('Employee deleted successfully!')
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
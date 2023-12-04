from functools import wraps
from flask import Flask, request, jsonify, render_template, session, url_for, redirect
from flask_cors import CORS
from mysql.connector import Error
from flask_mail import Mail, Message
from itsdangerous import BadSignature, SignatureExpired, URLSafeTimedSerializer
import hashlib
import mysql.connector
import os
import bcrypt
import re


DB_HOST = os.environ.get('DB_HOST', 'localhost') 
DB_PORT = int(os.environ.get('DB_PORT', 3306))    
DB_USER = os.environ.get('DB_USER', 'root')      
DB_PASSWORD = os.environ.get('DB_PASSWORD', 'Vof09325')  
DB_NAME = os.environ.get('DB_NAME', 'db_app_b')  



app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}}) 

mail = Mail(app)

app.config['SECRET_KEY'] = '\x0b\x10fj\x14g\xf7\xd1\x8eh'
serializer = URLSafeTimedSerializer(app.config['SECRET_KEY'])

def get_db_connection():
    return mysql.connector.connect(
        host=DB_HOST,
        port=DB_PORT,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME
    )

def create_tables():
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute('''
                CREATE TABLE IF NOT EXISTS cadastro (
                    id INT AUTO_INCREMENT,
                    usuario VARCHAR(255),
                    email VARCHAR(255),
                    senha VARCHAR(255),
                    departamento VARCHAR(255),
                    PRIMARY KEY(id)
                )
            ''')
            conn.commit()
         
create_tables()

def is_valid_email(email):
    return re.match(r"[^@]+@[^@]+\.[^@]+", email)



# Rotas
@app.route('/cadastro', methods=['POST'])
def cadastro():
    try:
        data = request.json
        if 'usuario' not in data or 'email' not in data or 'senha' not in data or 'departamento' not in data:
            return jsonify({"success": False, "message": "Dados incompletos"})

        usuario = data['usuario']
        email = data['email']
        senha = bcrypt.hashpw(data['senha'].encode('utf-8'), bcrypt.gensalt())
        departamento = data['departamento']

        if not is_valid_email(email):
            return jsonify({"success": False, "message": "Email inválido"})

        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute('SELECT * FROM cadastro WHERE email = %s', (email,))
                if cursor.fetchone():
                    return jsonify({"success": False, "message": "Email já cadastrado"})

                cursor.execute('INSERT INTO cadastro (usuario, email, senha, departamento) VALUES (%s, %s, %s, %s)', 
                               (usuario, email, senha, departamento))
                conn.commit()
                return jsonify({"success": True, "message": "Usuário cadastrado com sucesso"})

    except Exception as e:
        print(e)
        return jsonify({"success": False, "message": "Erro ao processar a solicitação"})
    

@app.route('/login', methods=['POST'])
def login():
    try:
        data = request.json
        usuario = data.get('usuario')
        senha = data.get('senha')

        if not usuario or not senha:
            return jsonify({"success": False, "message": "Usuário e senha são obrigatórios"})

        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute(
                    'SELECT senha FROM cadastro WHERE usuario = %s', (usuario,))
                user_record = cursor.fetchone()

                if user_record and bcrypt.checkpw(senha.encode('utf-8'), user_record[0].encode('utf-8')):
                    return jsonify({"success": True, "message": "Login bem-sucedido"})
                else:
                    return jsonify({"success": False, "message": "Usuário ou senha incorretos"})
    except Exception as e:
        print(e)
        return jsonify({"success": False, "message": "Erro ao processar a solicitação"})

    
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3001) 
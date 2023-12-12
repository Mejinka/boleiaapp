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

from datetime import timedelta, datetime, time


DB_HOST = os.environ.get('DB_HOST', 'localhost') 
DB_PORT = int(os.environ.get('DB_PORT', 3306))    
DB_USER = os.environ.get('DB_USER', 'root')      
DB_PASSWORD = os.environ.get('DB_PASSWORD', 'Vof09325')  
DB_NAME = os.environ.get('DB_NAME', 'db_app_b')  



app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}}) 

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
                    escolha VARCHAR(255),
                    PRIMARY KEY(id)
                )
            ''')
                       
            cursor.execute('''
                CREATE TABLE IF NOT EXISTS colaboradores (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    usuario VARCHAR(255),
                    rotaAtual VARCHAR(255),
                    hora TIME,
                    escolha VARCHAR(255),
                    departamento VARCHAR(255)
                )
            ''')  
            cursor.execute('''
                CREATE TABLE IF NOT EXISTS rotas (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    motorista_id INT,
                    descricao VARCHAR(255),
                    FOREIGN KEY (motorista_id) REFERENCES colaboradores(id) ON DELETE CASCADE
                )
            ''')           
            conn.commit()   
create_tables()

def is_valid_email(email):
    return re.match(r"[^@]+@[^@]+\.[^@]+", email)


@app.route('/add_rota', methods=['POST'])
def add_rota():
    data = request.json
    motorista_id = data.get('motorista_id')
    descricao = data.get('descricao')

    if not motorista_id or not descricao:
        return jsonify({"success": False, "message": "Motorista ID e descrição são obrigatórios"})

    try:
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute('INSERT INTO rotas (motorista_id, descricao) VALUES (%s, %s)', 
                               (motorista_id, descricao))
                conn.commit()
                return jsonify({"success": True, "message": "Rota adicionada com sucesso"})
    except Exception as e:
        print(e)
        return jsonify({"success": False, "message": "Erro ao adicionar rota"})

    return jsonify({"success": False, "message": "Erro ao processar a solicitação"})


@app.route('/motoristas', methods=['GET'])
def get_motoristas():
    try:
        with get_db_connection() as conn:
            with conn.cursor(dictionary=True) as cursor:
                # Selecione os usuários da tabela 'cadastro' onde a escolha é 'motorista'
                cursor.execute("SELECT id, usuario, rotaAtual, hora, escolha, departamento FROM colaboradores WHERE escolha = 'Motorista'")
                motoristas = cursor.fetchall()
                for motorista in motoristas:
                    motorista['hora'] = str(motorista['hora'])
                return jsonify(motoristas)
    except Exception as e:
        print(e)
        return jsonify({"success": False, "message": "Erro ao buscar motoristas"}), 500


@app.route('/cadastro', methods=['POST'])
def cadastro():
    try:
        data = request.json
        if 'usuario' not in data or 'email' not in data or 'senha' not in data or 'departamento' not in data or 'escolha' not in data:
            return jsonify({"success": False, "message": "Dados incompletos"})

        usuario = data['usuario']
        email = data['email']
        senha = data['senha']
        departamento = data['departamento']
        escolha = data['escolha']

        if not is_valid_email(email):
            return jsonify({"success": False, "message": "Email inválido"})

        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute('SELECT * FROM cadastro WHERE email = %s', (email,))
                if cursor.fetchone():
                    return jsonify({"success": False, "message": "Email já cadastrado"})

                # Insere na tabela cadastro
                cursor.execute('INSERT INTO cadastro (usuario, email, senha, departamento, escolha) VALUES (%s, %s, %s, %s, %s)', 
                               (usuario, email, senha, departamento, escolha))
                conn.commit()

                # Se a escolha for 'motorista', insere na tabela motoristas
                if escolha == 'Motorista':
                    cursor.execute('INSERT INTO colaboradores (usuario, escolha, departamento) VALUES (%s, %s, %s)', (usuario, escolha, departamento))
                    conn.commit()

                return jsonify({"success": True, "message": "Utilizador cadastrado com sucesso"})

    except Exception as e:
        print(e)
        return jsonify({"success": False, "message": "Erro ao processar a solicitação"})

    return jsonify({"success": False, "message": "Erro ao cadastrar usuário"})


@app.route('/login', methods=['POST'])
def login():
    try:
        data = request.json
        usuario = data.get('usuario')
        senha = data.get('senha')

        if not usuario or not senha:
            return jsonify({"success": False, "message": "Utilizador e Password são obrigatórios"})

        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute(
                    'SELECT senha, usuario, departamento, escolha FROM cadastro WHERE usuario = %s', (usuario,))
                user_record = cursor.fetchone()

                if user_record and user_record[0] == senha:
                    return jsonify({
                        "success": True, 
                        "message": "Login bem-sucedido",
                        "usuario": user_record[1],
                        "departamento": user_record[2],
                        "escolha": user_record[3]  # Por exemplo, 'Motorista', 'Administrador', etc.

                    })
                else:
                    return jsonify({"success": False, "message": "Utilizador ou Password incorretos"})

    except Exception as e:
        print(e)
        return jsonify({"success": False, "message": "Erro ao processar a solicitação"})

@app.route('/recsenha', methods=['POST'])
def recsenha():
    data = request.json
    email = data['email']

    if not is_valid_email(email):
        return jsonify({"success": False, "message": "Email inválido"})
        
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute('SELECT * FROM cadastro WHERE email = %s', (email,))
            if cursor.fetchone():
                # Email encontrado
                return jsonify({"success": True, "message": "Email encontrado"})
            else:
                # Email não encontrado
                return jsonify({"success": False, "message": "Email não cadastrado"})
@app.route('/update_password', methods=['POST'])
def update_password():
    data = request.json
    email = data.get('email')
    novaSenha = data.get('novaSenha')

    if not email or not novaSenha:
        return jsonify({"success": False, "message": "Email ou Password ausentes"})

    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute('UPDATE cadastro SET senha = %s WHERE email = %s', (novaSenha, email))
            conn.commit()
            if cursor.rowcount > 0:
                return jsonify({"success": True, "message": "Password atualizada com sucesso"})
            else:
                return jsonify({"success": False, "message": "Email não encontrado"})

    return jsonify({"success": False, "message": "Erro ao atualizar senha"})

@app.route('/usuario/<nome_usuario>', methods=['GET'])
def get_usuario(nome_usuario):
    try:
        with get_db_connection() as conn:
            with conn.cursor(dictionary=True) as cursor:
                cursor.execute("SELECT usuario, departamento, escolha FROM cadastro WHERE usuario = %s", (nome_usuario,))
                usuario = cursor.fetchone()
                if usuario:
                    return jsonify(usuario)
                else:
                    return jsonify({"success": False, "message": "Usuário não encontrado"}), 404
    except Exception as e:
        print(e)
        return jsonify({"success": False, "message": "Erro ao buscar usuário"}), 500

    
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3001) 
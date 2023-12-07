import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'home/home.dart';

class ApiService {
  final String _baseUrl = 'http://192.168.2.121:3001';
  Future<Map<String, dynamic>> registerUser(String usuario, String email,
      String senha, String departamento, String dropdownValueM) async {
    final url = Uri.parse('$_baseUrl/cadastro');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'usuario': usuario,
        'email': email,
        'senha': senha,
        'departamento': departamento,
        'escolha': dropdownValueM,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return {
        'success': responseData['success'],
        'message': responseData['message']
      };
    }
    return {'success': false, 'message': 'Erro na comunicação com o servidor'};
  }

  Future<Map<String, dynamic>> loginUser(String usuario, String senha) async {
    final url = Uri.parse('$_baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'usuario': usuario,
        'senha': senha,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return {
        'success': responseData['success'],
        'message': responseData['message'],
        'usuario': responseData['usuario'],
        'departamento': responseData['departamento']
      };
    }
    return {'success': false, 'message': 'Erro na comunicação com o servidor'};
  }

  Future<Map<String, dynamic>> recoverPassword(String email) async {
    final url = Uri.parse('$_baseUrl/recsenha');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return {
        'success': responseData['success'],
        'message': responseData['message']
      };
    }
    return {'success': false, 'message': 'Erro na comunicação com o servidor'};
  }

  Future<Map<String, dynamic>> updatePassword(
      String email, String novaSenha) async {
    final url = Uri.parse('$_baseUrl/update_password');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'novaSenha': novaSenha}),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return {
        'success': responseData['success'],
        'message': responseData['message']
      };
    }
    return {'success': false, 'message': 'Erro na comunicação com o servidor'};
  }

  Future<List<Motorista>> getMotoristas() async {
    final url = Uri.parse('$_baseUrl/motoristas');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> motoristasJson = json.decode(response.body) as List;
      return motoristasJson.map((json) => Motorista.fromJson(json)).toList();
    } else {
      // Se a resposta não for bem-sucedida, lançar uma exceção
      throw Exception('Erro ao carregar motoristas: ${response.statusCode}');
    }
  }
}

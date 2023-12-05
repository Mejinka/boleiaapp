import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String _baseUrl =
      'http://192.168.2.121:3001'; // Substitua com a URL da sua API

  Future<Map<String, dynamic>> registerUser(
      String usuario, String email, String senha, String departamento) async {
    final url = Uri.parse('$_baseUrl/cadastro');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'usuario': usuario,
        'email': email,
        'senha': senha,
        'departamento': departamento,
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
        'message': responseData['message']
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
}

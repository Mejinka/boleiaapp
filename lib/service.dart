import 'dart:convert';
import 'package:app_boleia/home/home_motorista.dart';
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
      print('ID do usuário: ${responseData['id']}');

      if (responseData['success']) {
        // Salvar informações do usuário nas SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', responseData['usuario']);
        await prefs.setString('userdep', responseData['departamento']);
        await prefs.setString('usertype', responseData['escolha']);
        await prefs.setString('motoristaId', responseData['id'].toString());
      }
      return {
        'success': responseData['success'],
        'message': responseData['message'],
        'id': responseData['id'],
        'usuario': responseData['usuario'],
        'departamento': responseData['departamento'],
        'escolha': responseData['escolha'],
      };
    } else {
      return {
        'success': false,
        'message': 'Erro na comunicação com o servidor',
      };
    }
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

  Future<Map<String, dynamic>> getUserInfo(String nomeUsuario) async {
    final url = Uri.parse('$_baseUrl/usuario/$nomeUsuario');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return {
        'success': true,
        'usuario': responseData['usuario'],
        'departamento': responseData['departamento'],
        'escolha': responseData['escolha'],
      };
    } else {
      return {
        'success': false,
        'message': 'Erro ao buscar informações do usuário'
      };
    }
  }

  Future<Map<String, dynamic>> saveRotas(
      String motoristaId, List<Rota> rotas) async {
    final url = Uri.parse(
        '$_baseUrl/add_rota'); // Substitua pela URL correta do seu endpoint

    List<Map<String, dynamic>> rotasData =
        rotas.map((rota) => {'descricao': rota.descricao}).toList();

    // Adicionando print para depurar as rotas
    print('Rotas a serem salvas: $rotasData');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'motoristaId': motoristaId,
        'rotas': rotasData,
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

  Future<List<Rota>> getRotas(String motoristaId) async {
    final url = Uri.parse('$_baseUrl/get_rotas/$motoristaId');
    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success']) {
        final rotasJson = responseData['rotas'] as List;
        return rotasJson
            .map((json) => Rota.fromJson(json as List<dynamic>))
            .toList();
      } else {
        throw Exception('Falha ao buscar rotas');
      }
    } else {
      throw Exception('Erro ao carregar rotas: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> updateRota(
      String rotaId, String descricao) async {
    final url = Uri.parse('$_baseUrl/update_rota/$rotaId');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'descricao': descricao}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro ao atualizar rota: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> deleteRota(String rotaId) async {
    final url = Uri.parse('$_baseUrl/delete_rota/$rotaId');
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro ao deletar rota: ${response.statusCode}');
    }
  }
}

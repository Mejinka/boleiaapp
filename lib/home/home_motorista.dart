import 'dart:io';
import 'dart:async';

import 'package:app_boleia/layout.dart';
import 'package:app_boleia/login/login.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service.dart';
import 'details.dart';

class MotoristaPage extends StatefulWidget {
  const MotoristaPage({super.key});

  @override
  State<MotoristaPage> createState() => _MotoristaPageState();
}

class Motoristas {
  final String nome;
  final String rotaAtual;
  final String departamento;
  final String escolha;
  String hora;

  Motoristas({
    required this.nome,
    required this.rotaAtual,
    required this.departamento,
    required this.escolha,
    required this.hora,
  });
}

String formatTime(String time) {
  try {
    // Supondo que a hora esteja em formato "HH:mm:ss"
    final DateTime parsedTime = DateFormat("HH:mm:ss").parse(time);
    return DateFormat("HH:mm").format(parsedTime);
  } catch (e) {
    // Em caso de erro, retorne a hora original ou um placeholder
    return time;
  }
}

class Rota {
  String? id;
  String descricao;
  bool isModified;

  Rota({this.id, required this.descricao, this.isModified = false});

  factory Rota.fromJson(List<dynamic> json) {
    // Ajuste os índices conforme necessário
    var id = json[0];
    String? idStr;

    if (id != null) {
      idStr = id.toString();
    }

    return Rota(
      id: idStr,
      descricao:
          json[2].toString(), // Assumindo que a descrição é o terceiro elemento
    );
  }
}

class _MotoristaPageState extends State<MotoristaPage> {
  List<Motoristas> _motoristas = [];
  Timer? _timer;
  Future<List<Motoristas>>? _futureMotoristas;
  bool _areButtonsVisible = false;

  Future<bool> _confirmExit() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Sair'),
            content: const Text('Você realmente deseja sair?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Não'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  SystemNavigator.pop();
                },
                child: const Text('Sim'),
              ),
            ],
          ),
        )) ??
        false;
  }

  ApiService apiService = ApiService();

  String _username = '';
  String _userdep = '';
  String _usertype = '';
  List<Rota> _rotas = [];

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _fetchRotas(); // Adiciona a chamada para buscar as rotas
  }

  Future<void> _fetchRotas() async {
    final prefs = await SharedPreferences.getInstance();
    final motoristaId = prefs.getInt('motoristaId')?.toString() ?? '';
    if (motoristaId.isNotEmpty) {
      print(
          'Buscando rotas para o motoristaId: $motoristaId'); // Adicione esta linha

      try {
        final rotas = await apiService.getRotas(motoristaId);
        setState(() {
          _rotas = rotas;
        });
      } catch (e) {
        // Trate erros adequadamente
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }

  void _addNewRota() async {
    String novaDescricao = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar Nova Rota'),
          content: TextFormField(
            onChanged: (value) {
              novaDescricao = value;
            },
            decoration: InputDecoration(
              hintText: 'Descrição da Rota',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (novaDescricao.isNotEmpty) {
                  setState(() {
                    _rotas.add(Rota(descricao: novaDescricao));
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void _removeLastRota() async {
    if (_rotas.isNotEmpty) {
      Rota ultimaRota = _rotas.last;

      try {
        final response = await apiService.deleteRota(ultimaRota.id!);
        if (response['success']) {
          setState(() {
            _rotas.removeLast();
          });
        } else {
          // Lide com o erro, talvez mostrando uma mensagem ao usuário
        }
      } catch (e) {
        // Lide com exceções, talvez mostrando uma mensagem de erro
      }
    }
  }

  void _saveRotas() async {
    final prefs = await SharedPreferences.getInstance();
    int motoristaId = prefs.getInt('motoristaId') ?? 0;

    if (motoristaId == 0) {
      _showErrorDialog('ID do motorista não encontrado.');
      return;
    }

    try {
      // Dividir as rotas em novas e existentes
      List<Rota> novasRotas = _rotas.where((rota) => rota.id == null).toList();
      List<Rota> rotasExistentes =
          _rotas.where((rota) => rota.id != null && rota.isModified).toList();

      // Processar novas rotas
      for (var rota in novasRotas) {
        await apiService.createRota(motoristaId.toString(), rota.descricao);
      }

      // Processar rotas existentes
      for (var rota in rotasExistentes) {
        await apiService.updateRota(rota.id!, rota.descricao);
      }

      _showSuccessDialog();
    } catch (e) {
      _showErrorDialog('Erro ao salvar rotas: $e');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sucesso'),
        content: Text('Rotas salvas com sucesso!'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Erro'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _toggleButtons() {
    setState(() {
      _areButtonsVisible = !_areButtonsVisible;
    });
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? 'Usuário Anônimo';
    String userdep = prefs.getString('userdep') ?? 'Cargo Anônimo';
    String usertype = prefs.getString('usertype') ?? 'Cargo Anônimo';

    setState(() {
      _username = username;
      _userdep = userdep;
      _usertype = usertype;
    });
  }

  void _editRota(int index) async {
    String novaDescricao = _rotas[index].descricao;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Rota'),
          content: TextFormField(
            initialValue: _rotas[index].descricao,
            onChanged: (value) {
              novaDescricao = value;
            },
            decoration: InputDecoration(
              hintText: 'Descrição da Rota',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (novaDescricao.isNotEmpty &&
                    novaDescricao != _rotas[index].descricao) {
                  if (_rotas[index].id != null) {
                    try {
                      final response = await apiService.updateRota(
                          _rotas[index].id!, novaDescricao);
                      if (response['success']) {
                        setState(() {
                          _rotas[index].descricao = novaDescricao;
                          _rotas[index].isModified =
                              true; // Marcar como modificada
                        });
                      }
                    } catch (e) {
                      // Tratar erros adequadamente
                    }
                  }
                  Navigator.of(context).pop();
                }
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Limpa todas as informações armazenadas

    // Redirecione para a tela de login ou inicial
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) =>
          LoginPage(), // Substitua TelaDeLogin pela sua tela de login
    ));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: _confirmExit,
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(200, 23, 135, 172),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            child: CircleAvatar(
                                backgroundColor:
                                    const Color.fromARGB(200, 23, 135, 172),
                                radius: 30.0,
                                child: Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.white,
                                )),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            _username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            _usertype,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.add_circle),
                      title: const Text('Iniciar Procedimento'),
                      onTap: () {
                        Navigator.pop(context);

                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const IniciarProc()),
                        //   );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.calculate),
                      title: const Text('Calculadora'),
                      onTap: () {
                        Navigator.pop(context);

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => const Calculadora()),
                        // );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Sair'),
                      onTap: _logout,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.blueGrey.shade800),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
        appBar: appBar(
          title: 'MotoristaPage',
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Center(
              heightFactor: 1.1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                      backgroundColor: const Color.fromARGB(200, 23, 135, 172),
                      radius: 50.0,
                      child: const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      )),
                  const SizedBox(height: 15.0),
                  Text(
                    _username,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    _userdep,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    _usertype,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount:
                    _rotas.length + 1, // Adiciona 1 para o botão de salvar
                itemBuilder: (context, index) {
                  if (index == _rotas.length) {
                    // Botão para salvar as rotas
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: _saveRotas,
                        child: Text('Salvar Rotas'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                    );
                  }

                  // Retorna o Card para cada rota com a funcionalidade de edição
                  return GestureDetector(
                    onTap: () => _editRota(index),
                    child: Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                            'Rota ${index + 1}: ${_rotas[index].descricao}'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Visibility(
              visible: _areButtonsVisible,
              child: FloatingActionButton(
                heroTag: "addBtn",
                onPressed: _addNewRota,
                child: Icon(Icons.add),
              ),
            ),
            SizedBox(height: 10), // Espaçamento entre os botões
            Visibility(
              visible: _areButtonsVisible,
              child: FloatingActionButton(
                heroTag: "removeBtn",
                onPressed: _removeLastRota,
                child: Icon(Icons.remove),
                backgroundColor: Colors.red,
              ),
            ),
            SizedBox(height: 10), // Espaçamento entre os botões
            FloatingActionButton(
              heroTag: "toggleBtn",
              onPressed: _toggleButtons,
              child: Icon(_areButtonsVisible ? Icons.close : Icons.menu),
            ),
          ],
        ),
      ),
    );
  }
}

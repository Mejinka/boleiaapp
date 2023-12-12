import 'dart:io';
import 'dart:async';

import 'package:app_boleia/layout.dart';

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
  String descricao;

  Rota({required this.descricao});
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
  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }

  void _addNewRota() {
    setState(() {
      _rotas.add(Rota(descricao: 'Nova Rota'));
    });
  }

  void _removeLastRota() {
    if (_rotas.isNotEmpty) {
      setState(() {
        _rotas.removeLast();
      });
    }
  }

  void _saveRotas() async {
    final prefs = await SharedPreferences.getInstance();
    String motoristaId = prefs.getString('motoristaId') ?? '';

    if (motoristaId.isEmpty) {
      _showErrorDialog('ID do motorista não encontrado.');
      return;
    }

    try {
      ApiService apiService = ApiService();
      Map<String, dynamic> response =
          await apiService.saveRotas(motoristaId, _rotas);
      if (response['success']) {
        _showSuccessDialog();
      } else {
        _showErrorDialog(response['message']);
      }
    } catch (e) {
      _showErrorDialog(e.toString());
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

  List<Rota> _rotas =
      List.generate(5, (index) => Rota(descricao: 'Rota ${index + 1}'));

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
                          backgroundColor:
                              const Color.fromARGB(200, 23, 135, 172),
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
                        // Se for o último item, retorna um botão para salvar as rotas
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            onPressed: _saveRotas,
                            child: Text('Salvar Rotas'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity,
                                  50), // Torna o botão mais largo
                            ),
                          ),
                        );
                      }

                      // Retorna o Card para cada rota
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          title: TextFormField(
                            initialValue: _rotas[index].descricao,
                            decoration: InputDecoration(
                              labelText: 'Descrição da Rota ${index + 1}',
                            ),
                            onChanged: (value) {
                              setState(() {
                                _rotas[index].descricao = value;
                              });
                            },
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
                ])));
  }
}

import 'dart:io';
import 'dart:async';

import 'package:app_boleia/layout.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service.dart';
import 'details.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class Motorista {
  final String nome;
  final String rotaAtual;
  final String departamento;
  final String escolha;
  String hora;

  Motorista({
    required this.nome,
    required this.rotaAtual,
    required this.departamento,
    required this.escolha,
    required this.hora,
  });

  factory Motorista.fromJson(Map<String, dynamic> json) {
    return Motorista(
      nome: json['usuario'] ??
          'Nome Indisponível', // Valores padrão para campos nulos
      rotaAtual: json['rotaAtual'] ?? 'Rota Indisponível',
      departamento: json['departamento'] ?? 'Hora Indisponível',
      escolha: json['escolha'] ?? 'Hora Indisponível',
      hora: json['hora'] ?? 'Hora Indisponível',
    );
  }
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

class _HomeState extends State<Home> {
  List<Motorista> _motoristas = [];
  Timer? _timer;
  Future<List<Motorista>>? _futureMotoristas;

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
    _startPolling();
    _futureMotoristas = apiService.getMotoristas(); // Armazene o future aqui
  }

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }

  void _startPolling() {
    _timer = Timer.periodic(
        Duration(seconds: 5), (Timer t) => _fetchAndUpdateMotoristas());
    _fetchAndUpdateMotoristas(); // Chame uma vez imediatamente
  }

  Future<void> _fetchAndUpdateMotoristas() async {
    try {
      var motoristas = await apiService.getMotoristas();
      if (mounted) {
        setState(() {
          _motoristas = motoristas;
        });
      }
    } catch (e) {
      // Trate a exceção, se necessário
      print(e);
    }
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
          appBar: appBar(title: 'Home'),
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
              SizedBox(
                height: 0.05 * screenheight,
              ),
              Expanded(
                child: FutureBuilder<List<Motorista>>(
                  future: _futureMotoristas,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erro: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      List<Motorista> motoristas = snapshot.data!;
                      return ListView.builder(
                        itemCount: motoristas.length,
                        itemBuilder: (context, index) {
                          var motorista = motoristas[index];
                          // Constrói o ListTile para cada motorista aqui
                          return ListTile(
                            title: Text(
                                "${motorista.nome} - ${motorista.departamento} - ${motorista.escolha}"),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${motorista.rotaAtual} "),
                                Text(
                                    "Disponível às: ${formatTime(motorista.hora)}  "),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MotoristaDetails(motorista: motorista),
                                ),
                              );
                              // Ação de tap aqui
                            },
                          );
                        },
                      );
                    } else {
                      return Center(
                          child: Text('Nenhum motorista encontrado.'));
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
}

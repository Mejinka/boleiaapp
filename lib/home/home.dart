import 'dart:io';

import 'package:app_boleia/layout.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  String _username = '';
  String _usertype = '';
  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? 'Usuário Anônimo';
    String usertype = prefs.getString('usertype') ?? 'Cargo Anônimo';

    setState(() {
      _username = username;
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
                              fontSize: 16.0,
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
                      leading: const Icon(Icons.alarm_add),
                      title: const Text('Temporizador'),
                      onTap: () {
                        Navigator.pop(context);

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => const Temp()),
                        // );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.receipt_long),
                      title: const Text('Bulário'),
                      onTap: () {
                        Navigator.pop(context);

                        //  Navigator.push(
                        //    context,
                        //    MaterialPageRoute(
                        //        builder: (context) => const Bulario()),
                        //  );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.favorite),
                      title: const Text('Favoritos'),
                      onTap: () {
                        Navigator.pop(context);

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => const Bulario()),
                        // );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.history),
                      title: const Text('Historico'),
                      onTap: () {
                        Navigator.pop(context);

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => const Bulario()),
                        // );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Configurações'),
                      onTap: () {
                        Navigator.pop(context);
                        //  Navigator.push(
                        //    context,
                        //    MaterialPageRoute(
                        //        builder: (context) => const ConfigApp()),
                        //  );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.info),
                      title: const Text('Sobre'),
                      onTap: () {
                        Navigator.pop(context);
                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) => const ProfilePage()));
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
              heightFactor: 1.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                      backgroundColor: const Color.fromARGB(200, 23, 135, 172),
                      radius: 70.0,
                      child: const Icon(
                        Icons.person,
                        size: 80,
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
            Column(
              children: <Widget>[],
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_application_1/calculadora.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

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

  @override
  Widget build(BuildContext context) {
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
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade800,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 30.0,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person,
                                size: 60, color: Colors.blueGrey.shade800),
                          ),
                          const SizedBox(height: 10.0),
                          const Text(
                            '############',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                          const Text(
                            '#################',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.calculate),
                      title: const Text('Calculadora'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Calculadora()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.favorite), //
                      title: const Text('Favoritos'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SecondPage()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.access_alarm), //
                      title: const Text('Alarme'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ThirdPage()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.info), //
                      title: const Text('Sobre'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FourthPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Ícone na parte inferior do Drawer
              Container(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.blueGrey.shade800),
                  onPressed: () {
                    Navigator.pop(context); // Fecha o Drawer
                  },
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          forceMaterialTransparency: true,
          automaticallyImplyLeading: true,
          centerTitle: true,
          iconTheme:
              const IconThemeData(color: Colors.black), // Mudança feita aqui
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Center(
              heightFactor: 1.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 70.0,
                    backgroundColor: Colors.grey.shade400,
                    child:
                        const Icon(Icons.person, size: 80, color: Colors.black),
                  ),
                  const SizedBox(height: 15.0),
                  const Text(
                    '################',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                  const Text(
                    '#######################',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Calculadora()));
                        },
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.calculate,
                                size: 60.0, color: Colors.black),
                            Text("Calculadora"),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SecondPage()));
                        },
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.favorite,
                                size: 60.0, color: Colors.black),
                            Text("Favoritos"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ThirdPage()));
                        },
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.access_alarm,
                                size: 60.0, color: Colors.black),
                            Text("Alarme"),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const FourthPage()));
                        },
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.info, size: 60.0, color: Colors.black),
                            Text("Sobre"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime agora = DateTime.now();
    String dataFormatada = DateFormat('dd/MM/yyyy').format(agora);
    String horaFormatada = DateFormat('HH:mm:ss').format(agora);
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: true,
        centerTitle: true,
        iconTheme:
            const IconThemeData(color: Colors.black), // Mudança feita aqui
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('VAZIO SEM NADA'),
            Text('Data: $dataFormatada '),
            Text(' Hora: $horaFormatada   ')
          ],
        ),
      ),
    );
  }
}

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime agora = DateTime.now();
    String dataFormatada = DateFormat('dd/MM/yyyy').format(agora);
    String horaFormatada = DateFormat('HH:mm:ss').format(agora);
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: true,
        centerTitle: true,
        iconTheme:
            const IconThemeData(color: Colors.black), // Mudança feita aqui
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('VAZIO SEM NADA'),
            Text('Data: $dataFormatada '),
            Text(' Hora: $horaFormatada   ')
          ],
        ),
      ),
    );
  }
}

class FourthPage extends StatelessWidget {
  const FourthPage({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime agora = DateTime.now();
    String dataFormatada = DateFormat('dd/MM/yyyy').format(agora);
    String horaFormatada = DateFormat('HH:mm:ss').format(agora);
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: true,
        centerTitle: true,
        iconTheme:
            const IconThemeData(color: Colors.black), // Mudança feita aqui
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('VAZIO SEM NADA'),
            Text('Data: $dataFormatada '),
            Text(' Hora: $horaFormatada   ')
          ],
        ),
      ),
    );
  }
}

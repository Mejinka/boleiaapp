// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_application_1/home.dart';

import 'registro.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: InitialPage(),
    );
  }
}

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 200.0,
              height: 200.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo1.jpg'),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            const Divider(
              color: Colors.transparent,
              height: 20,
            ),
            SizedBox(
              width: 0.5 * screenWidth,
              child: const TextField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26),
                  ),
                  labelText: "Nome de Utilizador",
                ),
                keyboardType: TextInputType.name,
              ),
            ),
            const Divider(
              color: Colors.transparent,
              height: 20,
            ),
            SizedBox(
              width: 100,
              height: 50,
              child: isLoading
                  ? Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation(Colors.blueGrey.shade800),
                        ),
                      ),
                    )
                  : ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blueGrey.shade800),
                      ),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        await Future.delayed(const Duration(seconds: 2));

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Home()),
                        );
                      },
                      child:
                          const Text('Entrar', style: TextStyle(fontSize: 16)),
                    ),
            ),
            const Divider(
              color: Colors.transparent,
              height: 20,
            ),
            TextButton(
                onPressed: () async {
                  setState(() {});

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegistroState()),
                  );
                },
                child: const Text('Registrar'))
          ],
        ),
      ),
    );
  }
}

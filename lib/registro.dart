import 'package:flutter/material.dart';

import 'home.dart';

class RegistroState extends StatefulWidget {
  const RegistroState({super.key});

  @override
  State<RegistroState> createState() => _RegistroStateState();
}

var items = [
  'Dep. 1',
  'Dep. 2',
  'Dep. 3',
  'Dep. 4',
  'Dep. 5',
];
String dropdownvalue = 'Dep. 1';

class _RegistroStateState extends State<RegistroState> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            Center(
              child: Container(
                width: 0.5 * screenWidth,
                height: 200.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo1.jpg'),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  flex: 2,
                  child: TextField(
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
                const SizedBox(width: 25),
                Expanded(
                  child: DropdownButton(
                    isExpanded: true,
                    value: dropdownvalue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black26),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black26),
                ),
                labelText: "Email",
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 0.5 * screenWidth, // 50% da largura da tela
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.blueGrey.shade800),
                ),
                onPressed: () async {
                  setState(() {});
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                  );
                },
                child: const Text('Confirmar', style: TextStyle(fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

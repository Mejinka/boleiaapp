import 'package:flutter/material.dart';

import 'home.dart';

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CalculadoraState createState() => _CalculadoraState();
}

String? selectedFarmaco;
String? selectedConcentration;

Map<String, double> farmacos = {
  ' Cetamin': 10.0,
  ' Dopalen': 11.6,
  ' Ketamina - 50': 0,
  ' Ketamina Agener 10%': 10,
  ' Quetamina Injetável Vetnil': 0,
  ' Telazol': 0,
  ' Vetaset': 0,
  ' Zoletil 50/ 100': 0,
  ' Alfaxalona': 0,
  ' Etomidato': 0,
  ' Fenobarbital': 0,
  ' Halotano': 3,
  ' Metoexital': 0,
  ' Pentobarbital': 0,
  ' Propofol': 0,
  ' Tiopental': 0,
  ' Isoflurano': 0,
  ' Anestésico Bravet': 0,
  ' Anestésico L': 0,
  ' Anestt': 2,
  ' Bupivacaína': 0,
  ' Isetionato de Hexamidina + Cloridato de Tetracaína': 0,
  ' Lidocaína': 0,
  ' Lidocaína Animalia Farma Creme': 0,
  ' Lidocaína Ligvet': 0,
  ' Proximetacaina': 0,
  ' Solução anti-flamatória DrogaVET': 0,
  ' Aminofilina Animalia Farma Cápsulas:t': 0,
  ' Antisedan': 0,
  ' Atipamezol': 0,
  ' Acepran® 0,2%': 0.2,
  ' Xilazina': 2,
};

class _CalculadoraState extends State<Calculadora> {
  final doseController = TextEditingController();
  final weightController = TextEditingController();
  final concentrationController = TextEditingController();
  final resultController = TextEditingController();

  @override
  void dispose() {
    doseController.dispose();
    weightController.dispose();
    concentrationController.dispose();
    resultController.dispose();
    super.dispose();
  }

  double parseInput(String input) {
    String normalized = input.replaceAll(',', '.');
    return double.tryParse(normalized) ?? 0.0;
  }

  void calculateResult() {
    if (doseController.text.isEmpty ||
        weightController.text.isEmpty ||
        concentrationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, preencha todos os campos!"),
        ),
      );
      return;
    }

    setState(() {
      double dose = parseInput(doseController.text);
      double weight = double.tryParse(weightController.text) ?? 0.0;
      double concentration =
          double.tryParse(concentrationController.text) ?? 0.0;

      if (concentration != 0) {
        double result = (dose * weight) / concentration;
        resultController.text = result.toStringAsFixed(4);
      } else {
        resultController.text = "0";
      }
    });
  }

  void _clearFields() {
    setState(() {
      doseController.clear();
      weightController.clear();
      concentrationController.clear();
      resultController.clear();
      selectedFarmaco = null;
      selectedConcentration = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        backgroundColor: Colors.blueGrey.shade800,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text('Calculadora de Doses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services),
            onPressed: _clearFields,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 55,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 7,
                        offset: const Offset(0, 3)),
                  ],
                  border: Border.all(color: Colors.black26, width: 2),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedFarmaco,
                    hint: const Text(' Escolha um fármaco'),
                    items: farmacos.keys.map((String key) {
                      return DropdownMenuItem<String>(
                        value: key,
                        child: Text(key),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedFarmaco = newValue;
                        selectedConcentration = null;
                        if (farmacos[newValue] == 0) {
                          concentrationController.clear();
                        } else {
                          concentrationController.text =
                              farmacos[newValue].toString();
                        }
                      });
                    },
                  ),
                ),
              ),
            ),
            const Divider(height: 6, color: Colors.transparent),
            if (selectedFarmaco == ' Isoflurano')
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 7,
                        offset: const Offset(0, 3)),
                  ],
                  border: Border.all(color: Colors.black26, width: 2),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    itemHeight: 50,
                    isExpanded: true,
                    value: selectedConcentration,
                    hint: const Text(' Escolha uma concentração'),
                    items: ['1.2%', '1.3%', '1.4%', '1.5%', '1.6%']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedConcentration = newValue;
                        concentrationController.text = newValue!
                            .replaceAll('%', ''); // remove the '%' sign
                      });
                    },
                  ),
                ),
              ),
            if (selectedFarmaco == ' Lidocaína Ligvet')
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 7,
                        offset: const Offset(0, 3)),
                  ],
                  border: Border.all(color: Colors.black26, width: 2),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    itemHeight: 50,
                    isExpanded: true,
                    value: selectedConcentration,
                    hint: const Text(' Escolha uma concentração'),
                    items: ['1%', '2%', '3%', '4%', '5%'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedConcentration = newValue;
                        concentrationController.text = newValue!
                            .replaceAll('%', ''); // remove the '%' sign
                      });
                    },
                  ),
                ),
              ),
            const Divider(height: 6, color: Colors.transparent),

            TextFormField(
              controller: doseController,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black26),
                ),
                labelText: "Dose",
              ),
              keyboardType: TextInputType.number,
            ),
            const Divider(height: 6, color: Colors.transparent),

            TextFormField(
              controller: weightController,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black26),
                ),
                labelText: "Peso",
                suffix: Padding(
                  padding: EdgeInsets.only(right: 260.0),
                  child: Text("KG"),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const Divider(height: 6, color: Colors.transparent),

            TextFormField(
              controller: concentrationController,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black26),
                ),
                labelText: "Concentração do fármaco",
                suffix: Padding(
                  padding: EdgeInsets.only(right: 260.0),
                  child: Text("%"),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const Divider(
              color: Colors.transparent,
              height: 20,
            ),
            //onPressed: calculateResult,
            SizedBox(
              width: 90,
              height: 40,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(Colors.blueGrey.shade800),
                ),
                onPressed: calculateResult,
                child: const Text('Calcular', style: TextStyle(fontSize: 15)),
              ),
            ),
            const Divider(height: 20, color: Colors.transparent),

            TextFormField(
              controller: resultController,
              decoration: const InputDecoration(
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black26),
                ),
                labelText: "Resultado",
              ),
              enabled: false,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:app_boleia/home/home.dart';
import 'package:flutter/material.dart';

class MotoristaDetails extends StatelessWidget {
  final Motorista motorista;

  const MotoristaDetails({Key? key, required this.motorista}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(motorista.nome),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
                backgroundColor: const Color.fromARGB(200, 23, 135, 172),
                radius: 50.0,
                child: const Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                )),
            Text("Nome: ${motorista.nome}"),
            Text("Departamento: ${motorista.departamento}"),
            Text("Rota Atual: ${motorista.rotaAtual}"),
            Text("Escolha: ${motorista.escolha}"),
            Text("Hora: ${motorista.hora}"),
            Expanded(
              child: ListView.builder(
                itemCount: motorista.rotaAtual.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text("Rota ${index + 1}"),
                      subtitle: Text(motorista.rotaAtual[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

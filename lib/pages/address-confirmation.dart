import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hpcty/pages/location-complaint.dart';
import 'package:http/http.dart' as http;

class AddressConfirmation extends StatefulWidget {
  final String endereco;

  AddressConfirmation(this.endereco);

  @override
  _AddressConfirmationState createState() => _AddressConfirmationState();
}

class _AddressConfirmationState extends State<AddressConfirmation> {
  bool? enderecoValido;

  Future<void> validarEndereco() async {
    final enderecoCompleto = widget.endereco;
    final apiKey = 'AIzaSyB2hJ15pQw_ODl-htVopPgE2A4jM-xIkMs';

    final response = await http.get(
      Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$enderecoCompleto&key=$apiKey',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Verifique se a resposta contém resultados
      if (data['results'] != null && data['results'].isNotEmpty) {
        setState(() {
          enderecoValido = true;
        });
      } else {
        setState(() {
          enderecoValido = false;
        });
      }
    } else {
      setState(() {
        enderecoValido = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      validarEndereco();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirmação de Endereço"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Endereço Digitado:",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              widget.endereco,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            if (enderecoValido == true)
              Text(
                "Endereço confirmado com sucesso!",
                style: TextStyle(fontSize: 20, color: Colors.green),
              )
            else if (enderecoValido == false)
              Column(
                children: [
                  Text(
                    "Não foi possível encontrar este endereço.",
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Voltar para a tela AddressSearch
                      Navigator.pop(context);
                    },
                    child: Text("Tente Novamente"),
                  ),
                ],
              )
            else
              CircularProgressIndicator(), // Mostrar um indicador de carregamento enquanto a validação está em andamento
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (enderecoValido == true) {
                  // Navegue para a tela LocationComplaint e envie as informações
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LocationComplaint(
                        endereco: widget.endereco,
                        // Adicione outras informações necessárias aqui
                      ),
                    ),
                  );
                }
              },
              child: Text("Continuar"),
            ),
          ],
        ),
      ),
    );
  }
}

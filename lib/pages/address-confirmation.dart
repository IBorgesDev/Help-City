// Importa as bibliotecas necessárias
import 'dart:convert'; // Para lidar com JSON

import 'package:flutter/material.dart';
import 'package:hpcty/pages/location-complaint.dart'; // Importa a página LocationComplaint
import 'package:http/http.dart' as http; // Para fazer solicitações HTTP

// Define um widget chamado AddressConfirmation que recebe um endereço como parâmetro
class AddressConfirmation extends StatefulWidget {
  final String endereco; // O endereço a ser confirmado

  AddressConfirmation(this.endereco);

  @override
  _AddressConfirmationState createState() => _AddressConfirmationState();
}

// O estado da tela de confirmação de endereço
class _AddressConfirmationState extends State<AddressConfirmation> {
  bool? enderecoValido; // Variável que armazena se o endereço é válido ou não

  // Função para validar o endereço usando a API do Google Maps
  Future<void> validarEndereco() async {
    final enderecoCompleto = widget.endereco; // Obtém o endereço da tela anterior
    final apiKey = 'AIzaSyB2hJ15pQw_ODl-htVopPgE2A4jM-xIkMs';

    final response = await http.get(
      Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$enderecoCompleto&key=$apiKey',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Verifica se a resposta da API contém resultados
      if (data['results'] != null && data['results'].isNotEmpty) {
        setState(() {
          enderecoValido = true; // Define que o endereço é válido
        });
      } else {
        setState(() {
          enderecoValido = false; // Define que o endereço não foi encontrado
        });
      }
    } else {
      setState(() {
        enderecoValido = false; // Define que ocorreu um erro ao acessar a API
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Chama a função de validação de endereço quando a tela é inicializada
    Future.delayed(Duration.zero, () {
      validarEndereco();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirmação de Endereço"), // Define o título da barra superior
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Endereço Digitado:", // Título para exibir o endereço digitado
              style: TextStyle(fontSize: 20),
            ),
            Text(
              widget.endereco, // Exibe o endereço digitado pelo usuário
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20), // Espaçamento
            // Exibe uma mensagem dependendo da validação do endereço
            if (enderecoValido == true)
              Text(
                "Endereço confirmado com sucesso!", // Mensagem de sucesso
                style: TextStyle(fontSize: 20, color: Colors.green),
              )
            else if (enderecoValido == false)
              Column(
                children: [
                  Text(
                    "Não foi possível encontrar este endereço.", // Mensagem de erro
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Volta para a tela AddressSearch quando o botão é pressionado
                      Navigator.pop(context);
                    },
                    child: Text("Tente Novamente"), // Botão para tentar novamente
                  ),
                ],
              )
            else
              CircularProgressIndicator(), // Mostra um indicador de carregamento enquanto a validação está em andamento
            SizedBox(height: 20), // Espaçamento
            ElevatedButton(
              onPressed: () {
                if (enderecoValido == true) {
                  // Navega para a tela LocationComplaint se o endereço for válido
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
              child: Text("Continuar"), // Botão para continuar
            ),
          ],
        ),
      ),
    );
  }
}

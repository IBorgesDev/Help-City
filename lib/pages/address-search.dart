// Importa as bibliotecas necessárias para criar um aplicativo Flutter
import 'package:flutter/material.dart';
import 'package:hpcty/pages/address-confirmation.dart';
import 'package:hpcty/pages/complaint-map.dart';

// A função principal que inicia o aplicativo
void main() {
  // Cria um aplicativo Flutter
  runApp(MaterialApp(
    home: AddressSearch(), // Define a tela inicial como AddressSearch
  ));
}

// Define um widget chamado AddressSearch que é uma tela do aplicativo
class AddressSearch extends StatefulWidget {
  const AddressSearch({Key? key}) : super(key: key);

  @override
  _AddressSearchState createState() => _AddressSearchState();
}

// O estado da tela AddressSearch
class _AddressSearchState extends State<AddressSearch> {
  // Controladores para os campos de texto
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController ruaController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController cidadeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Address Search"), // Define o título da barra superior
        actions: [
          // Adiciona um botão na parte superior direita da tela
          TextButton(
            onPressed: () {
              // Navega para a página ReclamacoesPage quando o botão é pressionado
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReclamacoesPage(),
                ),
              );
            },
            child: Text(
              "Ver Mapa de Reclamações", // Texto exibido no botão
              style: TextStyle(color: Colors.white), // Estilo do texto
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Campos de texto para inserir informações do endereço
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFieldWithPlaceholder(
              label: "Bairro",
              controller: bairroController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFieldWithPlaceholder(
              label: "Rua",
              controller: ruaController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFieldWithPlaceholder(
              label: "Número",
              controller: numeroController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFieldWithPlaceholder(
              label: "Cidade",
              controller: cidadeController,
            ),
          ),
          // Botão para continuar
          ElevatedButton(
            onPressed: () {
              // Obtém os valores dos campos de texto
              final bairro = bairroController.text;
              final rua = ruaController.text;
              final numero = numeroController.text;
              final cidade = cidadeController.text;

              // Cria uma string com o endereço completo
              final enderecoCompleto = "$bairro $rua $numero $cidade";

              // Navega para a segunda tela (AddressConfirmation) com o endereço completo
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddressConfirmation(enderecoCompleto),
                ),
              );
            },
            child: Text("Continuar"), // Texto exibido no botão
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Libera os recursos dos controladores quando a tela é descartada
    bairroController.dispose();
    ruaController.dispose();
    numeroController.dispose();
    cidadeController.dispose();
    super.dispose();
  }
}

// Um widget reutilizável que cria um campo de texto com um rótulo (label)
class TextFieldWithPlaceholder extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  TextFieldWithPlaceholder({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label, // Rótulo exibido acima do campo de texto
        labelStyle: TextStyle(color: Colors.grey[400]), // Estilo do rótulo
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
      ),
    );
  }
}

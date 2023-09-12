import 'package:flutter/material.dart';
import 'package:hpcty/pages/address-confirmation.dart';
import 'package:hpcty/pages/complaint-map.dart';

void main() {
  runApp(MaterialApp(
    home: AddressSearch(),
  ));
}

class AddressSearch extends StatefulWidget {
  const AddressSearch({Key? key}) : super(key: key);

  @override
  _AddressSearchState createState() => _AddressSearchState();
}

class _AddressSearchState extends State<AddressSearch> {
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController ruaController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController cidadeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Address Search"),
        actions: [
          // Adicione um botão na parte superior direita da tela
          TextButton(
            onPressed: () {
              // Navegue para a página ReclamacoesPage quando o botão for pressionado
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReclamacoesPage(),
                ),
              );
            },
            child: Text(
              "Ver Mapa de Reclamações",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
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
          ElevatedButton(
            onPressed: () {
              final bairro = bairroController.text;
              final rua = ruaController.text;
              final numero = numeroController.text;
              final cidade = cidadeController.text;

              final enderecoCompleto = "$bairro $rua $numero $cidade";

              // Navegue para a segunda tela
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddressConfirmation(enderecoCompleto),
                ),
              );
            },
            child: Text("Continuar"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    bairroController.dispose();
    ruaController.dispose();
    numeroController.dispose();
    cidadeController.dispose();
    super.dispose();
  }
}

class TextFieldWithPlaceholder extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  TextFieldWithPlaceholder({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[400]),
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

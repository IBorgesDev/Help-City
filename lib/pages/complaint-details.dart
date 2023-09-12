import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'address-search.dart';
import 'firebase_service.dart';

class ComplaintDetails {
  String endereco;
  final double latitude;
  final double longitude;
  String horaReclamacao;
  bool isEnderecoValido = true;

  ComplaintDetails({
    required this.endereco,
    required this.latitude,
    required this.longitude,
    this.horaReclamacao = "08:00",
  });
}

class ComplaintDetailsPage extends StatefulWidget {
  final ComplaintDetails details;

  ComplaintDetailsPage({required this.details});

  @override
  _ComplaintDetailsPageState createState() => _ComplaintDetailsPageState();
}

class _ComplaintDetailsPageState extends State<ComplaintDetailsPage> {
  final List<String> tiposDeBarulho = [
    "Selecione o tipo",
    "Gritaria",
    "Música alta",
    "Briga",
    "Evento no local",
    "Animais",
    "Automóveis",
    "Conversa alta",	
  ];
  String selectedTipoDeBarulho = "Selecione o tipo";
  TextEditingController detalhesController = TextEditingController();
  TextEditingController enderecoController = TextEditingController();
  bool isEditingEndereco = false;

  @override
  void initState() {
    super.initState();
    _setHoraAtual();
  }

  @override
  void dispose() {
    detalhesController.dispose();
    enderecoController.dispose();
    super.dispose();
  }

  void _setHoraAtual() {
    final now = DateTime.now();
    final formattedTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    setState(() {
      widget.details.horaReclamacao = formattedTime;
    });
  }

  void _startEditingEndereco() {
    setState(() {
      isEditingEndereco = true;
      enderecoController.text = widget.details.endereco;
    });
  }

  Future<void> _saveEditedEndereco() async {
    final isValid = await _validateEndereco(enderecoController.text);

    if (isValid) {
      setState(() {
        widget.details.endereco = enderecoController.text;
        widget.details.isEnderecoValido = true;
        isEditingEndereco = false;
      });
    } else {
      setState(() {
        widget.details.isEnderecoValido = false;
      });
      // Exibir uma mensagem de erro ou feedback ao usuário.
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Endereço Inválido'),
            content: Text('Por favor, insira um endereço válido.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<bool> _validateEndereco(String endereco) async {
    final apiKey =
        'AIzaSyB2hJ15pQw_ODl-htVopPgE2A4jM-xIkMs'; // Substitua com sua chave da API do Google Maps
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$endereco&key=$apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Verifique se o JSON de resposta contém resultados válidos.
      // Aqui, você deve analisar a resposta JSON para determinar se o endereço é válido.
      // Neste exemplo, consideramos válido se houver pelo menos um resultado.
      return data['results'] != null && data['results'].isNotEmpty;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Reclamação'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.all(16.0),
            margin: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Tipo de Barulho:',
                  style: TextStyle(fontSize: 18.0),
                ),
                DropdownButton<String>(
                  value: selectedTipoDeBarulho,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedTipoDeBarulho = newValue;
                      });
                    }
                  },
                  items: tiposDeBarulho.map((String tipo) {
                    return DropdownMenuItem<String>(
                      value: tipo,
                      child: Text(tipo),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Endereço:',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _startEditingEndereco();
                      },
                    ),
                  ],
                ),
                if (isEditingEndereco)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: enderecoController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          _saveEditedEndereco();
                        },
                        child: Text('Salvar Endereço'),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      if (widget.details.isEnderecoValido)
                        Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                      else
                        Icon(
                          Icons.clear,
                          color: Colors.red,
                        ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.details.endereco,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: widget.details.isEnderecoValido
                                ? Colors.black
                                : Colors.red,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 20),
                Text(
                  'Detalhes da Reclamação:',
                  style: TextStyle(fontSize: 18.0),
                ),
                TextField(
                  controller: detalhesController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Hora da Reclamação:',
                  style: TextStyle(fontSize: 18.0),
                ),
                Text(
                  widget.details.horaReclamacao,
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedTipoDeBarulho != "Selecione o tipo") {
                      final firebaseService = FirebaseService();
                      try {
                        await firebaseService.enviarReclamacao(
                          selectedTipoDeBarulho,
                          widget.details.endereco,
                          detalhesController.text,
                          widget.details.horaReclamacao,
                          widget.details.latitude,
                          widget.details.longitude,
                        );

                        // Navegar para a tela de confirmação
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConfirmationScreen(),
                          ),
                        );
                      } catch (error) {
                        // Tratar erros de envio para o Firebase
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Erro ao Enviar Reclamação'),
                              content: Text(
                                  'Ocorreu um erro ao enviar a reclamação. Por favor, tente novamente.'),
                              actions: [
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else {
                      // Exibir mensagem de erro ao usuário
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Tipo de Barulho Inválido'),
                            content: Text(
                                'Por favor, selecione um tipo de barulho válido.'),
                            actions: [
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text('Enviar Reclamação'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reclamação Enviada'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100.0,
            ),
            SizedBox(height: 20.0),
            Text(
              'Sua reclamação foi enviada com sucesso!',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
ElevatedButton(
  onPressed: () {
    // Navegue diretamente para a tela AddressSearch() e substitua a tela atual
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AddressSearch(),
      ),
    );
  },
  child: Text('Voltar'),
),
          ],
        ),
      ),
    );
  }
}
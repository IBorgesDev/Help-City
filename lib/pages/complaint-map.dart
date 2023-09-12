// Importações necessárias para usar o Firebase, Flutter e mapas do Google.
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Função principal, onde o aplicativo começa a ser executado.
void main() async {
  // Inicializa o Flutter e o Firebase.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

// Classe que representa uma reclamação.
class Reclamacao {
  final double latitude;
  final double longitude;
  final String tipoDeBarulho;

  Reclamacao(this.latitude, this.longitude, this.tipoDeBarulho);
}

// Classe principal do aplicativo.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ReclamacoesPage(),
    );
  }
}

// Página que exibe as reclamações no mapa.
class ReclamacoesPage extends StatefulWidget {
  @override
  _ReclamacoesPageState createState() => _ReclamacoesPageState();
}

class _ReclamacoesPageState extends State<ReclamacoesPage> {
  // Referência para o banco de dados Firebase.
  final databaseReference = FirebaseDatabase.instance.reference();

  // Lista de reclamações.
  List<Reclamacao> reclamacoes = [];

  // Controlador do mapa do Google.
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    // Inicializa a busca das reclamações ao iniciar a página.
    _buscarReclamacoes();
  }

  // Função para buscar as reclamações no banco de dados Firebase.
  void _buscarReclamacoes() {
    databaseReference.child('reclamacoes').once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? values = event.snapshot.value as Map<dynamic, dynamic>?;

        if (values != null) {
          values.forEach((key, value) {
            var reclamacao = Reclamacao(
              (value['latitude'] as double?) ?? 0.0,
              (value['longitude'] as double?) ?? 0.0,
              value['tipoDeBarulho'] as String? ?? "",
            );
            setState(() {
              reclamacoes.add(reclamacao);
            });
          });
        }
      }
    }).catchError((error) {
      print("Erro ao buscar as reclamações: $error");
    });
  }

  // Função para criar círculos no mapa com base nas reclamações.
  Set<Circle> _createCircles() {
    return Set<Circle>.from(reclamacoes.map((reclamacao) {
      Color circleColor;

      // Define a cor do círculo com base no tipo de barulho.
      if (reclamacao.tipoDeBarulho == 'Evento no local') {
        circleColor = const Color.fromARGB(255, 89, 33, 243).withOpacity(0.3);
      } else if (reclamacao.tipoDeBarulho == 'Briga') {
        circleColor = Colors.red.withOpacity(0.3);
      } else if (reclamacao.tipoDeBarulho == "Gritaria") {
        circleColor = const Color.fromARGB(255, 175, 132, 76).withOpacity(0.3);
      } else if (reclamacao.tipoDeBarulho == 'Conversa alta') {
        circleColor = const Color.fromARGB(255, 244, 54, 158).withOpacity(0.3);
      } else if (reclamacao.tipoDeBarulho == 'Animais') {
        circleColor = const Color.fromARGB(255, 54, 174, 244).withOpacity(0.3);
      } else if (reclamacao.tipoDeBarulho == 'Automóveis') {
        circleColor = Color.fromARGB(255, 33, 255, 25).withOpacity(0.3);
      } else {
        circleColor = Colors.grey.withOpacity(0.3);
      }

      // Cria um círculo no mapa.
      return Circle(
        circleId: CircleId(reclamacao.latitude.toString() + reclamacao.longitude.toString()),
        center: LatLng(reclamacao.latitude, reclamacao.longitude),
        radius: 27,
        fillColor: circleColor,
        strokeColor: Color.fromARGB(255, 0, 0, 0),
        strokeWidth: 2,
        onTap: () {
          // Mostra o tipo de barulho ao tocar no círculo.
          Fluttertoast.showToast(
            msg: 'Tipo de Barulho: ${reclamacao.tipoDeBarulho}',
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
          );
        },
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reclamações'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            _mapController = controller;
          });
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(-22.7557, -47.1717),
          zoom: 12.0,
        ),
        markers: Set<Marker>.from(reclamacoes.map((reclamacao) {
          // Cria marcadores no mapa com base nas reclamações.
          return Marker(
            markerId: MarkerId(reclamacao.latitude.toString() + reclamacao.longitude.toString()),
            position: LatLng(reclamacao.latitude, reclamacao.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: InfoWindow(
              title: 'Tipo de Barulho',
              snippet: reclamacao.tipoDeBarulho,
            ),
          );
        })),
        circles: _createCircles(), // Adiciona os círculos ao mapa.
      ),
    );
  }
}

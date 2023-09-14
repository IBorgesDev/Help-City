// Importando as bibliotecas necessárias para criar um aplicativo Flutter.
import 'package:flutter/material.dart'; // Para criar a interface do aplicativo.
import 'package:geocoding/geocoding.dart'; // Para converter um endereço em coordenadas geográficas.
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Para usar mapas do Google.

// Importando um arquivo chamado 'complaint-details.dart', que contém detalhes de reclamação.
import 'complaint-details.dart';

// Definindo uma classe chamada 'LocationComplaint' que é um widget de tela.
class LocationComplaint extends StatefulWidget {
  final String endereco; // Uma variável para armazenar um endereço.

  // Um construtor para a classe 'LocationComplaint' que recebe um 'endereco' como parâmetro.
  LocationComplaint({required this.endereco});

  @override
  _LocationComplaintState createState() => _LocationComplaintState();
}

// Definindo uma classe interna chamada '_LocationComplaintState' para gerenciar o estado da tela.
class _LocationComplaintState extends State<LocationComplaint> {
  String? _latitude; // Variável para armazenar a latitude.
  String? _longitude; // Variável para armazenar a longitude.
  late GoogleMapController _mapController; // Controlador do mapa.

  double _circleRadius = 28; // Raio inicial do círculo em metros.
  late CircleId _circleId = CircleId('complaint_radius'); // Identificador do círculo.

  @override
  void initState() {
    super.initState();
    _convertAddressToCoordinates(); // Quando a tela é iniciada, convertemos o endereço em coordenadas.
  }

  // Função para converter um endereço em coordenadas geográficas.
  Future<void> _convertAddressToCoordinates() async {
    try {
      // Usando a biblioteca 'geocoding' para obter uma lista de localizações com base no endereço.
      List<Location> locations = await locationFromAddress(widget.endereco);
      if (locations.isEmpty) {
        throw Exception('Nenhuma localização encontrada para o endereço fornecido');
      }
      Location firstLocation = locations.first;
      setState(() {
        _latitude = firstLocation.latitude.toString(); // Armazenando a latitude.
        _longitude = firstLocation.longitude.toString(); // Armazenando a longitude.
      });
      _zoomToLocation(); // Ampliando o mapa para mostrar a localização.
    } catch (e) {
      print('Erro ao converter o endereço em coordenadas: $e');
    }
  }

  // Função para ampliar o mapa até a localização.
  void _zoomToLocation() {
    if (_mapController != null && _latitude != null && _longitude != null) {
      _mapController.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(double.parse(_latitude!), double.parse(_longitude!)),
        19.0, // Nível de zoom.
      ));
    }
  }

  // Função para criar um círculo no mapa.
  Set<Circle> _createCircle() {
    if (_latitude != null && _longitude != null) {
      return <Circle>{
        Circle(
          circleId: _circleId,
          center: LatLng(
            double.parse(_latitude!),
            double.parse(_longitude!),
          ),
          radius: _circleRadius,
          fillColor: Colors.blue.withOpacity(0.3),
          strokeColor: Colors.blue,
          strokeWidth: 2,
        ),
      };
    }
    return <Circle>{}; // Retorna um conjunto vazio de círculos se as coordenadas não estiverem disponíveis.
  }

  // Função para navegar para a tela de detalhes da reclamação.
  void _navigateToComplaintDetails() {
    if (_latitude != null && _longitude != null) {
      ComplaintDetails details = ComplaintDetails(
        endereco: widget.endereco,
        latitude: double.parse(_latitude!),
        longitude: double.parse(_longitude!),
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ComplaintDetailsPage(details: details),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Complaint'), // Título da barra superior.
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: (controller) {
              setState(() {
                _mapController = controller; // Inicializando o controlador do mapa.
              });
            },
            initialCameraPosition: _latitude != null && _longitude != null
                ? CameraPosition(
                    target: LatLng(
                      double.parse(_latitude!),
                      double.parse(_longitude!),
                    ),
                    zoom: 15.0, // Nível de zoom inicial.
                  )
                : CameraPosition(
                    target: LatLng(0, 0), // Localização padrão se as coordenadas não estiverem disponíveis.
                    zoom: 1.0, // Nível de zoom mínimo.
                  ),
            markers: <Marker>{
              if (_latitude != null && _longitude != null)
                Marker(
                  markerId: MarkerId('complaint_location'),
                  position: LatLng(
                    double.parse(_latitude!),
                    double.parse(_longitude!),
                  ),
                  infoWindow: InfoWindow(title: 'Localização da reclamação'),
                ),
            },
            circles: _createCircle(), // Adicionando o círculo ao mapa.
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton(
                onPressed: _navigateToComplaintDetails, // Quando o botão é pressionado, navega para a tela de detalhes da reclamação.
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                ),
                child: Icon(Icons.arrow_forward, size: 30), // Ícone do botão.
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Função principal que inicia o aplicativo.
void main() {
  runApp(MaterialApp(
    home: LocationComplaint(
      endereco: "Endereço Inicial", // Fornecendo um endereço inicial para a tela 'LocationComplaint'.
    )));
}
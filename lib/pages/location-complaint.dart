import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'complaint-details.dart';

class LocationComplaint extends StatefulWidget {
  final String endereco;

  LocationComplaint({required this.endereco});

  @override
  _LocationComplaintState createState() => _LocationComplaintState();
}

class _LocationComplaintState extends State<LocationComplaint> {
  String? _latitude;
  String? _longitude;
  late GoogleMapController _mapController;

  double _circleRadius = 28; // Initial radius in meters
  late CircleId _circleId = CircleId('complaint_radius');

  @override
  void initState() {
    super.initState();
    _convertAddressToCoordinates();
  }

  Future<void> _convertAddressToCoordinates() async {
    try {
      List<Location> locations = await locationFromAddress(widget.endereco);
      if (locations.isEmpty) {
        throw Exception('No location found for the provided address');
      }
      Location firstLocation = locations.first;
      setState(() {
        _latitude = firstLocation.latitude.toString();
        _longitude = firstLocation.longitude.toString();
      });
      _zoomToLocation();
    } catch (e) {
      print('Error converting address to coordinates: $e');
    }
  }

  void _zoomToLocation() {
    if (_mapController != null && _latitude != null && _longitude != null) {
      _mapController.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(double.parse(_latitude!), double.parse(_longitude!)),
        19.0,
      ));
    }
  }

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
    return <Circle>{};
  }

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
        title: Text('Location Complaint'),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: (controller) {
              setState(() {
                _mapController = controller;
              });
            },
            initialCameraPosition: _latitude != null && _longitude != null
                ? CameraPosition(
                    target: LatLng(
                      double.parse(_latitude!),
                      double.parse(_longitude!),
                    ),
                    zoom: 15.0,
                  )
                : CameraPosition(
                    target: LatLng(0, 0),
                    zoom: 1.0,
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
            circles: _createCircle(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton(
                onPressed: _navigateToComplaintDetails,
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                ),
                child: Icon(Icons.arrow_forward, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LocationComplaint(
      endereco: "Endereço Inicial",
    ),
  ));
}

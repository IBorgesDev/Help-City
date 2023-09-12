import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hpcty/pages/address-search.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Garante a inicialização do Flutter.

  try {
    await Firebase.initializeApp(); // Inicializa o Firebase.
  } catch (e) {
    print('Erro ao inicializar o Firebase: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  // Este widget é a raiz do seu aplicativo.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home:  AddressSearch(),
    );
  }
}

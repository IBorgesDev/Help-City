import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hpcty/pages/address-search.dart';
import 'package:hpcty/pages/splashscreen.dart';


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

  // Este widget é a raiz do aplicativo.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  Splash(),
    );
  }
}

import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final _database = FirebaseDatabase.instance.ref();

  Future<void> enviarReclamacao(
      String tipoDeBarulho, String endereco, String detalhes, String horaReclamacao, double latitude, double longitude) async {
    try {
      await _database.child('reclamacoes').push().set({
        'tipoDeBarulho': tipoDeBarulho,
        'endereco': endereco,
        'detalhes': detalhes,
        'horaReclamacao': horaReclamacao,
        'latitude': latitude,
        'longitude': longitude,
      });
    } catch (error) {
      print('Erro ao enviar reclamação: $error');
      throw error;
    }
  }
}

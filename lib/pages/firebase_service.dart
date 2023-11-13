import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:intl/date_symbol_data_local.dart'; // Import for localization

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _database = FirebaseDatabase.instance.ref();

  Future<void> enviarReclamacao(
      String tipoDeBarulho,
      String endereco,
      String detalhes,
      String horaReclamacao,
      double latitude,
      double longitude
      ) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        String userId = user.uid;
        DatabaseReference userComplaintsRef = _database.child('users').child(userId).child('REPORTS');
        String newComplaintId = userComplaintsRef.push().key ?? 'new_complaint';

        // Initialize locale
        await initializeDateFormatting('pt_BR', null);

        // Format the date as "12 de agosto de 2023"
        String formattedDate = DateFormat('d \'de\' MMMM \'de\' yyyy', 'pt_BR').format(DateTime.now());

        await userComplaintsRef.child(newComplaintId).set({
          'tipoDeBarulho': tipoDeBarulho,
          'endereco': endereco,
          'detalhes': detalhes,
          'horaReclamacao': horaReclamacao,
          'latitude': latitude,
          'longitude': longitude,
          'data': formattedDate // Use the formatted date here
        });

        print('Reclamação enviada com sucesso.');
      } catch (error) {
        print('Erro ao enviar reclamação: $error');
        throw error;
      }
    } else {
      print('Nenhum usuário está logado.');
      throw Exception('UserNotLoggedIn');
    }
  }
}

import 'package:firebase_database/firebase_database.dart';

// Primeiro, estamos importando uma biblioteca chamada 'firebase_database' que nos permite interagir com um banco de dados Firebase.

class FirebaseService {
  // Aqui estamos criando uma classe chamada 'FirebaseService' para organizar nossas operações com o Firebase.

  final _database = FirebaseDatabase.instance.ref();
  // Criamos uma variável chamada '_database' para representar a conexão com o banco de dados Firebase.

  Future<void> enviarReclamacao(
      String tipoDeBarulho, String endereco, String detalhes, String horaReclamacao, double latitude, double longitude) async {
    // Este é um método chamado 'enviarReclamacao' que nos permite enviar uma reclamação para o banco de dados Firebase.
    
    try {
      // Aqui começamos um bloco 'try-catch', que nos ajuda a lidar com erros caso algo dê errado.

      await _database.child('reclamacoes').push().set({
        // Estamos acessando o banco de dados Firebase e dizendo que queremos armazenar informações sobre uma reclamação.

        'tipoDeBarulho': tipoDeBarulho,
        // 'tipoDeBarulho' é o tipo de barulho que está sendo relatado na reclamação.

        'endereco': endereco,
        // 'endereco' é o endereço onde o barulho está ocorrendo.

        'detalhes': detalhes,
        // 'detalhes' são informações adicionais sobre a reclamação.

        'horaReclamacao': horaReclamacao,
        // 'horaReclamacao' é o momento em que a reclamação está sendo feita.

        'latitude': latitude,
        // 'latitude' é a coordenada de latitude da localização da reclamação.

        'longitude': longitude,
        // 'longitude' é a coordenada de longitude da localização da reclamação.
      });
    } catch (error) {
      // Se algo der errado ao enviar a reclamação, capturamos o erro aqui.

      print('Erro ao enviar reclamação: $error');
      // Imprimimos uma mensagem de erro com informações sobre o que deu errado.

      throw error;
      // E lançamos o erro novamente para que possa ser tratado em outro lugar, se necessário.
    }
  }
}

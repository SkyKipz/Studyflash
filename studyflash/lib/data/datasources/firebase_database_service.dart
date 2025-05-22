import 'package:firebase_database/firebase_database.dart';
import 'package:studyflash/domain/models/flashcard.dart';

class FirebaseDatabaseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Future<void> insertCard(String uid, String conjuntoId, Flashcard card) async {
    final path = 'users/$uid/conjuntos/$conjuntoId/flashcards/${card.id}';
    await _db.child(path).set({
      'question': card.question,
      'answer': card.answer,
    });
  }

  Future<List<Flashcard>> getAllCards(String uid, String conjuntoId) async {
    final path = 'users/$uid/conjuntos/$conjuntoId/flashcards';
    final snapshot = await _db.child(path).get();
    final List<Flashcard> cards = [];

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      data.forEach((id, value) {
        final item = Map<String, dynamic>.from(value);
        cards.add(Flashcard(
          id: id,
          question: item['question'] ?? '',
          answer: item['answer'] ?? '',
        ));
      });
    }

    return cards;
  }

  Future<void> updateConjuntoInfo(String userId, String setId, String nombre, String descripcion) async {
    final ref = FirebaseDatabase.instance.ref('users/$userId/conjuntos/$setId');
    await ref.update({
      'name': nombre,
      'description': descripcion,
    });
  }

  Future<Map<String, String>> getConjuntoMetadata(String uid, String conjuntoId) async {
    final ref = FirebaseDatabase.instance
        .ref('users/$uid/conjuntos/$conjuntoId');

    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);

      return {
        'name': data['name'] ?? '',
        'description': data['description'] ?? '',
      };
    } else {
      return {'name': '', 'description': ''};
    }
  }
  
  Future<List<Map<String, String>>> getAllConjuntos(String uid) async {
    final conjuntosRef = _db.child('users/$uid/conjuntos');
    final snapshot = await conjuntosRef.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;

      return data.entries.map<Map<String, String>>((entry) {
        final conjuntoData = entry.value as Map<dynamic, dynamic>;

        return {
          'titulo': conjuntoData['name'] ?? 'Sin título',
          'descripcion': conjuntoData['description'] ?? 'Sin descripción',
          'id': entry.key,
        };
      }).toList();
    } else {
      return [];
    }
  }

  Future<String> createConjunto(
    String uid,
    String nombre,
    String descripcion,
    String primeraPregunta,
    String primeraRespuesta,
  ) async {
    try {
      final conjuntosRef = _db.child('users/$uid/conjuntos');
      final nuevoConjuntoRef = conjuntosRef.push();
      
      await nuevoConjuntoRef.set({
        'name': nombre,
        'description': descripcion,
        'createdAt': ServerValue.timestamp,
      });

      return nuevoConjuntoRef.key!;
    } catch (e) {
      throw Exception('Error al crear el conjunto: $e');
    }
  }
}

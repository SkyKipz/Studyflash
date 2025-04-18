import 'package:firebase_database/firebase_database.dart';
import 'package:studyflash/domain/models/flashcard.dart';

class FirebaseDatabaseService {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref('flashcards');

  Future<void> insertCard(Flashcard card) async {
    await _ref.child(card.id).set({
      'question': card.question,
      'answer': card.answer,
    });
  }

  Future<List<Flashcard>> getAllCards() async {
    final snapshot = await _ref.get();
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
}

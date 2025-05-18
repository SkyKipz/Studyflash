import 'package:studyflash/domain/models/flashcard.dart';

abstract class FlashcardRepository {
  Future<void> createFlashcard(String uid, String conjuntoId, Flashcard card);
  Future<List<Flashcard>> getAllFlashcards(String uid, String conjuntoId);
}

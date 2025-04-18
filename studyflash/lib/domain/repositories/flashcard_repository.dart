import 'package:studyflash/domain/models/flashcard.dart';

abstract class FlashcardRepository {
  Future<void> createFlashcard(Flashcard card);
  Future<List<Flashcard>> getAllFlashcards();
}
import 'package:studyflash/domain/models/flashcard.dart';
import 'package:studyflash/domain/repositories/flashcard_repository.dart';

class CreateFlashcard {
  final FlashcardRepository repository;

  CreateFlashcard(this.repository);

  Future<void> call({
    required String uid,
    required String conjuntoId,
    required Flashcard card,
  }) {
    return repository.createFlashcard(uid, conjuntoId, card);
  }
}

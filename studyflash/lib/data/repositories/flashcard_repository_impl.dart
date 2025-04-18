import 'package:studyflash/domain/models/flashcard.dart';
import 'package:studyflash/domain/repositories/flashcard_repository.dart';
import 'package:studyflash/data/datasources/firebase_database_service.dart';

class FlashcardRepositoryImpl implements FlashcardRepository {
  final FirebaseDatabaseService db;

  FlashcardRepositoryImpl(this.db);

  @override
  Future<void> createFlashcard(Flashcard card) => db.insertCard(card);

  @override
  Future<List<Flashcard>> getAllFlashcards() => db.getAllCards();
}

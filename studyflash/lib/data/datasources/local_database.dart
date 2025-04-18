import 'package:studyflash/domain/models/flashcard.dart';

class LocalDatabase {
  final List<Flashcard> _cards = [];

  Future<void> insertCard(Flashcard card) async {
    _cards.add(card);
  }

  Future<List<Flashcard>> getAllCards() async {
    return _cards;
  }
}

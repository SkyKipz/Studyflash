import 'package:flutter/material.dart';
import 'package:studyflash/data/datasources/firebase_database_service.dart';
import 'package:studyflash/data/repositories/flashcard_repository_impl.dart';
import 'package:studyflash/domain/models/flashcard.dart';

class RepasarScreen extends StatefulWidget {
  final String conjuntoId;

  const RepasarScreen(this.conjuntoId, {super.key});

  @override
  State<RepasarScreen> createState() => _RepasarScreenState();
}

class _RepasarScreenState extends State<RepasarScreen> {
  final _repo = FlashcardRepositoryImpl(FirebaseDatabaseService());
  List<Flashcard> flashcards = [];
  int currentIndex = 0;
  bool showAnswer = false;

  late String conjuntoId;

  @override
  void initState() {
    super.initState();
    conjuntoId = widget.conjuntoId;
    _loadFlashcards();
  }

  Future<void> _loadFlashcards() async {
    final cards = await _repo.getAllFlashcards('temp_uid', conjuntoId);
    setState(() {
      flashcards = cards;
    });
  }

  void _flipCard() {
    setState(() {
      showAnswer = !showAnswer;
    });
  }

  void _nextCard() {
    if (currentIndex < flashcards.length - 1) {
      setState(() {
        currentIndex++;
        showAnswer = false;
      });
    }
  }

  void _previousCard() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        showAnswer = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentCard = flashcards.isNotEmpty ? flashcards[currentIndex] : null;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Repasar',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: flashcards.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const SizedBox(height: 60),
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1B2E),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        showAnswer ? currentCard!.answer : currentCard!.question,
                        style: const TextStyle(
                          fontSize: 60,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: _previousCard,
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                        iconSize: 30,
                      ),
                      ElevatedButton(
                        onPressed: _flipCard,
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          backgroundColor: Colors.deepPurple,
                        ),
                        child: const Icon(Icons.flip, color: Colors.white, size: 28),
                      ),
                      IconButton(
                        onPressed: _nextCard,
                        icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                        iconSize: 30,
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

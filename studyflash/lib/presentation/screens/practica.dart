import 'package:flutter/material.dart';
import 'package:studyflash/data/datasources/firebase_database_service.dart';
import 'package:studyflash/data/repositories/flashcard_repository_impl.dart';
import 'package:studyflash/domain/models/flashcard.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  final _repo = FlashcardRepositoryImpl(FirebaseDatabaseService());
  List<Flashcard> flashcards = [];
  int currentIndex = 0;
  bool showAnswer = false;

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  Future<void> _loadFlashcards() async {
    final cards = await _repo.getAllFlashcards('temp_uid', 'default_conjunto');
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

  void _onDifficultySelected(String difficulty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Dificultad seleccionada: $difficulty')),
    );
    // Aquí puedes agregar la lógica que quieras para la dificultad
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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Flashcards', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: flashcards.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
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
                        showAnswer
                            ? currentCard!.answer
                            : currentCard!.question,
                        style: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DifficultyButton(
                        text: 'Fácil',
                        color: Colors.green,
                        onPressed: () => _onDifficultySelected('Fácil'),
                      ),
                      DifficultyButton(
                        text: 'Moderado',
                        color: Colors.purple,
                        onPressed: () => _onDifficultySelected('Moderado'),
                      ),
                      DifficultyButton(
                        text: 'Difícil',
                        color: Colors.red,
                        onPressed: () => _onDifficultySelected('Difícil'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _flipCard,
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(16),
                          backgroundColor: Colors.deepPurple,
                        ),
                        child: const Icon(Icons.flip, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 30),
                      ElevatedButton(
                        onPressed: _nextCard,
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(16),
                          backgroundColor: Colors.deepPurple,
                        ),
                        child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 28),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}

class DifficultyButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const DifficultyButton({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(text),
    );
  }
}

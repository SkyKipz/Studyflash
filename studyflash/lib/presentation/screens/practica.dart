import 'package:flutter/material.dart';
import 'package:studyflash/data/datasources/firebase_database_service.dart';
import 'package:studyflash/data/repositories/flashcard_repository_impl.dart';
import 'package:studyflash/domain/models/flashcard.dart';

class FlashcardScreen extends StatefulWidget {
  final String conjuntoId;

  const FlashcardScreen(this.conjuntoId, {super.key});

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
    final cards = await _repo.getAllFlashcards('temp_uid', widget.conjuntoId);
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
    _nextCard();
  }

  @override
  Widget build(BuildContext context) {
    final currentCard = flashcards.isNotEmpty ? flashcards[currentIndex] : null;

    return Scaffold(
      backgroundColor: const Color(0xFF131215),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF1D1B20),
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(12),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFEF7FF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Flashcards',
          style: TextStyle(
            color: Color(0xFFFEF7FF),
            letterSpacing: -0.24,
          ),
        ),
        centerTitle: true,
      ),
      body: flashcards.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFEF7FF),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: _flipCard,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: 500,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: showAnswer
                            ? const Color(0xFF65558F) // Reverso
                            : const Color(0xFF1D192B), // Anverso
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            showAnswer ? currentCard!.answer : currentCard!.question,
                            style: const TextStyle(
                              fontSize: 32,
                              color: Color(0xFFFEF7FF),
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DifficultyButton(
                        text: 'Fácil',
                        color: const Color(0xFF4CAF50), // Verde
                        onPressed: () => _onDifficultySelected('Fácil'),
                      ),
                      DifficultyButton(
                        text: 'Moderado',
                        color: const Color(0xFF9C27B0), // Morado
                        onPressed: () => _onDifficultySelected('Moderado'),
                      ),
                      DifficultyButton(
                        text: 'Difícil',
                        color: const Color(0xFFF44336), // Rojo
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
                          backgroundColor: const Color(0xFF49454F),
                        ),
                        child: const Icon(
                          Icons.flip,
                          color: Color(0xFFFEF7FF),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 30),
                      ElevatedButton(
                        onPressed: _nextCard,
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(16),
                          backgroundColor: const Color(0xFF49454F),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFFFEF7FF),
                          size: 28,
                        ),
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
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFFEF7FF),
          letterSpacing: -0.16,
        ),
      ),
    );
  }
}
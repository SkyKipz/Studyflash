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
      backgroundColor: const Color(0xFF131215),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D1B20),
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: const RoundedRectangleBorder( // Añadido el shape con borderRadius
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(12), // BorderRadius de 12 como solicitaste
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFEF7FF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Repasar',
          style: TextStyle(
            color: Color(0xFFFEF7FF),
            letterSpacing: -0.24,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: flashcards.isEmpty
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFEF7FF),
                ),
              )
            : Column(
                children: [
                  const SizedBox(height: 60),
                  GestureDetector(
                    onTap: _flipCard,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: 600,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: showAnswer 
                            ? const Color(0xFF65558F) //REVERSO
                            : const Color(0xFF1D192B), //ANVERSO
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
                              fontSize: 32, // Reducido para mejor legibilidad
                              color: Color(0xFFFEF7FF),
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: _previousCard,
                        icon: const Icon(Icons.arrow_back_ios, 
                          color: Color(0xFFFEF7FF)),
                        iconSize: 30,
                      ),
                      ElevatedButton(
                        onPressed: _flipCard,
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          backgroundColor: const Color(0xFF49454F),
                        ),
                        child: const Icon(
                          Icons.flip, 
                          color: Color(0xFFFEF7FF), 
                          size: 28
                        ),
                      ),
                      IconButton(
                        onPressed: _nextCard,
                        icon: const Icon(Icons.arrow_forward_ios, 
                          color: Color(0xFFFEF7FF)),
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

import 'package:flutter/material.dart';
import 'package:studyflash/data/datasources/firebase_database_service.dart';
import 'package:studyflash/data/repositories/flashcard_repository_impl.dart';
import 'package:studyflash/domain/models/flashcard.dart';
import 'package:studyflash/domain/use_cases/create_flashcard.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repo = FlashcardRepositoryImpl(FirebaseDatabaseService());
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  List<Flashcard> flashcards = [];

  void _loadFlashcards() async {
    final cards = await _repo.getAllFlashcards();
    setState(() {
      flashcards = cards;
    });
  }

  void _addFlashcard() async {
    final question = _questionController.text;
    final answer = _answerController.text;

    if (question.isEmpty || answer.isEmpty) return;

    final card = Flashcard(
      id: DateTime.now().toString(),
      question: question,
      answer: answer,
    );

    await CreateFlashcard(_repo).call(card);
    _questionController.clear();
    _answerController.clear();
    _loadFlashcards();
  }

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flashcards')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(labelText: 'Question'),
            ),
            TextField(
              controller: _answerController,
              decoration: const InputDecoration(labelText: 'Answer'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addFlashcard,
              child: const Text('Add Flashcard'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: flashcards.length,
                itemBuilder: (_, i) {
                  final card = flashcards[i];
                  return ListTile(
                    title: Text(card.question),
                    subtitle: Text(card.answer),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
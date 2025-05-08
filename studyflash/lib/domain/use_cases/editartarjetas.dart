import 'package:flutter/material.dart';
import 'package:studyflash/data/datasources/firebase_database_service.dart';
import 'package:studyflash/data/repositories/flashcard_repository_impl.dart';
import 'package:studyflash/domain/models/flashcard.dart';
import 'package:studyflash/domain/use_cases/create_flashcard.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _repo = FlashcardRepositoryImpl(FirebaseDatabaseService());
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  List<Flashcard> flashcards = [];
  bool showInputFields = false;

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
      id: DateTime.now().toIso8601String().replaceAll(RegExp(r'[.#$[\]]'), '-'),
      question: question,
      answer: answer,
    );

    await CreateFlashcard(_repo).call(card);
    _questionController.clear();
    _answerController.clear();
    setState(() {
      showInputFields = false;
    });
    _loadFlashcards();
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        title: const Text(
          'Borrar el conjunto',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '¿Seguro que quieres borrar el conjunto?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              backgroundColor: Colors.purple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              // Aquí puedes agregar la lógica para eliminar
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Borrar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Placeholder', style: TextStyle(color: Colors.white)),
        actions: const [
          Icon(Icons.search, color: Colors.white),
          SizedBox(width: 16),
          Icon(Icons.filter_list, color: Colors.white),
          SizedBox(width: 16),
          Icon(Icons.more_vert, color: Colors.white),
          SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Lorem Ipsum', style: TextStyle(color: Colors.white70)),
            if (showInputFields) ...[
              TextField(
                controller: _questionController,
                decoration: const InputDecoration(
                  labelText: 'Question',
                  labelStyle: TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              TextField(
                controller: _answerController,
                decoration: const InputDecoration(
                  labelText: 'Answer',
                  labelStyle: TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addFlashcard,
                child: const Text('Add Flashcard'),
              ),
              const SizedBox(height: 20),
            ],
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: flashcards.length,
                itemBuilder: (_, i) {
                  final card = flashcards[i];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A3A3A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Anverso', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        Text(card.question, style: TextStyle(color: Colors.white)),
                        const Spacer(),
                        Text('Reverso', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        Text(card.answer, style: TextStyle(color: Colors.white)),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.edit, color: Colors.white70, size: 20),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: _showDeleteDialog,
                              child: Icon(Icons.delete, color: Colors.redAccent, size: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => showInputFields = !showInputFields),
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}

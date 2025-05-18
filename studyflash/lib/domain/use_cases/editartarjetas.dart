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

  String conjuntoNombre = 'Placeholder';
  String conjuntoDescripcion = 'Subtítulo placeholder';

  void _loadFlashcards() async {
    final cards = await _repo.getAllFlashcards('temp_uid', 'default_conjunto');
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

    await CreateFlashcard(_repo).call(
      uid: 'temp_uid', // TODO: autenticar al usuario
      conjuntoId: 'default_conjunto',
      card: card,
    );
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
        backgroundColor: const Color(0xFF1D1B20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        title: const Text(
          'Borrar el conjunto',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        content: const Text(
          '¿Seguro que quieres borrar el conjunto?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF49454F),
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

  void _editConjuntoNombre() {
    // ignore: no_leading_underscores_for_local_identifiers
    final _nameController = TextEditingController(text: conjuntoNombre);
    // ignore: no_leading_underscores_for_local_identifiers
    final _descController = TextEditingController(text: conjuntoDescripcion);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1D1B20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Editar nombre y descripción', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Nombre',
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Descripción',
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Guardar', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              final newName = _nameController.text.trim();
              final newDesc = _descController.text.trim();
              final navigator = Navigator.of(context);

              if (newName.isNotEmpty) {
                await FirebaseDatabaseService().updateConjuntoInfo(
                  'temp_uid',          // TODO: autenticar al usuario
                  'default_conjunto',  // TODO: obtener el id del conjunto
                  newName,
                  newDesc,
                );

                setState(() {
                  conjuntoNombre = newName;
                  conjuntoDescripcion = newDesc;
                });
              }

              navigator.pop();
            },
          ),
        ],
      ),
    );
  }

  void _loadMetadata() async {
    final meta = await FirebaseDatabaseService()
        .getConjuntoMetadata('temp_uid', 'default_conjunto');
    setState(() {
      conjuntoNombre = meta['name'] ?? '';
      conjuntoDescripcion = meta['description'] ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
    _loadMetadata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131215),
      appBar: AppBar(
        toolbarHeight: 120,
        backgroundColor: const Color(0xFF1D1B20),
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(28),
          ),
        ),
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.white),
                    onPressed: () {},
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onSelected: (value) {
                      if (value == 'editname') {
                        _editConjuntoNombre();
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: 'editname',
                        child: Text('Editar nombre'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'settings',
                        child: Text('Configuración'),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    conjuntoNombre,
                    style: TextStyle(
                      color: Color(0xFFFEF7FF),
                      fontSize: 24,
                      height: 1.2,
                      letterSpacing: -0.24,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    conjuntoDescripcion,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            if (showInputFields) ...[
              TextField(
                controller: _questionController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Pregunta',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0xFF1D1B20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _answerController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Respuesta',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0xFF1D1B20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addFlashcard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF49454F),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Añadir Flashcard',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 24),
            ],
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: flashcards.length,
                itemBuilder: (_, i) {
                  final card = flashcards[i];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF49454F),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.question,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            height: 1.8,
                            letterSpacing: -0.14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          card.answer,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            height: 0.08,
                            letterSpacing: -0.14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, 
                                color: Colors.white70, 
                                size: 20),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, 
                                color: Colors.redAccent, 
                                size: 20),
                              onPressed: _showDeleteDialog,
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
        backgroundColor: const Color(0xFFFEF7FF),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
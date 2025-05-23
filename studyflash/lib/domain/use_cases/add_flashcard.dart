import 'package:flutter/material.dart';
import 'package:studyflash/data/datasources/firebase_database_service.dart';
import 'package:studyflash/data/repositories/flashcard_repository_impl.dart';
import 'package:studyflash/domain/use_cases/create_flashcard.dart';
import 'package:studyflash/domain/models/flashcard.dart';

class AgregarConjuntoScreen extends StatefulWidget {
  final String uid;
  const AgregarConjuntoScreen(this.uid, {super.key});

  @override
  State<AgregarConjuntoScreen> createState() => _AgregarConjuntoScreenState();
}

class _AgregarConjuntoScreenState extends State<AgregarConjuntoScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _anversoController = TextEditingController();
  final TextEditingController _reversoController = TextEditingController();

  Future<void> _guardarConjunto() async {
    final nombre = _nombreController.text.trim();
    final descripcion = _descripcionController.text.trim();
    final anverso = _anversoController.text.trim();
    final reverso = _reversoController.text.trim();
    final navigator = Navigator.of(context);

    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre del conjunto es requerido')),
      );
      return;
    }

    if (_conjuntoId == null && (anverso.isEmpty || reverso.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes agregar al menos una flashcard')),
      );
      return;
    }

    try {
      final repo = FlashcardRepositoryImpl(FirebaseDatabaseService());
      final createFlashcard = CreateFlashcard(repo);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      if (_conjuntoId == null) {
        _conjuntoId = await FirebaseDatabaseService().createConjunto(
          uid,
          nombre,
          descripcion,
          anverso,
          reverso,
        );

        final primeraFlashcard = Flashcard(
          id: DateTime.now().toIso8601String().replaceAll(RegExp(r'[.#$[\]]'), '-'),
          question: anverso,
          answer: reverso,
        );

        await createFlashcard.call(
          uid: uid,
          conjuntoId: _conjuntoId!,
          card: primeraFlashcard,
        );
      } else {
        await FirebaseDatabaseService().updateConjuntoInfo(
          uid,
          _conjuntoId!,
          nombre,
          descripcion,
        );
      }

      navigator.pop();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conjunto guardado')),
        );
        Navigator.pop(context, _conjuntoId); // salir y pasar el ID
      }
    } catch (e) {
      navigator.pop();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  String? _conjuntoId; 

  void _agregarFlashcard() async {
    final anverso = _anversoController.text.trim();
    final reverso = _reversoController.text.trim();

    if (anverso.isEmpty || reverso.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa ambos lados de la flashcard')),
      );
      return;
    }

    try {
      final repo = FlashcardRepositoryImpl(FirebaseDatabaseService());
      final createFlashcard = CreateFlashcard(repo);

      if (_conjuntoId == null) {
        final nuevoId = await FirebaseDatabaseService().createConjunto(
          uid,
          _nombreController.text.trim(),
          _descripcionController.text.trim(),
          anverso,
          reverso,
        );
        _conjuntoId = nuevoId;
      }

      final flashcard = Flashcard(
        id: DateTime.now().toIso8601String().replaceAll(RegExp(r'[.#$[\]]'), '-'),
        question: anverso,
        answer: reverso,
      );

      await createFlashcard.call(
        uid: uid,
        conjuntoId: _conjuntoId!,
        card: flashcard,
      );

      _anversoController.clear();
      _reversoController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Flashcard agregada')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  late String uid;

  @override
  void initState() {
    super.initState();
    uid = widget.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131215),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(190),
        child: AppBar(
          backgroundColor: const Color(0xFF1D1B20),
          elevation: 4,
          shadowColor: Colors.black.withValues(alpha: 0.3),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
          ),
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.white),
                      onPressed: _guardarConjunto,
                    ),
                  ],
                ),
                TextField(
                  controller: _nombreController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Nombre del conjunto',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                ),
                TextField(
                  controller: _descripcionController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'Descripción del conjunto',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Anverso:',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _anversoController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Escribe el anverso...',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF1D1B20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Reverso:',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reversoController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Escribe el reverso...',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF1D1B20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _agregarFlashcard,
        backgroundColor: const Color(0xFFFEF7FF),
        child: const Icon(Icons.add, color: Colors.black, size: 32),
      ),
    );
  }
}

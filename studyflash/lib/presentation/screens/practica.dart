import 'package:flutter/material.dart';

class FlashcardScreen extends StatelessWidget {
  const FlashcardScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Placeholder',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 60),
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFF1E1B2E),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  'Ejemplo',
                  style: TextStyle(
                    fontSize: 60,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                DifficultyButton(text: 'Fácil', color: Colors.green),
                DifficultyButton(text: 'Moderado', color: Colors.purple),
                DifficultyButton(text: 'Difícil', color: Colors.red),
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

  const DifficultyButton({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Acción al presionar el botón
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(text),
    );
  }
}

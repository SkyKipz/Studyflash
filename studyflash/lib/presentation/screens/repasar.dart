import 'package:flutter/material.dart';

class RepasarScreen extends StatelessWidget {
  const RepasarScreen({super.key});

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
              children: [
                IconButton(
                  onPressed: () {
                    // Acción de "anterior"
                  },
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  iconSize: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Acción de "voltear" tarjeta
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: const Icon(Icons.flip, color: Colors.white, size: 28),
                ),
                IconButton(
                  onPressed: () {
                    // Acción de "siguiente"
                  },
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

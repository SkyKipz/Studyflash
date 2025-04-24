import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Volver a confi.dart
          },
        ),
        title: const Text('Información', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Nombre',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Icon(Icons.edit, color: Colors.purple, size: 20),
              ],
            ),
            const Divider(color: Colors.grey),
            const SizedBox(height: 20),
            const Text(
              'Correo',
              style: TextStyle(color: Colors.white70),
            ),
            const Text(
              '1ejemplo@gmail.com',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 30),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Cambiar cuenta', style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
            ),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Cerrar sesión', style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}

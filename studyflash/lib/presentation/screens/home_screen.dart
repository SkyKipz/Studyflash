import 'package:flutter/material.dart';
import 'editartarjetas.dart';
import 'confi.dart';

class NewHomeScreen extends StatelessWidget {
  const NewHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    //cambiarlo despues por la bd
    final List<Map<String, String>> conjuntos = [
      {'titulo': 'Biología Básica', 'subtitulo': 'Células, ADN y más'},
      {'titulo': 'Historia Mundial', 'subtitulo': 'Primera y Segunda Guerra'},
      {'titulo': 'Inglés Intermedio', 'subtitulo': 'Vocabulario y gramática'},
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 85, 84, 84),
              ),
              child: Column(
                children: [
                  const Text(
                    'Menú',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[800],
                    child: const Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Invitado',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.bookmark),
              title: const Text('Marcadores'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ConfiScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Ayuda'),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('StudyFlash', style: TextStyle(color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: InkWell(
              onTap: () => debugPrint("Barra de búsqueda presionada"),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(8),
                ),
                width: 180,
                height: 40,
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Colors.white70),
                    SizedBox(width: 8),
                    Text('Buscar...', style: TextStyle(color: Colors.white54)),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Conjuntos de flashcards',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Usamos Expanded para que ListView.builder no genere error
            Expanded(
              child: ListView.builder(
                itemCount: conjuntos.length,
                itemBuilder: (context, index) {
                  final conjunto = conjuntos[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.black54, blurRadius: 4, offset: Offset(0, 2)),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              conjunto['titulo']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              conjunto['subtitulo']!,
                              style: const TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.more_vert, color: Colors.white),
                            onPressed: () {},
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                            ),
                            onPressed: () {
                              // Acción de repasar
                            },
                            child: const Text('Repasar'),
                          ),
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }
}


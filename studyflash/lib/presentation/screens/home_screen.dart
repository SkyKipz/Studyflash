import 'package:flutter/material.dart';
import 'package:studyflash/domain/use_cases/add_flashcard.dart';
import 'confi.dart';
import 'opciones.dart'; 
import 'package:studyflash/data/datasources/firebase_database_service.dart';
import 'practica.dart';
import 'repasar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _busquedaController = TextEditingController();

  List<Map<String, String>> conjuntos = [];

  List<Map<String, String>> _conjuntosFiltrados = [];

  @override
  void initState() {
    super.initState();
    _loadConjuntos();
  }

  void _filtrarConjuntos(String query) {
    setState(() {
      _conjuntosFiltrados = conjuntos
          .where((conjunto) =>
              conjunto['titulo']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _mostrarCampoBusqueda() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          title: const Text('Buscar', style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: _busquedaController,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Buscar título...',
              hintStyle: TextStyle(color: Colors.white54),
              enabledBorder:
                  UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
              focusedBorder:
                  UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            ),
            onChanged: _filtrarConjuntos,
          ),
          actions: [
            TextButton(
              onPressed: () {
                _busquedaController.clear();
                _filtrarConjuntos('');
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar', style: TextStyle(color: Colors.deepPurple)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadConjuntos() async {
    final uid = 'temp_uid'; 
    final data = await FirebaseDatabaseService().getAllConjuntos(uid);

    setState(() {
      conjuntos = data;
      _conjuntosFiltrados = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131215),
      drawer: Drawer(
        backgroundColor: const Color(0xFF1D1B20),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF1D1B20),
              ),
              child: Column(
                children: [
                  const Text('Menú', 
                    style: TextStyle(
                      color: Color(0xFFFEF7FF), 
                      fontSize: 16,
                      letterSpacing: -0.16,
                    )),
                  const SizedBox(height: 8),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xFF49454F),
                    child: const Icon(Icons.person, 
                      color: Color(0xFFFEF7FF), 
                      size: 30),
                  ),
                  const SizedBox(height: 5),
                  const Text('Invitado', 
                    style: TextStyle(
                      color: Color(0xFFFEF7FF), 
                      fontSize: 16,
                      letterSpacing: -0.16,
                    )),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.bookmark, color: Color(0xFFFEF7FF)),
              title: const Text('Marcadores', 
                style: TextStyle(color: Color(0xFFFEF7FF))),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Color(0xFFFEF7FF)),
              title: const Text('Configuración', 
                style: TextStyle(color: Color(0xFFFEF7FF))),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ConfiScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help, color: Color(0xFFFEF7FF)),
              title: const Text('Ayuda', 
                style: TextStyle(color: Color(0xFFFEF7FF))),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF1D1B20),
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(28),
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFFFEF7FF)),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('StudyFlash', 
          style: TextStyle(
            color: Color(0xFFFEF7FF),
            letterSpacing: -0.24,
          )),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: InkWell(
              onTap: _mostrarCampoBusqueda,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF49454F),
                  borderRadius: BorderRadius.circular(12),
                ),
                width: 180,
                height: 40,
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Color(0xFFFEF7FF)),
                    SizedBox(width: 8),
                    Text('Buscar', 
                      style: TextStyle(
                        color: Color(0xFFFEF7FF),
                        letterSpacing: -0.14,
                      )),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFFFEF7FF)),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Conjuntos de flashcards',
              style: TextStyle(
                color: Color(0xFFFEF7FF),
                fontSize: 20, 
                fontWeight: FontWeight.bold,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await _loadConjuntos();
                },
                color: const Color(0xFFFEF7FF),
                backgroundColor: const Color(0xFF1D1B20),
                child: ListView.builder(
                  itemCount: _conjuntosFiltrados.length,
                  itemBuilder: (context, index) {
                    final conjunto = _conjuntosFiltrados[index];
                    final conjuntoId = conjunto['id']!;
                    return Container(
                      height: 140,
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1D1B20),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 4, 
                            offset: const Offset(0, 2)),
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
                                  color: Color(0xFFFEF7FF),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.18,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                conjunto['descripcion']!,
                                style: const TextStyle(
                                  color: Color(0xFFFEF7FF),
                                  letterSpacing: -0.14,
                                ),
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.more_vert, color: Color(0xFFFEF7FF)),
                              onPressed: () {
                                showOpcionesDialog(context, conjuntoId);
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF49454F),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => RepasarScreen(conjuntoId)),
                                    );
                                  },
                                  child: const Text(
                                    'Repasar',
                                    style: TextStyle(color: Color(0xFFFEF7FF)),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF49454F),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => FlashcardScreen(conjuntoId)),
                                    );
                                  },
                                  child: const Text(
                                    'Practicar',
                                    style: TextStyle(color: Color(0xFFFEF7FF)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),  
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final uid = 'temp_uid';
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgregarConjuntoScreen(uid),
            ),
          );
        },
        backgroundColor: const Color(0xFFFEF7FF),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}

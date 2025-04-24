import 'package:flutter/material.dart';
import 'home_screen2.dart';
import 'confi.dart';

class NewHomeScreen extends StatelessWidget {
  const NewHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                        Text(
                          'Menú',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        CircleAvatar(
                          radius: 30,  // Tamaño de la imagen
                           backgroundColor: Colors.grey[800],
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 30, // Tamaño del ícono dentro del círculo
                          ),
                        ),
                        SizedBox(height: 5),  // Espacio entre la imagen y el texto
                        Text(
                          'Invitado',  // Nombre predeterminado
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.bookmark),
                    title: Text('Marcadores'),
                    onTap: () {
                      // Funcionalidad futura para Marcadores
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Configuración'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ConfiScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.help),
                    title: Text('Ayuda'),
                    onTap: () {
                      // Funcionalidad futura para Ayuda
                    },
                  ),
                ],
              ),
            ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        //boton "menu"
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,  // Establece el color del ícono como blanco
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'StudyFlash',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,  // Establece el color del texto como blanco
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            //boton "Busqueda"
            child: InkWell(
              onTap: () {
                debugPrint("Barra de búsqueda presionada");
              },
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
                    Text(
                      'Buscar...',
                      style: TextStyle(color: Colors.white54, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
          //boton "tres puntos"
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
          children: const [
            Text(
              'Conjuntos de flashcards',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 32),
            // contenido futuro aquí
          ],
        ),
      ),
      //boton "+"
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

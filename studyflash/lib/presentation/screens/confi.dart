import 'package:flutter/material.dart';
import 'configuracion/info.dart';
import 'configuracion/leng.dart';
import 'configuracion/noti.dart';

class ConfiScreen extends StatelessWidget {
  const ConfiScreen({super.key});

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
        title: const Text('Configuración', style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        children: [
          const ListTile(
            leading: Icon(Icons.person, color: Colors.white),
            title: Text('Invitado', style: TextStyle(color: Colors.white)),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ),
          ListTile(
            title: const Text('Información', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InfoScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Lenguaje', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LengScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Notificaciones', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotiScreen()),
               );
            },
          ),
        ],
      ),
    );
  }
}

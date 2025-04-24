import 'package:flutter/material.dart';

class NotiScreen extends StatefulWidget {
  const NotiScreen({super.key});

  @override
  State<NotiScreen> createState() => _NotiScreenState();
}

class _NotiScreenState extends State<NotiScreen> {
  bool _notifGeneral = true;
  bool _notifCorreo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Notificaciones', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            ListTile(
              title: const Text('Activar notificaciones', style: TextStyle(color: Colors.white)),
              trailing: Switch(
                value: _notifGeneral,
                activeColor: Colors.green,
                activeTrackColor: Colors.greenAccent,
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.grey.shade800,
                onChanged: (bool value) {
                  setState(() {
                    _notifGeneral = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Notificaciones por correo', style: TextStyle(color: Colors.white)),
              trailing: Switch(
                value: _notifCorreo,
                activeColor: Colors.blue,
                activeTrackColor: Colors.lightBlueAccent,
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.grey.shade800,
                onChanged: (bool value) {
                  setState(() {
                    _notifCorreo = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

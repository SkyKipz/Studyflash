import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  void _launchGitHub() async {
    final url = Uri.parse('https://github.com/SkyKipz/Studyflash');
    if (await canLaunchUrl(url)) {
      final success = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!success) {
        throw 'No se pudo abrir el enlace';
      }
    } else {
      throw 'URL no válida';
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131215),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D1B20),
        title: const Text('Ayuda'),
        centerTitle: true,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('📚 Instrucciones básicas'),
            _bulletPoint('Crea conjuntos de tarjetas de estudio.'),
            _bulletPoint('Agrega preguntas y respuestas rápidamente.'),
            _bulletPoint('Edita o elimina cualquier flashcard.'),
            const SizedBox(height: 32),
            _sectionTitle('👨‍💻 Desarrolladores'),
            const SizedBox(height: 8),
            const Text(
              '• SkyKipz\n• MayteHdez\n• Hectordani14',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 32),
            _sectionTitle('🔗 Código fuente'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _launchGitHub,
              child: Row(
                children: const [
                  Icon(FontAwesomeIcons.github, color: Colors.white70),
                  SizedBox(width: 12),
                  Text(
                    'github.com/SkyKipz/Studyflash',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Colors.white, fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

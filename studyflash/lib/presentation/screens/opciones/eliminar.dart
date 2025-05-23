import 'package:flutter/material.dart';
import 'package:studyflash/data/datasources/firebase_database_service.dart';
import 'package:studyflash/presentation/screens/home_screen.dart'; // ajusta si tienes otro path

void showDeleteDialog(BuildContext context, String conjuntoId) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF2C2C2C),
      title: const Text(
        'Borrar el conjunto',
        style: TextStyle(color: Colors.white),
      ),
      content: const Text(
        '¿Seguro que quieres borrar el conjunto?',
        style: TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            backgroundColor: Colors.purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: () async {
            await FirebaseDatabaseService().deleteConjunto(
              'temp_uid',
              conjuntoId,
            );

            if (context.mounted) {
              Navigator.of(context).pop();
              
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Conjunto eliminado')),
              );
            }
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text('Borrar', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
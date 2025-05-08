import 'package:flutter/material.dart';

void showDeleteDialog(BuildContext context) {
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
          onPressed: () {
            // Aquí puedes agregar la lógica para eliminar
            Navigator.of(context).pop();
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

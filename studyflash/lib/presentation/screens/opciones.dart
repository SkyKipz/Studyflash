// opciones.dart
import 'package:flutter/material.dart';
import 'opciones/eliminar.dart';

void showOpcionesDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      backgroundColor: const Color(0xFF2C2C2C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Opciones',
        style: TextStyle(color: Colors.white),
      ),
      children: [
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop();
            // Lógica para editar
          },
          child: const Text('Editar', style: TextStyle(color: Colors.white)),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop();
            // Lógica para marcador
          },
          child: const Text('Marcador', style: TextStyle(color: Colors.white)),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop();
            // Lógica para compartir
          },
          child: const Text('Compartir', style: TextStyle(color: Colors.white)),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop(); // Cierra este diálogo
            showDeleteDialog(context);  // Llama al cuadro de confirmación
          },
          child: const Text(
            'Borrar',
            style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}

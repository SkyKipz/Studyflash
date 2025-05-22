// opciones.dart
import 'package:flutter/material.dart';
import 'opciones/eliminar.dart';
import 'package:studyflash/domain/use_cases/editartarjetas.dart';

void showOpcionesDialog(BuildContext context, String conjuntoId) {
  conjuntoId = conjuntoId;
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditScreen(conjuntoId)),
            );
          },
          child: const Text('Editar', style: TextStyle(color: Colors.white)),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Marcador', style: TextStyle(color: Colors.white)),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Compartir', style: TextStyle(color: Colors.white)),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop();
            showDeleteDialog(context, conjuntoId); // Pásalo también aquí si hace falta
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

import 'package:flutter/material.dart';

class DiarioDeSaludScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diario de salud'),
        backgroundColor: const Color(0xFFEC407A),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Bienvenida a tu diario de salud'),
            const SizedBox(height: 16), // Espacio entre el texto y el botón
            TextButton(
              onPressed: () => throw Exception("Crashlytics test!"),
              child: const Text(
                "Generar Error para Crashlytics",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
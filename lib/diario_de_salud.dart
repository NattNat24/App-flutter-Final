import 'package:flutter/material.dart';
class DiarioDeSaludScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Diario de salud'), backgroundColor: Color(0xFFEC407A)),
      body: Center(
        child: Text('Bienvenida a tu diario de salud'),
      ),
    );
  }
}

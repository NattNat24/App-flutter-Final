import 'package:flutter/material.dart';

class ForoEndoAmigasScreen extends StatelessWidget {
  final TextEditingController _postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Foro EndoAmigas'),
        backgroundColor: Color(0xFFEC407A),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Mensaje de bienvenida
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Comparte tus pensamientos, dudas o experiencias',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),

          // Caja para escribir un nuevo post
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _postController,
              decoration: InputDecoration(
                hintText: '¿Qué quieres compartir hoy?',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send, color: Color(0xFFEC407A)),
                  onPressed: () {
                    //parte santi solicitud post
                    print('Mensaje enviado: ${_postController.text}');
                    _postController.clear();
                  },
                ),
              ),
              maxLines: null,
            ),
          ),

          SizedBox(height: 16),

         
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildPostCard('Hola a todas, ¿alguna ha probado la dieta antiinflamatoria?'),
                _buildPostCard('Recomiendo una ginecóloga súper buena en Medellín'),
                _buildPostCard('Hoy fue un día difícil... pero agradezco este espacio para desahogarme.'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(String text) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(text),
      ),
    );
  }
}

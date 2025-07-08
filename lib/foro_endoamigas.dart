import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForoEndoAmigasScreen extends StatelessWidget {
  final TextEditingController _postController = TextEditingController();

  ForoEndoAmigasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foro EndoAmigas'),
        backgroundColor: const Color(0xFFEC407A),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Mensaje de bienvenida
          const Padding(
            padding: EdgeInsets.all(16.0),
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
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFFEC407A)),
                  onPressed: () async {
                    final text = _postController.text.trim();
                    final user = FirebaseAuth.instance.currentUser;
                    if (text.isNotEmpty && user != null) {
                      await FirebaseFirestore.instance.collection('posts').add({
                        'text': text,
                        'timestamp': FieldValue.serverTimestamp(),
                        'userId': user.uid,
                        'email': user.email, // opcional: muestra quién escribió
                      });
                      _postController.clear();
                    }
                  },
                ),
              ),
              maxLines: null,
            ),
          ),

          const SizedBox(height: 16),

          // Mostrar los posts desde Firestore
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final post = docs[index];
                    final text = post['text'] ?? '';
                    final email = post['email'] ?? 'Usuario';
                    final timestamp = post['timestamp'] as Timestamp?;
                    final fecha = timestamp?.toDate().toLocal().toString().substring(0, 16) ?? '';

                    return _buildPostCard(text, email, fecha);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(String text, String email, String fecha) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('$email • $fecha',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

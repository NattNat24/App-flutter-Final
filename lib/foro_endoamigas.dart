import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForoEndoAmigasScreen extends StatefulWidget {
  const ForoEndoAmigasScreen({super.key});

  @override
  State<ForoEndoAmigasScreen> createState() => _ForoEndoAmigasScreenState();
}

class _ForoEndoAmigasScreenState extends State<ForoEndoAmigasScreen> {
  final TextEditingController _postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Foro EndoAmigas'),
        backgroundColor: const Color(0xFFEC407A),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Comparte tus pensamientos, dudas o experiencias',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
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
                    if (text.isNotEmpty && currentUser != null) {
                      await FirebaseFirestore.instance.collection('posts').add({
                        'text': text,
                        'timestamp': FieldValue.serverTimestamp(),
                        'userId': currentUser.uid,
                        'email': currentUser.email,
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
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final post = docs[index];
                    final text = post['text'] ?? '';
                    final email = post['email'] ?? 'Usuario';
                    final postId = post.id;
                    final timestamp = post['timestamp'] as Timestamp?;
                    final fecha = timestamp?.toDate().toLocal().toString().substring(0, 16) ?? '';

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatGlobalScreen(
                              postId: postId,
                              postText: text,
                            ),
                          ),
                        );
                      },
                      child: Card(
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
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChatGlobalScreen extends StatefulWidget {
  final String postId;
  final String postText;

  const ChatGlobalScreen({
    super.key,
    required this.postId,
    required this.postText,
  });

  @override
  State<ChatGlobalScreen> createState() => _ChatGlobalScreenState();
}

class _ChatGlobalScreenState extends State<ChatGlobalScreen> {
  final TextEditingController _messageController = TextEditingController();
  late final String currentUserId;
  late final String currentUserEmail;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser!;
    currentUserId = user.uid;
    currentUserEmail = user.email ?? 'Anónimo';
  }

  void sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('posts/${widget.postId}/chat')
          .add({
        'senderId': currentUserId,
        'email': currentUserEmail,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tema: ${widget.postText.length > 25 ? widget.postText.substring(0, 25) + "..." : widget.postText}'),
        backgroundColor: const Color(0xFFEC407A),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts/${widget.postId}/chat')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index];
                    final isMe = data['senderId'] == currentUserId;
                    final email = data['email'] ?? 'Usuario';

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.pink[100] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(email, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                            Text(data['text']),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Escribe tu mensaje...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFFEC407A)),
                  onPressed: sendMessage,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DiarioDeSaludScreen extends StatefulWidget {
  @override
  _DiarioDeSaludScreenState createState() => _DiarioDeSaludScreenState();
}

class _DiarioDeSaludScreenState extends State<DiarioDeSaludScreen> {
  DateTime _selectedDay = DateTime.now();
  TextEditingController _notaController = TextEditingController();

  Map<DateTime, List<String>> _notasDelDia = {};

  @override
  void initState() {
    super.initState();
    _fetchNotas();
  }

  void _fetchNotas() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .collection('diario')
        .get();

    final notas = <DateTime, List<String>>{};

    snapshot.docs.forEach((doc) {
      final data = doc.data();
      final fecha = (data['fecha'] as Timestamp).toDate();
      final texto = data['nota'] as String;

      final dia = DateTime.utc(fecha.year, fecha.month, fecha.day);
      if (notas.containsKey(dia)) {
        notas[dia]!.add(texto);
      } else {
        notas[dia] = [texto];
      }
    });

    setState(() {
      _notasDelDia = notas;
    });
  }

  void _agregarNota() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || _notaController.text.trim().isEmpty) return;

    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .collection('diario')
        .add({
      'fecha': _selectedDay,
      'nota': _notaController.text.trim(),
    });

    _notaController.clear();
    _fetchNotas(); // Recargar las notas
  }

  @override
  Widget build(BuildContext context) {
    final notas = _notasDelDia[_selectedDay] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Diario de Salud'),
        backgroundColor: Color(0xFFEC407A),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TableCalendar(
              focusedDay: _selectedDay,
              firstDay: DateTime(2000),
              lastDay: DateTime(2100),
              calendarFormat: CalendarFormat.month,
              selectedDayPredicate: (day) =>
                  isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: _notaController,
              decoration: InputDecoration(
                hintText: 'Escribe tu nota...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _agregarNota,
              child: Text('Agregar Nota'),
            ),
            SizedBox(height: 16),
            Text('Notas para el ${_selectedDay.toLocal().toString().split(' ')[0]}:'),
            Expanded(
              child: ListView.builder(
                itemCount: notas.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(notas[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
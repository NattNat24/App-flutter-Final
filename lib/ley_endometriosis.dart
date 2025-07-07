import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LeyEndometriosisScreen extends StatelessWidget {
  final String _url = 'https://www.endometriosiscolombia.com/';

  Future<void> _launchURL() async {
    final Uri uri = Uri.parse(_url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'No se pudo abrir $_url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ley de Endometriosis'),
        backgroundColor: Color(0xFFEC407A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Mensaje principal
            Text(
              'Infórmate sobre tus derechos como mujer con endometriosis',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),

            
            Icon(Icons.gavel, size: 80, color: Color(0xFFEC407A)),
            SizedBox(height: 24),

            // Botón para ir al sitio web
            ElevatedButton.icon(
              onPressed: _launchURL,
              icon: Icon(Icons.open_in_browser),
              label: Text('Visita ASOCOEN'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEC407A),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

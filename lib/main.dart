import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endoser_app2/utils/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'diario_de_salud.dart';
import 'foro_endoamigas.dart';
import 'ley_endometriosis.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  runApp(EndoSerApp());
}

class EndoSerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EndoSer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Arial',
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Color(0xFFEC407A),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFF5F5F5),
          contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFEC407A),
            foregroundColor: Colors.white,
            textStyle: TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: Size(double.infinity, 50),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Color(0xFFEC407A),
            side: BorderSide(color: Color(0xFFEC407A)),
            textStyle: TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: Size(double.infinity, 50),
          ),
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          labelMedium: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}

// Pantalla Splash
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Center(
        child: SvgPicture.asset(
          'assets/images/girasol.svg',
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              SizedBox(height: 40),
              SvgPicture.asset(
                'assets/images/girasol.svg',
                width: 100,
                height: 100,
              ),
              SizedBox(height: 20),
              Text('EndoSer', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Nombre de usuario', style: Theme.of(context).textTheme.labelMedium),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _userController,
                decoration: InputDecoration(
                  hintText: 'Ingresa tu usuario',
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Contraseña', style: Theme.of(context).textTheme.labelMedium),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Ingresa tu contraseña',
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async{
                  var result= await _auth.singInEmailAndPasword(_userController.text, _passwordController.text);
                  if(result==1){
                    print("usuario no found");
                  }else if(result==2){
                    print("contraseña incorrecta");
                  }else if(result !=null){
                    final user = FirebaseAuth.instance.currentUser;
                    final userId = user!.uid;

                    print('Usuario autenticado con UID: $userId');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => HomeScreen()),
                    );
                  }


                },
                child: Text('ACCEDER'),
              ),
              SizedBox(height: 12),
              TextButton(
                onPressed: () {},
                child: Text(
                  '¿Has olvidado tu contraseña?',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
              SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RegisterScreen()),
                  );
                },
                child: Text('CREAR CUENTA'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class RegisterScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController(); // Nuevo campo para nombre
  final TextEditingController _newUserController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
        backgroundColor: Color(0xFFEC407A),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Nombre', style: Theme.of(context).textTheme.labelMedium),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Ingresa tu nombre',
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Correo electrónico', style: Theme.of(context).textTheme.labelMedium),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _newUserController,
              decoration: InputDecoration(
                hintText: 'Ingresa tu correo',
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Contraseña', style: Theme.of(context).textTheme.labelMedium),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Ingresa tu contraseña',
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                // Primero, creamos el usuario en Firebase Auth
                var result = await _auth.createAccount(_newUserController.text, _newPasswordController.text);

                if (result == 1) {
                  print("contraseña muy corta");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Contraseña muy corta'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 3),
                    ),
                  );
                } else if (result == 2) {
                  print("usuario ya existe");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('El usuario ya existe'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 3),
                    ),
                  );
                } else if (result != null) {
                  // Si result es el UID, guardamos el nombre en Firestore
                  await FirebaseFirestore.instance.collection('usuarios').doc(result).set({
                    'nombre': _nameController.text,
                    'uid': result,
                  });

                  print("Registro exitoso");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                  );
                }
              },
              child: Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bienvenida, EndoAmiga'),
          backgroundColor: Color(0xFFEC407A),
          automaticallyImplyLeading: false, 
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              tooltip: 'Cerrar sesión',
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFC1E3), Color(0xFFFF80AB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '¡Hola, EndoAmiga!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3,
                      color: Colors.black26,
                    )
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                icon: Icon(Icons.book),
                label: Text('Diario de salud'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFFEC407A),
                  textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => DiarioDeSaludScreen()));
                },
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                icon: Icon(Icons.forum),
                label: Text('Foro EndoAmigas'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFFEC407A),
                  textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ForoEndoAmigasScreen()));
                },
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                icon: Icon(Icons.gavel),
                label: Text('Ley de Endometriosis Colombia'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFFEC407A),
                  textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => LeyEndometriosisScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}



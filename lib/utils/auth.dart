import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth _auth= FirebaseAuth.instance ;

  Future createAccount(String correo, String pass)async{

    try{
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: correo, password: pass);
      print(userCredential.user);
      return (userCredential.user?.uid);
    }on FirebaseAuthException catch(e){
      if(e.code=='weak-password'){
        print('debilucho');
        return 1;
      }else if(e.code == "email-already-in-use"){
        print("el correo ya existe");
        return 2;

      }

    }catch(e){
      print(e);
    }

  }


  Future singInEmailAndPasword(String email, String password)async{
    try {
      UserCredential userCredential =await _auth.signInWithEmailAndPassword(email: email, password: password);
      final a =userCredential.user;
      if(a?.uid !=null){
        return a?.uid;
      }


    }on FirebaseAuthException catch(e){
      if (e.code=='user-not-found'){
        return 1;
      }else if(e.code == 'wrong password') {
        return 2;
      }
    }
  }
}
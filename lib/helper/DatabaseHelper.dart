import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo/utils/global.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DatabaseHelper {

  static DatabaseHelper instance = DatabaseHelper();

  // CupertinoButton.filled(
  //   onPressed: () async {
  //     try{
  //       final userCredential =  await FirebaseAuth.instance.signInAnonymously();
  //     } catch(e){
  //       print(e);
  //     }
  //   },
  //   child: Text("Anonymou"),
  // ),
  //
  // SizedBox(height: 40,),
  //
  // CupertinoButton.filled(
  //     child: Text("Email & PassWord"),
  //   onPressed: () async {
  //      try{
  //        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //          email: "abc@gmail.com",
  //          password: "123456",
  //        );
  //      } catch(e)
  //     {
  //       print(e);
  //     }
  //   },
  // ),
  //
  // SizedBox(height: 20,),
  //
  // CupertinoButton.filled(
  //     child: Text("Login In Google",),
  //     onPressed: () => setState(() {
  //       dbhHelper.authGoogle();
  //     }),
  //
  // ),

  authSignin() async {
    try {
      final userCredential =  await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text, password: pass.text,);
      user = userCredential.user;
      print(user?.emailVerified);
    } on FirebaseAuthException catch(e){
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      }
      print(e);
    }
  }


  authSignUp() async {
    try {
      final userCredential =  await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text, password: pass.text,);

    }  catch(e){
      print(e);
    }
  }

  authAnonymous() async {
    try{
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      user = userCredential.user;
      print(user);
    }catch(e){
      print(e);
    }
  }

  authGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    print("email ${googleUser!.email}");
    print(user);
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
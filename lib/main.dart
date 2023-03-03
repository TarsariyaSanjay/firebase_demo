import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(
    MaterialApp(
      home: HomeScreen(),
    ),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Appbar Auth"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoButton.filled(
              onPressed: () async {
                try{
                  final userCredential =  await FirebaseAuth.instance.signInAnonymously();
                } catch(e){
                  print(e);
                }
              },
              child: Text("Anonymou"),
            ),
            SizedBox(height: 20,),

            CupertinoButton.filled(
                child: Text("Email & PassWord"),
              onPressed: () async {
                 try{
                   final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                     email: "abc@gmail.com",
                     password: "123456",
                   );
                 } catch(e)
                {
                  print(e);
                }
              },
            ),

            SizedBox(height: 20,),

            CupertinoButton.filled(
                child: Text("Login In Google",),
                onPressed: () => setState(() {
                  authGoogle();
                }),

            ),

          ],
        ),
      ),
    );
  }

  authGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    print("email ${googleUser!.email}");
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }


}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/DatabaseHelper.dart';
import '../utils/global.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  DatabaseHelper dbhHelper = DatabaseHelper.instance;
  GlobalKey<FormState> sign = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Appbar Auth"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: sign,
          child: ListView(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100,),
              Text("Sign In",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 50,),

              // ====== Email =============

              TextFormField(
                validator: (val){
                  if(val!.isEmpty){
                    return "Please Enter The Email";
                  }
                  return null;
                },
                onChanged: (val){
                  setState(() {
                    email.text = val;
                    print(email.text);
                  });
                },
                decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        fontSize: 18
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    focusedBorder: OutlineInputBorder()
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  fontSize: 20,
                ),
              ),

              SizedBox(height: 30,),

              // ====== pass =============

              TextFormField(
                validator: (val){
                  if(val!.isEmpty){
                    return "Please Enter The Password";
                  }
                  return null;
                },
                onChanged: (val){
                  setState(() {
                    pass.text = val;
                  });
                },
                decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        fontSize: 18
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    focusedBorder: OutlineInputBorder()
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  fontSize: 20,
                ),
              ),

              SizedBox(height: 70,),


              CupertinoButton(
                color: Colors.black,
                minSize: 60,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 70),
                  child: Text("Log In",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        fontSize: 22
                    ),
                  ),
                ),
                onPressed: () async {
                  if(sign.currentState!.validate()){
                    try {
                      final userCredential =  await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email.text, password: pass.text,);
                      user = userCredential.user;
                      Navigator.pushReplacementNamed(
                        context,
                        'home',
                      );
                      print(user?.emailVerified);
                    } on FirebaseAuthException catch(e){
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                            Text("No user found for that email."),
                          ),
                        );
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided.');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Wrong password provided."),
                          ),
                        );
                      }
                      print(e);
                    }
                  }
                },
              ),

              SizedBox(height: 15,),

              Center(
                child: Text("OR",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              SizedBox(height: 15,),

              CupertinoButton(
                color: Colors.black,
                minSize: 60,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text("Continue With Google",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        fontSize: 22
                    ),
                  ),
                ),
                onPressed: (){
                  if(sign.currentState!.validate()){
                    dbhHelper.authGoogle();
                  }
                },
              ),

              SizedBox(height: 15,),

              //========== Signup

              CupertinoButton(
                child: Text("Sign UP",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                  ),
                ),
                onPressed: () {
                  if(sign.currentState!.validate()){
                    dbhHelper.authSignUp();
                  }
                },
                color: Colors.black,
              ),

              SizedBox(height: 15,),

              //========== Anonymous

              CupertinoButton(
                child: Text("Anonymous",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                  ),
                ),
                onPressed: () => dbhHelper.authAnonymous(),
                color: Colors.black,
              ),


            ],
          ),
        ),
      ),
    );
  }
}

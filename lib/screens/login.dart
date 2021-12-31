import 'package:chattingapp/screens/chatsusers.dart';
import 'package:chattingapp/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

TextEditingController emailcontrollerlogin = TextEditingController();
TextEditingController passwordcontrollerlogin = TextEditingController();

FirebaseAuth auth = FirebaseAuth.instance;

Future login(context) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailcontrollerlogin.text,
            password: passwordcontrollerlogin.text);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ChatUser()),
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
}

class _LoginState extends State<Login> {
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.pink,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(
                  "assets/images/logo.png",
                ),
                height: 150,
                width: MediaQuery.of(context).size.width,
              ),
              Text(
                "Welcome to Baatcheet",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.09),
              Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    "Email",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  )),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    fillColor: Colors.pinkAccent,
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(3)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  controller: emailcontrollerlogin,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    "Password",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  )),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  obscureText: _isObscure,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    fillColor: Colors.pinkAccent,
                    filled: true,
                    suffixIcon: IconButton(
                        icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        }),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(3)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  controller: passwordcontrollerlogin,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.08,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        textStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      login(context);
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.pink),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't have account ?",
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Signup()),
                          );
                        },
                        child: Text(
                          " create account",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

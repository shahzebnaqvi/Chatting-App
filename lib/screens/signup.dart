import 'package:chattingapp/helper/stoarage_helper.dart';
import 'package:chattingapp/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

import 'package:file_picker/file_picker.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

TextEditingController emailcontroller = TextEditingController();
TextEditingController passwordcontroller = TextEditingController();
TextEditingController usernamecontroller = TextEditingController();

FirebaseAuth auth = FirebaseAuth.instance;
var results;

Future signup1(context) async {
  if (results != "" &&
      emailcontroller.text != "" &&
      usernamecontroller.text != "" &&
      passwordcontroller.text != "") {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailcontroller.text, password: passwordcontroller.text);
      await FirebaseFirestore.instance.collection("user_detail").add({
        'email': emailcontroller.text,
        'username': usernamecontroller.text,
        'password': passwordcontroller.text,
        'profile': results.files.single.path
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}

class _SignupState extends State<Signup> {
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
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    fillColor: Colors.pinkAccent,
                    filled: true,
                    hintText: "Enter Email",
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(3)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  controller: emailcontroller,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    fillColor: Colors.pinkAccent,
                    filled: true,
                    hintText: "Enter Username",
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(3)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  controller: usernamecontroller,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    fillColor: Colors.pinkAccent,
                    filled: true,
                    hintText: "Enter Password",
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(3)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  controller: passwordcontroller,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              InkWell(
                onTap: () async {
                  results = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowMultiple: false,
                      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg']);
                  setState(() {
                    results = results;
                  });
                  if (results == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("content"),
                      ),
                    );
                  }
                  Storage storageobj = Storage();

                  var filename = results.files.single.name;
                  var pathname = results.files.single.path;
                  storageobj.uploadFile(pathname, filename);
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.pinkAccent,
                  child: Icon(Icons.add),
                ),
              ),
              if (results != null)
                Container(
                  width: MediaQuery.of(context).size.width * .4,
                  child: Image.file(
                    File(results.files.single.path),
                  ),
                ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton(
                  onPressed: () {
                    signup1(context);
                  },
                  child: Text(
                    "Signup",
                    style: TextStyle(color: Colors.pink),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      textStyle:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already hava an account ?",
                      style: TextStyle(color: Colors.white),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          " login",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
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

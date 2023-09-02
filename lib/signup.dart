// ignore_for_file: dead_code, unused_local_variable, unnecessary_null_comparison

import 'dart:io';

import 'package:backend/login.dart';
import 'package:backend/pickers/user_pics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final auth = FirebaseAuth.instance;
  late UserCredential credential;
  bool isLoading = false;

  void submitAuthForm(String email, String password, String username,
      File image, BuildContext ctx) async {
    try {
      setState(() {
        isLoading = true;
      });
      credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child('${credential.user!.uid}.jpg');

      await ref.putFile(image);

      final url = await ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set(
        {
          'username': username,
          'password': password,
          'image_url': url,
        },
      );
    } on FirebaseAuthException catch (e) {
      String messege = 'Error Occured';
      if (e.code == 'weak-password') {
        messege = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        messege = 'The account already exists for that email.';
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    String email = '';
    String password = '';
    String userName = '';
    // ignore: prefer_typing_uninitialized_variables
    File? userImageFile;
    void pickedImage(File pickedImage) {
      userImageFile = pickedImage;
    }

    void submit() async {
      final isValid = key.currentState!.validate();
      FocusScope.of(context).unfocus();

      if (userImageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please Pick an Image'),
            backgroundColor: Colors.amber,
          ),
        );
        return;
      }

      if (isValid) {
        key.currentState!.save();
        submitAuthForm(email, password, userName, userImageFile!, context);
      }
    }

    return Scaffold(
      body: Center(
        child: Card(
          elevation: 10,
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Form(
                  key: key,
                  child: Column(
                    children: [
                      UserImagePicker(
                        imagePickerFn: pickedImage,
                      ),
                      TextFormField(
                        key: const ValueKey('username'),
                        decoration: const InputDecoration(
                          label: Text('Username'),
                          prefixIcon: Icon(Icons.person),
                        ),
                        onSaved: (newValue) => userName = newValue!,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 7) {
                            return 'Username must be atleast 7 characters';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
                      ),
                      TextFormField(
                        key: const ValueKey('email'),
                        decoration: const InputDecoration(
                          label: Text('Email'),
                          prefixIcon: Icon(Icons.email),
                        ),
                        onSaved: (newValue) => email = newValue!,
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Please Enter a valid E-mail';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextFormField(
                        key: const ValueKey('password'),
                        decoration: const InputDecoration(
                            label: Text('Password'),
                            prefixIcon: Icon(Icons.lock)),
                        onSaved: (newValue) => password = newValue!,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 6) {
                            return 'Password must be atleast 6 characters';
                          }
                          return null;
                        },
                        obscureText: true,
                      ),
                      const SizedBox(height: 15),
                      if (isLoading) const CircularProgressIndicator(),
                      if (!isLoading)
                        ElevatedButton(
                            onPressed: submit, child: const Text('Sign up')),
                      const SizedBox(height: 15),
                      if (!isLoading)
                        TextButton(
                          child: const Text('Already have an account'),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => const Login()),
                              ),
                            );
                          },
                        ),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}

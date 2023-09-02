import 'package:backend/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final auth = FirebaseAuth.instance;
  UserCredential? credential;
  bool isLoading = false;

  void loginSubmit(String email, String password, BuildContext context) async {
    try {
      setState(() {
        isLoading = true;
      });
      credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw ' No user found for that email.';
      } else if (e.code == 'wrong-password') {
        throw 'Wrong password provided for that user.';
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

    void submit() {
      final isValid = key.currentState!.validate();
      FocusScope.of(context).unfocus();
      if (isValid) {
        key.currentState!.save();
        loginSubmit(email, password, context);
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
                            onPressed: submit, child: const Text('Login')),
                      const SizedBox(height: 15),
                      if (!isLoading)
                        TextButton(
                          child: const Text('Don\'t have an account?'),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => const SignUp()),
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

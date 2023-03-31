import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/firebase_auth.dart';
import 'package:login_screen/homeScreen.dart';
import 'package:login_screen/signUpScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:login_screen/validator.dart';

class Login extends StatefulWidget {
   Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<Login> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _focusname = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  final _formKey = GlobalKey<FormState>();


  User? user = FirebaseAuth.instance.currentUser;

   _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            user: user,
          ),
        ),
      );
    }

    return firebaseApp;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done){
            return Padding(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          child: const Text(
                            'Login Page',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                                fontSize: 30),
                          )),
                    ),
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 20),
                        )),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: nameController,
                        focusNode: _focusname,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'User Name',
                        ),
                        validator: (value) => Validator.validateEmail(
                          email: value,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        focusNode: _focusPassword,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                        validator: (value) => Validator.validatePassword(
                          password: value,
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    _isProcessing? CircularProgressIndicator():
                    Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                          child: Text('Login'),
                          onPressed: () async {
                            _focusname.unfocus();
                            _focusPassword.unfocus();
                            if (_formKey.currentState!
                                .validate()){
                              setState(() {
                                _isProcessing = true;
                              });
                              User? user = await FirebaseAuthHelper
                                  .signInUsingEmailPassword(
                                email: nameController.text,
                                password:
                                passwordController.text,
                              );
                              setState(() {
                                _isProcessing = false;
                              });
                              if (user != null){
                                Navigator.of(context)
                                    .pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          HomeScreen(user: user),
                                    )
                                );
                              }
                            }

                          },
                        )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Does not have account?'),
                        TextButton(
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return SignupPage();
                              }),
                            );
                          },
                        )
                      ],

                    ),
                  ],
                ));
          }
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

      ),
    );
  }
}
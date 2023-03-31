import 'package:flutter/material.dart';
import 'package:login_screen/Loginscreen.dart';
import 'package:login_screen/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_screen/homeScreen.dart';


class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();

  final _emailTextController = TextEditingController();

  final _passwordTextController = TextEditingController();

  final _focusName = FocusNode();

  final _focusEmail = FocusNode();

  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,),


        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),

          child: Form(
            key: _registerFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("Sign up",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,

                      ),),
                    SizedBox(height: 40,),
                  ],
                ),
                Column(
                  children: <Widget>[
                    inputFile(label: "Firstname",controller: _nameTextController,focus: _focusName),
                    inputFile(label: "Email",controller: _emailTextController,focus: _focusEmail),
                    inputFile(label: "Password", obscureText: true,controller: _passwordTextController,focus: _focusPassword),
                  ],
                ),
                SizedBox(height: 30,),
                _isProcessing?CircularProgressIndicator():
                Container(
                  padding: EdgeInsets.only(top: 3, left: 3),
                  decoration:
                  BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                  ),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () async {
                      setState(() {
                        _isProcessing = true;
                      });
                      if (_registerFormKey.currentState!
                          .validate()){
                        User? user = await FirebaseAuthHelper
                            .registerUsingEmailPassword(
                          name: _nameTextController.text,
                          email: _emailTextController.text,
                          password:
                          _passwordTextController.text,
                        );
                        setState(() {
                          _isProcessing = false;
                        });
                        if (user != null){
                          Navigator.of(context)
                              .pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) =>
                                  HomeScreen(user: user),
                            ),
                            ModalRoute.withName('/'),
                          );
                        }
                      }else{
                        setState(() {
                          _isProcessing = false;
                        });
                      }

                    },
                    color: Color(0xff0095FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      "Sign up", style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    ),

                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Already have an account?"),
                    InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return Login();
                          }),
                        );
                      },
                      child: Text(" Login", style:TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18
                      ),
                      ),
                    )
                  ],
                )



              ],

            ),
          ),


        ),

      ),

    );
  }
}

Widget inputFile({label, obscureText = false, TextEditingController ?controller, FocusNode ?focus})
{
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color:Colors.black87
        ),
      ),
      SizedBox(
        height: 5,
      ),
      TextField(
        obscureText: obscureText,
        controller: controller,
        focusNode: focus,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0,
                horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey
              ),

            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)
            )
        ),
      ),
      SizedBox(height: 10,)
    ],
  );
}
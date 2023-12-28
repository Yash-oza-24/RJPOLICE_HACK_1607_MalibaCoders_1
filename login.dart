// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, avoid_print, avoid_unnecessary_containers, unused_field, prefer_final_fields, use_build_context_synchronously, empty_statements, use_key_in_widget_constructors, unnecessary_new, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mylogin3/views/Police/dropdown.dart';
import 'package:mylogin3/views/Police/policehomescreen.dart';
import 'package:mylogin3/views/User/scanner.dart';

import 'package:mylogin3/views/auth/forgotpassword.dart';
import 'package:mylogin3/views/registartion/registartion.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  bool _obsecuretext = true;
  TextEditingController loginemailController = TextEditingController();
  TextEditingController loginpasswordController = TextEditingController();
  String selectedRole = "user";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _formkey,
        child: Scaffold(
          backgroundColor: Colors.white,
          // body: Container(
          //   decoration: BoxDecoration(
          //       // image: DecorationImage(
          //     // image: AssetImage("assets/bg2.jpg"),
          //     fit: BoxFit.cover,
          //     colorFilter: new ColorFilter.mode(
          //         Colors.black.withOpacity(0.5), BlendMode.dstATop),
          //   )),
          //   child:
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image(image: AssetImage('assets/Login.png')),
                    Text(
                      'Welcome',
                      style: TextStyle(fontSize: 40, color: Colors.black),
                    ),
                    Text('Login to Your Account'),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Email is Required";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      controller: loginemailController,
                      decoration: InputDecoration(
                          label: Text('Email'),
                          // hintText: "Enter Email",
                          prefixIcon: const Icon(
                            Icons.email,
                          ),
                          fillColor: Colors.black,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "PassWord is Required";
                        }
                        return null;
                      },
                      obscureText: _obsecuretext,
                      controller: loginpasswordController,
                      decoration: InputDecoration(
                          label: Text('Password'),
                          // hintText: "Enter Password",
                          prefixIcon: Icon(
                            Icons.security,
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obsecuretext = !_obsecuretext;
                                });
                              },
                              icon: _obsecuretext
                                  ? Icon(
                                      Icons.visibility_off,
                                      color: Colors.black,
                                    )
                                  : Icon(
                                      Icons.visibility,
                                      color: Colors.black,
                                    )),
                          fillColor: Colors.black,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          Get.to(() => Forgotpassword());
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          var loginemail = loginemailController.text.trim();
                          var loginpassword =
                              loginpasswordController.text.trim();

                          try {
                            var userSnapshot = await FirebaseFirestore.instance
                                .collection('users')
                                .where('UserEmaiId', isEqualTo: loginemail)
                                .get();
                            if (userSnapshot.docs.isNotEmpty) {
                              final User? firebaseUser = (await FirebaseAuth
                                      .instance
                                      .signInWithEmailAndPassword(
                                email: loginemail,
                                password: loginpassword,
                              ))
                                  .user;

                              if (firebaseUser != null) {
                                saveUserInformationLocally('user');
                                Fluttertoast.showToast(
                                  msg: "Login Successfully",
                                  backgroundColor: Colors.yellow,
                                  textColor: Colors.black,
                                );
                                Get.to(() => IFlutterBarcodeScanner());
                              } else {
                                print("Check email & password.");
                              }
                            } else {
                              var policeSnapshot = await FirebaseFirestore
                                  .instance
                                  .collection('Police')
                                  .where('PoliceEmaiId', isEqualTo: loginemail)
                                  .get();

                              if (policeSnapshot.docs.isNotEmpty) {
                                final User? firebaseUser2 = (await FirebaseAuth
                                        .instance
                                        .signInWithEmailAndPassword(
                                  email: loginemail,
                                  password: loginpassword,
                                ))
                                    .user;

                                if (firebaseUser2 != null) {
                                  saveUserInformationLocally2('police');

                                  Fluttertoast.showToast(
                                    msg: "Login Successfully",
                                    backgroundColor: Colors.yellow,
                                    textColor: Colors.black,
                                  );
                                  Get.to(() => drop());
                                } else {
                                  print("Check email & password.");
                                }
                              } else {
                                print("User not found.");
                              }
                            }
                          } on FirebaseAuthException catch (e) {
                            Fluttertoast.showToast(
                              msg: "Login Failed !!",
                              backgroundColor: Colors.red,
                              textColor: Colors.black,
                            );
                            print("Error $e");
                          }
                          saveUserInfoLocally();
                        }
                      },
                      child: Text('Login'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don`t have an account?'),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => registartion()));
                          },
                          child: Text('Sign up'),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void saveUserInfoLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Username', 'John Doe');
  }
}

void saveUserInformationLocally(String userRole) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('userRole', userRole);
}

void saveUserInformationLocally2(String userRole) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('userRole', userRole);
}

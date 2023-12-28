// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, avoid_print, sized_box_for_whitespace, use_key_in_widget_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mylogin3/views/registartion/login.dart';

class Forgotpassword extends StatefulWidget {
  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  TextEditingController ForgotpasswordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 250,
                        width: 400,
                        child: Image(image: AssetImage('assets/Forgot.png'))),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Forgot Password",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Email is Required";
                        }
                        return null;
                      },
                      controller: ForgotpasswordController,
                      decoration: InputDecoration(
                          label: Text("Email"),
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            var forgotpassword =
                                ForgotpasswordController.text.trim();
                            try {
                              FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: forgotpassword)
                                  .then((value) => {
                                        print("Sent email"),
                                        Get.off(() => LoginScreen())
                                      });
                            } on FirebaseAuthException catch (e) {
                              print("Error$e");
                            }
                          }
                        },
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(color: Colors.black),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

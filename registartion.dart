// ignore_for_file: unnecessary_null_comparison, body_might_complete_normally_nullable, use_key_in_widget_constructors, use_key_in_widget_constructors, duplicate_ignore, library_private_types_in_public_api, avoid_print, unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types, unnecessary_new, use_build_context_synchronously, avoid_unnecessary_containers

import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:mylogin3/views/Police/policehomescreen.dart';
import 'package:mylogin3/views/auth/otp.dart';
import 'package:mylogin3/views/registartion/login.dart';
import 'package:otp/otp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class registartion extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

enum UserRole {
  selectRole,
  user,
  police,
}

String generateOTP() {
  String secret = OTP.generateTOTPCodeString(
      'YOUR_SECRET_KEY', DateTime.now().millisecondsSinceEpoch);
  return secret.substring(0, 6);
}

void sendEmail({required String recipientMail, required String otp}) async {
  String username = 'yashoza2408@gmail.com';
  String password = 'eflv awek ccbz hrol';
  final smtpServer = gmail(username, password);
  final message = Message()
    ..from = Address(username, '')
    ..recipients.add(recipientMail)
    ..subject = 'Your OTP Verification Code'
    ..text =
        'Thank you for choosing our service! To complete your  registration/account setup, please use the following  One-Time Password (OTP) within the next 2 minutes OTP Code: $otp';
  try {
    await send(message, smtpServer);
    print('OTP Sent!');
  } catch (e) {
    print('Error: $e');
  }
}

class _MyHomePageState extends State<registartion> {
  UserRole selectedRole = UserRole.selectRole;
  final _formkey = GlobalKey<FormState>();
  bool _obsecuretext = true;
  TextEditingController policenameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController loginnameController = TextEditingController();
  TextEditingController loginpasswordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController userphoneController = TextEditingController();
  TextEditingController useremailController = TextEditingController();
  TextEditingController userpasswordController = TextEditingController();
  Future<void> _uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null || result.files.isEmpty) return;
    PlatformFile file = result.files.first;
    if (file == null || file.path == null) {
      print('Error Accessing The File.');
      return;
    }
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('uploads/${result.files.single.name}');
    UploadTask uploadTask = storageReference.putFile(File(file.path!));
    try {
      await uploadTask;
      print('File Uploaded Successfully.');
    } on FirebaseException catch (e) {
      print('Error Uploading The File: $e');
    }
    await uploadTask.whenComplete(() {
      print('File Uploaded Successfully.');
    });
    Fluttertoast.showToast(
        msg: " Upload Successfully ",
        backgroundColor: Colors.white,
        textColor: Colors.black);
  }

  TextEditingController captchaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _formkey,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image(image: AssetImage('assets/Signup.png')),
                    Text(
                      'Welcome',
                      style: TextStyle(fontSize: 40, color: Colors.black),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DropdownButton<UserRole>(
                      value: selectedRole,
                      onChanged: (UserRole? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedRole = newValue;
                          });
                        }
                      },
                      items: [
                        DropdownMenuItem(
                          value: UserRole.selectRole,
                          child: Text('Select Role'),
                        ),
                        DropdownMenuItem(
                          value: UserRole.user,
                          child: Text('User'),
                        ),
                        DropdownMenuItem(
                          value: UserRole.police,
                          child: Text('Police'),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    if (selectedRole == UserRole.user)
                      userRegistrationWidget()
                    else if (selectedRole == UserRole.police)
                      policeRegistrationWidget(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget userRegistrationWidget() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            // Username field
            validator: (value) {
              if (value!.isEmpty) {
                return "Username is required";
              }
            },
            controller: usernameController,
            decoration: InputDecoration(
              label: Text("Username"),
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            // Phone number field
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter Your Phone No.';
              } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                return 'Phone No. must be 10 digits and numerical.';
              }
              return null;
            },
            controller: userphoneController,
            decoration: InputDecoration(
              label: Text("Phone"),
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            // Email field
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter Your Email Id';
              } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                  .hasMatch(value)) {
                return 'Enter valid Email Id';
              }
              return null;
            },
            controller: useremailController,
            decoration: InputDecoration(
              label: Text("Email"),
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            // Password field
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter Your Password';
              } else if (!RegExp(
                      r'^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>])(.{8,})$')
                  .hasMatch(value)) {
                return 'Password atleast 8 character , 1 capital , 1 special symbol ';
              }
              return null;
            },
            obscureText: _obsecuretext,
            controller: userpasswordController,
            decoration: InputDecoration(
              label: Text("Password"),
              prefixIcon: Icon(Icons.security),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obsecuretext = !_obsecuretext;
                  });
                },
                icon: _obsecuretext
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formkey.currentState!.validate()) {
                var username = usernameController.text.trim();
                var userphone = userphoneController.text.trim();
                var useremail = useremailController.text.trim();
                var userpassword = userpasswordController.text.trim();
                String otp = generateOTP();
                sendEmail(recipientMail: useremailController.text, otp: otp);
                await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                      email: useremail,
                      password: userpassword,
                    )
                    .then((value) => {
                          print("User Created"),
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc()
                              .set({
                            "UserName": username,
                            "UserPhoneNo": userphone,
                            "UserEmaiId": useremail,
                          }),
                          Fluttertoast.showToast(
                            msg: "Registration Successfully",
                            backgroundColor: Colors.white,
                            textColor: Colors.black,
                          ),
                        });

                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('isLoggedIn', true);
                prefs.setString('userRole', 'user');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OTPVerificationScreen(
                      email: useremailController.text,
                      generatedOTP: otp,
                    ),
                  ),
                );
              } else {
                Fluttertoast.showToast(
                    msg: 'Registration Failed', backgroundColor: Colors.black);
              }
            },
            child: Text(
              'Register',
              style: TextStyle(color: Colors.black),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already Have an Account ?  "),
                GestureDetector(
                  onTap: () {
                    Get.to(() => LoginScreen());
                  },
                  child: Text(
                    "Log in",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget policeRegistrationWidget() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return "Policename is Required";
              }
            },
            controller: policenameController,
            decoration: InputDecoration(
              label: Text("PoliceName"),
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter PoliceID';
              } else if (!RegExp(r'^[0-9]{6}$').hasMatch(value)) {
                return 'ID must be 6 digits and numerical.';
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
            controller: idController,
            decoration: InputDecoration(
              label: Text('Id'),
              hintText: "ID in Your Id Card",
              prefixIcon: const Icon(
                Icons.security,
              ),
              fillColor: Colors.black,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter Your Email Id';
              } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                  .hasMatch(value)) {
                return 'Enter valid Email Id';
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
            controller: loginnameController,
            decoration: InputDecoration(
              label: Text('Email'),
              prefixIcon: const Icon(
                Icons.email,
              ),
              fillColor: Colors.black,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter Your Password';
              } else if (!RegExp(
                      r'^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>])(.{8,})$')
                  .hasMatch(value)) {
                return 'Password atleast 8 character , 1 capital , 1 special symbol ';
              }
              return null;
            },
            obscureText: _obsecuretext,
            controller: loginpasswordController,
            decoration: InputDecoration(
              label: Text('Password'),
              prefixIcon: Icon(
                Icons.password,
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
                      ),
              ),
              fillColor: Colors.black,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Upload your Police Id ',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: _uploadFile,
            child: Text('Select and Upload File'),
          ),
          SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: () async {
              if (_formkey.currentState!.validate()) {
                var name = policenameController.text.trim();
                var id = idController.text.trim();
                var email = loginnameController.text.trim();
                var pass = loginpasswordController.text.trim();
                String otp = generateOTP();
                sendEmail(recipientMail: loginnameController.text, otp: otp);
                FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                      email: email,
                      password: pass,
                    )
                    .then((value) => {
                          print("User Created"),
                          FirebaseFirestore.instance
                              .collection('Police')
                              .doc()
                              .set({
                            "PoliceName": name,
                            "PoliceID": id,
                            "PoliceEmaiId": email,
                          }),
                          Fluttertoast.showToast(
                            msg: "Registration Successfully",
                            backgroundColor: Colors.white,
                            textColor: Colors.black,
                          ),
                        });
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('isLoggedIn', true);
                prefs.setString('userRole', 'police');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OTPVerificationScreen(
                      email: loginnameController.text,
                      generatedOTP: otp,
                    ),
                  ),
                );
              } else {
                Fluttertoast.showToast(
                    msg: 'Registration Failed', backgroundColor: Colors.black);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black87,
            ),
            child: Text(
              'Register',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already Have An Account ?  "),
                GestureDetector(
                  onTap: () {
                    Get.to(() => LoginScreen());
                  },
                  child: Text(
                    "Log in",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  // bool isPasswordValid(String password) {
  //   if (password.length < 8) {
  //     return false;
  //   }

  //   if (!password.contains(RegExp(r'[A-Z]'))) {
  //     return false;
  //   }

  //   if (!password.contains(RegExp(r'[a-z]'))) {
  //     return false;
  //   }

  //   // Password should contain at least one digit
  //   if (!password.contains(RegExp(r'[0-9]'))) {
  //     return false;
  //   }

  //   // Password should contain at least one special character
  //   if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
  //     return false;
  //   }

  //   return true;
  // }

  bool isValidPhoneNumber(String phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return false;
    }

    // Check if the phone number contains only digits
    if (!RegExp(r'^[0-9]{10}$').hasMatch(phoneNumber)) {
      return false;
    }

    return true;
  }
}

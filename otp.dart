// ignore_for_file: prefer_const_constructors, unused_import, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:mylogin3/views/User/scanner.dart';
import 'package:mylogin3/views/registartion/login.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  final String generatedOTP;

  OTPVerificationScreen({
    required this.email,
    required this.generatedOTP,
  });

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  bool isOTPVerified = false;
  bool didAttemptVerification = false;
  bool isInvalidOTP = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.tealAccent,
        title: Text('OTP Verification'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            Center(
              child: Text(
                'Enter the OTP sent to ${widget.email}',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: 'Enter OTP',
                prefixIcon: Icon(Icons.verified, color: Colors.black),
                fillColor: Color.fromARGB(255, 227, 255, 252),
                filled: true,
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                verifyOTP(otpController.text, widget.generatedOTP);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              child: Text('Verify OTP'),
            ),
            if (didAttemptVerification && isInvalidOTP)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Invalid OTP! Please try again.',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (isOTPVerified)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'OTP Verified!',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void verifyOTP(String enteredOTP, String generatedOTP) {
    if (enteredOTP == generatedOTP) {
      // TODO: Add logic to handle successful OTP verification
      print('OTP Verified!');
      // You can navigate to the next screen or perform other actions here.
    } else {
      // TODO: Add logic to handle invalid OTP
      print('Invalid OTP');
      // Display an error message or take appropriate action.
    }
  }
}

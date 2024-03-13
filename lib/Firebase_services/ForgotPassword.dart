// ignore_for_file: camel_case_types

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class forgotPasswordScreen extends StatefulWidget {
  const forgotPasswordScreen({super.key});

  @override
  State<forgotPasswordScreen> createState() => _forgotPasswordScreenState();

}

class _forgotPasswordScreenState extends State<forgotPasswordScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var mobileNumber = TextEditingController();
  var _formField = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  Widget button = const Text("Send Email",style: TextStyle(color: Colors.white),);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            decoration: InputDecoration(
              label: const Text('Email'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
              ),
              hintText: 'abc@gmail.com',
              // helperText: 'abc@gmail.com',
              suffixIcon: const Icon(Icons.email_outlined),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: const BorderSide(
                    color: Colors.blue,
                  )
                ),
            ),
            validator: (value) => EmailValidator.validate(value!) ? null : "Please enter a valid email",
          ),
          ElevatedButton(onPressed: (){
            setState(() {
              button = const SizedBox(height:25,width:25,child: CircularProgressIndicator(color: Colors.white,));
            });
            auth.sendPasswordResetEmail(email: emailController.text.toString()).then((value) {
              Fluttertoast.showToast(msg: 'Check Mail Box',textColor: Colors.white,backgroundColor: Colors.black);
              setState(() {
                button = const Text("Email Sent",style: TextStyle(color: Colors.white),);
              });
              // Utils().toastMessage('We have sent you email to recover password , check your mail box');
            }).onError((error, stackTrace) {
              // Utils().toastMessage(error.toString());
              setState(() {
                button = const Text("Send Email",style: TextStyle(color: Colors.white),);
              });
              Fluttertoast.showToast(msg: 'something went wrong',textColor: Colors.white,backgroundColor: Colors.red);
            });
          }, child:button)
        ],
      ),
    );
  }
}

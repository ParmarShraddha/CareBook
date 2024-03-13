// ignore_for_file: non_constant_identifier_names, file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/SplashScreen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Application',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: SplashScreen(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() {
    return SignUpPageState();
  }
}

class SignUpPageState extends State<SignUpPage>{
  DatabaseReference userRef = FirebaseDatabase.instance.ref('Users');
  final _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var userNameController = TextEditingController();
  var passwordController =TextEditingController();
  var confirmPasswordController =TextEditingController();
  bool flag = true;
  bool flagConfirm = true;
  bool loading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: _formKey,
              child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    const Text('Sing Up',style: TextStyle(fontSize: 40,fontWeight: FontWeight.w800,color: Colors.pink),),
                    Container(height:MediaQuery.of(context).size.height*0.09),
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.90,
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: userNameController,
                        decoration: InputDecoration(
                          label: const Text('UserName'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                              borderSide: const BorderSide(
                                color: Colors.green,
                              )
                          ),
                          hintText: 'abc',

                          suffixIcon: const Icon(Icons.account_circle_outlined),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: const BorderSide(
                                color: Colors.green,
                              )
                          ),
                        ),
                        validator:(value){
                          return value!.isEmpty ? 'enter userName' : null;
                        },
                      ),
                    ),
                    Container(height:MediaQuery.of(context).size.height*0.01),
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.90,
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                          label: const Text('Email'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                          hintText: 'abc@gmail.com',
                          suffixIcon: const Icon(Icons.email_outlined),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: const BorderSide(
                                  color: Colors.green
                              )
                          ),
                        ),
                        validator: (value) => EmailValidator.validate(value!) ? null : "Please enter a valid email",
                      ),
                    ),
                    Container(height:MediaQuery.of(context).size.height*0.01),
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.90,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: passwordController,
                        obscureText: flag,
                        obscuringCharacter: '*',
                        decoration: InputDecoration(
                          label: const Text('Create Password'),
                          hintText: 'Enter Password',
                          suffixIcon: IconButton(
                            icon: flag?const Icon(Icons.remove_red_eye):const Icon(Icons.lock_outline_rounded),
                            onPressed: () {
                              if(flag){
                                flag = false;
                                setState(() {});
                              }
                              else{
                                flag = true;
                                setState(() {});
                              }
                            },),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: const BorderSide(
                                  color: Colors.green
                              )
                          ),
                        ),
                        validator: (value) {
                          if(value!.isEmpty){
                            return 'Enter Password';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(height:MediaQuery.of(context).size.height*0.01),
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.90,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: confirmPasswordController,
                        obscureText: flagConfirm,
                        obscuringCharacter: '*',
                        decoration: InputDecoration(
                          label: const Text('Confirm Password'),
                          hintText: 'Enter Password',
                          suffixIcon: IconButton(
                            icon: flagConfirm?const Icon(Icons.remove_red_eye):const Icon(Icons.lock_outline_rounded),
                            onPressed: () {
                              if(flagConfirm){
                                flagConfirm = false;
                                setState(() {});
                              }
                              else{
                                flagConfirm = true;
                                setState(() {});
                              }
                            },),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: const BorderSide(
                                  color: Colors.green
                              )
                          ),
                        ),
                        validator: (value) {
                          if(value!.isEmpty){
                            return 'Enter Password';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(height:MediaQuery.of(context).size.height*0.01),

                    ElevatedButton(onPressed: (){
                      setState(() {
                        loading = true;
                      });
                      if((passwordController.text.toString().isNotEmpty) &&
                          (confirmPasswordController.text.toString().isNotEmpty) &&
                          (userNameController.text.toString().isNotEmpty) &&
                          (emailController.text.toString().isNotEmpty)){
                      if (passwordController.text.toString() == confirmPasswordController.text.toString()){
                      SignUp();
                      setState(() {
                        loading = false;
                      });
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const MyHomePage()));
                      }
                      else{setState(() {
                        loading = false;
                      });
                        Fluttertoast.showToast(msg: 'Set Correct Password');
                        confirmPasswordController.clear();
                        passwordController.clear();

                      }}
                      else{setState(() {
                        loading = false;
                      });
                        Fluttertoast.showToast(msg: 'Fill All Details',backgroundColor: Colors.red,textColor: Colors.white);
                      }}, child: loading ? const SizedBox(height:25,width:25,child: CircularProgressIndicator(color: Colors.white,)):const Text('Sign Up ')),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyHomePage()));
                        }, child: const Text('Login'))
                      ],
                    )
                  ]
              ),
            ),
          ),
        )
    );
  }
  void SignUp(){

    if(_formKey.currentState!.validate()){
      _auth.createUserWithEmailAndPassword(
          email: emailController.text.toString(),
          password: passwordController.text.toString()).then((value){
            userRef.child(value.user!.uid.toString()).set({
              'uid' : value.user!.uid.toString(),
              'email' : emailController.text.toString(),
              'userName': userNameController.text.toString(),
              'Password' : passwordController.text.toString(),
              'Appointments': "",
              'History': "",
            }
            ).then((value) {
            }).onError((error, stackTrace) {
            });
        setState(() {
          loading = false;
        });
      }).onError((error, stackTrace){
        setState(() {
          loading= false;
        });
      });
    }
    loading? const CircularProgressIndicator(strokeWidth: 4,color:Colors.black87 ,):const Text('Done');
  }
}



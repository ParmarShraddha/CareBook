// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/Lpgin_Wd_phoneNumber.dart';
import 'package:flutter_application_1/SignUp_Screen.dart';
import 'package:flutter_application_1/SplashScreen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_application_1/UserProfilePage.dart';
import 'package:flutter_application_1/utils/Utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Firebase_services/ForgotPassword.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

bool isEmail(String input) => EmailValidator.validate(input);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Application',
      theme: ThemeData(
        primarySwatch: Colors.pink,
            scaffoldBackgroundColor: Colors.white,
      ),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

   @override
  State<MyHomePage> createState() {
     return MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage>{

  var _formField = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var mobileNumber = TextEditingController();
  var passwordController =TextEditingController();
  bool flag = true;
  var result= "";
  var userRef ;
  bool loading = false;
  var userToken ;


  @override
  void initState() {
    super.initState();
    _formField =GlobalKey();

  }
  final _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login()async{
    var pref = await  SharedPreferences.getInstance();
    _auth.signInWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString()).then((value) async{
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        userToken = value.user!.uid.toString();
        sharedPreferences.setString("userToken", value.user!.uid.toString());
        pref.setString('login', 'true');
        setState(() {
          loading = false;
        });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>userProfile(userToken: userToken,)));
    }).onError((error, stackTrace)
    {
      setState(() {
        loading = false;
      });
      Utils().toastMessage(error.toString(),Colors.red);
    });
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body:Container(
       margin:const EdgeInsets.only(right:5,left:5),
       height : MediaQuery.of(context).size.height * 0.95,
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           const Padding(
             padding: EdgeInsets.only(bottom:5.0,top:130.0),
             child: Text('LogIn',style: TextStyle(fontSize: 40,fontWeight: FontWeight.w800,color: Colors.pink),),
           ),
           Form(
             autovalidateMode: AutovalidateMode.always,
             key: _formField,
           child:Expanded(
             child: SingleChildScrollView(
               child: Column(
                 // mainAxisAlignment: MainAxisAlignment.center,
                 children:[
                   Container(height:MediaQuery.of(context).size.height*0.1),
                   const SizedBox(height: 11,),
                   TextFormField(
                     keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: InputDecoration(
                      label: const Text('Email'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                          borderSide: const BorderSide(
                            color: Colors.green,
                          )
                      ),
                     hintText: 'abc@gmail.com',
                     // helperText: 'abc@gmail.com',
                     suffixIcon: const Icon(Icons.email_outlined),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: const BorderSide(
                              color: Colors.green,
                          )
                      ),
                   ),
                     validator: (value) => EmailValidator.validate(value!) ? null : "Please enter a valid email",
                 ),
               const SizedBox(height: 11,),
               TextFormField(
                 keyboardType: TextInputType.text,
                 controller: passwordController,
                 obscureText: flag,
                 obscuringCharacter: '*',
                 decoration: InputDecoration(
                   label: const Text('Password'),
                   hintText: 'Enter Password',
                   suffixIcon: IconButton(
                     icon: flag?const Icon(Icons.remove_red_eye):const Icon(Icons.lock_outline_rounded),
                     onPressed: () {
                       if (flag){
                         flag = false;
                         setState(() {});
                       }
                       else {
                         flag = true;
                         setState(() {});
                       }
                     },
                   ),
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
               ),
                   Container(height: MediaQuery.of(context).size.height*0.01,),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: [
                       InkWell(onTap: (){
                         Navigator.push(context,MaterialPageRoute(builder: (context)=>const forgotPasswordScreen()));
                       },child: const Text('Forgot Password?',style:TextStyle(decoration: TextDecoration.underline),),),
                     ],
                   ),
               const SizedBox(height: 21,),
               ElevatedButton(onPressed: () async  {
                 setState(() {
                   loading = true;
                 });
                 if (emailController.toString().isNotEmpty &&
                     passwordController.toString().isNotEmpty
                    )
                 {
                   if(_formField.currentState!.validate()){
                     var pref = await SharedPreferences.getInstance();
                     pref.setString('login', 'true');
                     login();
                   }
                 }
               },
                   child: loading ? const SizedBox(height:25,width:25,child: CircularProgressIndicator(color: Colors.white,)):const Text('Login ')),
                   SizedBox(height: MediaQuery.of(context).size.height*0.003,),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       const Text("Don't have an account?"),
                       TextButton(onPressed: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignUpPage()));
                       }, child: const Text('Sign Up'))
                     ],
                   ),
                   InkWell(
                     onTap: (){
                       Navigator.push(context,MaterialPageRoute(builder: (context)=>const LoginWithPhone()));
                     },
                     child: Container(
                       height: 50,
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(50),
                         border: Border.all(
                           color: Colors.pink
                         )
                       ),
                       child:const Center(
                         child: Text('Login with Phone Number'),
                       )
                     ),
                   ),
         ]
         ),
             ),
           ),
   ),
       ]
    ),
     )
    );
  }
}


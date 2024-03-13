// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/UserProfilePage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({Key? key}) : super(key: key);

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  final phoneNumberController = TextEditingController();
  final OTPController = TextEditingController();
  bool loading = false;
  var verificationIdUse;
  Widget otpLoading = const Text("Send");
  late Map<dynamic,dynamic>temp1 ;
  var firebaseDatabase = FirebaseDatabase.instance.ref("Users");
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseDatabase.get().then((value) async{
      temp1 = value.value as Map<dynamic,dynamic>;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 50,),
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: phoneNumberController,
              decoration: InputDecoration(
                label: const Text('Mobile number:'),
                hintText: 'country code required',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.green,
                  )
                )
              ),
            ),
            const SizedBox(height: 10,),
          ElevatedButton(onPressed: ()async {
            setState(() {
              otpLoading = const SizedBox(height:20,width:20,child: CircularProgressIndicator(color: Colors.white,));
            });
            _firebaseAuth.verifyPhoneNumber(
              phoneNumber: phoneNumberController.text.toString(),
                verificationCompleted: (_) {},
                verificationFailed: (error) {
                  Fluttertoast.showToast(msg: error.toString());
                  setState(() {
                    otpLoading = const Text("Send");
                  });
                },
                codeSent: (verificationId, forceResendingToken) {
                  verificationIdUse = verificationId;
                  setState(() {
                    otpLoading = const Text("Sent");
                  });
                },
                codeAutoRetrievalTimeout: (e) {
                  Fluttertoast.showToast(msg: e.toString());
                  setState(() {
                    otpLoading = const Text("Send");
                  });
                },);
            // setState(() {
            //   if ((!verificationIdUse.isNull)){
            //     otpLoading = const Text("Sent");
            //   }
            // });
          }, child: otpLoading),
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: OTPController,
              decoration: InputDecoration(
                  label: const Text('OTP:'),
                  hintText: 'sent on phone',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      )
                  )
              ),
            ),
            ElevatedButton(onPressed: ()async {
              setState(() {
                loading = true;
              });
              final credentialUse = PhoneAuthProvider.credential(verificationId: verificationIdUse.toString(), smsCode: OTPController.text.toString());
              await _firebaseAuth.signInWithCredential(credentialUse).then((value) async{
                SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                sharedPreferences.setString("userToken", value.user!.uid.toString());
                sharedPreferences.setString('login', 'true');
                Fluttertoast.showToast(msg: "LogIn Successful",textColor: Colors.white,backgroundColor: Colors.black26);
                if (temp1.containsKey(value.user!.uid)){
                  setState(() {
                    loading = false;
                  });
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => userProfile(userToken: value.user!.uid.toString(),)));
                }
                else{
                  firebaseDatabase.child(value.user!.uid).set({
                    'uid' : value.user!.uid.toString(),
                    'phone' : phoneNumberController.text.toString(),
                    'Appointments': "",
                    'History': "",
                    'userName':phoneNumberController.text.toString(),
                    });
                  setState(() {
                    loading = false;
                  });
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => userProfile(userToken: value.user!.uid,),));
                }

              }).onError((error, stackTrace) {
                Fluttertoast.showToast(msg: "error");
              });
            }, child: loading ? const SizedBox(height:25,width:25,child: CircularProgressIndicator(color: Colors.white,)):const Text('LogIn')),


          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/UserProfilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    checkRoute();
  }

  void checkRoute() async {
    var pref = await SharedPreferences.getInstance();

    var userToken = pref.getString('userToken');
    if (pref.getString("login")== "true") {
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => userProfile(userToken: userToken,)),);
      });
    } else {
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyHomePage()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(height: MediaQuery.of(context).size.height*0.08,),
          Container(height: MediaQuery.of(context).size.height*0.04,),
          Container(height: MediaQuery.of(context).size.height*0.3,),
          const Center(
            child: Image(
              image: AssetImage("assets/images/CareBookImg.png"),
            height: 120,
            width: 120,),
          ),
          Container(height: MediaQuery.of(context).size.height*0.3,),
          const Column(
            children: [
              SizedBox(
                  height:70,
                  width:110,
                  // child:
                  // Image(image: AssetImage("assets/images/Renotechno_Dark.png"))
              )
            ],
          ),
        ],
      )
    );
  }
}
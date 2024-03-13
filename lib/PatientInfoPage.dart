// ignore_for_file: prefer_typing_uninitialized_variables, camel_case_types

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_application_1/UserProfilePage.dart';

void main() {
  runApp(const patientDetailPage());
}
class patientDetailPage extends StatefulWidget {

  final docName;
  final selectedDate;
  final selctedTime;
  final weekDay;
  final city;
  final userToken;
  final cityName;
  final month;
  final docPhoto;
  const patientDetailPage({super.key,this.docName,this.selectedDate,this.selctedTime,this.weekDay,this.city,this.userToken,this.cityName,this.month,this.docPhoto});

  @override
  State<patientDetailPage> createState() => _patientDetailPageState();
}

class _patientDetailPageState extends State<patientDetailPage> {

  var patientFullNameController = TextEditingController();
  var contactNoController = TextEditingController();
  var ageController = TextEditingController();
  var sexController = TextEditingController();
  String patientNameToBeDisplay = "";
  String contactNoToBeDisplay = "";
  String ageToBeDisplay = "";
  String sexToBeDisplay = "";
  bool t1 = false;
  bool t2 = false;
  bool t3 = false;
  bool t4 = false;
  var selectedDocName;
  var selectedTime;
  var selectedDate;
  var selectedWeekDay;
  var selectedcity;
  var selectedDocPhoto;
  var userToken ;
  var cityName ;
  var month;
  var docPhoto;
  final _formkey = GlobalKey<FormState>();
  var userAppointment ;
  String selectedGender = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedDocName = widget.docName ;
    selectedTime = widget.selctedTime ;
    selectedDate = widget.selectedDate ;
    selectedWeekDay = widget.weekDay;
    selectedcity = widget.city;
    userToken = widget.userToken;
    month = widget.month;
    docPhoto = widget.docPhoto;
    userAppointment = FirebaseDatabase.instance.ref('Users').child(userToken).child('Appointments');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        bottomNavigationBar: BottomAppBar(
            child: Container(
              width: 400,
              margin: const EdgeInsets.all(20),
              height: 40,
              child: ElevatedButton(onPressed: () {
                if (
                (patientFullNameController.text.toString().isNotEmpty) &&
                    (contactNoController.text.toString().isNotEmpty) &&
                    (ageController.text.toString().isNotEmpty) &&
                    (selectedGender.toString().isNotEmpty)
                ) {
                  if(contactNoController.text.toString().length<10){
                    Fluttertoast.showToast(msg: 'Enter 10 digit valid Contact Number !',backgroundColor: Colors.red);
                  }
                  else if(contactNoController.text.toString().length>10){
                    Fluttertoast.showToast(msg: 'Enter 10 digit valid Contact Number !',backgroundColor: Colors.red);
                  }
                  else
                  {
                   showDialog(context: context, builder: (context) {
                    return AlertDialog(
                      title:const Text('Confirm Appointment?') ,
                      actions: [TextButton(
                        child: const Text('Close'),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },),
                      TextButton(
                        child:const Text('Confirm'),onPressed: (){
                        var temp = userAppointment.push();
                        temp.set({
                          'docName': selectedDocName,
                          'patientName' : patientFullNameController.text.toString(),
                          'mobileNo':contactNoController.text.toString(),
                          'age':ageController.text.toString(),
                          'gender' :sexController.text.toString(),
                          'date' :selectedDate,
                          'month' : month,
                          'weekDay': selectedWeekDay,
                          'time':selectedTime,
                          'hospital':selectedcity,
                          'docphoto':docPhoto,
                        });
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>userProfile(userToken: userToken,)), (route) => false);
                        Fluttertoast.showToast(
                            msg: "Appointment Booked.",
                            backgroundColor: CupertinoColors.activeGreen,
                            textColor: Colors.white);
                      },
                      )
                      ],
                    );
                  },);
                  }
                }
                else{
                  Fluttertoast.showToast(msg: "Fill all details",textColor: Colors.white,backgroundColor: Colors.red);
                 }
              }, child: const Text("Confirm")),
            )
        ),
        body: Container(
          height :MediaQuery.of(context).size.height * 0.90,
          width :MediaQuery.of(context).size.height * 0.60,
        margin: const EdgeInsets.only(left: 10,right: 10),
          child: Column(
            children: [
              Container(height: 30,),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("About Patient",style: TextStyle(color: Colors.black,fontSize: 28,fontWeight: FontWeight.bold),),
                  Text("your details",style: TextStyle(color: Colors.black54),)
                ],
              ),
              Container(height: 10,),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text("Name : ",style: TextStyle(color: Colors.black,fontSize: 20),),
                            SizedBox(
                              width :MediaQuery.of(context).size.width * 0.75,
                              child: Form(child: TextFormField(

                                validator: (value) {
                                  if (value!.toString().isEmpty){
                                    return "Enter Name";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    t1 = value.isNotEmpty;
                                    patientNameToBeDisplay = value;

                                  });
                                },
                                controller: patientFullNameController,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                    hintText: "First Name",
                                    hintStyle: const TextStyle(color: Colors.black26),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(11),
                                        borderSide: BorderSide(color: !t1 ? Colors.black54 : Colors.green,width: 2)
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(11),
                                        borderSide: const BorderSide(color: Colors.blue,width: 2)
                                    )
                                ),
                              )),
                            )
                          ],
                        ),
                        Container(height: 10,),
                        Row(
                          children: [
                            const Text("Mobile: ",style: TextStyle(color: Colors.black,fontSize: 20),),
                            SizedBox(
                              width :MediaQuery.of(context).size.width * 0.745,
                              child: Form(child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty){
                                    return "Enter Contact";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    t2 = value.isNotEmpty;
                                    contactNoToBeDisplay = value;
                                  });
                                },
                                controller: contactNoController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    hintText: "contact no",
                                    hintStyle: const TextStyle(color: Colors.black26),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(11),
                                        borderSide: BorderSide(color: !t2 ? Colors.black54 : Colors.green,width: 2)
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(11),
                                        borderSide: const BorderSide(color: Colors.blue,width: 2)
                                    )
                                ),
                              )),
                            )
                          ],
                        ),
                        Container(height: 10,),
                        Row(
                          children: [
                            const Text("Age     : ",style: TextStyle(color: Colors.black,fontSize: 20),),
                            SizedBox(
                              width :MediaQuery.of(context).size.width * 0.75,
                              child: Form(child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty){
                                    return "Enter Age";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    t3 = value.isNotEmpty;
                                    ageToBeDisplay = value;
                                  });
                                },
                                controller: ageController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintText: "in number",
                                    hintStyle: const TextStyle(color: Colors.black26),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(11),
                                        borderSide: BorderSide(color: !t3 ? Colors.black54 : Colors.green,width: 2)
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(11),
                                        borderSide: const BorderSide(color: Colors.blue,width: 2)
                                    )
                                ),
                              )),
                            )
                          ],
                        ),
                        Container(height: 10,),
                        Row(
                          children: [
                            const Text(
                              'Sex      : ',
                              style: TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Radio<String>(
                                      value: 'Male',
                                      groupValue: selectedGender,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedGender = value!;
                                        });
                                      },
                                    ),
                                    const Text('Male'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Radio<String>(
                                      value: 'Female',
                                      groupValue: selectedGender,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedGender = value!;
                                        });
                                      },
                                    ),
                                    const Text('Female'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Radio<String>(
                                      value: 'Other',
                                      groupValue: selectedGender,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedGender = value!;
                                        });
                                      },
                                    ),
                                    const Text('Other'),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),

                        Container(height: 10,),
                        Container(
                          height: 220,
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            gradient:  LinearGradient(
                                colors: [Colors.pink.shade200,Colors.pink.shade100,]
                            ),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Container(
                            width :MediaQuery.of(context).size.width * 0.95,
                            // color: Colors.white,
                            margin: const EdgeInsets.only(left: 10,right: 5,top: 5,bottom: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Patient's Details:",style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold),),
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.person,color: Colors.white,),
                                          Text(": $patientNameToBeDisplay  ($selectedGender)")
                                        ],
                                      ),
                                      Container(height: 3,),
                                      Row(
                                        children: [
                                          const Icon(Icons.call,color: Colors.white,),
                                          Text(": $contactNoToBeDisplay")
                                        ],
                                      ),
                                      Container(height: 3,),
                                      Row(
                                        children: [
                                          const Icon(Icons.timeline,color: Colors.white,),
                                          Text(": $ageToBeDisplay years")
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Text("                         Doctor's Details:",style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold),),
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Text("                                          "),
                                          const Icon(Icons.person,color: Colors.white,),
                                          Text(": Dr. $selectedDocName")
                                        ],
                                      ),
                                      Container(height: 3,),

                                      Row(
                                        children:[
                                          const Text("                                          "),
                                          const Icon(Icons.calendar_month,color: Colors.white,),
                                          Text(": $selectedDate $month ,$selectedWeekDay ")
                                        ],
                                      ),
                                      Container(height: 3,),
                                      Row(
                                        children: [
                                          const Text("                                          "),
                                          const Icon(Icons.access_time,color: Colors.white,),
                                          Text(": $selectedTime")
                                        ],
                                      ),

                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}

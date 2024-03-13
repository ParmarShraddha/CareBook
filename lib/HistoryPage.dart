// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class historyPage extends StatefulWidget {
  final userToken;
  const historyPage({super.key,this.userToken});

  @override
  State<historyPage> createState() => _historyPageState();
}

class _historyPageState extends State<historyPage> {

  late final String userToken ;
  var docList = [];
  var userRef;
  var userAppointment;
  var userHistory;
  var userName;
  var targetDocHos = "";
  final targetController = TextEditingController();
  var userNameRef = FirebaseDatabase.instance.ref('Users');

  @override
  void initState() {
    super.initState();
    userToken = widget.userToken;
    userAppointment = FirebaseDatabase.instance
        .ref('Users')
        .child(userToken)
        .child('Appointments');
    userHistory = FirebaseDatabase.instance
        .ref('Users')
        .child(userToken)
        .child('History');
    userNameRef.child(userToken).child('userName').get().then((value) {
      if (value.exists) {
        var myName = value.value.toString();
        userName = myName;
        setState(() {});
      }
    });
  }


  int monthToInt(String month){
    switch(month){
      case 'Jan':
        return 1;
      case 'Feb':
        return 2;
      case 'Mar':
        return 3;
      case 'Apr':
        return 4;
      case 'May':
        return 5;
      case 'Jun':
        return 6;
      case 'July':
        return 7;
      case 'Aug':
        return 8;
      case 'Sep':
        return 9;
      case 'Oct':
        return 10;
      case 'Nov':
        return 11;
      case 'Dec':
        return 12;
    }
    return 0;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 90,
        width: MediaQuery.of(context).size.width * 90,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              SizedBox(
                // color: Colors.blue,
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.95,
                child: const Text(
                  'History',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: FirebaseAnimatedList(
                  reverse: true,
                  query: userAppointment,
                  itemBuilder: (context, snapshot, animation, index) {
                    Text(snapshot.child('hospital').value.toString());
                    Text(snapshot.child('docName').value.toString());
                    int intMonth = monthToInt(snapshot.child('month').value.toString());
                    if (DateTime.now().month > intMonth || (DateTime.now().month == intMonth && DateTime.now().day >  int.parse(snapshot.child("date").value.toString()))){
                        return
                          Column(
                          children: [
                            Container(
                              height: 10,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Container(
                                height: MediaQuery.of(context).size.height * 0.40,
                                width: MediaQuery.of(context).size.width * 0.87,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.pink.shade200,
                                      Colors.pink.shade100,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(21),
                                ),
                                child: Column(
                                  children: [

                                    SizedBox(
                                      height: MediaQuery.of(context).size.height *
                                          0.003,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width:
                                          MediaQuery.of(context).size.width *
                                              0.02,
                                          height:
                                          MediaQuery.of(context).size.height *
                                              0.13,
                                        ),
                                        Container(
                                          height:70,
                                          width:70,
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.black),
                                              shape: BoxShape.circle,
                                              image:DecorationImage(image: CachedNetworkImageProvider(snapshot.child('docphoto').value.toString()),fit: BoxFit.cover)
                                          ),
                                        ),
                                        SizedBox(
                                          width:
                                          MediaQuery.of(context).size.width *
                                              0.07,
                                          height:
                                          MediaQuery.of(context).size.height *
                                              0.13,
                                        ),
                                        Text(
                                          "Dr.${snapshot.child('docName').value.toString()}",
                                          style: const TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height *
                                          0.01,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          " Patient : ",
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          snapshot
                                              .child('patientName')
                                              .value
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                    // Text(" Patient :  ${snapshot.child('patientName').value.toString()}",style: const TextStyle(fontSize: 25),overflow: TextOverflow.ellipsis,),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          " Hospital : ",
                                          style: TextStyle(
                                              fontSize: 21,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          snapshot
                                              .child('hospital')
                                              .value
                                              .toString(),
                                          style: const TextStyle(fontSize: 19),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width:
                                          MediaQuery.of(context).size.width *
                                              0.02,
                                        ),
                                        const Text(
                                          'Date:',
                                          style: TextStyle(
                                              fontSize: 21,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          snapshot.child('date').value.toString(),
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        const Text(" "),
                                        Text(
                                          snapshot
                                              .child('month')
                                              .value
                                              .toString(),
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height *
                                          0.02,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width:
                                          MediaQuery.of(context).size.width *
                                              0.02,
                                        ),
                                        const Text(
                                          'Time:',
                                          style: TextStyle(
                                              fontSize: 21,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          snapshot.child('time').value.toString(),
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        const Text(", "),
                                        Text(
                                          snapshot
                                              .child('weekDay')
                                              .value
                                              .toString(),
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 30,
                            ),
                          ],
                        );

                    }
                    return Container();

                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

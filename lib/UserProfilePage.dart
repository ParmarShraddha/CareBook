import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/CitySelectionPage.dart';
import 'package:flutter_application_1/HistoryPage.dart';
import 'package:flutter_application_1/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class userProfile extends StatefulWidget {
  final cityToBeShown;
  final uEmail1 = "";
  final uPassWord1 = "";
  final userToken;
  const userProfile({super.key, this.cityToBeShown, this.userToken});

  @override
  State<userProfile> createState() => _userProfileState();
}

class _userProfileState extends State<userProfile> {
  var docList = [];
  var userRef;
  var userToken;
  var userAppointment;
  var userHistory;
  var userName;
  var targetDocHos = "";
  final targetController = TextEditingController();
  var userNameRef = FirebaseDatabase.instance.ref('Users');
  final ScrollController _scrollController = ScrollController();
  bool set = true;

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
    userNameRef.child(userToken!).child('userName').get().then((value) {
      if (value.exists) {
        var myName = value.value.toString();
        userName = myName;
        setState(() {});
      }

    });

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    targetController.dispose();
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve:Curves.bounceOut);
    });
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Stack(children: [
          Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.10,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CitySelect(userToken: userToken)));
                },
                child: const Icon(
                  Icons.add,
                  size: 40,
                ),
              )),
        ]),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 90,
        width: MediaQuery.of(context).size.width * 90,
        // color: Colors.green,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.pink.shade50,
                      Colors.pink.shade50,
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "  ${userName ?? ''}",
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 30),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        showMenu(
                            context: context,
                            position: const RelativeRect.fromLTRB(1, 0, 0, 0),
                            items: <PopupMenuEntry>[
                              PopupMenuItem(
                                child: InkWell(
                                  onTap:() async {
                                    showDialog(context: context, builder: (context) {
                                      return  AlertDialog(
                                        title: const Text("Log Out",style: TextStyle(color: Colors.black),),
                                        content: const Text("Are you sure to log out?",style: TextStyle(color: Colors.black),),
                                        actions: [
                                          TextButton(onPressed: () {
                                            Navigator.pop(context);
                                          }, child: const Text("Cancel",style: TextStyle(color: Colors.blue),)),
                                          TextButton(onPressed: () async{
                                            var pref = await SharedPreferences.getInstance();
                                            pref.setString('login', "false");
                                            // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
                                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MyHomePage(),), (route) => false);
                                          }, child: const Text("LogOut",style: TextStyle(color: Colors.red),))
                                        ],
                                      );
                                    },);

                                  },
                                  child: const Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.logout_rounded,color: Colors.black,),
                                        Text('Log Out',style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500),),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              PopupMenuItem(

                                child: InkWell(
                                  onTap:(){
                                    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => historyPage(userToken: userToken,)));
                                  },
                                  child: const Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // SizedBox(width: 10,),
                                        Icon(Icons.history,color: Colors.black,),
                                        Text('History',style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500),),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ]
                        );
                      },child:const SizedBox(
                        width:50,
                        height: 50,
                        child: Icon(Icons.settings, size: 30, ),
                    ),

                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.008,
              ),
              Container(
                // color: Colors.green,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.08,
                alignment: Alignment.center,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        targetDocHos = value.toString();
                      });
                    },
                    controller: targetController,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.search),
                      hintText: 'Search Doctor / Hospital',
                      hintStyle: const TextStyle(fontSize: 19),
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                alignment: Alignment.topLeft,
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width * 0.95,
                child: TextButton(
                  child: const Text('My Appointments',style: TextStyle(fontSize: 35,color: Colors.black, fontWeight: FontWeight.bold),),
                  onPressed: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve:Curves.bounceOut);
    });
                  },

                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              SizedBox(
                // color: Colors.pink,
                height: MediaQuery.of(context).size.height * 0.6,
                child: FirebaseAnimatedList(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  reverse: true,
                  query: userAppointment,
                  itemBuilder: (context, snapshot, animation, index) {
                    if (set){
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve:Curves.bounceOut);
                      });
                      set = false;
                    }
                    final searchHospital = Text(snapshot.child('hospital').value.toString());
                    final searchDoc = Text(snapshot.child('docName').value.toString());
                    int intMonth = monthToInt(snapshot.child('month').value.toString());
                    if (DateTime.now().month < intMonth || (DateTime.now().month == intMonth && DateTime.now().day <  int.parse(snapshot.child("date").value.toString())))
                    {
                      if (targetDocHos.isEmpty) {
                        return Column(
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
                      else if (searchDoc.toString().toLowerCase().contains(targetDocHos.toLowerCase()) || searchHospital.toString().toLowerCase().contains(targetDocHos.toLowerCase())) {
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

                      else {
                        return Container();
                      }
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

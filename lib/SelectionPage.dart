// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/PatientInfoPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';


class docSelection extends StatefulWidget {
  final cityToBeShown ;
  final userToken;
  const docSelection({super.key, this.cityToBeShown,this.userToken});

  @override
  State<docSelection> createState() => _docSelectionState();
}

class _docSelectionState extends State<docSelection> {

  var selectedCity;
  var docController = TextEditingController();
  String? selectedDayOption;
  String? selectedTimeOption;
  String? selectedDocOption;
  bool isDocSelected= false;
  bool isselected = false;
  bool isTimeSelected = false ;
  var selectedDay = "";
  var selectedWeekday = "";
  var selectedMonth = "";
  var selectedTime = "";
  var selectedDoc = "";
  var selectedDocPhoto = "";
  var doctobeSearch = "";
  var amList = ["10:00 AM","10:30 AM","11:00 AM","11:30 AM","12:00 PM"];
  var pmList = ["1:30 PM","2:00 PM","2:30 PM","3:00 PM","3:30 PM","4:00 PM",];
  var cityRef ;
  var userToken;
  var month =  DateFormat('MMMM').format(DateTime.now());
  final searchCityController = TextEditingController();
  var time = DateTime.now();
  final _currentDate = DateTime.now();
  final _dayFormatter = DateFormat('d');
  final _monthFormatter = DateFormat('MMM');
  final dates = <Widget>[];


  @override
  void initState(){

    super.initState();
    userToken = widget.userToken;
    selectedCity = widget.cityToBeShown;
    cityRef = FirebaseDatabase.instance.ref('sytemData').child(selectedCity).child('docList');

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    docController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
          child: Container(
            margin: const EdgeInsets.all(20),
            height: 40,
            width: 400,
            child: ElevatedButton(
                onPressed: () {
                  if(selectedWeekday.isNotEmpty &&
                      selectedDay.isNotEmpty &&
                      selectedTime.isNotEmpty&&
                  selectedDoc.isNotEmpty
                  ){
                    Fluttertoast.showToast(msg: "Saved",backgroundColor: Colors.black54,textColor: Colors.white);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>patientDetailPage(docName: selectedDoc,docPhoto:selectedDocPhoto,selectedDate: selectedDay,selctedTime: selectedTime,weekDay: selectedWeekday,city: selectedCity,userToken: userToken,month:selectedMonth,)), );
                  }else{
                    Fluttertoast.showToast(msg: 'Select All Details',textColor: Colors.white,backgroundColor: Colors.red);
                  }
                }, child: const Text("Make an Appointment",)),
          )
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.95,
        width: MediaQuery.of(context).size.width * 0.95,
        margin: const EdgeInsets.only(left: 10,right: 10),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.045,),
            Container(height: 15,),

            //searchbar
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              decoration:  BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  gradient: const LinearGradient(
                      colors: [Colors.black12,Colors.white12]
                  )
              ),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    doctobeSearch = value.toString();
                  });
                },
                controller: docController,
                decoration: InputDecoration(
                    filled: true,
                    suffixIcon: const Icon(Icons.search_outlined,color: Colors.black38,),
                    hintText: "Search a Doctor",
                    hintStyle: const TextStyle(color: Colors.black38),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(11),),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(11),
                    )

                ),
              ),
            ),

            //Doctors list
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Text("Popular Doctors",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),)
                      ],
                    ),
                    Container(height: 15,),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.13,
                      child: FirebaseAnimatedList(
                        scrollDirection: Axis.horizontal,
                        query: cityRef,
                        itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                          final title = Text(snapshot.key.toString());
                          String option = snapshot.key.toString();
                          bool selectedDocOption = (option == selectedDoc);
                          String optionPhoto = snapshot.value.toString();
                            if (doctobeSearch.isEmpty) {
                              return InkWell(onTap: (){
                                setState(() {
                                  selectedDoc = option;
                                  selectedDocPhoto = optionPhoto;
                                  selectedDocOption;
                                });
                              },
                                child: Container(
                                  width: 130,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius
                                          .circular(11),
                                      border: Border.all(
                                          color: !selectedDocOption ? Colors
                                              .transparent : Colors
                                              .blueAccent, width: 2)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: MediaQuery.of(context).size.height*0.08,
                                       decoration: BoxDecoration(
                                         color: Colors.pinkAccent,
                                         shape: BoxShape.circle,
                                         image: DecorationImage(image: CachedNetworkImageProvider(snapshot.value.toString()),)
                                       ),
                                      ),
                                      Text("Dr.${snapshot.key.toString()}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
                                      // Text("${snapshot.value.toString()}"),
                                    ],
                                  ),
                                ),
                              );
                            }
                            else if (title.toString().toLowerCase().contains(doctobeSearch)) {
                              return InkWell(onTap: (){
                                setState(() {
                                  selectedDoc = option;
                                  selectedDocPhoto = snapshot.value.toString();
                                  selectedDocOption;
                                });
                              },
                                child: Container(
                                  width: 130,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius
                                          .circular(11),
                                      border: Border.all(
                                          color: !selectedDocOption ? Colors
                                              .transparent : Colors
                                              .blueAccent, width: 2)
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: MediaQuery.of(context).size.height*0.08,
                                        decoration: BoxDecoration(
                                            color: Colors.pinkAccent,
                                            shape: BoxShape.circle,
                                            image: DecorationImage(image: CachedNetworkImageProvider(snapshot.value.toString()))
                                        ),
                                      ),
                                      Text("Dr.${snapshot.key.toString()}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
                                    ],
                                  ),
                                ),
                              );
                            }
                            else {
                              return Container();
                            }
                          }
                      ),
                    ),
                    Container(height: 10,),
                    SizedBox(height: MediaQuery.of(context).size.height*0.02,),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(" ${DateTime.now().year}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.black),),
                        const Text("your date",style: TextStyle(color: Colors.black54),)
                      ],
                    ),
                    Container(
                      height:MediaQuery.of(context).size.height*0.1,
                      // height: 100,
                      margin: const EdgeInsets.only(top: 8),
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final date = _currentDate.add(Duration(days: index+1));
                            DateTime currentDate = DateTime.now().add(Duration(days: index+1));
                            String weekdayName = DateFormat('EE').format(currentDate);
                            month=_monthFormatter.format(date);
                            String option = _dayFormatter.format(date);
                            isselected = (option == selectedDayOption);
                            return InkWell(
                              onTap: () {
                                selectedDay= option;
                                selectedWeekday = weekdayName;
                                selectedMonth=_monthFormatter.format(date);
                                setState(() {selectedDayOption = option;});
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width:50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.circular(11),
                                        border: Border.all(color: !isselected ? Colors.transparent : Colors.blue,width: 2)
                                    ),
                                    child: Column(
                                      children: [
                                        Text(_dayFormatter.format(date),style: const TextStyle(color: Colors.black,fontSize: 25),),
                                        Text(month),
                                      ],
                                    )
                                  ),
                                  Text(weekdayName,style: const TextStyle(color: Colors.black),)
                                ],),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Container(width: 18,);
                          },
                          itemCount: 10),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.03,),
                    Container(
                      margin:const  EdgeInsets.only(bottom: 10),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Choose Time",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),
                          Text("your time",style: TextStyle(color: Colors.black54),)
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 60,
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                String optionTime = amList[index];
                                isTimeSelected = (optionTime == selectedTimeOption);
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedTime = optionTime;
                                      selectedTimeOption = optionTime;
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 110,
                                    decoration: BoxDecoration(
                                        color: Colors.black12,
                                        border: Border.all(color: !isTimeSelected ? Colors.transparent : Colors.blue,width: 2),
                                        borderRadius: BorderRadius.circular(11)
                                    ),
                                    child: Center(child: Text(amList[index],style: const TextStyle(color: Colors.black,fontSize: 20),),),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => Container(width: 25,),
                              itemCount: amList.length),
                        ),

                        Container(margin: const EdgeInsets.only(bottom: 10),),
                        SizedBox(
                          height: 60,
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                String optionTime = pmList[index];
                                isTimeSelected = (optionTime == selectedTimeOption);
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedTime = optionTime;
                                      selectedTimeOption = optionTime;
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 110,
                                    decoration: BoxDecoration(
                                        color: Colors.black12,
                                        border: Border.all(color: !isTimeSelected ? Colors.transparent : Colors.blue,width: 2),
                                        borderRadius: BorderRadius.circular(11)
                                    ),
                                    child: Center(child: Text(pmList[index],style: const TextStyle(color: Colors.black,fontSize: 20),),),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => Container(width: 25,),
                              itemCount: pmList.length),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
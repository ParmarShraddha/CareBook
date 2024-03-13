// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/SelectionPage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CitySelect extends StatefulWidget {
  final userToken;
  const CitySelect({super.key, this.userToken});

  @override
  State<CitySelect> createState() => _CitySelectState();
}

class _CitySelectState extends State<CitySelect> {

  final auth = FirebaseAuth.instance;
  final cityRef = FirebaseDatabase.instance.ref('sytemData');
  final searchCityController = TextEditingController();
  var cityNames=[];
  var listt = [];
  var targetCity = "";
  var userToken;
  String selectedOption="";

  @override
  void initState() {
    super.initState();
    userToken = widget.userToken;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchCityController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        margin: const EdgeInsets.only(right: 5,left: 5),
        child: Column(
          children: [
            Container(height: MediaQuery.of(context).size.height*0.03,),
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8.0, bottom: 8.0,top: 14.0),
              child:
              TextFormField(
                cursorHeight: 30,
                controller: searchCityController,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.pink.shade50,
                    suffixIcon:const Icon(Icons.search),
                    hintText: 'Search ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                    )
                ),
                onChanged: (String Value){
                  setState(() {
                  });
                },
              ),

            ),
            Expanded(
                child:
                FirebaseAnimatedList(
                    query: cityRef,
                    defaultChild: const Text('Loading..'),
                    padding: const EdgeInsets.all(12),
                    itemBuilder: ( context, snapshot, animation, index) {
                      final title = Text(snapshot.key.toString());
                      String option = snapshot.key.toString();
                      bool selectedBorder = (option ==  selectedOption);

                      if (searchCityController.text.isEmpty){
                        listt.add(title);
                        return Column(
                          children: [
                            InkWell(
                              onTap: (){
                                setState(() {
                                  selectedOption = option;
                                });
                              },
                              child : Container(
                                  alignment: Alignment.centerLeft,
                                  height: 55,
                                  width :MediaQuery.of(context).size.height * 0.75,
                                  decoration: BoxDecoration(
                                      border: Border.all(color:!selectedBorder? Colors.black12 : Colors.blueAccent,width: 2 )
                                  ),
                                  child : Text(snapshot.key.toString(),style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w400,))
                              ),

                            ),
                            Container(
                                height : 2
                            )
                          ],
                        );
                      }
                      else if(title.toString().toLowerCase().contains(searchCityController.text.toLowerCase().toLowerCase())){
                        return Column(
                          children: [
                            InkWell(
                              onTap: (){
                                setState(() {
                                  selectedOption = option;
                                });
                              },
                              child : Container(
                                  alignment: Alignment.centerLeft,
                                  height: 55,
                                  width :MediaQuery.of(context).size.height * 0.75,
                                  decoration: BoxDecoration(
                                      border: Border.all(color:!selectedBorder? Colors.black12 : Colors.blueAccent,width: 2 )
                                  ),
                                  child : Text(snapshot.key.toString(),style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w400,))
                              ),

                            ),
                            Container(
                                height : 2
                            )
                          ],
                        );
                      }
                      else{
                        return Container();
                      }
                    }

                )
            ),

            Container(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(onPressed: (){
                  if(selectedOption.isNotEmpty) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => docSelection(cityToBeShown: selectedOption,userToken: userToken,)));
                  }else{
                    Fluttertoast.showToast(msg: 'Select City',textColor: Colors.white,backgroundColor: Colors.red);
                  }},
                  child: const Icon(Icons.check,size: 25,),
                )
            )
          ],
        ),
      ),
    );
  }
}
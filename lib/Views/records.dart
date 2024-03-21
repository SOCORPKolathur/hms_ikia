import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_ikia/widgets/ReusableHeader.dart';
import 'package:hms_ikia/widgets/customtextfield.dart';
import 'package:intl/intl.dart';

import '../Constants/constants.dart';
import '../widgets/switch_button.dart';


class Records extends StatefulWidget {
  const Records({super.key});

  @override
  State<Records> createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  final TextEditingController SearchPhoneNum = TextEditingController();
  // fr the attendance
  List attendanceList = [];
  bool markAttendance = false;
  // for date and time
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  DateTime selectedDate = DateTime.now();

  // setDateTime() async {
  //   setState(() {
  //     searchDateController.text = formatter.format(selectedDate);
  //   });
  // }

  DateTime? dateRangeStart;
  DateTime? dateRangeEnd;
  bool isFiltered= false;
  bool attendanceMarked = false;
  bool editAttendance = false;

  // @override
  // void initState() {
  //   setDateTime();
  //   super.initState();
  // }


  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      child: Padding(
        padding:  const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Image.asset("assets/Group 75.png"),
              const ReusableHeader(Headertext: 'Records ', SubHeadingtext: 'Keep track of student details, attendance, and more with ease."'),
              const SizedBox(height: 10,),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xff262626).withOpacity(0.10)),
              borderRadius: BorderRadius.circular(30),
            ), child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomTextField(hint: 'search Phone , User ID....', controller:SearchPhoneNum , fillColor: const Color(0xffF5F5F5),validator: null, header: '', width: 335,preffixIcon: Icons.search, height: 45,),
              ),
              
              ElevatedButton(onPressed: (){
              //   pop up for attendance
                _showMyDialog();
              }, child: Text('Mark Attendance'))
           
          ],),),
            const SizedBox(height: 20,),
            //   2nd Container
      //         Container(
      //           height: 80,
      //   width: double.infinity,
      //   decoration: BoxDecoration(
      //   border: Border.all(color: const Color(0xff262626).withOpacity(0.10)),
      // borderRadius: BorderRadius.circular(30),
      //         ),
      //             child: Padding(
      //               padding: const EdgeInsets.all(8.0),
      //               child: Row(children: [
      //               //   Mini Container (Like a button)
      //                 Expanded(
      //                   child: Padding(
      //                     padding: const EdgeInsets.all(10),
      //                     child: Container(
      //                       child: Center(child: Text('In Room', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626)),)),
      //                       width: 200,
      //                       height: 50,
      //                       decoration: const BoxDecoration(color:Color(0xffF5F5F5), borderRadius: BorderRadius.all(Radius.circular(30))),),
      //                   ),
      //                 ),
      //                 // SizedBox(width: 7,),
      //
      //                 Expanded(child:
      //                 Padding(
      //                   padding: const EdgeInsets.all(10),
      //                   child: Container(
      //                     width: 200,
      //                     height: 50,
      //                     child: Center(child: Text('Out Room', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: Colors.white),)),
      //                     decoration: const BoxDecoration(color:Color(0xff37D1D3), borderRadius: BorderRadius.all(Radius.circular(30))),),
      //                 )
      //                 )
      //               ]
      //               ),
      //             ),
      //         ),
          const SizedBox(height: 10,),

          // decoration: BoxDecoration(
          //     border: Border.all(color: const Color(0xff262626).withOpacity(0.10)),
          //     borderRadius: BorderRadius.circular(30),

              Container(
                decoration: BoxDecoration(border: Border.all(color: const Color(0xff262626).withOpacity(0.10)), borderRadius: BorderRadius.circular(30) ),
                child:
                SizedBox(
                  height: 40,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('S.No', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
                        Text('User ID', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
                        Text('Name', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
                        Text('Phone No', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
                        Text('Check In', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
                        Text('Status', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
                        Text('Actions', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
                      ],),
                  ),
                ),
              ),
              ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          width: 70,
                          child: Text('1.', style: GoogleFonts.openSans( fontSize: 18),)),
                      Container(

                          width: 130,
                          child: Center(child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Text('2930UH', style: GoogleFonts.openSans( fontSize: 18),),
                          ))),
                      Container(
                          width: 170,
                          child: Center(child: Text('Muzzu Muzam', style: GoogleFonts.openSans(fontSize: 18),))),
                      Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: Container(

                            width: 110,

                            child: Center(child: Text('9360777431', style: GoogleFonts.openSans( fontSize: 18),))),
                      ),
                      Container(

                          width: 150,

                          child: Center(child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Text('9:40 Am', style: GoogleFonts.openSans( fontSize: 18),),
                          ))),
                      Padding(
                        padding: const EdgeInsets.only(right: 25),
                        child: Container(
                          decoration: const BoxDecoration(
                            // color: Colors.blue,
color: Color(0xffddffe7),

                              borderRadius: BorderRadius.all(Radius.circular(20))),
                            width: 130,

                            child: Center(child: Padding(
                              padding: const EdgeInsets.all(1),
                              child: Text('Out Room', style: GoogleFonts.openSans( fontSize: 18, color: Color(0xff1da644)),),
                            ))),
                      ),
                     const Row(
                       children: [
                         CircleAvatar(
                           radius: 15,
                           backgroundColor: Color(0xfff5f5f5f5), child: Icon(Icons.edit, size: 20, color: Colors.blue,),),
                         SizedBox(width: 10,),
                         CircleAvatar
                           (
                           radius: 15,
                           backgroundColor:  Color(0xfff5f5f5f5), child: Icon(Icons.remove_red_eye_outlined, size: 20, color: Color(0xfffd7e50),))
                       ],
                     )
                    ],),
                ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(

                            width: 70,
                            child: Text('2.', style: GoogleFonts.openSans( fontSize: 18),)),
                        Container(

                            width: 130,
                            child: Center(child: Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: Text('2930UH', style: GoogleFonts.openSans( fontSize: 18),),
                            ))),
                        Container(
                            width: 170,
                            child: Center(child: Text('Ismail', style: GoogleFonts.openSans(fontSize: 18),))),
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Container(

                              width: 110,

                              child: Center(child: Text('8320920021', style: GoogleFonts.openSans( fontSize: 18),))),
                        ),
                        Container(

                            width: 150,

                            child: Center(child: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Text('9:12 Am', style: GoogleFonts.openSans( fontSize: 18),),
                            ))),
                        Padding(
                          padding: const EdgeInsets.only(right: 25),
                          child: Container(
                              decoration: const BoxDecoration(
                                  // color: Colors.blue,
                                color: Color(0xffffd3d3),


                                  borderRadius: BorderRadius.all(Radius.circular(20))),
                              width: 130,

                              child: Center(child: Padding(
                                padding: const EdgeInsets.all(1),
                                child: Text('Out Room', style: GoogleFonts.openSans( fontSize: 18, color: Color(0xfff12d2d)),),
                              ))),
                        ),
                        const Row(
                          children: [
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: Color(0xfff5f5f5f5), child: Icon(Icons.edit, size: 20, color: Colors.blue,),),
                            SizedBox(width: 10,),
                            CircleAvatar
                              (
                                radius: 15,
                                backgroundColor:  Color(0xfff5f5f5f5), child: Icon(Icons.remove_red_eye_outlined, size: 20, color: Color(0xfffd7e50),))
                          ],
                        )
                      ],),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(

                            width: 70,
                            child: Text('3.', style: GoogleFonts.openSans( fontSize: 18),)),
                        Container(

                            width: 130,
                            child: Center(child: Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: Text('2930UH', style: GoogleFonts.openSans( fontSize: 18),),
                            ))),
                        Container(
                            width: 170,
                            child: Center(child: Text('Mustaq', style: GoogleFonts.openSans(fontSize: 18),))),
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Container(
                              width: 110,
                              child: Center(child: Text('8320920021', style: GoogleFonts.openSans( fontSize: 18),))),
                        ),
                        Container(
                            width: 150,

                            child: Center(child: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Text('9:12 Am', style: GoogleFonts.openSans( fontSize: 18),),
                            ))),
                        Padding(
                          padding: const EdgeInsets.only(right: 25),
                          child: Container(
                              decoration: const BoxDecoration(
                                // color: Colors.blue,
                                  color: Color(0xffffd3d3),


                                  borderRadius: BorderRadius.all(Radius.circular(20))),
                              width: 130,

                              child: Center(child: Padding(
                                padding: const EdgeInsets.all(1),
                                child: Text('Out Room', style: GoogleFonts.openSans( fontSize: 18, color: Color(0xfff12d2d)),),
                              ))),
                        ),
                        const Row(
                          children: [
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: Color(0xfff5f5f5f5), child: Icon(Icons.edit, size: 20, color: Colors.blue,),),
                            SizedBox(width: 10,),
                            CircleAvatar
                              (
                                radius: 15,
                                backgroundColor:  Color(0xfff5f5f5f5), child: Icon(Icons.remove_red_eye_outlined, size: 20, color: Color(0xfffd7e50),))
                          ],
                        )
                      ],),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(

                            width: 70,
                            child: Text('2.', style: GoogleFonts.openSans( fontSize: 18),)),
                        Container(

                            width: 130,
                            child: Center(child: Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: Text('2930UH', style: GoogleFonts.openSans( fontSize: 18),),
                            ))),
                        Container(
                            width: 170,
                            child: Center(child: Text('Ismail', style: GoogleFonts.openSans(fontSize: 18),))),
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Container(

                              width: 110,

                              child: Center(child: Text('8320920021', style: GoogleFonts.openSans( fontSize: 18),))),
                        ),
                        Container(
                            width: 150,
                            child: Center(child: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Text('9:12 Am', style: GoogleFonts.openSans( fontSize: 18),),
                            ))),
                        Padding(
                          padding: const EdgeInsets.only(right: 25),
                          child: Container(
                              decoration: const BoxDecoration(
                                // color: Colors.blue,
                                  color: Color(0xffffd3d3),


                                  borderRadius: BorderRadius.all(Radius.circular(20))),
                              width: 130,

                              child: Center(child: Padding(
                                padding: const EdgeInsets.all(1),
                                child: Text('Out Room', style: GoogleFonts.openSans( fontSize: 18, color: Color(0xfff12d2d)),),
                              ))),
                        ),
                        const Row(
                          children: [
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: Color(0xfff5f5f5f5), child: Icon(Icons.edit, size: 20, color: Colors.blue,),),
                            SizedBox(width: 10,),
                            CircleAvatar
                              (
                                radius: 15,
                                backgroundColor:  Color(0xfff5f5f5f5), child: Icon(Icons.remove_red_eye_outlined, size: 20, color: Color(0xfffd7e50),))
                          ],
                        )
                      ],),
                  ),

                ],)
            ]
          ),
        ),
      ),
    );
  }
//   Pop up for alert
  Future<void> _showMyDialog() async {
    bool status = false;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:Colors.white,
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Mark Todays Attendance'),
                ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff37d1d3))),
                    onPressed: (){}, child: Text('Cancle'))
              ],
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  child: Row(children: [
SizedBox(width: 100, child: Text('No.',style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.w600),),),
                    SizedBox(width: 400, child: Text('Name',style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.w600),),),
                    SizedBox(width: 400, child: Text('Actions',style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.w600),),),
Divider(color: Colors.grey, thickness: 0.1,)
                  ],),
                ),
                Divider(color: Colors.grey, thickness: 0.2,),
                Container(
                  width: 900,
                  height: 500,
                  child: StreamBuilder(stream: FirebaseFirestore.instance.collection('Users').snapshots(), builder: (context, snapshot){
                    if(snapshot.hasData){
                      return ListView.builder(itemBuilder: (context, index) {
                        int serialNumber = index + 1;
                        var data = snapshot.data!.docs[index];
                        return                Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Row(children: [
                              SizedBox(width: 100, child: Text( '${serialNumber}',style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.w600),),),
                              SizedBox(width: 400, child: Text(data['firstName'],style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.w600),),),
                              SizedBox(
                                child: SmartSwitch(
                                  size: SwitchSize.medium,
                                  disabled: false,
                                  activeColor: Constants()
                                      .primaryAppColor,

                                  inActiveColor: Colors.grey,
                                  defaultActive: status,

                                  onChanged: (value) {
                                    setState(() {
                                      status = true;
                                    });


                                  },
                                ),
                              ),





                              Divider(color: Colors.grey, thickness: 0.1,)
                            ],),
                          ),
                        );

                      }, itemCount: snapshot.data!.docs.length,);

                    }else{
                      return Text('Document ');
                    }
                  },)



                  // ListView.builder(itemBuilder: (context, index) {
                  //
                  //   return
                  //
                  // },
                  // ),

                ),


              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


}

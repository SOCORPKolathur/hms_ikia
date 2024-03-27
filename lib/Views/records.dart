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
  // for date and time
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  DateTime selectedDate = DateTime.now();
  bool AttendanceStatus = false;

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
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff37d1d3))),
                    onPressed: (){
                      _showMyDialog(context);
                    }, child: Text('Mark Attendance', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: Colors.white),)),
              )
          ],),),
            const SizedBox(height: 20,),

          const SizedBox(height: 10,),
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
                        Container(
                            width: 80,
                            child: Text('Name', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),)),
                        Text('Phone No', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
                        Text('Check In', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
                        Text('Status', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
                        Text('Actions', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
                      ],),
                  ),
                ),
              ),
              // ListView(
              //   shrinkWrap: true,
              //   children: [
              //     Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: [
              //         Container(
              //             width: 70,
              //             child: Text('1.', style: GoogleFonts.openSans( fontSize: 18),)),
              //         Container(
              //
              //             width: 130,
              //             child: Center(child: Padding(
              //               padding: const EdgeInsets.only(left: 0),
              //               child: Text('2930UH', style: GoogleFonts.openSans( fontSize: 18),),
              //             ))),
              //         Container(
              //             width: 170,
              //             child: Center(child: Text('Muzzu Muzam', style: GoogleFonts.openSans(fontSize: 18),))),
              //         Padding(
              //           padding: const EdgeInsets.only(right: 30),
              //           child: Container(
              //               width: 110,
              //               child: Center(child: Text('9360777431', style: GoogleFonts.openSans( fontSize: 18),))),
              //         ),
              //         Container(
              //             width: 150,
              //             child: Center(child: Padding(
              //               padding: const EdgeInsets.only(right: 20),
              //               child: Text('9:40 Am', style: GoogleFonts.openSans( fontSize: 18),),
              //             ))),
              //         Padding(
              //           padding: const EdgeInsets.only(right: 25),
              //           child: Container(
              //             decoration: const BoxDecoration(
              //               // color: Colors.blue,
              //               color: Color(0xffddffe7),
              //                 borderRadius: BorderRadius.all(Radius.circular(20))),
              //               width: 130,
              //
              //               child: Center(child: Padding(
              //                 padding: const EdgeInsets.all(1),
              //                 child: Text('Out Room', style: GoogleFonts.openSans( fontSize: 18, color: Color(0xff1da644)),),
              //               ))),
              //         ),
              //        const Row(
              //          children: [
              //            CircleAvatar(
              //              radius: 15,
              //              backgroundColor: Color(0xfff5f5f5f5), child: Icon(Icons.edit, size: 20, color: Colors.blue,),),
              //            SizedBox(width: 10,),
              //            CircleAvatar
              //              (
              //              radius: 15,
              //              backgroundColor:  Color(0xfff5f5f5f5), child: Icon(Icons.remove_red_eye_outlined, size: 20, color: Color(0xfffd7e50),))
              //          ],
              //        )
              //       ],),
              //   ),
              //   ],)

              StreamBuilder(stream: FirebaseFirestore.instance.collection('Users').orderBy("timestamp", descending: true).snapshots(), builder: (context, snapshot) {
                print(snapshot);
                if (snapshot.hasData) {
                  var documents = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var data = documents[index].data();
                      int serialNumber = index + 1;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              // color: Colors.pink,
                                width: 128,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Text(serialNumber.toString(),
                                    style: GoogleFonts.openSans(fontSize: 18),),
                                )),
                            Container(
                              // color: Colors.blue,
                                width: 135,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: Text(data['userid'],
                                    style: GoogleFonts.openSans(fontSize: 18),),
                                )),
                            Container(
                                width: 150,
                                child: Text(data['firstName'],
                                  style: GoogleFonts.openSans(fontSize: 18),)
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 30),
                              child: Container(
                                // color: Colors.grey,
                                  width: 140,
                                  child: Text('+91${data['phone']}',
                                    style: GoogleFonts.openSans(
                                        fontSize: 18),)),
                            ),
                            Container(
                                width: 130,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Text('9:40 Am',
                                    style: GoogleFonts.openSans(fontSize: 18),),
                                )),

                            Padding(
                              padding: const EdgeInsets.only(right: 25),
                              child: Container(
                                  decoration: const BoxDecoration(
                                    // color: Colors.blue,
                                      color: Color(0xffddffe7),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  width: 130,
                                  child: Center(child: Padding(
                                    padding: const EdgeInsets.all(1),
                                    child: Text('In room',
                                      style: GoogleFonts.openSans(fontSize: 18,
                                          color: Color(0xff1da644)),),
                                  ))),
                            ),
                            const Row(
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Color(0xfff5f5f5f5),
                                  child: Icon(Icons.edit, size: 20,
                                    color: Colors.blue,),),
                                SizedBox(width: 10,),
                                CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Color(0xfff5f5f5f5),
                                    child: Icon(
                                      Icons.remove_red_eye_outlined, size: 20,
                                      color: Color(0xfffd7e50),))
                              ],
                            )
                          ],),
                      );
                    },
                  itemCount: documents.length,
                  );
                }
                if (snapshot.hasError) {
                  return Text('Error: $Error');
                }
                else {
                  return CircularProgressIndicator();
                }
              },
              )
           ]
          ),
        ),
      ),
    );
  }
//   Pop up for alert
//  real
  Future<void> _showMyDialog(BuildContext context) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
     // Check if a document with today's date already exists
    DocumentSnapshot? existingDocument = await FirebaseFirestore.instance
        .collection('Attendance')
        .doc(formattedDate)
        .get();

if(existingDocument.exists){
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Todays Attendance done '),
      duration: Duration(seconds: 2),
    ),
  );
//  if today didnt took attendance
}else{

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
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
                  onPressed: (){
                    Navigator.of(context).pop();
                  }, child: Text('Cancle', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: Colors.white),))
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
                        String name = data['firstName'];
                        bool attendanceStatus = AttendanceStatus;
                        return Padding(
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
                                  defaultActive: AttendanceStatus,
                                  onChanged: (ChangeValue) {
                                    setState(() {
                                      AttendanceStatus = !ChangeValue;
                                      // ChangeValue = !ChangeValue;
                                    });
                                    attendanceStatus=ChangeValue;
                                    print('$name - Attendance Status: $attendanceStatus');
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
              ),


            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff37d1d3))),
              onPressed: (){
                AttendanceColl(AttendanceStatus, formattedDate);
              }, child: Text('Submit', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: Colors.white),))
        ],
      );
    },
  );
}

  }

  // void AttendanceColl(bool attendanceStatus, String formattedDate) {
  //   bool tookAttendance = false;
  //   DateTime now = DateTime.now();
  //   formattedDate = DateFormat('yyyy-MM-dd').format(now);
  //   FirebaseFirestore.instance
  //       .collection('Attendance')
  //       .doc(formattedDate)
  //       .set({
  //     'marked': !tookAttendance,
  //     'date': formattedDate,
  //     'timestamp': DateTime.now().millisecondsSinceEpoch
  //   });
  //   FirebaseFirestore.instance
  //       .collection('Users')
  //       .get()
  //       .then((userSnapshot) {
  //     userSnapshot.docs.forEach((userDoc) {
  //       FirebaseFirestore.instance
  //           .collection('Attendance')
  //           .doc(formattedDate)
  //           .collection('Residents')
  //           .doc(userDoc.id)
  //           .set({
  //         'name': userDoc['firstName'],
  //         'attendanceStatus': attendanceStatus,
  //       });
  //     });
  //   });
  //   print('doneeeeeeeeeeee');
  //   Navigator.of(context).pop();
  // }




  void AttendanceColl(bool attendanceStatus, String formattedDate) {
    DateTime now = DateTime.now();
    formattedDate = DateFormat('yyyy-MM-dd').format(now);
    FirebaseFirestore.instance
        .collection('Attendance')
        .doc(formattedDate)
        .set({
      'date': formattedDate,
      'timestamp': DateTime.now().millisecondsSinceEpoch
    });

    // Get all users and update their attendance status
    FirebaseFirestore.instance
        .collection('Users')
        .get()
        .then((userSnapshot) {
      userSnapshot.docs.forEach((userDoc) {
        FirebaseFirestore.instance
            .collection('Attendance')
            .doc(formattedDate)
            .collection('Residents')
            .doc(userDoc.id)
            .set({
          'name': userDoc['firstName'],
          'attendanceStatus': attendanceStatus,
        });
      });
    });

    print('Attendance marked successfully');
    Navigator.of(context).pop();
  }




}

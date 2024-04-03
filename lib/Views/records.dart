import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_ikia/widgets/ReusableHeader.dart';
import 'package:hms_ikia/widgets/customtextfield.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../Constants/constants.dart';
import '../widgets/kText.dart';
import '../widgets/switch_button.dart';


class Records extends StatefulWidget {
  const Records({super.key});

  @override
  State<Records> createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  // search
  final TextEditingController SearchPhoneNum = TextEditingController();
  final TextEditingController attendanceDate = TextEditingController();
  // fr the attendance
  // for date and time
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  DateTime selectedDate = DateTime.now();
  bool AttendanceStatus = false;
  DateTime ? selectedAttDate;
  bool isDataAvailable = true;


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
                child: Row(
                  children: [
                    CustomTextField(hint: 'search Phone , User ID....', controller:SearchPhoneNum , fillColor: const Color(0xffF5F5F5),validator: null, header: '', width: 335,preffixIcon: Icons.search, height: 45,
                    onChanged: (value){
                      setState(() {

                      });
                    },
                    ),
SizedBox(width: 10,),
                    Container(
                      width: 260,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Color(0xffF5F5F5),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Color(0x7f262626)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0.0, right: 0),
                        child: TextFormField(
                          onTap: () {
                            AttendaceDatePicker(context);
                          },
                          cursorColor: Constants().primaryAppColor,
                          controller: attendanceDate,
                          readOnly: true,
                          decoration: InputDecoration(
                            prefixIcon: IconButton(
                              onPressed: () {

                              },
                              icon: Icon(Icons.calendar_month, size: 20,),
                            ),
                            border: InputBorder.none,
                            hintText: "Select the Date",
                            hintStyle: GoogleFonts.openSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0x7f262626),
                            ),
                          ),
                          style: GoogleFonts.openSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff37d1d3))),
                    onPressed: (){
                      _EditshowMyDialog(context);
                      // _showMyDialog(context);
                    }, child: KText(text:'Edit Today Attendance', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: Colors.white),)),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff37d1d3))),
                    onPressed: (){
                      // _EditshowMyDialog
                      _showMyDialog(context);
                    }, child: KText(text: 'Mark Attendance', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: Colors.white),)),
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
                        Container(
                            width: 200,
                            child: Text('S.No', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),)),
                        Container(
                            width: 200,
                            child: Text('User ID', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),)),
                        Container(
                             width: 200,
                            child: Text('Name', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),)),
                        Container(
                            width: 200,
                            child: Text('Phone No', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),)),
                        Container(
                            width: 200,
                            child: Center(child: Text('Status', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),))),
                      ],),
                  ),
                ),
              ),
              StreamBuilder(stream: FirebaseFirestore.instance.collection('Attendance').
              doc(getSelectedDate()
              ).collection('Residents').snapshots(), builder: (context, snapshot) {
                print(snapshot);
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }if(isDataAvailable){

                  // this is matched one with the search
                  List<DocumentSnapshot> matchedData = [];
                  // this is remaining one
                  List<DocumentSnapshot> remainingData = [];
                  if(SearchPhoneNum.text.isNotEmpty){
                    // Separate the snapshot data based on the search text
                    snapshot.data!.docs.forEach((doc) {
                      final name = doc["name"].toString().toLowerCase();
                      final searchText = SearchPhoneNum.text.toLowerCase();
                      if (name.contains(searchText)) {
                        matchedData.add(doc);
                      } else {
                        remainingData.add(doc);
                      }
                    });

                    // Sort the matched data
                    matchedData.sort((a, b) {
                      final nameA = a["name"].toString().toLowerCase();
                      final nameB = b["name"].toString().toLowerCase();
                      final searchText = SearchPhoneNum.text.toLowerCase();
                      return nameA.compareTo(nameB);
                    });

                  }else{
                    // If search query is empty, display original data
                    remainingData = snapshot.data!.docs;
                  }
                  // Concatenate matched data and remaining data
                  List<DocumentSnapshot> combinedData = [...matchedData, ...remainingData];


                  var documents = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if(snapshot.hasData){
                        // var data = documents[index].data();
                        final document = combinedData[index];
                        int serialNumber = index + 1;
                        String status = 'Absent';
                        Color Tcolor = Color(0xffF12D2D);
                        Color Bcolor = Color(0xffFFD3D3);
                        document['attendanceStatus'] == true ?
                        status = 'Present' : status = 'Absent';
                        document['attendanceStatus'] == true ?
                        Tcolor = Color(0xff1DA644) : Tcolor = Color(0xffF12D2D);
                        document['attendanceStatus'] == true ?
                        Bcolor = Color(0xffDDFFE7): Bcolor = Color(0xffFFD3D3);

                        return Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  width: 200,
                                  child: Text(serialNumber.toString(),
                                    style: GoogleFonts.openSans(fontSize: 18),)),
                              Container(
                                  width: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 0),
                                    child: Text(document['userid'],
                                      style: GoogleFonts.openSans(fontSize: 18),),
                                  )),
                              Container(
                                  width: 200,
                                  child: Text(document['name'],
                                    style: GoogleFonts.openSans(fontSize: 18),)
                              ),
                              Container(
                                // color: Colors.grey,
                                  width: 200,
                                  child: Text('+91${document['phone']}',
                                    style: GoogleFonts.openSans(
                                        fontSize: 18),)),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Container(
                                    height: 50,
                                    width: 200,
                                    child: Center(child: ElevatedButton(
                                      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Bcolor)),
                                      onPressed: () {}, child: Text(status, style: GoogleFonts.openSans(color: Tcolor, fontSize: 15),),)
                                    )
                                ),
                              ),
                            ],),
                        );
                      }
                    },
                    itemCount: documents.length,
                  );
                }
                else {
                 return Center(
                   child: Container(
                     width: 200,
                     height: 230,
                     // child: Center(
                     //   child: Lottie.network(
                     //        'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/A.json'),
                     // ),
                     child: Center(
                       child: Lottie.asset('assets/ui-design-/noData.json'),
                     ),
                   ),
                 );
                }
              },
              )

           ]
          ),
        ),
      ),
    );
  }

  String getSelectedDate() {
    return selectedAttDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedAttDate!)
        : DateFormat('yyyy-MM-dd').format(DateTime.now());
  }


//  real
  List<bool> attendanceStatus = [];
  // normal
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
      content: Text("Today's Attendance done "),
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
                  }, child: Text('Cancel', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: Colors.white),))
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
                      List<bool> attendanceStatus2 = List.generate(snapshot.data!.docs.length, (index) => false);
                      return ListView.builder(itemBuilder: (context, index) {
                        int serialNumber = index + 1;
                        var data = snapshot.data!.docs[index];
                        String name = data['firstName'];
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
                                      attendanceStatus2[index]=ChangeValue;
                                      attendanceStatus= attendanceStatus2;
                                    });
                                    print('$name - Attendance Status: ${attendanceStatus[index]}');
                                  },
                                ),
                              ),
                              Divider(color: Colors.grey, thickness: 0.1,)
                            ],),
                          ),
                        );

                      }, itemCount: snapshot.data!.docs.length,);

                    }
                    // if(error == true){
                    //   return Lottie.asset('assets/ui-design-/noData.json');
                    // }

                    else{
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
                AttendanceColl(attendanceStatus, formattedDate);
              }, child: Text('Submit', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: Colors.white),))
        ],
      );
    },
  );
}
  }
  // for edit
  Future<void> _EditshowMyDialog(BuildContext context) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    // Check if a document with today's date already exists
    DocumentSnapshot? existingDocument = await FirebaseFirestore.instance
        .collection('Attendance')
        .doc(formattedDate)
        .get();

    if(existingDocument.exists)
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text("Today's Attendance done "),
      //     duration: Duration(seconds: 2),
      //   ),
      // );
//  if today didnt took attendance
    {
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
                  const Text('Update Todays Attendance'),
                  ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff37d1d3))),
                      onPressed: (){
                        Navigator.of(context).pop();
                      }, child: Text('Cancel', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: Colors.white),))
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
                      child: StreamBuilder(stream: FirebaseFirestore.instance.collection('Attendance')
                          .doc(formattedDate).collection('Residents').snapshots(), builder: (context, snapshot){
                        if(snapshot.hasData){
                          List<bool> attendanceStatus2 = List.generate(snapshot.data!.docs.length, (index) => false);
                          return ListView.builder(itemBuilder: (context, index) {
                            int serialNumber = index + 1;
                            var data = snapshot.data!.docs[index];
                            String name = data['name'];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Row(children: [
                                  SizedBox(width: 100, child: Text( '${serialNumber}',style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.w600),),),
                                  SizedBox(width: 400, child: Text(data['name'],style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.w600),),),
                                  SizedBox(
                                    child: SmartSwitch(
                                      size: SwitchSize.medium,
                                      disabled: false,
                                      activeColor: Constants()
                                          .primaryAppColor,
                                      inActiveColor: Colors.grey,
                                      defaultActive: data['attendanceStatus'],
                                      onChanged: (ChangeValue) {
                                        setState(() {
                                          AttendanceStatus = !ChangeValue;
                                          // ChangeValue = !ChangeValue;
                                          attendanceStatus2[index]=ChangeValue;
                                          attendanceStatus= attendanceStatus2;
                                        });
                                       FirebaseFirestore.instance.collection('Attendance')
                                           .doc(formattedDate).collection('Residents').doc(data.id).update({
                                         'attendanceStatus' : ChangeValue
                                       });
                                      },
                                    ),
                                  ),
                                  Divider(color: Colors.grey, thickness: 0.1,)
                                ],),
                              ),
                            );
                          }, itemCount: snapshot.data!.docs.length,);
                        }
                        // if(error == true){
                        //   return Lottie.asset('assets/ui-design-/noData.json');
                        // }

                        else{
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
                    // AttendanceColl(attendanceStatus, formattedDate);
                    showTopSnackBar(
                      Overlay.of(context),
                      CustomSnackBar.success(
                        backgroundColor: Color(0xff3ac6cf),
                        message:
                        "Attendance Updated Sucessfully",
                      ),
                    );
                    Navigator.pop(context);

                  }, child: Text('Submit', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: Colors.white),))
            ],
          );
        },
      );
    }
else{
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text("You Didnt even took the Attendance Yet!!"),
      //     duration: Duration(seconds: 2),
      //   ),
      // );

      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          backgroundColor: Color(0xffF12D2D),
          message:
          "You Didnt even took the Attendance Yet!!",
        ),
      );

 // if today didnt took attendance
    }
  }

  Future<void> AttendanceColl(List<bool> attendanceStatus, String formattedDate) async {
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
   var docu = await FirebaseFirestore.instance
        .collection('Users')
        .get();
   for(int i=0;i<docu.docs.length;i++){
     FirebaseFirestore.instance
         .collection('Attendance')
         .doc(formattedDate)
         .collection('Residents')
         .doc(docu.docs[i].id)
         .set({
       'name': docu.docs[i]['firstName'],
       'userid': docu.docs[i]['userid'],
       'phone': docu.docs[i]['phone'],
       'attendanceStatus': attendanceStatus[i],
     });
   }
    print('Attendance marked successfully');
    Navigator.of(context).pop();
  }

  Future<void> AttendaceDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDate: selectedAttDate ?? DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedAttDate = picked;
        attendanceDate.text = DateFormat('yyyy-MM-dd').format(picked);
      });
      fetchAttendanceData(DateFormat('yyyy-MM-dd').format(picked));
    } else {
      setState(() {
        selectedAttDate = DateTime.now();
        attendanceDate.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
      });
      fetchAttendanceData(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    }
  }
  // Future fetchAttendanceData(String selectedDate) async {
  //   DocumentSnapshot attendanceDoc = await FirebaseFirestore.instance
  //       .collection('Attendance')
  //       .doc(selectedDate)
  //       .get();
  //
  //   if (attendanceDoc.exists) {
  //     QuerySnapshot attendanceRecords = await FirebaseFirestore.instance
  //         .collection('Attendance')
  //         .doc(selectedDate)
  //         .collection('Residents')
  //         .get();
  //
  //   } else {
  //   return Lottie.asset('assets/ui-design-/noData.json');
  //   }}
  Future fetchAttendanceData(String selectedDate) async {
    DocumentSnapshot attendanceDoc = await FirebaseFirestore.instance
        .collection('Attendance')
        .doc(selectedDate)
        .get();
    if (attendanceDoc.exists) {
      // Data is available
      isDataAvailable = true;
    } else {
      // Data is not available
      isDataAvailable = false;
    }
  }
}

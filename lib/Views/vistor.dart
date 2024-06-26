import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_ikia/widgets/kText.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;
import '../Constants/constants.dart';
import '../widgets/ReusableHeader.dart';
import '../widgets/ReusableRoomContainer.dart';
import '../widgets/customtextfield.dart';
import 'package:flutter_svg/flutter_svg.dart';


class Visitor_Page extends StatefulWidget {
  const Visitor_Page({super.key});

  @override
  State<Visitor_Page> createState() => _Visitor_PageState();
}

class _Visitor_PageState extends State<Visitor_Page> {

  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  DateTime selectedDate = DateTime.now();
  bool VisitorStatus = false;
  DateTime ? selectedVisitorDate;
  bool isDataAvailable = true;

  final TextEditingController searchVisitors = TextEditingController();
  //main fields
  final TextEditingController visitorName = TextEditingController();
  final TextEditingController visitorDate = TextEditingController();
  final TextEditingController visitorNumber = TextEditingController();
  final TextEditingController totalVisitors = TextEditingController();
  final TextEditingController reasonFor = TextEditingController();
  final TextEditingController residentId = TextEditingController();
  final TextEditingController residentName = TextEditingController();

  //date pick
  final TextEditingController checkInTime = TextEditingController();
  final TextEditingController checkOutTime = TextEditingController();
  final TextEditingController checkInDate = TextEditingController();
  final TextEditingController checkOutDate = TextEditingController();

  List<String> BlockNames = [];
  String selectedBlockName = "Select Block Name";

  List<String> ResidentNames = [];
  String selectedResidentName = "Select Name";

  List<String> ResidentUserIds = [];
  String selectedResidentUserId = "Select UserId";

  List<String> RoomNames= [];
  // blockname list here


  Future<List<String>> getBlockNames() async {
    try {
      List<String> blockNames = ['Select Block Name'];
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Block').get();
      querySnapshot.docs.forEach((doc) {
        String blockName = doc['blockname'];
        if (blockName != "") {
          blockNames.add(blockName);
        }
      });
      setState(() {
        BlockNames.addAll(blockNames);
      });
      print(blockNames);
      return blockNames;
    } catch (e) {
      print("Error fetching block names: $e");
      return [];
    }
  }

  Future<void> getResidentNames() async {
    try {
      List<String> residentNames = ['Select Name'];
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Users').get();
      querySnapshot.docs.forEach((doc) {
        String residentName = doc['firstName'];
        if (residentName != "") {
          residentNames.add(residentName);
        }
      });
      setState(() {
        ResidentNames.addAll(residentNames);
      });
      print(residentNames);
    } catch (e) {
      print("Error fetching names: $e");
    }
  }
  Future<void> getResidentUserids() async {
    try {
      List<String> residentUserids = ['Select UserId'];
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Users').get();
      querySnapshot.docs.forEach((doc) {
        String residentUserid = doc['userid'];
        if (residentUserid != "") {
          residentUserids.add(residentUserid);
        }
      });
      setState(() {
        ResidentUserIds.addAll(residentUserids);
      });
      print(residentUserids);
    } catch (e) {
      print("Error fetching UserId: $e");
    }
  }
  void getRoomNames(String selectedBlockName) async {
    setState(() {
      blockRoomNames = ['Select Room Name'];
    });
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Room')
          .where('blockname', isEqualTo: selectedBlockName)
          .get();
      // Iterate through the documents and extract data
      querySnapshot.docs.forEach((doc) {
        String roomName = doc['roomnumber'];
        if (roomName != "") {
          setState(() {
            blockRoomNames.add(roomName);
          });
        }
      });
      print(blockRoomNames);
    } catch (e) {
      print("Error fetching room names: $e");
    }
  }

  List<String> blockRoomNames = ['Select Room Name'];
  // String selectedBlockName = "Select Block Name";
  String selectedRoomName = "Select Room Name";

  int TodayVisitors = 0;

  // for normal
  DateTime ? selectedCheckIn;
  // for Insurance Date
  DateTime ? selectedCheckout ;


  // for normal
  DateTime ? selectedCheckinDate;
  // for Insurance Date
  DateTime ? selectedCheckoutDate ;

  Future<void> getTodaysVisitors() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Visitors').get();
      int length = querySnapshot.docs.length;
      setState(() {
        TodayVisitors = length;
      });
    } catch (e) {
      print("Error getting rooms length: $e");
    }
  }


  Future<void> CheckInTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        selectedCheckIn = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          pickedTime.hour,
          pickedTime.minute,
        );
        print('selected time: $selectedCheckIn');
        checkInTime.text = DateFormat('h:mm a').format(selectedCheckIn!);
      });
    }
  }
  Future<void> CheckOutTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        selectedCheckout = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          pickedTime.hour,
          pickedTime.minute,
        );
        print('selected time: $selectedCheckout');
        checkOutTime.text = DateFormat('h:mm a').format(selectedCheckout!);
      });
    }
  }

  Future<void> CheckInDate(BuildContext context) async{
    final DateTime ? picked = await showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime(2030));
    if(picked != null){
      setState(() {
        selectedCheckinDate = picked;
        print('normal date $selectedCheckinDate');
        checkInDate.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }
  Future<void>CheckOutDate(BuildContext context) async{
    final DateTime ? picked = await showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime(2030));
    if(picked != null){
      setState(() {
        selectedCheckoutDate = picked;
        print('normal date $selectedCheckoutDate');
        checkOutDate.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  // String _getFormattedDate() {
  //   final now = DateTime.now();
  //   final formattedDate = "${now.year}-${now.month}-${now.day}";
  //   return formattedDate;
  // }

  String _getFormattedDate() {
    final now = DateTime.now();
    final formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    return formattedDate;
  }

  String getSelectedDate() {
    return selectedVisitorDate != null
        ? DateFormat('dd-MM-yyyy').format(selectedVisitorDate!)
        : DateFormat('dd-MM-yyyy').format(DateTime.now());
  }




  @override
  void initState() {

     getResidentNames();
     getResidentUserids();
      getBlockNames();
      getRoomNames(selectedBlockName);
      getTodaysVisitors();


    setState(() {
      // fetchUserData();
    });
    // TODO: implement initState
    super.initState();
  }




  // Future<void> fetchUserData() async {
  //   try {
  //     // Fetch Resident Names
  //     QuerySnapshot residentNamesSnapshot = await FirebaseFirestore.instance.collection('Users').get();
  //     ResidentNames = residentNamesSnapshot.docs.map((doc) => doc['firstName'] as String).toList();
  //
  //     // Fetch Resident User IDs
  //     QuerySnapshot residentUserIdsSnapshot = await FirebaseFirestore.instance.collection('Users').get();
  //     ResidentUserIds = residentUserIdsSnapshot.docs.map((doc) => doc['userid'] as String).toList();
  //
  //     // Fetch Block Names
  //     QuerySnapshot blockNamesSnapshot = await FirebaseFirestore.instance.collection('Block').get();
  //     BlockNames = blockNamesSnapshot.docs.map((doc) => doc['blockname'] as String).toList();
  //
  //     // Fetch Room Names
  //     QuerySnapshot roomNamesSnapshot = await FirebaseFirestore.instance.collection('Room').get();
  //     RoomNames = roomNamesSnapshot.docs.map((doc) => doc['roomnumber'] as String).toList();
  //
  //     // Update state to rebuild the UI
  //     setState(() {});
  //   } catch (error) {
  //     print('Error fetching data: $error');
  //   }
  // }


  final Color _svgColor = Colors.white;
  @override
  Widget build(BuildContext context) {
    return  FadeInRight(
      child:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Image.asset("assets/Visitor Management.png"),
              const ReusableHeader(Headertext: 'Visitor Management ', SubHeadingtext: '"Manage Easily Visitors Records"'),
              const SizedBox(height: 20,),

              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Visitors')
                    .where('checkinDate', isEqualTo: _getFormattedDate())
                    .snapshots(),
                builder: (context, checkInSnapshot) {
                  if (checkInSnapshot.hasData) {
                    final checkInDocs = checkInSnapshot.data!.docs;

                    // Count the number of check-ins
                    final numberOfCheckIns = checkInDocs.length;

                    // Sum up the total visitors from all documents
                    int totalVisitors = 0;
                    for (var doc in checkInDocs) {
                      // Parse 'totalvisitors' field and add to totalVisitors
                      String totalVisitorsString = doc['totalvisitors'] ?? '';
                      List<String> visitorsList = totalVisitorsString.split(',');
                      for (var visitor in visitorsList) {
                        totalVisitors += int.tryParse(visitor.trim()) ?? 0;
                      }
                    }

                    return StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('Visitors')
                          .where('checkoutDate', isEqualTo: _getFormattedDate())
                          .snapshots(),
                      builder: (context, checkOutSnapshot) {
                        if (checkOutSnapshot.hasData) {
                          final checkOutDocs = checkOutSnapshot.data!.docs;

                          Set<String> checkIns = {};
                          Set<String> checkOuts = {};

                          // Add unique identifiers for check-ins
                          for (var doc in checkInDocs) {
                            checkIns.add(doc['name']);
                          }

                          for (var doc in checkOutDocs) {
                            // Assuming 'name' is a field uniquely identifying visitors
                            checkOuts.add(doc['name']);
                          }

                          // Count the number of unique visitors
                          final numberOfVisitors = (checkIns.union(checkOuts)).length;

                          // Count the number of check-outs
                          final numberOfCheckOuts = checkOuts.length;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ReusableRoomContainer(
                                firstColor: const Color(0xff034d7f),
                                secondColor: const Color(0xff058be5),
                                title: 'Today Total Visitors',
                                totalRooms: totalVisitors.toString(),
                                waveImg: 'assets/ui-design-/images/Vector 38 (1).png',
                                roomImg: 'assets/ui-design-/images/Group 70.png',
                              ),
                              ReusableRoomContainer(
                                firstColor: const Color(0xff0e4d1f),
                                secondColor: const Color(0xff1b9a3f),
                                totalRooms: numberOfCheckIns.toString(),
                                title: 'Today Visitors Check In',
                                waveImg: 'assets/ui-design-/images/Vector 37 (3).png',
                                roomImg: 'assets/ui-design-/images/Group 71.png',
                              ),
                              ReusableRoomContainer(
                                firstColor: const Color(0xff971c1c),
                                secondColor: const Color(0xffe22a2a),
                                totalRooms: numberOfCheckOuts.toString(),
                                title: 'Visitors Check Out',
                                waveImg: 'assets/ui-design-/images/Vector 36 (3).png',
                                roomImg: 'assets/ui-design-/images/Group 72.png',
                              ),
                            ],
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),





              const SizedBox(height: 20,),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color:  const Color(0xff262626).withOpacity(0.10)),
                  borderRadius: BorderRadius.circular(30),
                ),
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // SizedBox(width: 20,),
                    Padding(
                      padding:  const EdgeInsets.only(left: 20),
                      child: CustomTextField(hint: 'search Visitors Name, No....',  controller: searchVisitors, validator: null, fillColor: const Color(0xffF5F5F5),header: '', width: 335, preffixIcon: Icons.search,height: 45, onChanged: (value){
                        setState(() {

                        });
                      }, ),
                    ),
                    SizedBox.fromSize(size:  const Size(0, 0),),
                    Padding(
                      padding:  const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          Container(
                            width: 260,
                            height: 46,
                            decoration: BoxDecoration(
                              color: const Color(0xffF5F5F5),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: const Color(0x7f262626)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0.0, right: 0),
                              child: TextFormField(
                                onTap: () {
                                  VisitorsDatePicker(context);
                                },
                                cursorColor: Constants().primaryAppColor,
                                controller: visitorDate,
                                readOnly: true,
                                decoration: InputDecoration(
                                  prefixIcon: IconButton(
                                    onPressed: () {
                                      VisitorsDatePicker(context);
                                    },
                                    icon: const Icon(Icons.calendar_month, size: 20,),
                                  ),
                                  border: InputBorder.none,
                                  hintText: "Select the Date",
                                  hintStyle: GoogleFonts.openSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0x7f262626),
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

SizedBox(width: 20,),
                          Container(
                            height: 44,
                            // width: 100,
                            child: ElevatedButton(
                                style:  const ButtonStyle(
                                    elevation: MaterialStatePropertyAll(2),
                                    backgroundColor: MaterialStatePropertyAll(Color(0xff37D1D3))),
                                onPressed: (){

                                  setState(() {
                                selectedResidentName = 'Select Name';
                                selectedResidentUserId = 'Select UserId';
                                selectedRoomName = 'Select Room Name';
                                selectedBlockName = 'Select Block Name';
                                  });
                                  AddvisitorsPopup();
                                }, child:
                            Row(
                              children: [
                                 const KText(style: TextStyle(color: Colors.white), text: 'Add Visitors',), SizedBox.fromSize(size: const Size(8,0),),  CircleAvatar(radius: 12,backgroundColor: Colors.transparent,
                                  child: Image.asset('assets/ui-design-/images/Waiting Room (2).png')
                                )
                              ],)
                            ),
                          ),
                          SizedBox.fromSize(size: const Size(23,0),),
                          Container(
                            height: 45,
                            child: ElevatedButton(
                                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff37D1D3))),
                                onPressed: (){
                                  showPopup(context);
                                }, child: Row(
                              children: [
                                KText(text:'Export Data', style: GoogleFonts.openSans(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white),),
                                const SizedBox(width: 4,),
                                SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: Image.asset('assets/ui-design-/images/Database Export.png'))
                              ],
                            )),
                          )
                        ],),
                    )
                  ],),),
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Container(
             decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20)
             ),
               border: Border.all(color: const Color(0xff262626).withOpacity(0.1))
             ),
             constraints: const BoxConstraints(
               minHeight: 100,
               maxHeight: 1000,
             ),
             width: double.infinity,
           child:
           Padding(
             padding: const EdgeInsets.all(15),
             child:
             Column(
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                   Container(
                       height: 50,
                       width: 100,
                       child: Center(child: KText(text:'S.No', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),
                       )
                       )),
                     Container(
                         height: 50,
                         width: 150,
                         child: Center(child: KText(text:'Visitor Name', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),))),
                     Container(
                         height: 50,
                         width: 100,
                         child: Center(child: KText(text:'Phone No', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),))),
                     Container(
                         height: 50,
                         width: 100,
                         child: Center(child: KText(text:'Purpose', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),))),
                     Container(
                         height: 50,
                         width: 200,
                         child: Center(child: KText(text:'Check In/Check Out', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),))),
                     Container(
                         height: 50,
                         width: 130,
                         child: Center(child: KText(text:'Status', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),))),
                     Container(
                         height: 50,
                         width: 100,
                         child: Center(child: KText(text:'Actions', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),))),
                 ],),
                 Container(color: const Color(0xff262626).withOpacity(0.1), width: double.infinity, height: 2,),
              StreamBuilder(stream: FirebaseFirestore.instance.collection('Visitors').where('checkinDate', isEqualTo: getSelectedDate()).snapshots(), builder: (context, snapshot) {
                if(snapshot.hasData){
                  // this is matched one with the search
                  List<DocumentSnapshot> matchedData = [];
                  // this is remaining one
                  List<DocumentSnapshot> remainingData = [];

                  if(searchVisitors.text.isNotEmpty){
                    // Separate the snapshot data based on the search text
                    snapshot.data!.docs.forEach((doc) {
                      final name = doc["name"].toString().toLowerCase();
                      final phone = doc["number"].toString().toLowerCase();
                      final searchText = searchVisitors.text.toLowerCase();
                      if (name.contains(searchText) || phone.contains(searchText)) {
                        matchedData.add(doc);
                      } else {
                        remainingData.add(doc);
                      }
                    });
                    // Sort the matched data
                    matchedData.sort((a, b) {
                      final nameA = a["name"].toString().toLowerCase();
                      final nameB = b["name"].toString().toLowerCase();
                      final searchText = searchVisitors.text.toLowerCase();
                      return nameA.compareTo(nameB);
                    });

                  }else{
                    // If search query is empty, display original data
                    remainingData = snapshot.data!.docs;
                  }
                  // Concatenate matched data and remaining data
                  List<DocumentSnapshot> combinedData = [...matchedData, ...remainingData];
                  print(snapshot.data!.docs.length);
                  print('iuoiuji');
                  return
                      ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          if(snapshot.data!.docs.length > 0){
                            final document = combinedData[index];
                            int serialNumber = index + 1;
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          height: 50,
                                          width: 100,
                                          child: Center(child: Text('$serialNumber.', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),
                                      Container(
                                          height: 50,
                                          width: 150,
                                          child: Center(child: KText(text:document['name'], style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),
                                      Container(

                                          height: 50,
                                          width: 100,
                                          child: Center(child: KText(text:document['number'],style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),

                                      Container(
                                          height: 50,
                                          width: 100,
                                          child: Center(child: KText(text:document['reason'], style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),

                                      Container(
                                          height: 50,
                                          width: 200,
                                          child: Center(child: KText( text:'${document['checkinDate']} - ${document['checkoutDate']}', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),
                                      document['checkoutTime'] == '' ?
                                      Container(
                                          height: 50,
                                          width: 130,
                                          child: Center(child: ElevatedButton(
                                            style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xffDDFFE7))),
                                            onPressed: () {}, child: KText(text:'Check In', style: GoogleFonts.openSans(color: const Color(0xff1DA644), fontSize: 15),),)
                                          )
                                      ) :
                                      Container(
                                          height: 50,
                                          width: 130,
                                          child: Center(child: ElevatedButton(
                                            style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xffFFD3D3))),
                                            onPressed: () {}, child: KText(text:'Check out', style: GoogleFonts.openSans(color: const Color(0xffF12D2D), fontSize: 15),),)
                                          )
                                      ),

                                      Container(
                                          height: 50,
                                          width: 100,
                                          child: Center(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setuserdata(snapshot.data!.docs[index].id);
                                                      UpdateVisitorPopUp(context,snapshot.data!.docs[index].id);
                                                    },
                                                    child: CircleAvatar(
                                                      radius: 14,
                                                      backgroundColor: const Color(0xffF5F5F5),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(3),
                                                        child: Image.asset('assets/ui-design-/images/edit.png'),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8,),
                                                  GestureDetector(
                                                    onTap: (){
                                                      VisitorViewPopUp(context, snapshot.data!.docs[index]);
                                                    },
                                                    child: CircleAvatar(
                                                      radius: 14,
                                                      backgroundColor: const Color(0xffF5F5F5),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(3),
                                                        child: Image.asset('assets/ui-design-/images/eye-8QM.png'),
                                                      ),
                                                    ),
                                                  ),
                                                ],)
                                          )),
                                    ],),
                                ),
                                Container(color: const Color(0xff262626).withOpacity(0.1), width: double.infinity, height: 2,),
                              ],
                            );
                          }else {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: Container(
                                  color: Colors.blue,
                                  width: 200,
                                  height: 230,
                                  child: Center(
                                    child: Lottie.asset(
                                        'assets/ui-design-/noData.json'),
                                  ),
                                ),
                              ),
                            );
                          }
                      }, itemCount: snapshot.data!.docs.length);
                  }else{
                  return const CircularProgressIndicator();
                }
              },)
               ],
             ),
           ),
           ),
         )
            ],
          ),
        ),
      ),
    );
  }
  Future<void> AddvisitorsPopup() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context,set) {
            return AlertDialog(
              elevation: 0,
              backgroundColor: const Color(0xffFFFFFF),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      KText(text:'Add Visitor or Guest', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
                      KText(text:'Enter Visitor Details', style: GoogleFonts.openSans(fontWeight: FontWeight.w500, fontSize: 15),),
                    ],
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 30, width: 30,
                      // here the Cross Icon
                      child:  Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 38,
                            width: 38,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                              boxShadow:[
                                BoxShadow(
                                    color: Color(0xfff5f6f7),
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                    offset: Offset(4,4)
                                )
                              ],
                            ),
                          ),
                          ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(50)),
                            child: Container(
                              height: 20,
                              width: 20,
                              child: Image.asset('assets/ui-design-/images/Multiply.png', fit: BoxFit.contain,scale: 0.5,),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              content: SingleChildScrollView(
                child: Container(
                  width: 750,
                  height: 580,
                  child: Column(
                    children: [
                      const SizedBox(height: 10,),
                      Divider(color: const Color(0xff262626).withOpacity(0.1), thickness: 1, height: 0.5),
                      ///visitor name, visitor phone number, no.of visitors
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                KText(text:'Visitor Name', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                                  child: CustomTextField(
                                    hint: 'Enter visitors Name',
                                    controller: visitorName,
                                    fillColor: Colors.white,
                                    validator: null,
                                    header: '',
                                    width: 200,
                                    height: 45,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                KText(text:'Visitor Phone Number', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                                  child: CustomTextField(
                                    hint: 'Visitor Phone Number',
                                    controller: visitorNumber,
                                    fillColor: Colors.white,
                                    validator: null,
                                    header: '',
                                    width: 200,
                                    height: 45,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                KText(text:'No of Visitors', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                                  child: CustomTextField(
                                    hint: 'No of Visitors',
                                    controller: totalVisitors,
                                    fillColor: Colors.white,
                                    validator: null,
                                    header: '',
                                    width: 200,
                                    height: 45,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      /// from time, to time, reason
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //checkIn time
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                KText(text:'From Time', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                                  child: Container(
                                    width: 220,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(color: const Color(0x7f262626)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0.0, right: 0),
                                      child: TextFormField(
                                        cursorColor: Constants().primaryAppColor,
                                        controller: checkInTime,
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          prefixIcon: IconButton(
                                            onPressed: () {
                                              CheckInTime(context);
                                            },
                                            icon: const Icon(Icons.watch_later_outlined),
                                          ),
                                          border: InputBorder.none,
                                          hintText: "From Time",
                                          hintStyle: GoogleFonts.openSans(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0x7f262626),
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
                                ),
                              ],
                            ),
                          ),
                          //checkout time
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                KText(text:'To Time', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                                  child: Container(
                                    width: 220,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(color: const Color(0x7f262626)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0.0, right: 0),
                                      child: TextFormField(

                                        onTap: () {
                                        },
                                        cursorColor: Constants().primaryAppColor,
                                        controller: checkOutTime,
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          prefixIcon: IconButton(
                                            onPressed: () {
                                              CheckOutTime(context);
                                            },
                                            icon: const Icon(Icons.watch_later_outlined, size: 20,),
                                          ),
                                          border: InputBorder.none,
                                          hintText: "Out Time", // Default hint
                                          hintStyle: GoogleFonts.openSans(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0x7f262626),
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
                                ),
                              ],
                            ),
                          ),
                          //reason for
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                KText(text:'Reason For', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                                  child: CustomTextField(
                                    hint: 'Reason',
                                    controller: reasonFor,
                                    fillColor: Colors.white,
                                    validator: null,
                                    header: '',
                                    width: 200,
                                    height: 45,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      /// check in date, checkout date, resident name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //checkIn time
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                KText(text:'Check In Date', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                                  child: Container(
                                    width: 220,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(color: const Color(0x7f262626)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0.0, right: 0),
                                      child: TextFormField(
                                        onTap: () {
                                        },
                                        cursorColor: Constants().primaryAppColor,
                                        controller: checkInDate,
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          prefixIcon: IconButton(
                                            onPressed: () {
                                              CheckInDate(context);
                                            },
                                            icon: const Icon(Icons.calendar_month),
                                          ),
                                          border: InputBorder.none,
                                          hintText: "CheckIn Date",
                                          hintStyle: GoogleFonts.openSans(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0x7f262626),
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
                                ),
                              ],
                            ),
                          ),
                          //checkout time
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                KText(text:'Checkout Date', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                                  child: Container(
                                    width: 220,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(color: const Color(0x7f262626)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0.0, right: 0),
                                      child: TextFormField(
                                        onTap: () {
                                        },
                                        cursorColor: Constants().primaryAppColor,
                                        controller: checkOutDate,
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          prefixIcon: IconButton(
                                            onPressed: () {
                                              CheckOutDate(context);
                                            },
                                            icon: const Icon(Icons.calendar_month),
                                          ),
                                          border: InputBorder.none,
                                          hintText: "CheckOut Date", // Default hint
                                          hintStyle: GoogleFonts.openSans(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0x7f262626),
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
                                ),
                              ],
                            ),
                          ),


                          // res name
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                KText(text: 'Resident Name', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                  child: Container(
                                    width: 220,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0x7f262626)),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 12.0, right: 10),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButtonFormField<String>(
                                          isExpanded: true,
                                          hint: const KText(text:
                                          'Select Resident Name',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0x7f262626),
                                            ),
                                          ),
                                          items: ResidentNames.map((String item) {
                                            return DropdownMenuItem<String>(
                                              value: item,
                                              child: KText(text:
                                              item,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          value: selectedResidentName,
                                          onChanged: (String? value) async {
                                            set(() {
                                              selectedResidentName = value!;
                                            });

                                            var docu = await FirebaseFirestore.instance.collection('Users').where('firstName', isEqualTo: selectedResidentName).get();
                                              set(() {
                                                selectedResidentUserId = docu.docs[0]['userid'];
                                                selectedBlockName = docu.docs[0]['blockname'];
                                              });
                                            try {
                                              QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                                  .collection('Room')
                                                  .where('blockname', isEqualTo: selectedBlockName)
                                                  .get();
                                              // Iterate through the documents and extract data
                                              blockRoomNames = ['Select Room Name'];
                                              querySnapshot.docs.forEach((doc) {
                                                String roomName = doc['roomnumber'];
                                                if (roomName != "") {
                                                  set(() {
                                                    blockRoomNames.add(roomName);
                                                  });
                                                }
                                              });
                                              print(blockRoomNames);
                                            } catch (e) {
                                              print("Error fetching room names: $e");
                                            }
                                         set(() {
                                           selectedRoomName = docu.docs[0]['roomnumber'];
                                         });
                                          },
                                          decoration: const InputDecoration(border: InputBorder.none),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 18,),
                        ],
                      ),
                      /// UserId, Block Name, Room
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                KText(text: 'Resident UserId', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                  child: Container(
                                    width: 220,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0x7f262626)),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 12.0, right: 10),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButtonFormField<String>(
                                          isExpanded: true,
                                          hint: const KText(text:
                                          'Select Resident UserId',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0x7f262626),
                                            ),
                                          ),
                                          items: ResidentUserIds.map((String item) {
                                            return DropdownMenuItem<String>(
                                              value: item,
                                              child: KText(text:
                                              item,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          value: selectedResidentUserId,
                                          // onChanged: (String? value) async {
                                          //   set(() {
                                          //     selectedResidentUserId = value!;
                                          //   });
                                          // },
                                          onChanged: (String? value) async {
                                            set(() {
                                              selectedResidentUserId = value!;
                                            });
                                            var docu = await FirebaseFirestore.instance.collection('Users').where('userid', isEqualTo: selectedResidentUserId).get();
                                            set(() {
                                              selectedRoomName = docu.docs[0]['roomnumber'];
                                              selectedBlockName = docu.docs[0]['blockname'];
                                              selectedResidentName = docu.docs[0]['firstName'];
                                            });
                                            try {
                                              QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                                  .collection('Room')
                                                  .where('blockname', isEqualTo: selectedBlockName)
                                                  .get();
                                              // Iterate through the documents and extract data
                                              querySnapshot.docs.forEach((doc) {
                                                String roomName = doc['roomnumber'];
                                                if (roomName != "") {
                                                  set(() {
                                                    blockRoomNames.add(roomName);
                                                  });
                                                }
                                              });
                                              print(blockRoomNames);
                                            } catch (e) {
                                              print("Error fetching room names: $e");
                                            }
                                            set(() {
                                              selectedRoomName = docu.docs[0]['roomnumber'];
                                            });
                                          },
                                          decoration: const InputDecoration(border: InputBorder.none),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //block here
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                KText(text: 'Block Name', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                  child: Container(
                                    width: 220,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0x7f262626)),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 12.0, right: 10),
                                      child: IgnorePointer(

                                        child: DropdownButtonHideUnderline(

                                          child: DropdownButtonFormField<String>(

                                            isExpanded: true,
                                            hint: const KText(text:
                                              'Select Block Name',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0x7f262626),
                                              ),
                                            ),
                                            items: BlockNames.map((String item) {
                                              return DropdownMenuItem<String>(
                                                value: item,
                                                child: KText(text:
                                                  item,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            value: selectedBlockName,
                                            onChanged: (String? value) async {
                                              // set(() {
                                              //   // selectedBlockName = value!;
                                              //   selectedRoomName = "Select Room Name";
                                              // });
                                              // set(() {
                                              //   blockRoomNames = ['Select Room Name'];
                                              // }
                                              // );
                                              // try {
                                              //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                              //       .collection('Room')
                                              //       .where('blockname', isEqualTo: selectedBlockName)
                                              //       .get();
                                              //   // Iterate through the documents and extract data
                                              //   querySnapshot.docs.forEach((doc) {
                                              //     String roomName = doc['roomnumber'];
                                              //     if (roomName != null) {
                                              //       set(() {
                                              //         blockRoomNames.add(roomName);
                                              //       });
                                              //     }
                                              //   });
                                              //   print(blockRoomNames);
                                              // } catch (e) {
                                              //   print("Error fetching room names: $e");
                                              // }
                                            },
                                            decoration: const InputDecoration(border: InputBorder.none),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 18,),
                          //room here
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              KText(text:'Room', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(
                                  width: 220,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: const Color(0x7f262626)),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0, right: 6),
                                    child: IgnorePointer(
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButtonFormField<String>(
                                          isExpanded: true,
                                          hint: const KText(text:
                                            'Select Room Name',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0x7f262626),
                                            ),
                                          ),
                                          items: blockRoomNames.map((String item) {
                                            return DropdownMenuItem<String>(
                                              value: item,
                                              child: KText(
                                                text:
                                                item,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          value: selectedRoomName,
                                          onChanged: (String? value) {
                                            setState(() {
                                              selectedRoomName = value!;
                                            });
                                          },
                                          decoration: const InputDecoration(border: InputBorder.none),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      /// For Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 110,
                                height: 40,
                                child: ElevatedButton(
                                  style: const ButtonStyle(
                                      elevation: MaterialStatePropertyAll(0),
                                      backgroundColor: MaterialStatePropertyAll(Color(0xfff5f6f7))),
                                  onPressed: (){
                                    visitorName.clear();
                                    // residentId.clear();
                                    visitorNumber.clear();
                                    totalVisitors.clear();
                                    reasonFor.clear();
                                    checkInTime.clear();
                                    checkInDate.clear();
                                    checkOutTime.clear();
                                    checkOutDate.clear();
                                    set(() {
                                      selectedResidentName = 'Select Name';
                                      selectedResidentUserId = 'Select Id';
                                      selectedRoomName = 'Select Room Name';
                                      selectedBlockName = 'Select Block Name';
                                    });

                                  }, child:
                                KText(text:
                                  'Clear All',
                                  style: GoogleFonts.openSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff37D1D3),
                                  ),
                                ),
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              SizedBox(
                                width: 110,
                                height: 40,
                                child: ElevatedButton(
                                  style: const ButtonStyle(
                                      elevation: MaterialStatePropertyAll(0),
                                      backgroundColor: MaterialStatePropertyAll(Color(0xfff5f6f7))),
                                  onPressed: (){
                                    Navigator.pop(context);
                                  }, child:
                                KText(text:
                                  'Cancel',
                                  style: GoogleFonts.openSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff37D1D3),
                                  ),
                                ),
                                ),
                              ),
                              const SizedBox(width: 6,),
                              SizedBox(
                                height: 40,
                                child: ElevatedButton(
                                  style: const ButtonStyle(
                                      elevation: MaterialStatePropertyAll(3),
                                      backgroundColor: MaterialStatePropertyAll(Color(0xff37D1D3))
                                  ),
                                  // Adjusted onPressed callback
                                  onPressed: () {
                                    if (
                                    visitorName.text.isNotEmpty &&
                                        // residentId.text.isNotEmpty &&
                                        visitorNumber.text.isNotEmpty &&
                                        totalVisitors.text.isNotEmpty &&
                                        reasonFor.text.isNotEmpty &&
                                        checkInTime.text.isNotEmpty &&
                                        checkInDate.text.isNotEmpty
                                    ) {
                                      final visitorname = visitorName.text;
                                      // final residentid = residentId.text;
                                      final visitornumber = visitorNumber.text;
                                      final checkinTime = checkInTime.text;
                                      final checkoutTime = checkOutTime.text;

                                      final checkinDate = checkInDate.text;
                                      final checkoutDate = checkOutDate.text;
                                      final totalvisitors = totalVisitors.text;
                                      final blockname = selectedBlockName;
                                      final residentname = selectedResidentName;
                                      final residentuserid = selectedResidentUserId;
                                      final roomname = selectedRoomName;
                                      final ReasonFor = reasonFor.text;
                                      bool Status = true;
                                      if(checkOutDate.text.isNotEmpty && checkOutTime.text.isNotEmpty){
                                        setState(() {
                                          Status = false;
                                        });
                                      }else{
                                        setState(() {
                                          Status = true;
                                        });
                                      }
                                      createVisitor(
                                          visitorname,  visitornumber, totalvisitors, checkinTime,
                                          checkoutTime,  checkinDate,  checkoutDate,  residentname,  residentuserid, blockname, roomname, ReasonFor, Status!)
                                          .then((_) async {
                                        showTopSnackBar(
                                          Overlay.of(context),
                                          const CustomSnackBar.success(
                                            backgroundColor: Color(0xff3ac6cf),
                                            message:
                                            "Added successfully!",
                                          ),
                                        );

                                        QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance.collection('Users').where('userid', isEqualTo: selectedResidentUserId).get();

                                        if (userQuerySnapshot.docs.isNotEmpty) {
                                          String token = userQuerySnapshot.docs.first['fcmToken'];

                                          // Send the push notification
                                          sendPushMessage(token: token, body: '${visitorName.text} came to Hostel to Visit you', title: 'Visitor');
                                        } else {
                                          print('User not found');
                                          // Handle the case where the user is not found
                                        }


                                        visitorName.clear();
                                        residentId.clear();
                                        visitorNumber.clear();
                                        totalVisitors.clear();
                                        reasonFor.clear();
                                        checkInTime.clear();
                                        checkInDate.clear();
                                        checkOutTime.clear();
                                        checkOutDate.clear();
                                        Navigator.pop(context);
                                      }).catchError((error) {
                                        // Provide feedback to the user
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: KText(text:'Error adding visitor: $error', style: GoogleFonts.openSans(),),
                                        ));

                                      });
                                    } else {
                                      // Navigator.pop(context);
                                      print('All fields needed');
                                      // Provide feedback to the user
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: KText(text:'All fields are required', style: GoogleFonts.openSans(),),
                                      ));
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      KText(text:
                                        'Allow',
                                        style: GoogleFonts.openSans(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const CircleAvatar(
                                        radius: 8,
                                        backgroundColor: Colors.white,
                                        child: Center(
                                          child: Icon(
                                            Icons.add,
                                            color: Color(0xff37D1D3),
                                            size: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // const SizedBox(width: 10,),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        );
      },
    );
  }
  Future<void> createVisitor(String visitorName, String visitorNumber,String totalVisitors,String checkInTime,
      String checkOutTime, String checkInDate, String checkOutDate, String residentname, String residentid, String blockname, String roomname, String ReasonFor, bool Status) async {
    try {
      await FirebaseFirestore.instance.collection('Visitors').add(
          {
            'name': visitorName,
            'number': visitorNumber,
            'totalvisitors' : totalVisitors,
            'checkinTime': checkInTime,
            'checkoutTime': checkOutTime,
            'checkinDate': checkInDate,
            'checkoutDate': checkOutDate,
            'residentname': residentname,
            'residentid': residentid,
            'blockname': blockname,
            'roomname': roomname,
            'reason': ReasonFor,
            'status': Status,
            'time': DateTime.now().millisecondsSinceEpoch,
            // 'status': Status,
            // 'residentName': residentName,
          }
      );
      print('Visitor added successfully');
    } catch (e) {
      print('Error adding visitor: $e');
      // Handle error here
    }
  }
//  for update
  Future<void> UpdateVisitorPopUp(BuildContext con,id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (context,set) {
              return AlertDialog(
                elevation: 0,
                backgroundColor: const Color(0xffFFFFFF),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        KText(text:'Update Visitor or Guest', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
                        KText(text:'Enter Visitor Details', style: GoogleFonts.openSans(fontWeight: FontWeight.w500, fontSize: 15),),
                      ],
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 30, width: 30,
                        // here the Cross Icon
                        child:  Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 38,
                              width: 38,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                boxShadow:[
                                  BoxShadow(
                                      color: Color(0xfff5f6f7),
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                      offset: Offset(4,4)
                                  )
                                ],
                              ),
                            ),
                            ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(50)),
                              child: Container(
                                height: 20,
                                width: 20,
                                child: Image.asset('assets/ui-design-/images/Multiply.png', fit: BoxFit.contain,scale: 0.5,),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                content: SingleChildScrollView(
                  child: Container(
                    width: 750,
                    height: 580,
                    child: Column(
                      children: [
                        const SizedBox(height: 10,),
                        Divider(color: const Color(0xff262626).withOpacity(0.1), thickness: 1, height: 0.5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(text:'Visitor Name', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                                    child: CustomTextField(
                                      hint: 'Enter visitors Name',
                                      controller: visitorName,
                                      fillColor: Colors.white,
                                      validator: null,
                                      header: '',
                                      width: 200,
                                      height: 45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(text:'Visitor Phone Number', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                                    child: CustomTextField(
                                      hint: 'Visitor Phone Number',
                                      controller: visitorNumber,
                                      fillColor: Colors.white,
                                      validator: null,
                                      header: '',
                                      width: 200,
                                      height: 45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(text:'No of Visitors', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                                    child: CustomTextField(
                                      hint: 'No of Visitors',
                                      controller: totalVisitors,
                                      fillColor: Colors.white,
                                      validator: null,
                                      header: '',
                                      width: 200,
                                      height: 45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //checkIn time
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(text:'From Time', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                                    child: Container(
                                      width: 220,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(color: const Color(0x7f262626)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 0.0, right: 0),
                                        child: TextFormField(
                                          cursorColor: Constants().primaryAppColor,
                                          controller: checkInTime,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            prefixIcon: IconButton(
                                              onPressed: () {
                                                CheckInTime(context);
                                              },
                                              icon: const Icon(Icons.watch_later_outlined),
                                            ),
                                            border: InputBorder.none,
                                            hintText: "From Time", // Default hint
                                            hintStyle: GoogleFonts.openSans(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0x7f262626),
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
                                  ),
                                ],
                              ),
                            ),
                            //checkout time
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(text:'To Time', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                                    child: Container(
                                      width: 220,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(color: const Color(0x7f262626)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 0.0, right: 0),
                                        child: TextFormField(

                                          onTap: () {
                                          },
                                          cursorColor: Constants().primaryAppColor,
                                          controller: checkOutTime,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            prefixIcon: IconButton(
                                              onPressed: () {
                                                CheckOutTime(context);
                                              },
                                              icon: const Icon(Icons.watch_later_outlined, size: 20,),
                                            ),
                                            border: InputBorder.none,
                                            hintText: "Out Time", // Default hint
                                            hintStyle: GoogleFonts.openSans(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0x7f262626),
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
                                  ),
                                ],
                              ),
                            ),
                            //reason for
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(text:'Reason For', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                                    child: CustomTextField(
                                      hint: 'Reason',
                                      controller: reasonFor,
                                      fillColor: Colors.white,
                                      validator: null,
                                      header: '',
                                      width: 200,
                                      height: 45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //checkIn time
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(text:'Checkin Date', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                                    child: Container(
                                      width: 220,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(color: const Color(0x7f262626)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 0.0, right: 0),
                                        child: TextFormField(
                                          onTap: () {
                                          },
                                          cursorColor: Constants().primaryAppColor,
                                          controller: checkInDate,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            prefixIcon: IconButton(
                                              onPressed: () {
                                                CheckInDate(context);
                                              },
                                              icon: const Icon(Icons.calendar_month),
                                            ),
                                            border: InputBorder.none,
                                            hintText: "CheckIn Date",
                                            hintStyle: GoogleFonts.openSans(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0x7f262626),
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
                                  ),
                                ],
                              ),
                            ),
                            //checkout time
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(text:'Checkout Date', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                                    child: Container(
                                      width: 220,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(color: const Color(0x7f262626)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 0.0, right: 0),
                                        child: TextFormField(
                                          onTap: () {
                                          },
                                          cursorColor: Constants().primaryAppColor,
                                          controller: checkOutDate,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            prefixIcon: IconButton(
                                              onPressed: () {
                                                CheckOutDate(context);
                                              },
                                              icon: const Icon(Icons.calendar_month),
                                            ),
                                            border: InputBorder.none,
                                            hintText: "CheckOut Date", // Default hint
                                            hintStyle: GoogleFonts.openSans(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0x7f262626),
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
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(text: 'Resident Name', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                    child: Container(
                                      width: 220,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: const Color(0x7f262626)),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 12.0, right: 10),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButtonFormField<String>(
                                            isExpanded: true,
                                            hint: const KText(text:
                                            'Select Resident Name',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0x7f262626),
                                              ),
                                            ),
                                            items: ResidentNames.map((String item) {
                                              return DropdownMenuItem<String>(
                                                value: item,
                                                child: KText(text:
                                                item,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            value: selectedResidentName,
                                            onChanged: (String? value) async {
                                              set(() {
                                                selectedResidentName = value!;
                                              });
                                              var docu = await FirebaseFirestore.instance.collection('Users').where('firstName', isEqualTo: selectedResidentName).get();
                                              set(() {
                                                selectedResidentUserId = docu.docs[0]['userid'];
                                                selectedBlockName = docu.docs[0]['blockname'];
                                              });
                                              try {
                                                QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                                    .collection('Room')
                                                    .where('blockname', isEqualTo: selectedBlockName)
                                                    .get();
                                                // Iterate through the documents and extract data
                                                querySnapshot.docs.forEach((doc) {
                                                  String roomName = doc['roomnumber'];
                                                  if (roomName != "") {
                                                    set(() {
                                                      blockRoomNames.add(roomName);
                                                    });
                                                  }
                                                });
                                                print(blockRoomNames);
                                              } catch (e) {
                                                print("Error fetching room names: $e");
                                              }
                                              set(() {
                                                selectedRoomName = docu.docs[0]['roomnumber'];
                                              });
                                            },
                                            decoration: const InputDecoration(border: InputBorder.none),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 18,),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(text: 'Resident UserId', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                    child: Container(
                                      width: 220,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: const Color(0x7f262626)),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 12.0, right: 10),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButtonFormField<String>(
                                            isExpanded: true,
                                            hint: const KText(text:
                                            'Select Resident UserId',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0x7f262626),
                                              ),
                                            ),
                                            items: ResidentUserIds.map((String item) {
                                              return DropdownMenuItem<String>(
                                                value: item,
                                                child: KText(text:
                                                item,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            value: selectedResidentUserId,
                                            // onChanged: (String? value) async {
                                            //   set(() {
                                            //     selectedResidentUserId = value!;
                                            //   });
                                            // },
                                            onChanged: (String? value) async {
                                              set(() {
                                                selectedResidentUserId = value!;
                                              });
                                              var docu = await FirebaseFirestore.instance.collection('Users').where('userid', isEqualTo: selectedResidentUserId).get();
                                              set(() {
                                                selectedRoomName = docu.docs[0]['roomnumber'];
                                                selectedBlockName = docu.docs[0]['blockname'];
                                                selectedResidentName = docu.docs[0]['firstName'];
                                              });
                                              try {
                                                QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                                    .collection('Room')
                                                    .where('blockname', isEqualTo: selectedBlockName)
                                                    .get();
                                                // Iterate through the documents and extract data
                                                querySnapshot.docs.forEach((doc) {
                                                  String roomName = doc['roomnumber'];
                                                  if (roomName != "") {
                                                    set(() {
                                                      blockRoomNames.add(roomName);
                                                    });
                                                  }
                                                });
                                                print(blockRoomNames);
                                              } catch (e) {
                                                print("Error fetching room names: $e");
                                              }
                                              set(() {
                                                selectedRoomName = docu.docs[0]['roomnumber'];
                                              });
                                            },

                                            decoration: const InputDecoration(border: InputBorder.none),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //block here
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(text: 'Block Name', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                    child: Container(
                                      width: 220,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: const Color(0x7f262626)),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 12.0, right: 10),
                                        child: IgnorePointer(

                                          child: DropdownButtonHideUnderline(

                                            child: DropdownButtonFormField<String>(

                                              isExpanded: true,
                                              hint: const KText(text:
                                              'Select Block Name',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0x7f262626),
                                                ),
                                              ),
                                              items: BlockNames.map((String item) {
                                                return DropdownMenuItem<String>(
                                                  value: item,
                                                  child: KText(text:
                                                  item,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              value: selectedBlockName,
                                              onChanged: (String? value) async {
                                                // set(() {
                                                //   // selectedBlockName = value!;
                                                //   selectedRoomName = "Select Room Name";
                                                // });
                                                // set(() {
                                                //   blockRoomNames = ['Select Room Name'];
                                                // }
                                                // );
                                                // try {
                                                //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                                //       .collection('Room')
                                                //       .where('blockname', isEqualTo: selectedBlockName)
                                                //       .get();
                                                //   // Iterate through the documents and extract data
                                                //   querySnapshot.docs.forEach((doc) {
                                                //     String roomName = doc['roomnumber'];
                                                //     if (roomName != null) {
                                                //       set(() {
                                                //         blockRoomNames.add(roomName);
                                                //       });
                                                //     }
                                                //   });
                                                //   print(blockRoomNames);
                                                // } catch (e) {
                                                //   print("Error fetching room names: $e");
                                                // }
                                              },
                                              decoration: const InputDecoration(border: InputBorder.none),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 18,),
                            //room here
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                KText(text:'Room', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container(
                                    width: 220,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0x7f262626)),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 12.0, right: 6),
                                      child: IgnorePointer(
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButtonFormField<String>(
                                            isExpanded: true,
                                            hint: const KText(text:
                                            'Select Room Name',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0x7f262626),
                                              ),
                                            ),
                                            items: blockRoomNames.map((String item) {
                                              return DropdownMenuItem<String>(
                                                value: item,
                                                child: KText(
                                                  text:
                                                  item,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            value: selectedRoomName,
                                            onChanged: (String? value) {
                                              setState(() {
                                                selectedRoomName = value!;
                                              });
                                            },
                                            decoration: const InputDecoration(border: InputBorder.none),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 110,
                              height: 40,
                              child: ElevatedButton(
                                style: const ButtonStyle(
                                    elevation: MaterialStatePropertyAll(0),
                                    backgroundColor: MaterialStatePropertyAll(Color(0xfff5f6f7))),
                                onPressed: (){
                                  visitorName.clear();
                                  residentId.clear();
                                  visitorNumber.clear();
                                  totalVisitors.clear();
                                  reasonFor.clear();
                                  checkInTime.clear();
                                  checkInDate.clear();
                                  checkOutTime.clear();
                                  checkOutDate.clear();
                                  // Navigator.pop(context);
                                }, child:
                              KText(text:
                                'Clear All',
                                style: GoogleFonts.openSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff37D1D3),
                                ),
                              ),
                              ),
                            ),
                            SizedBox(
                              width: 110,
                              height: 40,
                              child: ElevatedButton(
                                style: const ButtonStyle(
                                    elevation: MaterialStatePropertyAll(0),
                                    backgroundColor: MaterialStatePropertyAll(Color(0xfff5f6f7))),
                                onPressed: (){
                                  Navigator.pop(context);
                                }, child:
                              KText(text:
                                'Cancel',
                                style: GoogleFonts.openSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff37D1D3),
                                ),
                              ),
                              ),
                            ),
                            const SizedBox(width: 10,),
                            SizedBox(
                              height: 40,
                              child: ElevatedButton(
                                style: const ButtonStyle(
                                    elevation: MaterialStatePropertyAll(3),
                                    backgroundColor: MaterialStatePropertyAll(Color(0xff37D1D3))
                                ),
                                // Adjusted onPressed callback
                                onPressed: () async {
                                  bool Status = true;
                                  final checkoutDate = checkOutDate.text;
                                  final checkoutTime = checkOutTime.text;
                                  if(checkoutDate.isNotEmpty && checkoutTime.isNotEmpty ){
                                    Status = true;
                                  }else{
                                    Status = false;
                                  }
                                  updateuser(id,Status);
                                  showTopSnackBar(
                                    Overlay.of(context),
                                    const CustomSnackBar.success(
                                      backgroundColor: Color(0xff3ac6cf),
                                      message:
                                      "Added successfully!",
                                    ),
                                  );


                                  QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance.collection('Users').where('userid', isEqualTo: selectedResidentUserId).get();

                                  if (userQuerySnapshot.docs.isNotEmpty) {
                                    String token = userQuerySnapshot.docs.first['fcmToken'];

                                    // Send the push notification
                                    sendPushMessage(token: token, body: '${visitorName.text} went outside the Hostel', title: 'Visitor');
                                  } else {
                                    print('User not found');
                                    // Handle the case where the user is not found
                                  }



                                  visitorName.clear();
                                  residentId.clear();
                                  visitorNumber.clear();
                                  totalVisitors.clear();
                                  reasonFor.clear();
                                  checkInTime.clear();
                                  checkInDate.clear();
                                  checkOutTime.clear();
                                  checkOutDate.clear();
                                  Navigator.pop(context);

                                },
                                child: Row(
                                  children: [
                                    KText(text:
                                      'Allow',
                                      style: GoogleFonts.openSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const CircleAvatar(
                                      radius: 8,
                                      backgroundColor: Colors.white,
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          color: Color(0xff37D1D3),
                                          size: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
        );
      },
    );
  }
  setuserdata(id) async {
    // creating a variable to store the Users data dynamically... using thier ID
    var docu = await FirebaseFirestore.instance.collection("Visitors").doc(id).get();
    Map<String,dynamic> ? val = docu.data();
    setState(() {
      visitorName.text=val!["name"];
      visitorNumber.text=val["number"];
      totalVisitors.text=val["totalvisitors"];
      checkInTime.text=val["checkinTime"];
      checkOutTime.text=val["checkoutTime"];
      reasonFor.text=val["reason"];
      checkInDate.text=val["checkinDate"];
      checkOutDate.text=val["checkoutDate"];
      residentName.text=val["residentname"];
      residentId.text=val["residentid"];
     selectedBlockName =val["blockname"];
      selectedRoomName =val["roomname"];
    });
  }
  // for update passing (id to get the EXACT person)
  updateuser(id, Status){
    FirebaseFirestore.instance.collection("Visitors").doc(id).update({
      "name":visitorName.text,
      "number" :visitorNumber.text,
      "totalvisitors" : totalVisitors.text,
      "checkinTime" : checkInTime.text,
      'checkoutTime': checkOutTime.text,
      "checkoutDate" :checkOutDate.text,
      "reason":reasonFor.text,
      "checkinDate" : checkInDate.text,
      "checkoutDate" : checkOutDate.text,
      "residentname":selectedResidentName,
      "residentid" : residentId.text,
      "blockname" : selectedBlockName,
      "roomname" : selectedRoomName,
      "status": Status,
      'time': DateTime.now().millisecondsSinceEpoch,
    });
    // Successdialog();
  }
//   view data
  Future<void> VisitorViewPopUp(BuildContext con, DocumentSnapshot visitorData) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (context,set) {
              return AlertDialog(
                elevation: 0,
                backgroundColor: const Color(0xffFFFFFF),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    KText(text:'Details Of Visitors', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 30, width: 30,
                        child:  Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 38,
                              width: 38,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                boxShadow:[
                                  BoxShadow(
                                      color: Color(0xfff5f6f7),
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                      offset: Offset(4,4)
                                  )
                                ],
                              ),
                            ),
                            ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(50)),
                              child: Container(
                                height: 20,
                                width: 20,
                                child: Image.asset('assets/ui-design-/images/Multiply.png', fit: BoxFit.contain,scale: 0.5,),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                content: SingleChildScrollView(
                  child: Container(
                    width: 380,
                    height: 330,
                // color: Colors.redAccent,
                child: Column(
                  children: [
                    const Divider(color: Colors.grey, height: 40,),
                    Row(
                      children: [
                        Container(
                            width: 150,
                            child: KText(text:'Visitor Name', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)),
                        Container(
                            width: 70,
                            child: Center(child: KText(text:':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
                        Container(

                            width: 150,
                            child: KText(text:'${visitorData['name']}',style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)),
                      ],
                    ),
                    const SizedBox(height: 4,),
                    Row(
                      children: [
                        Container(
                            width: 150,
                            child: KText(text:'Receiver User ID', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)),
                        Container(
                            width: 70,
                            child: Center(child: KText(text:':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
                        Container(

                            width: 150,
                            child: KText(text:'${visitorData['residentid']}',style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)),
                      ],
                    ),
                    const SizedBox(height: 4,),
                    ///name
                    Row(
                      children: [
                        Container(
                            width: 150,
                            child: KText(text:'Receiver Name', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)),
                        Container(
                            width: 70,
                            child: Center(child: KText(text:':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
                        Container(
                            width: 150,
                            child: KText(text:'${visitorData['residentname']}',style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)),
                      ],
                    ),
                    const SizedBox(height: 4,),
                    Row(
                      children: [
                        Container(
                            width: 150,
                            child: KText(text:'Check in Date', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)),
                        Container(
                            width: 70,
                            child: Center(child: KText(text:':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
                        Container(
                            width: 150,
                            child: KText(text:'${visitorData['checkinDate']}',style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)),
                      ],
                    ),
                    const SizedBox(height: 4,),
                    Row(
                      children: [
                        Container(
                            width: 150,
                            child: KText(text:'Check out Date', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)),
                        Container(
                            width: 70,
                            child: Center(child: KText(text:':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
                        Container(
                            width: 150,
                            child: KText(text:'${visitorData['checkoutDate']}',style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)),
                      ],
                    ),
                    const SizedBox(height: 4,),
                    Row(
                      children: [
                        Container(
                            width: 150,
                            child: KText(text:'Phone No', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)),
                        Container(
                            width: 70,
                            child: Center(child: KText(text:':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
                        Container(

                            width: 150,
                            child: KText(text:'${visitorData['number']}',style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)),
                      ],
                    ),
                    const SizedBox(height: 4,),
                    Row(
                      children: [
                        Container(
                            width: 150,
                            child: KText(text:'Purpose', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)),
                        Container(
                            width: 70,
                            child: Center(child: KText(text:':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
                        Container(

                            width: 150,
                            child: KText(text:'${visitorData['reason']}',style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)),
                      ],
                    ),
                    const SizedBox(height: 4,),

                    Row(
                      children: [
                        Container(
                            width: 150,
                            child: KText(text:'Check In Time', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)),
                        Container(
                            width: 70,
                            child: Center(child: KText(text:':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
                        Container(

                            width: 150,
                            child: KText(text:'${visitorData['checkinTime']}',style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)),
                      ],
                    ),
                    const SizedBox(height: 4,),
                    Row(
                      children: [
                        Container(
                            width: 150,
                            child: KText(text:'Check Out Time', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)),
                        Container(
                            width: 70,
                            child: Center(child: KText(text:':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
                        Container(
                            width: 150,
                            child: KText(text:'${visitorData['checkoutTime']}',style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)),
                      ],
                    ),
                    const SizedBox(height: 4,),
                    Row(
                      children: [
                        Container(
                            width: 150,
                            child: KText(text:'Status', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)),
                        Container(
                            width: 70,
                            child: Center(child: KText(text:':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
                        Container(
                            width: 150,
                            child: KText(text:'${visitorData['status']}',style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)),
                      ],
                    ),
                    const SizedBox(height: 4,),
                  ],
                ),
                  ),
                ),
              );
            }
        );
      },
    );
  }
  showPopup(cxt) async {
    double height=MediaQuery.of(cxt).size.height;
    double width=MediaQuery.of(cxt).size.width;
    await showMenu(
        context: context,
        color: const Color(0xffFFFFFF),
        surfaceTintColor: const Color(0xffFFFFFF),
        shadowColor: Colors.black12,
        position:  const RelativeRect.fromLTRB(60, 400, 15, 55),
        items: [
          PopupMenuItem<String>(
            value: 'print',
            child:KText(text:'Print',style: GoogleFonts.openSans(),),
            onTap: () {
              _generatePdf();
            },
          ),
          PopupMenuItem<String>(
            value: 'excel',
            child:KText(text:'Excel',style: GoogleFonts.openSans(),),
            onTap: () {
              _generateCSVAndView(context);
            },
          ),
        ],
        elevation: 8.0,
        useRootNavigator: true);
  }
  Future<void> _generateCSVAndView(BuildContext context) async {
    final List<List<dynamic>> data = [[
      'Visitor Name',
      'Number of Visitors',
      'Date',
      'Phone Number',
      'Purpose',
      'Receiver UserID',
      'Check In Time',
      'Check Out Time',
      'Status',
    ]
    ];

    // Fetch data from Firebase Firestore
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('Visitors').get();

    // Populate data from Firestore
    querySnapshot.docs.forEach((doc) {
      data.add([
        doc['name'],
        doc['totalvisitors'],
        doc['checkinDate'],
        doc['number'],
        doc['reason'],
        doc['residentid'],
        doc['checkinTime'],
        doc['checkoutTime'],
        doc['status'],
      ]);
    });
    // Convert data to CSV format
    String csvData = ListToCsvConverter().convert(data);
    // Convert to Blob (for web)
    final blob = html.Blob([csvData], 'text/csv');
    // Create object URL
    final url = html.Url.createObjectUrlFromBlob(blob);
    // Create anchor element
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "users.csv")
      ..click();
    // Revoke object URL
    html.Url.revokeObjectUrl(url);
  }
  _generatePdf() async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.nunitoExtraLight();

    // Fetch user data from Firebase
    List<Map<String, dynamic>> userData = await fetchUserDataFromFirebase();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            children: [
              pw.Row(
                children: [
                  pw.Container(
                    decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black)),
                    width: 80,
                    height: 20,
                    child: pw.Text('S.No'),
                  ),
                  pw.Container(
                    decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black)),
                    width: 80,
                    height: 20,
                    child: pw.Text('Name'),
                  ),
                  pw.Container(
                    decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black)),
                    width: 80,
                    height: 20,
                    child: pw.Text('Number'),
                  ),
                  pw.Container(
                    decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black)),
                    width: 110,
                    height: 20,
                    child: pw.Text('Reason'),
                  ),
                  pw.Container(
                    decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black)),
                    width: 80,
                    height: 20,
                    child: pw.Text('Check In'),
                  ),

                  pw.Container(
                    decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black)),
                    width: 80,
                    height: 20,
                    child: pw.Text('Check Out '),
                  ),
                ],
              ),
              for (var i = 0; i < userData.length; i++)
                pw.Row(
                  children: [
                    pw.Container(
                      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black)),
                      width: 80,
                      height: 20,
                      child: pw.Text((i + 1).toString()),
                    ),
                    pw.Container(
                      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black)),
                      width: 80,
                      height: 20,
                      child: pw.Text( userData[i]['name'] ?? ''),
                    ),
                    pw.Container(
                      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black)),
                      width: 80,
                      height: 20,
                      child: pw.Text( userData[i]['number'] ?? ''),
                    ),
                    pw.Container(
                      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black)),
                      width: 110,
                      height: 20,
                      child: pw.Text( userData[i]['reason'] ?? ''),
                    ),
                    pw.Container(
                      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black)),
                      width: 80,
                      height: 20,
                      child: pw.Text( userData[i]['checkinDate'] ?? ''),
                    ),
                    pw.Container(
                      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black)),
                      width: 80,
                      height: 20,
                      child: pw.Text( userData[i]['checkoutDate'] ?? ''),
                    ),

                  ],
                ),
            ],
          );
        },
      ),
    );

    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
    return pdf.save();
  }
  Future<List<Map<String, dynamic>>> fetchUserDataFromFirebase() async {
    List<Map<String, dynamic>> userData = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(
        'Visitors').get();
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> userDataMap = doc.data() as Map<String, dynamic>;
      userData.add(userDataMap);
    });
    return userData;
  }

  ///Date Picker
  Future<void> VisitorsDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDate: selectedVisitorDate ?? DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedVisitorDate = picked;
        visitorDate.text = DateFormat('dd-MM-yyyy').format(picked);
      });
      fetchVisitorsData(DateFormat('dd-MM-yyyy').format(picked));
    } else {
      setState(() {
        selectedVisitorDate = DateTime.now();
        visitorDate.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
      });
      fetchVisitorsData(DateFormat('dd-MM-yyyy').format(DateTime.now()));
    }
  }

  ///fetch visitor data
  Future fetchVisitorsData(String selectedDate) async {
    DocumentSnapshot attendanceDoc = await FirebaseFirestore.instance
        .collection('Visitors')
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

  ///Notification
  void sendPushMessage({required String token, required String body, required String title}) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
          'key=${Constants.apiKeyForNotification}',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': body, 'title': title},
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }







}

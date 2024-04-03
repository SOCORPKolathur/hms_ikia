import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_ikia/widgets/kText.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

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
  final TextEditingController searchVisitors = TextEditingController();
  //main fields
  final TextEditingController visitorName = TextEditingController();
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
  // List<String> BlockNames = [];
  List<String> RoomNames= [];
  // blockname list here
  Future<List<String>> getBlockNames() async {
    try {
      List<String> blockNames = ['Select Block Name'];
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Block').get();
      querySnapshot.docs.forEach((doc) {
        String blockName = doc['blockname'];
        if (blockName != null) {
          blockNames.add(blockName);
        }
      });
      print(blockNames);
      return blockNames;
    } catch (e) {
      print("Error fetching block names: $e");
      return [];
    }
  }
  void getRoomNames(String selectedBlockName) async {
    setState(() {
      blockRoomNames = ['Select Room Name']; // Reset room names
    });
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Room')
          .where('blockname', isEqualTo: selectedBlockName)
          .get();
      // Iterate through the documents and extract data
      querySnapshot.docs.forEach((doc) {
        String roomName = doc['roomnumber'];
        if (roomName != null) {
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
        checkInDate.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
  Future<void>CheckOutDate(BuildContext context) async{
    final DateTime ? picked = await showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime(2030));
    if(picked != null){
      setState(() {
        selectedCheckoutDate = picked;
        print('normal date $selectedCheckoutDate');
        checkOutDate.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  void initState() {
    setState(() {
      // getBlockNames();
      getRoomNames(selectedBlockName);
      getTodaysVisitors();
      getBlockNames().then((names) {
        setState(() {
          BlockNames.addAll(names);
        });
      }
      );
    });
    // TODO: implement initState
    super.initState();
  }
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
              const ReusableHeader(Headertext: 'Fees Register ', SubHeadingtext: '"Manage Easily Residents Records"'),
              const SizedBox(height: 20,),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ReusableRoomContainer(
                    firstColor: Color(0xff034d7f),
                    secondColor: Color(0xff058be5),
                    // totalRooms: getTodaysVisitors.toString(),
                    title: 'Today Total Visitors',
                    totalRooms: '05',
                    waveImg: 'assets/ui-design-/images/Vector 38 (1).png', roomImg: 'assets/ui-design-/images/Group 70.png',
                  ),
                  ReusableRoomContainer(
                    firstColor: Color(0xff0e4d1f),
                    secondColor: Color(0xff1b9a3f),
                    totalRooms: '20',
                    title: 'Today Visitors  Check In',
                    waveImg: 'assets/ui-design-/images/Vector 37 (3).png', roomImg: 'assets/ui-design-/images/Group 71.png',
                  ),
                  ReusableRoomContainer(
                    firstColor: Color(0xff971c1c),
                    secondColor: Color(0xffe22a2a),
                    totalRooms: '20',
                    title: 'Today Visitors Check Out',
                    waveImg: 'assets/ui-design-/images/Vector 36 (3).png', roomImg: 'assets/ui-design-/images/Group 72.png',
                  ),
                ],
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
                            height: 44,
                            // width: 100,
                            child: ElevatedButton(
                                style:  const ButtonStyle(
                                    elevation: MaterialStatePropertyAll(2),
                                    backgroundColor: MaterialStatePropertyAll(Color(0xff37D1D3))),
                                onPressed: (){
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
                                Text('Export Data', style: GoogleFonts.openSans(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white),),
                                SizedBox(width: 4,),
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
               border: Border.all(color: Color(0xff262626).withOpacity(0.1))
             ),
             constraints: BoxConstraints(
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
                       child: Center(child: Text('S.No', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),
                       )
                       )),
                     Container(
                         height: 50,
                         width: 150,
                         child: Center(child: Text('Visitor Name', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),))),
                     Container(
                         height: 50,
                         width: 100,
                         child: Center(child: Text('Phone No', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),))),
                     Container(
                         height: 50,
                         width: 100,
                         child: Center(child: Text('Purpose', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),))),
                     Container(
                         height: 50,
                         width: 200,
                         child: Center(child: Text('Check In/Check Out', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),))),
                     Container(
                         height: 50,
                         width: 130,
                         child: Center(child: Text('Status', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),))),
                     Container(
                         height: 50,
                         width: 100,
                         child: Center(child: Text('Actions', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),))),
                 ],),
                 Container(color: const Color(0xff262626).withOpacity(0.1), width: double.infinity, height: 2,),
              StreamBuilder(stream: FirebaseFirestore.instance.collection('Visitors').snapshots(), builder: (context, snapshot) {
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

                  return
                      ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          if(snapshot.hasData){
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
                                          child: Center(child: Text(document['name'], style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),
                                      Container(

                                          height: 50,
                                          width: 100,
                                          child: Center(child: Text(document['number'],style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),

                                      Container(
                                          height: 50,
                                          width: 100,
                                          child: Center(child: Text(document['reason'], style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),

                                      Container(
                                          height: 50,
                                          width: 200,
                                          child: Center(child: Text( '${document['checkinTime']} - ${document['checkoutTime']}', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),
                                      document['checkoutTime'] == '' ?
                                      Container(
                                          height: 50,
                                          width: 130,
                                          child: Center(child: ElevatedButton(
                                            style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xffDDFFE7))),
                                            onPressed: () {}, child: Text('Check In', style: GoogleFonts.openSans(color: const Color(0xff1DA644), fontSize: 15),),)
                                          )
                                      ) :
                                      Container(
                                          height: 50,
                                          width: 130,
                                          child: Center(child: ElevatedButton(
                                            style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xffFFD3D3))),
                                            onPressed: () {}, child: Text('Check out', style: GoogleFonts.openSans(color: const Color(0xffF12D2D), fontSize: 15),),)
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

                          }


                      }, itemCount: snapshot.data!.docs.length );
                  }else{
                  return CircularProgressIndicator();
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
                      Text('Add Visitor or Guest', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
                      Text('Enter Visitor Details', style: GoogleFonts.openSans(fontWeight: FontWeight.w500, fontSize: 15),),
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
                                Text('Visitor Name', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
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
                                Text('Visitor Phone Number', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
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
                                Text('No of Visitors', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
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
                                Text('From Time', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                Padding(
                                  padding: EdgeInsets.only(top: 10, bottom: 20),
                                  child: Container(
                                    width: 220,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(color: Color(0x7f262626)),
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
                                            icon: Icon(Icons.watch_later_outlined),
                                          ),
                                          border: InputBorder.none,
                                          hintText: "From Time", // Default hint
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
                                Text('To Time', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                Padding(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Container(
                                    width: 220,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(color: Color(0x7f262626)),
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
                                            icon: Icon(Icons.watch_later_outlined, size: 20,),
                                          ),
                                          border: InputBorder.none,
                                          hintText: "Out Time", // Default hint
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
                                Text('Reason For', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
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
                                Text('Checkin Date', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                Padding(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Container(
                                    width: 220,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(color: Color(0x7f262626)),
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
                                            icon: Icon(Icons.calendar_month),
                                          ),
                                          border: InputBorder.none,
                                          hintText: "CheckIn Date",
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
                                Text('Checkout Date', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                Padding(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Container(
                                    width: 220,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(color: Color(0x7f262626)),
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
                                            icon: Icon(Icons.calendar_month),
                                          ),
                                          border: InputBorder.none,
                                          hintText: "CheckOut Date", // Default hint
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
                                Text('Resident Name', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                                  child: CustomTextField(
                                    hint: 'Resident Name',
                                    controller: residentName,
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
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Resident User ID', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                                  child: CustomTextField(
                                    hint: 'Enter Id here',
                                    controller: residentId,
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
                          //block here
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Visitor Name', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
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
                                          hint: const Text(
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
                                              child: Text(
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
                                            set(() {
                                              selectedBlockName = value!;
                                              selectedRoomName = "Select Room Name";
                                            });
                                            set(() {
                                              blockRoomNames = ['Select Room Name']; // Reset room names
                                            });
                                            try {
                                              QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                                  .collection('Room')
                                                  .where('blockname', isEqualTo: selectedBlockName)
                                                  .get();
                                              // Iterate through the documents and extract data
                                              querySnapshot.docs.forEach((doc) {
                                                String roomName = doc['roomnumber'];
                                                if (roomName != null) {
                                                  set(() {
                                                    blockRoomNames.add(roomName);
                                                  });
                                                }
                                              });
                                              print(blockRoomNames);
                                            } catch (e) {
                                              print("Error fetching room names: $e");
                                            }
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
                          //room here
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Room', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
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
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButtonFormField<String>(
                                        isExpanded: true,
                                        hint: const Text(
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
                                            child: Text(
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
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
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
                                Text(
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
                                Text(
                                  'Cancel',
                                  style: GoogleFonts.openSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff37D1D3),
                                  ),
                                ),
                                ),
                              ),
                              SizedBox(width: 6,),
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
                                        residentId.text.isNotEmpty &&
                                        visitorNumber.text.isNotEmpty &&
                                        totalVisitors.text.isNotEmpty &&
                                        reasonFor.text.isNotEmpty &&
                                        checkInTime.text.isNotEmpty &&
                                        checkInDate.text.isNotEmpty
                                    // checkOutDate.text.isNotEmpty
                                    ) {
                                      final visitorname = visitorName.text;
                                      final residentid = residentId.text;
                                      final visitornumber = visitorNumber.text;
                                      final checkinTime = checkInTime.text;
                                      final checkoutTime = checkOutTime.text;
                                      final checkinDate = checkOutDate.text;
                                      final checkoutDate = checkOutDate.text;
                                      final residentname = residentName.text;
                                      final totalvisitors = totalVisitors.text;
                                      final blockname = selectedBlockName;
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
                                          checkoutTime,  checkinDate,  checkoutDate,  residentname,  residentid, blockname, roomname, ReasonFor, Status!)
                                          .then((_) {
                                        showTopSnackBar(
                                          Overlay.of(context),
                                          CustomSnackBar.success(
                                            backgroundColor: Color(0xff3ac6cf),
                                            message:
                                            "Added successfully!",
                                          ),
                                        );
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
                                          content: Text('Error adding visitor: $error'),
                                        ));
                                      });
                                    } else {
                                      // Navigator.pop(context);
                                      print('All fields needed');
                                      // Provide feedback to the user
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text('All fields are required'),
                                      ));
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Text(
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
                        Text('Update Visitor or Guest', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
                        Text('Enter Visitor Details', style: GoogleFonts.openSans(fontWeight: FontWeight.w500, fontSize: 15),),
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
                                  Text('Visitor Name', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
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
                                  Text('Visitor Phone Number', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
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
                                  Text('No of Visitors', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
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
                                  Text('From Time', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10, bottom: 20),
                                    child: Container(
                                      width: 220,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(color: Color(0x7f262626)),
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
                                              icon: Icon(Icons.watch_later_outlined),
                                            ),
                                            border: InputBorder.none,
                                            hintText: "From Time", // Default hint
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
                                  Text('To Time', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10, bottom: 10),
                                    child: Container(
                                      width: 220,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(color: Color(0x7f262626)),
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
                                              icon: Icon(Icons.watch_later_outlined, size: 20,),
                                            ),
                                            border: InputBorder.none,
                                            hintText: "Out Time", // Default hint
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
                                  Text('Reason For', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
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
                                  Text('Checkin Date', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10, bottom: 10),
                                    child: Container(
                                      width: 220,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(color: Color(0x7f262626)),
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
                                              icon: Icon(Icons.calendar_month),
                                            ),
                                            border: InputBorder.none,
                                            hintText: "CheckIn Date",
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
                                  Text('Checkout Date', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10, bottom: 10),
                                    child: Container(
                                      width: 220,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(color: Color(0x7f262626)),
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
                                              icon: Icon(Icons.calendar_month),
                                            ),
                                            border: InputBorder.none,
                                            hintText: "CheckOut Date", // Default hint
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
                                  Text('Resident Name', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                                    child: CustomTextField(
                                      hint: 'Resident Name',
                                      controller: residentName,
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
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Resident User ID', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                                    child: CustomTextField(
                                      hint: 'Enter Id here',
                                      controller: residentId,
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
                            //block here
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Visitor Name', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
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
                                            hint: const Text(
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
                                                child: Text(
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
                                              set(() {
                                                selectedBlockName = value!;
                                                selectedRoomName = "Select Room Name";
                                              });
                                              set(() {
                                                blockRoomNames = ['Select Room Name']; // Reset room names
                                              });
                                              try {
                                                QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                                    .collection('Room')
                                                    .where('blockname', isEqualTo: selectedBlockName)
                                                    .get();
                                                // Iterate through the documents and extract data
                                                querySnapshot.docs.forEach((doc) {
                                                  String roomName = doc['roomnumber'];
                                                  if (roomName != null) {
                                                    set(() {
                                                      blockRoomNames.add(roomName);
                                                    });
                                                  }
                                                });
                                                print(blockRoomNames);
                                              } catch (e) {
                                                print("Error fetching room names: $e");
                                              }
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
                            //room here
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Room', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
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
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButtonFormField<String>(
                                          isExpanded: true,
                                          hint: const Text(
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
                                              child: Text(
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
                              Text(
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
                              Text(
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
                                onPressed: () {
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
                                    CustomSnackBar.success(
                                      backgroundColor: Color(0xff3ac6cf),
                                      message:
                                      "Added successfully!",
                                    ),
                                  );
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
                                    Text(
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
    FirebaseFirestore.instance.collection("Visitors").doc(id).set({
      "name":visitorName.text,
      "number" :visitorNumber.text,
      "totalvisitors" : totalVisitors.text,
      "checkinTime" : checkInTime.text,
      'checkoutTime': checkOutTime.text,
      "checkoutDate" :checkOutDate.text,
      "reason":reasonFor.text,
      "checkinDate" : checkInDate.text,
      "checkoutDate" : checkOutDate.text,
      "residentname":residentName.text,
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
                    Text('Details Of Visitors', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
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
                    Divider(color: Colors.grey, height: 40,),
                    Row(
                      children: [
                        Container(
                            width: 150,
                            child: Text('Visitor Name', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)),
                        Container(
                            width: 70,
                            child: Center(child: Text(':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
                        Container(

                            width: 150,
                            child: Text('${visitorData['name']}',style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: Color(0xff262626).withOpacity(0.8)),)),
                      ],
                    ),
                    SizedBox(height: 4,),
                    Row(
                      children: [
                        Container(
                            width: 150,
                            child: Text('Visitor ID', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)),
                        Container(
                            width: 70,
                            child: Center(child: Text(':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
                        Container(
                            width: 150,
                            child: Text('${visitorData['residentid']}',style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: Color(0xff262626).withOpacity(0.8)),)),
                      ],
                    ),
                    SizedBox(height: 4,),
                    Row(
                      children: [
                        Container(
                            width: 150,
                            child: Text('Date', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)),
                        Container(
                            width: 70,
                            child: Center(child: Text(':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
                        Container(
                            width: 150,
                            child: Text('${visitorData['checkinDate']}',style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: Color(0xff262626).withOpacity(0.8)),)),
                      ],
                    ),
                    SizedBox(height: 4,),
                    Row(
                      children: [
                        Container(
                            width: 150,
                            child: Text('Phone No', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)),
                        Container(
                            width: 70,
                            child: Center(child: Text(':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
                        Container(

                            width: 150,
                            child: Text('${visitorData['number']}',style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: Color(0xff262626).withOpacity(0.8)),)),
                      ],
                    ),
                    SizedBox(height: 4,),
                    Row(
                      children: [
                        Container(
                            width: 150,
                            child: Text('Purpose', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)),
                        Container(
                            width: 70,
                            child: Center(child: Text(':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
                        Container(

                            width: 150,
                            child: Text('${visitorData['reason']}',style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: Color(0xff262626).withOpacity(0.8)),)),
                      ],
                    ),
                    SizedBox(height: 4,),
                    Row(
                      children: [
                        Container(
                            width: 150,
                            child: Text('Receiver User ID', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)),
                        Container(
                            width: 70,
                            child: Center(child: Text(':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
                        Container(

                            width: 150,
                            child: Text('${visitorData['residentid']}',style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: Color(0xff262626).withOpacity(0.8)),)),
                      ],
                    ),
                    SizedBox(height: 4,),
                    Row(
                      children: [
                        Container(
                            width: 150,
                            child: Text('Check In Time', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)),
                        Container(
                            width: 70,
                            child: Center(child: Text(':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
                        Container(

                            width: 150,
                            child: Text('${visitorData['checkinTime']}',style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: Color(0xff262626).withOpacity(0.8)),)),
                      ],
                    ),
                    SizedBox(height: 4,),
                    Row(
                      children: [
                        Container(
                            width: 150,
                            child: Text('Check Out Time', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)),
                        Container(
                            width: 70,
                            child: Center(child: Text(':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
                        Container(
                            width: 150,
                            child: Text('${visitorData['checkoutTime']}',style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: Color(0xff262626).withOpacity(0.8)),)),
                      ],
                    ),
                    SizedBox(height: 4,),
                    Row(
                      children: [
                        Container(
                            width: 150,
                            child: Text('Status', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)),
                        Container(
                            width: 70,
                            child: Center(child: Text(':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
                        Container(
                            width: 150,
                            child: Text('${visitorData['status']}',style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: Color(0xff262626).withOpacity(0.8)),)),
                      ],
                    ),
                    SizedBox(height: 4,),
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
            child:  const Text('Print'),
            onTap: () {
            },
          ),
          PopupMenuItem<String>(
            value: 'excel',
            child:  const Text('Excel'),
            onTap: () {
            },
          ),
        ],
        elevation: 8.0,
        useRootNavigator: true);
  }


}

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
  final Color _svgColor = Colors.blue;
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
                      child: CustomTextField(hint: 'search Visitors Name, No....',  controller: searchVisitors, validator: null, fillColor: const Color(0xffF5F5F5),header: '', width: 335, preffixIcon: Icons.search,height: 45, ),
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
                                 const Text('Add Visitors', style: TextStyle(color: Colors.white),), SizedBox.fromSize(size: const Size(8,0),),  CircleAvatar(radius: 12,backgroundColor: Colors.transparent,
                                  child: Image.asset('assets/ui-design-/images/Waiting Room.png')
                                )
                              ],)
                            ),
                          ),
                          SizedBox.fromSize(size: const Size(23,0),),
                          Container(
                            height: 44,
                            // width: 100,
                            child: ElevatedButton(
                                style: const ButtonStyle(
                                    elevation: MaterialStatePropertyAll(2),
                                    backgroundColor: MaterialStatePropertyAll(Color(0xffFD7E50))),
                                onPressed: (){}, child:
                            Row(
                              children: [
                                 const Text('Export Data', style: TextStyle(color: Colors.white),), SizedBox.fromSize(size: const Size(8,0),),  CircleAvatar(radius: 12,backgroundColor: Colors.transparent,
                                  child: Center(child: SvgPicture.asset('assets/ui-design-/images/Database Export.svg', color: _svgColor, semanticsLabel: 'SVG Image',width: 100)
                                  ),
                                )
                              ],)
                            ),
                          ),
                        ],),
                    )
                  ],),),
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Container(
             decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20)
             ),
               border: Border.all(color: Colors.blue)
             ),
             height: 500,
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
                  return
                      ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          int serialNumber = index + 1;
                        final data = snapshot.data!.docs[index];
                        return   Column(
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
                                      child: Center(child: Text(data['name'], style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),
                                  Container(

                                      height: 50,
                                      width: 100,
                                      child: Center(child: Text(data['number'],style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),

                                  Container(
                                      height: 50,
                                      width: 100,
                                      child: Center(child: Text(data['reason'], style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),

                                  Container(
                                      height: 50,
                                      width: 200,
                                      child: Center(child: Text( '${data['checkinTime']} - ${data['checkoutTime']}', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),
                                  data['checkoutTime'] == '' ?
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
                                              CircleAvatar(
                                                radius: 14,
                                                backgroundColor: const Color(0xffF5F5F5),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(3),
                                                  child: Image.asset('assets/ui-design-/images/edit.png'),
                                                ),
                                              ),
                                              const SizedBox(width: 8,),
                                              CircleAvatar(
                                                radius: 14,
                                                backgroundColor: const Color(0xffF5F5F5),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(3),
                                                  child: Image.asset('assets/ui-design-/images/eye-8QM.png'),
                                                ),
                                              ),
                                            ],)
                                      )),
                                ],),
                            ),
                            Container(color: const Color(0xff262626).withOpacity(0.1), width: double.infinity, height: 2,),

                          ],
                        );

                      }, itemCount: snapshot.data!.docs.length, );
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

                                if (
                                visitorName.text.isNotEmpty &&
                                    residentId.text.isNotEmpty &&
                                    visitorNumber.text.isNotEmpty &&
                                    totalVisitors.text.isNotEmpty &&
                                    reasonFor.text.isNotEmpty &&
                                    checkInTime.text.isNotEmpty &&
                                    checkOutTime.text.isNotEmpty &&
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

                                  // final checkinDate = checkInDate.text;
                                  // final checkoutDate = checkOutDate.text;
                
                                  bool status = false;
                                  createVisitor(
                                      visitorname,  visitornumber, totalvisitors, checkinTime,
                                      checkoutTime,  checkinDate,  checkoutDate,  residentname,  residentid, blockname, roomname, ReasonFor
                                    // status,
                                  ).then((_) {
                                    // Provide feedback to the user
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text('Visitor added successfully'),
                                    ));
                                  }).catchError((error) {
                                    // Provide feedback to the user
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text('Error adding visitor: $error'),
                                    ));
                                  });
                                } else {
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
      String checkOutTime, String checkInDate, String checkOutDate, String residentname, String residentid, String blockname, String roomname, String ReasonFor) async {
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
            'time': DateTime.now().millisecondsSinceEpoch,
            // 'status': status,
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
  setuserdata(id) async {
    // creating a variable to store the Users data dynamically... using thier ID
    var docu = await FirebaseFirestore.instance.collection("Users").doc(id).get();
    Map<String,dynamic> ? val = docu.data();
    setState(() {
      visitorName.text=val!["firstName"];
      visitorNumber.text=val["middleName"];
      totalVisitors.text=val["lastName"];
      checkInTime.text=val["dob"];
      checkOutTime.text=val["dob"];
      reasonFor.text=val["bloodgroup"];
      checkInDate.text=val["phone"];
      checkOutDate.text=val["mobile"];
      residentName.text=val["aadhaar"];
      residentId.text=val["email"];
      // =val["parentprefix"];
      // country.text=val["country"];
      // state.text=val["state"];
      // city.text=val["city"];
      // pincode.text=val["pincode"];
      // parentname.text=val["parentname"];
      // parentmobile.text=val["parentmobile"];
      // parentOccupation.text=val["parentOccupation"];
      // userid.text=val["userid"];
      // roomnumber.text=val["roomnumber"];
      // blockname.text=val["blockname"];
      // imgUrl=val["imageUrl"];
      // selectedprefix=val["prefix"];
      // selectedprefix2=val["parentprefix"];
      // selectedgender=val["gender"];
    });
  }
  // for update passing (id to get the EXACT person)
  // updateuser(id){
  //   FirebaseFirestore.instance.collection("Users").doc(id).set({
  //     "prefix":selectedprefix,
  //     "firstName" :firstName.text,
  //     "middleName" : middleName.text,
  //     "lastName" : lastName.text,
  //     "dob" :dob.text,
  //     "gender":selectedgender,
  //     "bloodgroup" : bloodgroup.text,
  //     "phone" : phone.text,
  //     "mobile" : mobile.text,
  //     "aadhaar" : aadhaar.text,
  //     "email" : email.text,
  //     "address" : address.text,
  //     "country" : country.text,
  //     "state" : state.text,
  //     "city" : city.text,
  //     "pincode" : pincode.text,
  //     "parentprefix":selectedprefix2,
  //     "parentname" : parentname.text,
  //     "parentmobile" : parentmobile.text,
  //     "parentOccupation" : parentOccupation.text,
  //     "userid" : userid.text,
  //     "roomnumber" : roomnumber.text,
  //     "blockname" : blockname.text,
  //     "imageUrl":imgUrl,
  //     "status" : false,
  //     "uid" : '',
  //     "timestamp":DateTime.now().millisecondsSinceEpoch
  //   });
  //   Successdialog();
  // }


}


import 'dart:html';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_ikia/widgets/ReusableHeader.dart';
import 'package:hms_ikia/widgets/ReusableRoomContainer.dart';
import 'package:hms_ikia/widgets/customtextfield.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../widgets/kText.dart';

class Rooms extends StatefulWidget {
  const Rooms({Key? key}) : super(key: key);
  @override
  State<Rooms> createState() => _RoomsState();
}
class _RoomsState extends State<Rooms> {
  final TextEditingController searchRoomName = TextEditingController();
  final TextEditingController SelectedRoom = TextEditingController();
  final TextEditingController SelectedBedCount = TextEditingController();
  int roomCount = 0;
  int roomVacancy = 0;
  int roomOccupied = 0;

  List<String> BlockNames = [];
  String selectedBlockName = "Select Block Name";
  @override
  void initState() {
    super.initState();

    getRoomsLength();
    fetchBedCounts();
    getBlockNames().then((names) {
      setState(() {
        BlockNames.addAll(names);
      });
    }
    );
  }
  Future<void> getRoomsLength() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Room').get();
      int length = querySnapshot.docs.length;
      setState(() {
        roomCount = length;
      });
    } catch (e) {
      print("Error getting rooms length: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ReusableHeader(
                Headertext: 'Room and Bed Allocation',
                SubHeadingtext: '"Manage Easily Residents Records"',
              ),
              SizedBox.fromSize(size: const Size(0, 10)),
              const SizedBox(height: 20),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ReusableRoomContainer(
                    firstColor: const Color(0xff04267d),
                    secondColor: const Color(0xff6085e5),
                    totalRooms: roomCount.toString().padLeft(2, '0'),
                    title: 'Rooms',
                    waveImg: 'assets/ui-design-/images/wave.png', roomImg: 'assets/ui-design-/images/Group 90.png',
                  ),
                  ReusableRoomContainer(
                    firstColor: const Color(0xffd39617),
                    secondColor: const Color(0xffffd57c),
                    totalRooms: '${roomVacancy.toString().padLeft(2,"0")}',
                    title: 'Rooms Vacancy',
                    waveImg: 'assets/ui-design-/images/yellow.png', roomImg: 'assets/ui-design-/images/Group 95.png',
                  ),
                  ReusableRoomContainer(
                    firstColor: const Color(0xffbe0e73),
                    secondColor: const Color(0xfff946a6),
                    totalRooms: '${roomOccupied.toString().padLeft(2,'0')}',
                    title: 'Rooms Occupied',
                    waveImg: 'assets/ui-design-/images/pink.png', roomImg: 'assets/ui-design-/images/Group 92.png',
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xff262626).withOpacity(0.10),
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 20,
                    top: 10,
                    bottom: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CustomTextField(
                          hint: 'Search Room Name',
                          controller: searchRoomName,
                          fillColor: const Color(0xffF5F5F5),
                          validator: null,
                          header: '',
                          onChanged: (value){
                            setState(() {

                            });
                          },
                          width: 335,
                          preffixIcon: Icons.search,
                          height: 45,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          style: const ButtonStyle(
                              elevation: MaterialStatePropertyAll(3),
                              backgroundColor: MaterialStatePropertyAll(Color(0xff37D1D3))
                          ),
                          onPressed: () {
                            SelectedBedCount.clear();
                            SelectedRoom.clear();
                            setState(() {
                              selectedBlockName = 'Select Block Name';
                            });
                            AddRoom();
                          },
                          child: Row(
                            children: [
                              KText(
                                text:'Add Room',
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
                ),
              ),
              const SizedBox(height: 30),
              Container(
                height: 500,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xff262626).withOpacity(0.10),
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child:

                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('Room').orderBy("timeStamp", descending: true).snapshots(),
                  builder: (context, snapshot) {
                    print("Builder function called!");
                    if (snapshot.hasData) {
                      // Add print statement to check snapshot contents
                      print("Snapshot Data: ${snapshot.data}");
                      List<DocumentSnapshot> matchedData = [];
                      List<DocumentSnapshot> remainingData = [];
                      if (searchRoomName.text.isNotEmpty) {
                        print("Searching for: ${searchRoomName.text}");
                        snapshot.data!.docs.forEach((doc) {
                          final roomNumberField = doc["roomnumber"].toString().toLowerCase();
                          final searchText = searchRoomName.text.toLowerCase();
                          print("Room Number Field: $roomNumberField");
                          print("Search Text: $searchText");
                          if (roomNumberField.contains(searchText)) {
                            matchedData.add(doc);
                          } else {
                            remainingData.add(doc);
                          }
                        });
                        // Sort matchedData separately
                        matchedData.sort((a, b) {
                          final nameA = a["roomnumber"].toString().toLowerCase();
                          final nameB = b["roomnumber"].toString().toLowerCase();
                          final searchText = searchRoomName.text.toLowerCase();
                          return nameA.compareTo(nameB);
                        });
                      } else {
                        remainingData = snapshot.data!.docs;
                      }
                      // Add print statement to check matchedData and remainingData
                      print("Matched Data: $matchedData");
                      print("Remaining Data: $remainingData");
                      // Concatenate matched data and remaining data
                      List<DocumentSnapshot> combinedData = [...matchedData, ...remainingData];
                      // Add print statement to check combinedData
                      print("Combined Data: $combinedData");

                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          crossAxisSpacing: 10.0,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: combinedData.length,
                        itemBuilder: (BuildContext context, index) {
                          final documents = combinedData[index];
                          var data = documents.data() as Map<String, dynamic>?;
                          if (snapshot.hasData) {
                            final document = combinedData[index];
                            int bedCount = document['bedcount'] ?? 0;
                            int vacantCount = document['vacant'] ?? bedCount;
                            double occupancyPercentage = bedCount != 0 ? ((bedCount - vacantCount) / bedCount) * 100 : 0;
                            String occupancyStatus;
                            Color homeColor = const Color(0xff37d1d3);
                            if (occupancyPercentage == 100) {
                              occupancyStatus = 'Occupied';
                              homeColor = const Color(0xfff12d2d);
                            } else if (occupancyPercentage >= 50) {
                              occupancyStatus = 'Reserved';
                              homeColor = const Color(0xfffd7e50);
                            } else if (occupancyPercentage > 0) {
                              occupancyStatus = 'Empty';
                              homeColor = const Color(0xff37d1d3);
                            } else {
                              occupancyStatus = 'Empty';
                              homeColor = const Color(0xff37d1d3);
                            }
                            // Change the occupancyStatus to "Full" if vacantCount is 0
                            if (vacantCount == 0) {
                              occupancyStatus = 'Occupied';
                              homeColor = const Color(0xfff12d2d);
                            }
                            return Padding(
                              padding: const EdgeInsets.all(10),
                              child: InkWell(
                                onTap: (){
                                  roomDetail(document);
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: homeColor), // Change border color dynamically
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      KText(
                                        text: 'Room No: ${document['roomnumber']}',
                                        style: const TextStyle(
                                          color: Color(0xff595959),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Icon(
                                        Icons.home_work,
                                        size: 40,
                                        color: homeColor, // Change color dynamically
                                      ),
                                      KText(
                                        text: occupancyStatus,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: homeColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            final document = combinedData[index];
                            int bedCount = document['bedcount'] ?? 0;
                            int vacantCount = document['vacant'] ?? bedCount;
                            double occupancyPercentage = bedCount != 0 ? ((bedCount - vacantCount) / bedCount) * 100 : 0;
                            String occupancyStatus;
                            Color homeColor = const Color(0xff37d1d3);
                            if (occupancyPercentage == 100) {
                              occupancyStatus = 'Occupied';
                              homeColor = const Color(0xfff12d2d);
                            } else if (occupancyPercentage >= 50) {
                              occupancyStatus = 'Reserved';
                              homeColor = const Color(0xfffd7e50);
                            } else if (occupancyPercentage > 0) {
                              occupancyStatus = 'Empty';
                              homeColor = const Color(0xff37d1d3);
                            } else {
                              occupancyStatus = 'Empty';
                              homeColor = const Color(0xff37d1d3);
                            }
                            // Change the occupancyStatus to "Full" if vacantCount is 0
                            if (vacantCount == 0) {
                              occupancyStatus = 'Occupied';
                              homeColor = const Color(0xfff12d2d);
                            }
                            return Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  border: Border.all(color: homeColor), // Change border color dynamically
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    KText(
                                     text: 'Room No: ${document['roomnumber']}',
                                      style: const TextStyle(
                                        color: Color(0xff595959),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Icon(
                                      Icons.home_work,
                                      size: 40,
                                      color: homeColor, // Change color dynamically
                                    ),
                                    KText(
                                      text:document['occupancyStatus'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: homeColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      );
                    } else if (snapshot.hasError) {
                      return KText(text:'Error: ${snapshot.error}', style: GoogleFonts.openSans(),);
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                )


              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> AddRoom() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
      return AlertDialog(
        elevation: 0,
        backgroundColor: const Color(0xffFFFFFF),
          title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            KText(text:'Add Room', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
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
            InkWell(
              onTap: (){
                Navigator.pop(context);
                SelectedBedCount.clear();
                SelectedRoom.clear();
                setState(() {
                  selectedBlockName == 'Select Block Name';
                });
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                child: Container(
                  height: 20,
                  width: 20,
                  child: Image.asset('assets/ui-design-/images/Multiply.png', fit: BoxFit.contain,scale: 0.5,),
                ),
              ),
            )
          ],
        ),
    ),
    ),
    ],
    ),

    content: Container(
    width: 700,
    height: 250,
    child: Column(
    children: [
      const SizedBox(height: 10,),
    Divider(color: const Color(0xff262626).withOpacity(0.1), thickness: 1, height: 0.5),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
    Padding(
    padding: const EdgeInsets.only(top: 30.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // block name
        KText(text:'Block Name', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
        Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 10),
          child: Container(
          width: 220,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all( width: 1.5, color: const Color(0x7f262626).withOpacity(0.3)
            )
            ,borderRadius: BorderRadius.circular(30),
          ),
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 6),
              child: DropdownButtonHideUnderline(

                child: DropdownButtonFormField<String>(
                  dropdownColor: Colors.white,
                  elevation: 1,
                  focusColor: Colors.white,
                  isExpanded: true,
                  hint: const KText(
                    text:'Select Block Name',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  items: BlockNames.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: KText(
                       text: item,
                        style: const TextStyle(

                          color: Color(0x7f262626),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                  value: selectedBlockName,
                  onChanged: (String? value) {
                    setState(() {
                      selectedBlockName = value!;
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

          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KText(text: 'Bed Count', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 10),
                child: CustomTextField(
                hint: 'Bed Count',
                controller: SelectedBedCount,
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
            padding: const EdgeInsets.only(top: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KText(text:'Room Number', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  child: CustomTextField(
                hint: 'Room Number',
                controller: SelectedRoom,
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
          const SizedBox(height: 40),
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
              KText(
                text:'Cancel',
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
                onPressed: () {
                  final selectedBed = SelectedBedCount.text;
                  final selectedRoom = SelectedRoom.text;
                  // final selectedBlockName = this.selectedBlockName;
                  CreateRoom(selectedRoom, selectedBed, selectedBlockName).then((value){
                    SelectedBedCount.clear();
                    SelectedRoom.clear();
                    selectedBlockName;
                    setState(() {
                      selectedBlockName = 'Select Block Name';
                    });
                  });

                },
                child: Row(
                  children: [
                    KText(
                      text:'Add Room',
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
          );
        },
    );
  }

  Future<void> EditRoom(BuildContext con, String documentId) async {
      DocumentSnapshot roomSnapshot = await FirebaseFirestore.instance.collection('Room').doc(documentId).get();
      int oldBedCount = roomSnapshot['bedcount'] ?? 0;
    await setuserdata(documentId);
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, set) {
            return AlertDialog(
              elevation: 0,
              backgroundColor: const Color(0xffFFFFFF),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  KText(text:'Edit Room', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
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

              content: Container(
                width: 700,
                height: 250,
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    Divider(color: const Color(0xff262626).withOpacity(0.1), thickness: 1, height: 0.5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // block name
                              KText(text:'Block Name', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10, top: 10),
                                child: Container(
                                  width: 220,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all( width: 1.5, color: const Color(0x7f262626).withOpacity(0.3)
                                    )
                                    ,borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0, right: 6),
                                    child: DropdownButtonHideUnderline(

                                      child: DropdownButtonFormField<String>(
                                        dropdownColor: Colors.white,
                                        elevation: 1,
                                        focusColor: Colors.white,
                                        isExpanded: true,
                                        hint: const KText(
                                          text:'Select Block Name',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        items: BlockNames.map((String item) {
                                          return DropdownMenuItem<String>(
                                            value: item,
                                            child: KText(
                                              text: item,
                                              style: const TextStyle(
                                                color: Color(0x7f262626),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        value: selectedBlockName,

                                          onChanged: (String? value) {
                                            print('Selected value: $value'); // Debug: Check the selected value
                                            set(() {
                                              selectedBlockName = value ?? ''; // Update selectedBlockName here
                                              print('selectedBlockName: $selectedBlockName'); // Debug: Check the updated value
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

                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              KText(text: 'Bed Count', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10, top: 10),
                                child: CustomTextField(
                                  hint: 'Bed Count',
                                  controller: SelectedBedCount,
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
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              KText(text:'Room Number', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10, top: 10),
                                child: CustomTextField(
                                  hint: 'Room Number',
                                  controller: SelectedRoom,
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
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Container(
                        //   height: 40,
                        //   child: ElevatedButton(
                        //     style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff37D1D3))),
                        //   onPressed: () {
                        //   final selectedBed = SelectedBedCount.text;
                        //   final selectedRoom = SelectedRoom.text;
                        //   final selectedBlockName = this.selectedBlockName;
                        //   CreateRoom(selectedRoom, selectedBed, selectedBlockName);
                        //   },
                        //   child: Row(
                        //
                        //     children: [
                        //       Text('Add Room', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 18), ),
                        //     SizedBox(
                        //         width: 25, height: 25,
                        //         child: Image.asset('assets/ui-design-/images/Add.png'))
                        //     ],
                        //   ),
                        //   ),
                        // ),
                        //
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
                          KText(
                            text:'Cancel',
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
                            // onPressed: () {
                            //   if(selectedBlockName == 'Select Block Name' || SelectedBedCount.text.isEmpty || SelectedRoom.text.isEmpty){
                            //     showTopSnackBar(
                            //       Overlay.of(context),
                            //       const CustomSnackBar.success(
                            //         backgroundColor: Color(0xff3ac6cf),
                            //         message:
                            //         "Please Enter all the fields!",
                            //       ),
                            //     );
                            //   }else if(
                            //
                            //
                            //
                            //
                            //   ){
                            //
                            //   }
                            //
                            //
                            //   else{
                            //
                            //     updateuser(documentId);
                            //     Navigator.pop(context);
                            //     showTopSnackBar(
                            //       Overlay.of(context),
                            //       const CustomSnackBar.success(
                            //         backgroundColor: Color(0xff3ac6cf),
                            //         message:
                            //         "Room Updated successfully!",
                            //       ),
                            //     );
                            //   }
                            // },

                            onPressed: () {
                              if (selectedBlockName == 'Select Block Name' ||
                                  SelectedBedCount.text.isEmpty ||
                                  SelectedRoom.text.isEmpty) {
                                showTopSnackBar(
                                  Overlay.of(context),
                                  const CustomSnackBar.success(
                                    backgroundColor: Color(0xff3ac6cf),
                                    message: "Please Enter all the fields!",
                                  ),
                                );
                              } else {
                                // Update vacant count based on bed count
                                                              int newBedCount = int.tryParse(SelectedBedCount.text) ?? 0;
                                                              int bedCountDifference = newBedCount - oldBedCount;
                                                              int updatedVacantCount = roomSnapshot['vacant'] + bedCountDifference;
                                updateuser(documentId, updatedVacantCount);
                              }
                            },



                            child: Row(
                              children: [
                                KText(
                                  text:'Update Room',
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
            );
          }
        );
      },
    );
  }


  // Future<void> EditRoom(BuildContext context, String documentId) async {
  //   await setuserdata(documentId);
  //   DocumentSnapshot roomSnapshot = await FirebaseFirestore.instance.collection('Room').doc(documentId).get();
  //   int oldBedCount = roomSnapshot['bedcount'] ?? 0;
  //
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return AlertDialog(
  //             elevation: 0,
  //             backgroundColor: const Color(0xffFFFFFF),
  //             title: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 KText(
  //                   text: 'Edit Room',
  //                   style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),
  //                 ),
  //                 InkWell(
  //                   onTap: () => Navigator.pop(context),
  //                   child: Container(
  //                     height: 30,
  //                     width: 30,
  //                     child: Stack(
  //                       alignment: Alignment.center,
  //                       children: [
  //                         Container(
  //                           height: 38,
  //                           width: 38,
  //                           decoration: const BoxDecoration(
  //                             color: Colors.white,
  //                             borderRadius: BorderRadius.all(Radius.circular(50)),
  //                             boxShadow: [
  //                               BoxShadow(
  //                                 color: Color(0xfff5f6f7),
  //                                 blurRadius: 5,
  //                                 spreadRadius: 1,
  //                                 offset: Offset(4, 4),
  //                               )
  //                             ],
  //                           ),
  //                         ),
  //                         ClipRRect(
  //                           borderRadius: const BorderRadius.all(Radius.circular(50)),
  //                           child: Container(
  //                             height: 20,
  //                             width: 20,
  //                             child: Image.asset('assets/ui-design-/images/Multiply.png', fit: BoxFit.contain, scale: 0.5,),
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             content: Container(
  //               width: 700,
  //               height: 250,
  //               child: Column(
  //                 children: [
  //                   const SizedBox(height: 10,),
  //                   Divider(color: const Color(0xff262626).withOpacity(0.1), thickness: 1, height: 0.5),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     children: [
  //                       Padding(
  //                         padding: const EdgeInsets.only(top: 30.0),
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             KText(
  //                               text: 'Block Name',
  //                               style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),
  //                             ),
  //                             Padding(
  //                               padding: const EdgeInsets.only(bottom: 10, top: 10),
  //                               child: Container(
  //                                 width: 220,
  //                                 height: 46,
  //                                 decoration: BoxDecoration(
  //                                   color: Colors.white,
  //                                   border: Border.all(width: 1.5, color: const Color(0x7f262626).withOpacity(0.3)),
  //                                   borderRadius: BorderRadius.circular(30),
  //                                 ),
  //                                 child: Padding(
  //                                   padding: const EdgeInsets.only(left: 12.0, right: 6),
  //                                   child: DropdownButtonHideUnderline(
  //                                     child: DropdownButtonFormField<String>(
  //                                       dropdownColor: Colors.white,
  //                                       elevation: 1,
  //                                       focusColor: Colors.white,
  //                                       isExpanded: true,
  //                                       hint: const KText(
  //                                         text: 'Select Block Name',
  //                                         style: TextStyle(
  //                                           fontSize: 12,
  //                                           fontWeight: FontWeight.w600,
  //                                           color: Colors.grey,
  //                                         ),
  //                                       ),
  //                                       items: BlockNames.map((String item) {
  //                                         return DropdownMenuItem<String>(
  //                                           value: item,
  //                                           child: KText(
  //                                             text: item,
  //                                             style: const TextStyle(
  //                                               color: Color(0x7f262626),
  //                                               fontSize: 12,
  //                                               fontWeight: FontWeight.w600,
  //                                             ),
  //                                           ),
  //                                         );
  //                                       }).toList(),
  //                                       value: selectedBlockName,
  //                                       onChanged: (String? value) {
  //                                         setState(() {
  //                                           selectedBlockName = value ?? ''; // Update selectedBlockName
  //                                         });
  //                                       },
  //                                       decoration: const InputDecoration(border: InputBorder.none),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.only(top: 30.0),
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             KText(
  //                               text: 'Bed Count',
  //                               style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),
  //                             ),
  //                             Padding(
  //                               padding: const EdgeInsets.only(bottom: 10, top: 10),
  //                               child: CustomTextField(
  //                                 hint: 'Bed Count',
  //                                 controller: SelectedBedCount,
  //                                 fillColor: Colors.white,
  //                                 validator: null,
  //                                 header: '',
  //                                 width: 200,
  //                                 height: 45,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.only(top: 30.0),
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             KText(
  //                               text: 'Room Number',
  //                               style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),
  //                             ),
  //                             Padding(
  //                               padding: const EdgeInsets.only(bottom: 10, top: 10),
  //                               child: CustomTextField(
  //                                 hint: 'Room Number',
  //                                 controller: SelectedRoom,
  //                                 fillColor: Colors.white,
  //                                 validator: null,
  //                                 header: '',
  //                                 width: 200,
  //                                 height: 45,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 40),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     children: [
  //                       SizedBox(
  //                         width: 110,
  //                         height: 40,
  //                         child: ElevatedButton(
  //                           style: ButtonStyle(
  //                               elevation: MaterialStatePropertyAll(0),
  //                               backgroundColor: MaterialStatePropertyAll(Color(0xfff5f6f7))),
  //                           onPressed: () {
  //                             Navigator.pop(context);
  //                           },
  //                           child: KText(
  //                             text:'Cancel',
  //                             style: GoogleFonts.openSans(
  //                               fontSize: 13,
  //                               fontWeight: FontWeight.w600,
  //                               color: const Color(0xff37D1D3),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(width: 10,),
  //                       SizedBox(
  //                         height: 40,
  //                         child: ElevatedButton(
  //                           style: ButtonStyle(
  //                               elevation: MaterialStatePropertyAll(3),
  //                               backgroundColor: MaterialStatePropertyAll(Color(0xff37D1D3))
  //                           ),
  //                           onPressed: () {
  //                             if (selectedBlockName == 'Select Block Name' ||
  //                                 SelectedBedCount.text.isEmpty ||
  //                                 SelectedRoom.text.isEmpty) {
  //                               showTopSnackBar(
  //                                 Overlay.of(context),
  //                                 const CustomSnackBar.success(
  //                                   backgroundColor: Color(0xff3ac6cf),
  //                                   message: "Please Enter all the fields!",
  //                                 ),
  //                               );
  //                             } else {
  //                               // Update vacant count based on bed count
  //                               int newBedCount = int.tryParse(SelectedBedCount.text) ?? 0;
  //                               int bedCountDifference = newBedCount - oldBedCount;
  //                               int updatedVacantCount = roomSnapshot['vacant'] + bedCountDifference;
  //
  //                               // Update Firestore document
  //                               FirebaseFirestore.instance.collection('Room').doc(documentId).update({
  //                                 'bedcount': newBedCount,
  //                                 'roomNumber': SelectedRoom.text,
  //                                 'blockName': selectedBlockName,
  //                                 'vacant': updatedVacantCount,
  //                               }).then((_) {
  //                                 // Fetch updated room details
  //                                 FirebaseFirestore.instance.collection('Room').doc(documentId).get().then((updatedRoomSnapshot) {
  //                                   // Handle success and display message
  //                                   showTopSnackBar(
  //                                     Overlay.of(context),
  //                                     const CustomSnackBar.success(
  //                                       backgroundColor: Color(0xff3ac6cf),
  //                                       message: "Room Updated successfully!",
  //                                     ),
  //                                   );
  //                                 }).catchError((error) {
  //                                   print("Failed to fetch updated room details: $error");
  //                                 });
  //                               }).catchError((error) {
  //                                 print("Failed to update room: $error");
  //                               });
  //                             }
  //                           },
  //                           child: Row(
  //                             children: [
  //                               KText(
  //                                 text: 'Update Room',
  //                                 style: GoogleFonts.openSans(
  //                                   fontSize: 13,
  //                                   fontWeight: FontWeight.w600,
  //                                   color: Colors.white,
  //                                 ),
  //                               ),
  //                               const SizedBox(width: 8),
  //                               const CircleAvatar(
  //                                 radius: 8,
  //                                 backgroundColor: Colors.white,
  //                                 child: Center(
  //                                   child: Icon(
  //                                     Icons.add,
  //                                     color: Color(0xff37D1D3),
  //                                     size: 13,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }





  Future<void> CreateRoom(selectedRoom, selectedBed, selectedBlockName) async {
    try {
      int bedCount = int.tryParse(selectedBed ?? '') ?? 0;
      if (selectedRoom != null &&
          selectedRoom.isNotEmpty &&
          selectedBlockName != null &&
          selectedBlockName.isNotEmpty) {
        QuerySnapshot existingRooms = await FirebaseFirestore.instance
            .collection('Room')
            .where('blockname', isEqualTo: selectedBlockName)
            .where('roomnumber', isEqualTo: selectedRoom)
            .get();
        if (existingRooms.docs.isEmpty) {
          await FirebaseFirestore.instance.collection('Room').add({
            'blockname': selectedBlockName,
            'roomnumber': selectedRoom,
            'vacant': bedCount,
            'bedcount': bedCount,
            'timeStamp': DateTime.now().millisecondsSinceEpoch,
          });
          print('Main collection created successfully!');
          print('BlockName: $selectedBlockName');
          print('RoomNumber: $selectedRoom');
          print('BedCount: $bedCount');
          SelectedBedCount.text = '';
          SelectedRoom.text = '';
          Navigator.pop(context);
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.success(
              backgroundColor: Color(0xff3ac6cf),
              message:
              "Room Created Successfully",
            ),
          );
        } else {
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.error(
              backgroundColor: Color(0xffF12D2D),
              message:
              "Room with the same block name and room number already exists.",
            ),
          );
          print('Room with the same block name and room number already exists.');
        }
      } else {
        print('Room number and block name must not be empty.');
      }
    } catch (e) {
      print('Error creating main collection: $e');
    }
  }

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
  Future<void> fetchBedCounts() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Room').get();
      print("Number of documents: ${querySnapshot.size}");
      roomCount =  querySnapshot.size;
      querySnapshot.docs.forEach((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        print("Data fetched: $data");
        int bedCount = data['bedcount'] ?? 0;
        int vacantCount = data['vacant'] ?? 0;

        // Calculate occupied rooms count
        if (vacantCount == 0) {
          roomOccupied++;
        }
      });
      roomVacancy = roomCount - roomOccupied;
      print("Total Bed Count: $roomVacancy");
      print("Room Occupied: $roomOccupied");
      print("Room Vacancy");
      setState(() {});
    } catch (e) {
      print('Error fetching bed counts: $e');
    }
  }
///  show users in popUp
  Future<void> roomDetail(DocumentSnapshot<Object?> document) async {
    try {
      // Fetch resident documents associated with the room
      QuerySnapshot residentSnapshot = await FirebaseFirestore.instance
          .collection("Room")
          .doc(document.id)
          .collection('resident')
          .get();
      List<String> residentNames = [];
      List<String> residentNumbers = [];
      // for name
      residentSnapshot.docs.forEach((resDoc) {
        String residentName = resDoc['firstName'];
        String residentNumber = resDoc['phone'];
        if (residentName != null && residentName.isNotEmpty &&
        residentNumber != null && residentNumber.isNotEmpty
        )
        {
          residentNames.add(residentName);
          residentNumbers.add(residentNumber);
        }
      });

      // Show dialog with resident details
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 0,
            backgroundColor: const Color(0xffFFFFFF),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                KText(text:'Details Of Room', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(color: Colors.grey, height: 10,),
                    Row(
                      children: [
                        Container(
                            width: 150,
                            child: KText(text:'Room Number', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)),
                        Container(
                            width: 70,
                            child: Center(child: Text(':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
                        Container(

                            width: 150,
                            child: KText(text:'${document['roomnumber']}',style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)),
                      ],
                    ),
                    const SizedBox(height: 4,),
                    Row(
                      children: [
                        Container(
                            width: 150,
                            child: KText(text:'Block Name', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)),
                        Container(
                            width: 70,
                            child: Center(child: KText(text:':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
                        Container(
                            width: 150,
                            child: KText(text:'${document['blockname']}',style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)),
                      ],
                    ),
                    const SizedBox(height: 4,),
                    Row(
                      children: [
                        Container(
                            width: 150,
                            child: KText(text:'Total Bed', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)),
                        Container(
                            width: 70,
                            child: Center(child: KText(text:':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
                        Container(
                            width: 150,
                            child: KText(text:'${document['bedcount']}',style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)),
                      ],
                    ),
                    const SizedBox(height: 4,),
                    Row(
                      children: [
                        Container(
                            width: 150,
                            child: KText(text:'Vacant', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)),
                        Container(
                            width: 70,
                            child: Center(child: KText(text:':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
                        Container(

                            width: 150,
                            child: KText(text:'${document['vacant']}',style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)),
                      ],
                    ),

                    const SizedBox(height: 10,),

                    Row(
                      children: [
                        Container(
                            width: 150,
                            child: KText(text:'Action', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)),
                        Container(
                            width: 30,
                            child: Center(child: KText(text:':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
                       ElevatedButton(
                           style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff37D1D3))),
                           onPressed: (){
                         Navigator.pop(context);
                         setuserdata(document.id);
                         EditRoom(context, document.id);
                       }, child: Text('Update', style: GoogleFonts.openSans(fontSize: 14, color: Colors.white),)
                       ),
                        SizedBox(width: 2,),
                        ElevatedButton(
                            style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xffF12D2D))),
                            onPressed: (){
                              Navigator.pop(context);
                          ForDeleteDialog(context, document.id);
                        }, child: Text('Delete', style: GoogleFonts.openSans(fontSize: 14, color: Colors.white),)
                        ),
                                 ],
                    ),




                    const SizedBox(height: 30,),

                    const Text('Residents List', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                    const Divider(color: Colors.grey, height: 10,),

                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: residentNames.map((residentName) => Text('${residentName}', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 15),)).toList(),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: residentNumbers.map((residentNumber) => Text(residentNumber)).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            )
                  ],
                ),
              ),
            ),
          );


        },
      );
    } catch (e) {
      print('Error fetching resident details: $e');
    }
  }
  ///for delete dialog
  Future<void> ForDeleteDialog(BuildContext con, String documentId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          content: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Container(
              padding: EdgeInsets.zero,
              color: Colors.white,
              height: 350,
              width: 550,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: const CircleAvatar(
                            backgroundColor: Color(0xffF5F6F7), radius: 20, child: Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(Icons.close, color: Colors.grey, size: 18,),
                          ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 130,
                          width: 130,
                          child: Image.asset('assets/ui-design-/images/DeleteL.png'),
                        ),
                        SizedBox(
                          height: 150,
                          width: 150,
                          child: Image.asset('assets/ui-design-/images/deleteCenter.png'),
                        ),
                        SizedBox(
                          height: 130,
                          width: 130,
                          child: Image.asset('assets/ui-design-/images/DeleteR.png'),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 20),
                      child: KText(text:'Are you sure you want to delete this room?', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 17),),
                    ),
                    KText(text: 'Once deleted, it cannot be recovered.', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 17),),
                    const SizedBox(height: 25,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 130,
                          height: 42,
                          child: ElevatedButton(
                            style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xffF5F5F5))),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: KText(text: 'Cancel', style: GoogleFonts.openSans(fontSize: 17, fontWeight: FontWeight.w700, color: const Color(0xff262626).withOpacity(0.8)),),
                          ),
                        ),
                        const SizedBox(width: 20,),
                        Container(
                          width: 130,
                          height: 42,
                          child: ElevatedButton(
                            style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xffF12D2D))),
                            onPressed: () async {
                              try {
                                await FirebaseFirestore.instance.collection('Room').doc(documentId).delete();
                                showTopSnackBar(
                                  Overlay.of(context),
                                  const CustomSnackBar.success(
                                    backgroundColor: Color(0xff3ac6cf),
                                    message:
                                    "Room Deleted successfully!",
                                  ),
                                );
                                Navigator.pop(context); // Close the dialog
                              } catch (e) {
                                // Show an error message if deletion fails
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: KText(text:'Error deleting block: $e', style: GoogleFonts.openSans(),),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            },


                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                KText(text:'Delete',style: GoogleFonts.openSans(fontSize: 17, fontWeight: FontWeight.w700, color: const Color(0xffFFFFFF))),
                                const Icon(Icons.delete, size: 18, color: Color(0xffFFFFFF),)
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
///set user data
  setuserdata(id) async {
    var docu = await FirebaseFirestore.instance.collection("Room").doc(id).get();
    Map<String, dynamic>? val = docu.data();
    setState(() {
      SelectedBedCount.text = val!["bedcount"].toString();
      selectedBlockName = val["blockname"].toString();
      SelectedRoom.text = val["roomnumber"].toString();
    });
  }
  Future<void> updateuser(String id, int vacantCount) async {
    try {
      int bedCount = int.tryParse(SelectedBedCount.text ?? '') ?? 0;
      if (selectedBlockName != null &&
          selectedBlockName.isNotEmpty &&
          SelectedRoom.text != null &&
          SelectedRoom.text.isNotEmpty) {
        QuerySnapshot existingRooms = await FirebaseFirestore.instance
            .collection('Room')
            .where('blockname', isEqualTo: selectedBlockName)
            .where('roomnumber', isEqualTo: SelectedRoom.text)
            .get();

        if (existingRooms.docs.isEmpty || existingRooms.docs.first.id == id) {
          await FirebaseFirestore.instance.collection("Room").doc(id).update({
            'bedcount': bedCount,
            'blockname': selectedBlockName,
            'roomnumber': SelectedRoom.text,
            'vacant': vacantCount,
          });
          print('Room updated successfully!');
          Navigator.pop(context);
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.success(
              backgroundColor: Color(0xff3ac6cf),
              message: "Room Updated successfully!",
            ),
          );
        } else {
          print('Room with the same block name and room number already exists.');
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.error(
              backgroundColor: Color(0xffF12D2D),
              message:
              "Room with the same block name and room number already exists.",
            ),
          );
        }
      } else {
        print('Room number and block name must not be empty.');
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(
            backgroundColor: Color(0xff3ac6cf),
            message: "Room number and block name must not be empty.",
          ),
        );
      }
    } catch (e) {
      print('Error updating room: $e');
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          backgroundColor: Color(0xff3ac6cf),
          message: "Error updating room. Please try again later.",
        ),
      );
    }
  }
}




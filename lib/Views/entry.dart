import 'dart:html';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_ikia/widgets/ReusableHeader.dart';
import 'package:hms_ikia/widgets/customtextfield.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../Constants/constants.dart';
import '../widgets/ReusableIconName.dart';
import '../widgets/switch_button.dart';
import '../widgets/userMiniDetails.dart';
import 'package:intl/intl.dart';

class Entry extends StatefulWidget {
  const Entry({Key? key});
  @override
  State<Entry> createState() => _EntryState();
}

class _EntryState extends State<Entry> {
  List<Map<String, dynamic>> searchSuggestions = [];
  // var noSuggestion;
  TextEditingController ResidentName = TextEditingController();
  TextEditingController ResidentUid = TextEditingController();
  TextEditingController Search = TextEditingController();
  Map<String, dynamic>? selectedUser;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  // Fetching the user data here...
  void fetchUsers() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Users').get();
    setState(() {
      searchSuggestions = snapshot.docs.map((doc) => {
        'name': doc['firstName'] as String,
        'docId': doc.id,
        'userid': doc['userid'] as String,
        'phone' : doc['phone']as String,
        'profilePicture': doc['imageUrl'] as String,
        'status' : doc['status'] as bool
      }).toList();
    }
    );
  }



  bool ChangeValue = false;

  @override
  Widget build(BuildContext context) {
    double listViewHeight = calculateListViewHeight();
    return FadeInRight(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ReusableHeader(
                Headertext: 'Register',
                SubHeadingtext: '"Manage Easily Residents Records"',
              ),
              SizedBox.fromSize(size: const Size(0, 10)),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color(0xff262626).withOpacity(0.10)),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextField(
                      hint: 'Search Resident Name',
                      onChanged: (value) {
                        setState(() {
                          if(value.isEmpty){
                            fetchUsers();
                            print('values Emp');
                          }
                          else{
                            searchSuggestions = searchSuggestions.where((user) => user['name'].toLowerCase().startsWith(value.toLowerCase()) ||
                                user['userid'].toLowerCase().startsWith(value.toLowerCase())
                            ).toList();
                          print(value);}
                          print(searchSuggestions);
                          print('ide');
                        });
                      },
                      controller: ResidentName,
                      fillColor: const Color(0xffF5F5F5),
                      header: '',
                      width: 335,
                      preffixIcon: Icons.search,
                      height: 45, validator:  null,
                    ),
                    SizedBox.fromSize(size: const Size(23, 0)),
                    CustomTextField(
                      hint: 'Search Resident User ID',
                      controller: ResidentUid,
                      onChanged: (value) {
                        setState(() {
                          if(value.isEmpty){
                            fetchUsers();
                            print('values Emp');
                          }
                          else{
                            searchSuggestions = searchSuggestions.where((user) => user['name'].toLowerCase().startsWith(value.toLowerCase())  ||
                                user['userId'].toLowerCase().startsWith(value.toLowerCase())
                            ).toList();
                            print(value);}
                          print(searchSuggestions);
                          print('ide');
                        });
                      },
                      fillColor: const Color(0xffF5F5F5),
                      header: '',
                      width: 335,
                      preffixIcon: Icons.search,
                      height: 45, validator:null,
                    ),
                    SizedBox.fromSize(size: const Size(23, 0)),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff37D1D3))),
                        onPressed: () {},
                        child: const Row(
                          children: [
                            Text('Search', style: TextStyle(color: Colors.white)),
                            SizedBox(width: 8),
                            Icon(Icons.search, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                    SizedBox.fromSize(size: const Size(23, 0)),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: const BorderSide(color: Color(0xff37D1D3)),
                            ),
                          ),
                        ),
                        onPressed: () {
                            ResidentName.clear();
                            ResidentUid.clear();
                            setState(() {
                              fetchUsers();
                              selectedUser = null;
                            });
                        },
                        child: const Row(
                          children: [
                            Text('Reset', style: TextStyle(color: Color(0xff37D1D3))),
                            SizedBox(width: 8),
                            Icon(Icons.restart_alt, color: Color(0xff37D1D3)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox.fromSize(size: const Size(0, 15)),
            ResidentName.text != '' || ResidentUid.text != ''?
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      width: 350,
                      height: listViewHeight,
                      child: ListView.builder(
                        itemCount: searchSuggestions.length,
                        itemBuilder: (context, index) {
                          Color titleColor = index == 0 ? const Color(0xffd1f4f5) : const Color(0xffF5F5F5);
                          return Container(
                            color: titleColor,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(searchSuggestions[index]['profilePicture']),
                                ),
                                title: Text(
                                  searchSuggestions[index]['name'],
                                  style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    ResidentName.text = searchSuggestions[index]['name'];
                                    selectedUser = searchSuggestions[index];
                                    searchSuggestions = [];

                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ) : const SizedBox(),
              if (selectedUser != null && ResidentName.text.isNotEmpty || ResidentUid.text.isNotEmpty ) ...[
                ClipRRect(
                  child: Container(
                      height: 450,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff262626).withOpacity(0.10)),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding:  const EdgeInsets.all(18),
                        child: Row(children: [
                          ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              child: Container(height: 390, color: const Color(0xff37D1D3), width: 260,
                                child:  Column(children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Stack(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(top: 10, bottom: 10, left: 15),
                                            child: SizedBox(
                                                height: 220,
                                                child: Image(image: AssetImage('assets/ui-design-/images/framee.png'))),
                                          ),
                                          Positioned(
                                            left: 71,
                                            top: 65,
                                            child: SizedBox(
                                                child: CircleAvatar(radius: 65,backgroundImage:
                                                  NetworkImage(selectedUser!['profilePicture'])
                                                )
                                            ),
                                          ),
                                        ],
                                        ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(children: [
                                          UserMiniDetails(IconName: Icons.contact_mail, userDet: selectedUser!['userid'], iName: 'User ID                :      ',),
                                          const SizedBox(height: 8,),
                                          UserMiniDetails(IconName: Icons.phone, iName: 'Phone Number  :      ',userDet: selectedUser!['phone']),
                                          const SizedBox(height: 8,),
                                          Row(
                                            children: [
                                              const UserMiniDetails(IconName: Icons.downloading, iName: 'Status                  :     ',),
                                              getStatusButton(selectedUser!['status']),
                                            ],
                                          ),
                                          const SizedBox(height: 8,),
                                          const Padding(
                                            padding: EdgeInsets.only(top: 3, bottom: 3),
                                            child: SizedBox(
                                                height: 30,
                                                child: Image(image: AssetImage('assets/ui-design-/images/Group 84.png'))),
                                          )
                                        ],),
                                      )
                                    ],)
                                ],),
                              )),
                          const SizedBox(width: 30,),
                          Expanded(
                            child: SizedBox(
                              height: 750,
                              child: SingleChildScrollView(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: const Color(0xff262626).withOpacity(0.10)),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child:  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start ,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 30, top: 30),
                                        child: SizedBox(height: 36, width: 36,
                                          child:
                                          Image(image: AssetImage('assets/ui-design-/images/Layer1.png',), fit: BoxFit.contain,),),
                                      ),
                                      const SizedBox(height: 20,),
                                      Center(
                                        child:
                                        SizedBox(
                                          child: SmartSwitch(
                                            size: SwitchSize.medium,
                                            disabled: false,
                                            // activeColor: Constants()
                                            //     .primaryAppColor,
                                            activeColor: Color(0xff1DA644),
                                            inActiveColor: Color(0xffF12D2D),
                                            defaultActive:  selectedUser!['status'],
                                            onChanged: (ChangeValue) async {
                                                  if (ChangeValue == true) {
                                                    await FirebaseFirestore.instance
                                                        .collection('Users')
                                                        .doc(selectedUser!['docId'])
                                                        .update({'status': true });
                                                    statusTrue();
                                                    print('Checked In');
                                                  }
                                                  else {
                                                    await FirebaseFirestore.instance
                                                        .collection('Users')
                                                        .doc(selectedUser!['docId'])
                                                        .update({'status': false });
                                                    statusFalse();
                                                    print('Checked Out');
                                                  }
                                                },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20,),
                                      const Padding(
                                        padding: EdgeInsets.only(right: 30),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            SizedBox(height: 40, child: Image(image: AssetImage('assets/ui-design-/images/Group 68.png')),)
                                          ],),
                                      ),
                                      // History...
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 50),
                                            child: Text('History', style: GoogleFonts.openSans(fontWeight: FontWeight.w800),),
                                          ),
                                          const SizedBox(height: 30,),
                                          // IconWithName(PrDateIcon: Icons.date_range, PrTimeIcon: Icons.watch_later_outlined, PrStatusIcon: Icons.downloading, TPrDate: 'Date', TPrTime: 'Time', TStatus: 'Status',textColor:  const Color(0xff262626).withOpacity(0.7),),
                                          //
                                          const SizedBox(height: 7,),
                                           Container(
                                             // color: Colors.pink,
                                             child: Row(
                                               mainAxisAlignment: MainAxisAlignment.center,
                                               children: [
                                              Container(
                                                width: 200,
                                                child: Row(
                                                  // mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(width: 20, child: Image.asset('assets/ui-design-/images/calendar.png'),),
                                                    SizedBox(width: 3,),
                                                    Text('Date',
                                                      style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 16,color: Color(0xff262626).withOpacity(0.8)
                                                    )
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 200,
                                                child: Row(
                                                  children: [
                                                    // Icon(Icons.watch,color: Color(0xff262626).withOpacity(0.7),size: 20,),
                                                    SizedBox(width: 20, child: Image.asset('assets/ui-design-/images/time.png'),),
                                                    SizedBox(width: 3,),
                                                    Text('Time',
                                                        style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 16,color: Color(0xff262626).withOpacity(0.8)
                                                        )
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 110,
                                                child: Row(
                                                  children: [
                                                  SizedBox(width: 20, child: Image.asset('assets/ui-design-/images/loading.png'),),
                                                    SizedBox(width: 3,),
                                                    Text('Status',
                                                  style: GoogleFonts.openSans(fontWeight: FontWeight.w700,fontSize: 16, color: Color(0xff262626).withOpacity(0.8)
                                              )
                                                    )
                                                  ],
                                                ),
                                              ),

                                                                                       ],),
                                           ),
                                          const SizedBox(height: 30,),
                                          StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('Users')
                                              .doc(selectedUser!['docId'])
                                              .collection('entries').orderBy("timestamp", descending: true).snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            }
                                            if (snapshot.hasError) {
                                              return Text('Error: ${snapshot.error}');
                                            }
                                            if (snapshot.hasData) {
                                              return ListView.builder(
                                                reverse: true,
                                                shrinkWrap: true,
                                                itemCount: snapshot.data!.docs.length,
                                                itemBuilder: (context, index) {
                                                  var entry = snapshot.data!.docs[index].data();
                                                  if (entry != null) {
                                                    // Storing the date nd time
                                                    DateTime date = (entry['date'] as Timestamp).toDate();
                                                    DateTime time = (entry['time'] as Timestamp).toDate();
                                                    // Formatting  the date and time
                                                    String formattedDate = DateFormat.yMMMd().format(date);
                                                    String formattedTime = DateFormat('h:mm a').format(time);
                                                    return Padding(
                                                      padding: const EdgeInsets.only(left: 70, right: 70,top: 2, bottom: 2),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          //data
                                                          Container(
                                                            width: 200,
                                child: Text(
                                  formattedDate,style: GoogleFonts.openSans(color: Color(0xff262626), fontWeight: FontWeight.w700),
                                ),),
                                                          Container(
                                width: 200,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(formattedTime,style: GoogleFonts.openSans(color: Color(0xff262626), fontWeight: FontWeight.w700),),
                                ),
                                                          ),
                                                           Container(
                                width: 110,
                                child: entry['status'] == 'true' ?  Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text('Check In',style: GoogleFonts.openSans(color: Color(0xff1DA644), fontWeight: FontWeight.w700),),
                                ) : Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text('Check Out',style: GoogleFonts.openSans(color: Color(0xffF12D2D), fontWeight: FontWeight.w700),),
                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  } else {
                                                    return Container();
                                                  }
                                                },
                                              );

                                            } else {
                                              return Text('No data available');
                                            }
                                          },
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.only(left: 100, right: 60, top: 20, bottom: 20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(
                                                    width: 18,
                                                    child: Image(image: AssetImage('assets/ui-design-/images/Vector 33.png'))),
                                                SizedBox(
                                                    width: 30,
                                                    child: Image(image: AssetImage('assets/ui-design-/images/Vector 33.png'))),

                                              ],),
                                          ),
                                        ],
                                      ),
                                    ],),
                                ),
                              ),
                            ),
                          )
                        ],),
                      )

                  ),
                ),

              ],
            ],
          ),
        ),
      ),
    );
  }
  double calculateListViewHeight() {
    // Calculate the total height of the ListView
    double itemHeight = 60; // Height of each item
    int itemCount = searchSuggestions.length;
    double totalHeight = itemHeight * itemCount;
    return totalHeight;
  }

  // creating sub collection (entries)
  void statusTrue() async {
    // main collection
    CollectionReference mainCollection =
    FirebaseFirestore.instance.collection('Users');
    //getting thje document ID
    DocumentReference documentRef =
    mainCollection.doc(selectedUser!['docId']);
    // creating a new sub collection
    CollectionReference subcollectionRef =
    documentRef.collection('entries');
    // mentioned timestamp
    int millisecondsSinceEpoch = Timestamp.now().millisecondsSinceEpoch;
    // adding the data
    await subcollectionRef.add({
      'status': 'true',
      'date': Timestamp.fromDate(DateTime.now()),
      'time': Timestamp.fromDate(DateTime.now()),
      'timestamp' : millisecondsSinceEpoch
    });
    print('Subcollection created successfully');
  }

  void statusFalse() async {
    CollectionReference mainCollection =
    FirebaseFirestore.instance.collection('Users');

    DocumentReference documentRef =
    mainCollection.doc(selectedUser!['docId']);

    CollectionReference subcollectionRef =
    documentRef.collection('entries');

    int millisecondsSinceEpoch = Timestamp.now().millisecondsSinceEpoch;

    await subcollectionRef.add({
      'status': 'false',
      'date': Timestamp.fromDate(DateTime.now()),
      'time': Timestamp.fromDate(DateTime.now()),
      'timestamp' : millisecondsSinceEpoch
    });
 }

  Widget getStatusButton(bool status) {
    return status
        ? SizedBox(
      width: 100,
      height: 29,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
          MaterialStateProperty.all<Color>(Color(0xffDDFFE7)),
        ),
        onPressed: () {},
        child: const Text(
          'In Room',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xff1DA644),
          ),
        ),
      ),
    )
        : SizedBox(
      width: 100,
      height: 29,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
          MaterialStateProperty.all<Color>(Color(0xffFFD3D3)),
        ),
        onPressed: () {},
        child: const Text(
          'Out Room',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xffF12D2D),
          ),
        ),
      ),
    );
  }




}
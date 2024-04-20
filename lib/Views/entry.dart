import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_ikia/widgets/ReusableHeader.dart';
import 'package:hms_ikia/widgets/customtextfield.dart';
import 'package:intl/intl.dart';
import '../Constants/constants.dart';
import '../widgets/kText.dart';
import '../widgets/switch_button.dart';
import '../widgets/userMiniDetails.dart';


import 'checkoutUsers.dart';

class Entry extends StatefulWidget {
  const Entry({Key? key});
  @override
  State<Entry> createState() => _EntryState();
}
class _EntryState extends State<Entry> {

  bool visiblity = false;

  List<Map<String, dynamic>> searchSuggestions = [];
  // var noSuggestion;
  TextEditingController ResidentName = TextEditingController();
  TextEditingController ResidentUid = TextEditingController();
  TextEditingController Search = TextEditingController();
  Map<String, dynamic>? selectedUser;
  bool viewAllHistory = false;
  @override
  void initState() {
    super.initState();
    fetchUsers();
  }



  void fetchUsers() async {
    try {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('Users').get();
      setState(() {
        searchSuggestions = snapshot.docs.map((doc) {
          // Validate that the required fields are present and not null
          final name = doc['firstName'] as String? ?? '';
          final userId = doc['userid'] as String? ?? '';
          final phone = doc['phone'] as String? ?? '';
          final fcmToken = doc['fcmToken'] as String ?? '';
          final profilePicture = doc['imageUrl'] as String? ?? '';
          final status = doc['status'] as bool? ?? false;

          return {
            'name': name,
            'docId': doc.id,
            'userid': userId,
            'phone': phone,
            'fcmToken': fcmToken,
            'profilePicture': profilePicture,
            'status': status,
          };
        }).toList();
      });
    } catch (error) {
      print('Error fetching users: $error');
      // Handle error as needed
    }
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ReusableHeader(
                    Headertext: 'Register',
                    SubHeadingtext: '"Manage Easily Residents Records"',
                  ),
                  SizedBox(
                    height: 45, width: 150,
                    child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff37D1D3))),
                        onPressed: (){
                          setState(() {
                            visiblity = !visiblity;
                          });
                      print(visiblity);
                    }, child:
                    Text(visiblity == true ? 'Normal View' : 'Check Out List', style: GoogleFonts.openSans(color: Colors.white, fontSize: 15),
                    )
                    ),
                  )
                ],
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
                          if (value.isEmpty) {
                            fetchUsers();
                            print('values Emp');
                          } else {
                            searchSuggestions = searchSuggestions.where((user) =>
                                user['name'].toLowerCase().startsWith(value.toLowerCase())).toList();
                            print(value);
                          }
                          print(searchSuggestions);
                          print('Resident name controller');
                        });
                      },
                      controller: ResidentName,
                      fillColor: const Color(0xffF5F5F5),
                      header: '',
                      width: 335,
                      preffixIcon: Icons.search,
                      height: 45,
                      validator: null,
                    ),
                    SizedBox.fromSize(size: const Size(23, 0)),
                    CustomTextField(
                      hint: 'Search Resident User ID',
                      controller: ResidentUid,
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty) {
                            fetchUsers();
                            print('Values Empty');
                          } else {
                            searchSuggestions = searchSuggestions.where((user) =>
                                user['userid'].toString().toLowerCase().contains(value.toLowerCase())
                            ).toList();
                            print(value);
                          }
                          print(searchSuggestions);
                          print('Resident User ID');
                        });
                      },

                      fillColor: const Color(0xffF5F5F5),
                      header: '',
                      width: 335,
                      preffixIcon: Icons.search,
                      height: 45,
                      validator: null,
                    ),



                    SizedBox.fromSize(size: const Size(23, 0)),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff37D1D3))),
                        onPressed: () {},
                        child: const Row(
                          children: [
                            KText(text:'Search', style: TextStyle(color: Colors.white)),
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
                            KText(text:'Reset', style: TextStyle(color: Color(0xff37D1D3))),
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
            // ResidentName.text != '' || ResidentUid.text != ''?
                Row(
                  children: [
                    /// for the name
                    ResidentName.text != '' ?
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
                                    title: KText(
                                     text: searchSuggestions[index]['name'],
                                      style: GoogleFonts.openSans(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        ResidentName.text = searchSuggestions[index]['name'];
                                        ResidentUid.text = searchSuggestions[index]['userid'];
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
                    ) : SizedBox(width: 350,),
                    ///for the uid
                    ResidentUid.text != '' ?
                    Padding(
                      padding: EdgeInsets.only(left:  ResidentName.text == '' ? 70 : 20),
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
                                    title: KText(
                                      text: searchSuggestions[index]['userid'],
                                      style: GoogleFonts.openSans(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        ResidentName.text = searchSuggestions[index]['name'];
                                        ResidentUid.text = searchSuggestions[index]['userid'];
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
                    ) : SizedBox(),
                  ],
                ),
                // : const SizedBox(),
              if (selectedUser != null && ResidentName.text.isNotEmpty
                  ||
                  selectedUser != null && ResidentUid.text.isNotEmpty ) ...[
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
                                            inactiveName: 'Check Out',
                                            activeName: 'Check In',
                                            size: SwitchSize.medium,
                                            disabled: false,
                                            activeColor: Color(0xff1DA644),
                                            inActiveColor: Color(0xffF12D2D),
                                            defaultActive:  selectedUser!['status'],
                                            onChanged: (ChangeValue) async {
                                                  if (ChangeValue == true) {
                                                    await FirebaseFirestore.instance
                                                        .collection('Users')
                                                        .doc(selectedUser!['docId'])
                                                        .update({'status': true,
                                                    });
                                                    sendPushMessage(title:'Entry Records',body: 'Just now you have Entered the Hostel',token: selectedUser!['fcmToken']);
                                                    statusTrue();
                                                    print('Checked In');
                                                  }
                                                  else {
                                                    await FirebaseFirestore.instance
                                                        .collection('Users')
                                                        .doc(selectedUser!['docId'])
                                                        .update({'status': false,
                                                    });
                                                    sendPushMessage(title:'Entry Records',body: 'Just now you Went outside the Hostel',token: selectedUser!['fcmToken']);
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
                                            padding: const EdgeInsets.only(left: 50, right: 50),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                KText(text:'History', style: GoogleFonts.openSans(fontWeight: FontWeight.w800, fontSize: 18),),
                                              SizedBox(
                                                width: 120,
                                                height: 40,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Color(0xff37D1D3),
                                                    textStyle: GoogleFonts.openSans(
                                                      fontWeight: FontWeight.w600, color: Colors.white, fontSize: 15
                                                    )
                                                  ),
                                                    onPressed: (){
                                                  setState(() {
                                                    viewAllHistory = !viewAllHistory;
                                                  });
                                                }, child:  Text(
                                                    viewAllHistory ? 'View Less' : 'View All')),
                                              ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 30,),
                                          const SizedBox(height: 7,),
                                           Container(
                                             child: Row(
                                               mainAxisAlignment: MainAxisAlignment.center,
                                               children: [
                                              SizedBox(
                                                width: 200,
                                                child: Row(
                                                  // mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(width: 20, child: Image.asset('assets/ui-design-/images/calendar.png'),),
                                                    SizedBox(width: 3,),
                                                    KText(text: 'Date',
                                                      style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 16,color: Color(0xff262626).withOpacity(0.8)
                                                    )
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 200,
                                                child: Row(
                                                  children: [
                                                    // Icon(Icons.watch,color: Color(0xff262626).withOpacity(0.7),size: 20,),
                                                    SizedBox(width: 20, child: Image.asset('assets/ui-design-/images/time.png'),),
                                                    SizedBox(width: 3,),
                                                    KText(text: 'Time',
                                                        style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 16,color: Color(0xff262626).withOpacity(0.8)
                                                        )
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 110,
                                                child: Row(
                                                  children: [
                                                  SizedBox(width: 20, child: Image.asset('assets/ui-design-/images/loading.png'),),
                                                    SizedBox(width: 3,),
                                                    KText(text:'Status',
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
                                              .collection('entries').orderBy("timestamp", descending: false).snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            }
                                            if (snapshot.hasError) {
                                              return KText(text:'Error: ${snapshot.error}', style: GoogleFonts.openSans(),);
                                            }
                                            if (snapshot.hasData) {
                                              List<DocumentSnapshot> documents = snapshot.data!.docs;
                                              int itemCount = viewAllHistory ? documents.length : min(documents.length, 20);
                                              return ListView.builder(
                                                reverse: true,
                                                shrinkWrap: true,
                                                // itemCount: snapshot.data!.docs.length,
                                                itemCount: itemCount,
                                                itemBuilder: (context, index) {
                                                  var entry = snapshot.data!.docs[index].data();
                                                  if (entry != null) {
                                                    // Storing the date nd time
                                                    // DateTime date = (entry['date'] as Timestamp).toDate();
                                                    // DateTime time = (entry['time'] as Timestamp).toDate();
                                                    // Formatting  the date and time
                                                    // String formattedDate = DateFormat.yMMMd().format(date);
                                                    // String formattedTime = DateFormat('h:mm a').format(time);
                                                    return Padding(
                                                      padding: const EdgeInsets.only(left: 70, right: 70,top: 2, bottom: 2),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          //data
                                                          SizedBox(
                                                            width: 200,
                                child: KText(
                                 text: entry['date'].toString(),style: GoogleFonts.openSans(color: Color(0xff262626), fontWeight: FontWeight.w700),
                                ),),
                                                          SizedBox(
                                width: 200,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: KText(text:entry['time'].toString(),style: GoogleFonts.openSans(color: Color(0xff262626), fontWeight: FontWeight.w700),),
                                ),
                                                          ),
                                                           SizedBox(
                                width: 110,
                                child: entry['status'] == 'true' ?  Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: KText(text:'Check In',style: GoogleFonts.openSans(color: Color(0xff1DA644), fontWeight: FontWeight.w700),),
                                ) : Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: KText(text:'Check Out',style: GoogleFonts.openSans(color: Color(0xffF12D2D), fontWeight: FontWeight.w700),),
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
                                              return KText(text:'No data available', style: GoogleFonts.openSans(),);
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

              // ResidentName.text == '' || ResidentUid.text == ''?


 visiblity == true ?




 Column(
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
     Padding(
       padding: const EdgeInsets.only(left: 20),
       child: Text('Check Out List', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 20),),
     ),

     SizedBox(height: 20,),
     Container(
       decoration: BoxDecoration(border: Border.all(color: const Color(0xff262626).withOpacity(0.10)), borderRadius: BorderRadius.circular(30) ),
       child:
       SizedBox(
         height: 40,
         child: Padding(
           padding: const EdgeInsets.only(left: 30, right: 30),
           child:
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [
               SizedBox(
                   width: 70,
                   child: KText(text:'S.No', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 18),)),
               SizedBox(
                   width: 100,
                   child: KText(text:'User ID', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),)),
               SizedBox(
                   width: 170,
                   child: KText(text:'Name', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),)),
               SizedBox(
                   width: 100,
                   child: KText(text:'Phone No', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),)),
               SizedBox(
                   width: 100,
                   child: Center(child: KText(text:'Date', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),))),
               SizedBox(
                   width: 100,
                   child: Center(child: KText(text:'Time', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),))),
             ],),
         ),
       ),
     ),


     StreamBuilder(stream: FirebaseFirestore.instance.collection('Users').where('status', isEqualTo: false).snapshots(),
       builder: (context, snapshot) {
         if(snapshot.hasData){
           var length = snapshot.data!.docs.length;
           return ListView.builder(
             shrinkWrap: true,
             itemBuilder: (context, index) {
               var document = snapshot.data!.docs[index];
               int serialNumber = index + 1;
               if(snapshot.hasData){
                 return Padding(
                   padding: const EdgeInsets.only(left: 0, right: 0),
                   child:
                   Padding(
                     padding: const EdgeInsets.only(top: 5, bottom: 5),
                     child: Row(
                       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: [
                         SizedBox(
                             width: 180,
                             child: Padding(
                               padding: const EdgeInsets.only(left: 35),
                               child: KText(text:serialNumber.toString(), style: GoogleFonts.openSans(fontSize: 18),),
                             )),
                       Container(
                             width: 180,
                             child: KText(text: document['userid'], style: GoogleFonts.openSans( fontSize: 18),)),
                         Container(

                             width: 250,
                             child: KText(text:document['firstName'], style: GoogleFonts.openSans( fontSize: 18),)),
                         Container(

                             width: 185,
                             child: KText(text:document['phone'], style: GoogleFonts.openSans( fontSize: 18),)),



                         // StreamBuilder(stream: FirebaseFirestore.instance.collection('Users').doc(document.id).collection('entries').orderBy('timestamp', descending: true).snapshots(),
                         //   builder: (context, snapshot) {
                         //     if(snapshot.hasData){
                         //       return Row(
                         //         children: [
                         //           Container(
                         //               width: 200,
                         //               child: KText(text:snapshot.data!.docs[0]['date'].toString(), style: GoogleFonts.openSans(fontSize: 18),)),
                         //
                         //           SizedBox(
                         //               width: 100,
                         //               child: KText(text:snapshot.data!.docs[0]['time'].toString(), style: GoogleFonts.openSans(fontSize: 18),)),
                         //         ],
                         //       );
                         //     }else{
                         //       return SizedBox.shrink();
                         //     }
                         //   },),



                         StreamBuilder(
                           stream: FirebaseFirestore.instance.collection('Users').doc(document.id).collection('entries').orderBy('timestamp', descending: true).snapshots(),
                           builder: (context, snapshot) {
                             if(snapshot.hasData && snapshot.data!.docs.isNotEmpty){
                               return Row(
                                 children: [
                                   Container(
                                       width: 200,
                                       child: KText(text:snapshot.data!.docs[0]['date'].toString(), style: GoogleFonts.openSans(fontSize: 18),)),
                                   SizedBox(
                                       width: 100,
                                       child: KText(text:snapshot.data!.docs[0]['time'].toString(), style: GoogleFonts.openSans(fontSize: 18),)),
                                 ],
                               );
                             } else {
                               return SizedBox.shrink(); // If no data, return an empty widget
                             }
                           },
                         ),



                       ],),
                   ),
                 );
               }
             },
             itemCount: length,
           );
         }else{
           return CircularProgressIndicator();
         }
       },),



   ],
 )



     : Container()


        // : Container(),



    ]
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
    // Get the current time as a Firestore Timestamp object
    Timestamp currentTime = Timestamp.now();

    // adding the data
    await subcollectionRef.add({
      'status': 'true',
      'date': DateFormat('dd-MM-yyyy').format(DateTime.now()),
      'time':  DateFormat('h:mm a').format(DateTime.now()),
      'timestamp' : DateTime.now().millisecondsSinceEpoch
    });
      setState(() {
        selectedUser!['status'] = true;
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

    await subcollectionRef.add({
      'status': 'false',
      'date': DateFormat('dd-MM-yyyy').format(DateTime.now()),
      'time':  DateFormat('h:mm a').format(DateTime.now()),
      'timestamp' : DateTime.now().millisecondsSinceEpoch
    });
    setState(() {
      selectedUser!['status'] = false;
    });
 }
  Widget getStatusButton(bool status) {
    return status
        ?
    SizedBox(
      width: 100,
      height: 29,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
          MaterialStateProperty.all<Color>(Color(0xffDDFFE7)),
        ),
        onPressed: () {},
        child: KText(
          text:'In Room',
          style: GoogleFonts.openSans(
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
        child: KText(
          text:'Out Room',
          style: GoogleFonts.openSans(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xffF12D2D),
          ),
        ),
      ),
    );
  }

  Future<void> updateUserStatus(bool isCheckedIn, String userDocId) async {
    final userStatus = isCheckedIn ? 'checkin' : 'checkout';
    final userTime = DateTime.now().millisecondsSinceEpoch;
    final userDate = DateTime.now().toLocal().toString();

    // Query the collection to check if there's an existing record for the user
    final querySnapshot = await FirebaseFirestore.instance
        .collection(userStatus)
    /// changing
        .where('userid', isEqualTo: userDocId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // If there's an existing record, update it
      final existingRecord = querySnapshot.docs.first;
      await existingRecord.reference.update({
        'time': userTime,
        'date': userDate,
      });
    } else {
      // If there's no existing record, add a new one
      await FirebaseFirestore.instance.collection(userStatus).add({
        // 'userId': userDocId,
        ///here changed
        'userid' : userDocId,
        'name': selectedUser!['name'],
        'status': isCheckedIn,
        'time': userTime,
        'date': userDate,
      });
    }
    try {
      // Convert DateTime to Timestamp
      // Timestamp timestamp = Timestamp.fromDate(DateTime.now());

      // Update the user's status and statusTime in the Users collection
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userDocId)
          .update({'status': isCheckedIn,
        // 'statusTime': '12/12/21'
          });

      print('Status and statusTime updated successfully.');
    } catch (e) {
      print('Error updating status and statusTime: $e');
    }


    // Perform additional actions based on the user's status
    if (isCheckedIn) {
      print('Checked In');
      statusTrue();
    } else {
      print('Checked Out');
      statusFalse();
    }
  }




  getData(){
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text( 'Check Out Users', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 20),),
        ),

        SizedBox(height: 20,),
        Container(
          decoration: BoxDecoration(border: Border.all(color: const Color(0xff262626).withOpacity(0.10)), borderRadius: BorderRadius.circular(30) ),
          child:
          SizedBox(
            height: 40,
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                      width: 70,
                      child: KText(text:'S.No', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 18),)),
                  SizedBox(
                      width: 100,
                      child: KText(text:'User ID', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),)),
                  SizedBox(
                      width: 170,
                      child: KText(text:'Name', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),)),
                  SizedBox(
                      width: 100,
                      child: KText(text:'Phone No', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),)),
                  SizedBox(
                      width: 100,
                      child: Center(child: KText(text:'Date', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),))),
                  SizedBox(
                      width: 100,
                      child: Center(child: KText(text:'Time', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),))),
                ],),
            ),
          ),
        ),


        StreamBuilder(stream: FirebaseFirestore.instance.collection('Users').where('status', isEqualTo: false).snapshots(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var document = snapshot.data!.docs[index];
                  int serialNumber = index + 1;
                  if(snapshot.hasData){
                    return Padding(
                      padding: const EdgeInsets.only(left: 0, right: 0),
                      child:
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                                width: 100,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 35),
                                  child: KText(text:serialNumber.toString(), style: GoogleFonts.openSans(fontSize: 18),),
                                )),
                            SizedBox(
                                width: 100,
                                child: KText(text: document['userid'], style: GoogleFonts.openSans( fontSize: 18),)),
                            SizedBox(
                                width: 170,
                                child: KText(text:document['firstName'], style: GoogleFonts.openSans( fontSize: 18),)),
                            SizedBox(
                                width: 120,
                                child: KText(text:document['phone'], style: GoogleFonts.openSans( fontSize: 18),)),

                            StreamBuilder(stream: FirebaseFirestore.instance.collection('Users').doc(document.id).collection('entries').orderBy('timestamp', descending: true).snapshots(),
                              builder: (context, snapshot) {
                              if(snapshot.hasData){
                            return Row(
                              children: [
                                SizedBox(
                                        width: 100,
                                        child: Center(child: KText(text:snapshot.data!.docs[1]['time'], style: GoogleFonts.openSans(fontSize: 18),))),

                                SizedBox(
                                    width: 100,
                                    child: Center(child: KText(text:snapshot.data!.docs[1]['date'], style: GoogleFonts.openSans(fontSize: 18),))),

                              ],
                            );

                            }else{
                                return Text('');
                              }
                            },),
                          ],),
                      ),
                    );
                  }
                },
                itemCount: snapshot.data!.docs.length,
              );
            }else{
              return CircularProgressIndicator();
            }
          },),

      ],
    );

  }

  /// for the notification...

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
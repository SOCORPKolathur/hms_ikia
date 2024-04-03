import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/RUsableCommunication.dart';
import '../widgets/ReusableHeader.dart';
import '../widgets/communicationTextfield.dart';
import '../widgets/customtextfield.dart';
import '../widgets/kText.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  static const IconData notifications = IconData(0xe44f, fontFamily: 'MaterialIcons');
  final TextEditingController SubjectCont = TextEditingController();
  final TextEditingController msgController = TextEditingController();
  List<String> blockNames = [];
  List<String> roomNumbers = [];
  List<String> phoneNumbers = [];
  List<String> pincodes = [];

  String selectedBlock = 'Select the value';
  String selectedRoom = 'Select the value';
  String selectedPhoneNum= 'Select Phone Number';
  String selectedPincode= 'Select Phone Number';

  @override
  void initState() {
    super.initState();
    fetchPhoneNumber();
    fetchBlockNames();
    fetchPincode();
  }
  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const ReusableHeader(
                  Headertext: 'Notifications',
                  SubHeadingtext: '"Connect and collaborate effortlessly"'),
              SizedBox.fromSize(size: const Size(0, 10)),
              //   a mini container for view email button
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xff262626).withOpacity(0.10)),
                  borderRadius: BorderRadius.circular(30),
                ),
                child:
                SizedBox(
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 45,
                        child: ElevatedButton(
                            style:  const ButtonStyle(
                                elevation: MaterialStatePropertyAll(3),
                                backgroundColor: MaterialStatePropertyAll(Color(0xffE2CB3F))),
                            onPressed: (){}, child: Row(
                          children: [
                            KText(text:'View Notification', style: GoogleFonts.openSans(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),),
                            const SizedBox(width: 8,),
                            const Icon(Icons.notifications, color: Colors.white, size: 20,)
                          ],)
                        ),
                      ),

                      const SizedBox(width: 20,)
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              KText( text: 'Send Alert Notification', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 800,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(color: const Color(0xff262626).withOpacity(0.1))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReusableDropdown4Commu(dropDownItems: const ['Alert', 'Vocation', 'Exam', 'Other'], hintText: 'Notify Type', onChanged: (value){}),
                          ReusableDropdown4Commu(dropDownItems: const ['Parents', 'Guardian', 'Student'], hintText: 'Person', onChanged: (value){}),
                          ReusableDropdown4Commu(dropDownItems: blockNames, hintText: 'Block No', onChanged: (value){
                            setState(() {
                              selectedBlock  = value!;
                            });
                            fetchRoomNames(value!);
                            selectedRoom = 'Select the value';
                          }),
                          ReusableDropdown4Commu(dropDownItems: roomNumbers, hintText: 'Room No', onChanged: (value){
                            setState(() {
                              selectedRoom = value!;
                            });
                          }),
                        ],),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReusableDropdown4Commu(dropDownItems: const ['Male', 'Female', 'Transgender'], hintText: 'Gender', onChanged: (value){}),
                          ReusableDropdown4Commu(dropDownItems: const ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'], hintText: 'Blood Group', onChanged: (value){}),
                          ReusableDropdown4Commu(dropDownItems: phoneNumbers, hintText: 'Phone Number', onChanged: (value){
                            setState(() {
                              selectedPhoneNum  = value!;
                            });
                            // fetchPhoneNumber();
                            selectedPhoneNum = 'Select the value';
                          }),
                          ReusableDropdown4Commu(dropDownItems:pincodes, hintText: 'Pin Code', onChanged: (value){
                            setState(() {
                              selectedPincode = value!;
                            });
                            selectedPincode = 'Select Pincode';
                          }),
                        ],),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            child:  SizedBox(
                              height: 45,
                              child: ElevatedButton(
                                  style:  const ButtonStyle(
                                      elevation: MaterialStatePropertyAll(3),
                                      backgroundColor: MaterialStatePropertyAll(Color(0xff37D1D3))),
                                  onPressed: (){}, child: Row(
                                children: [
                                  Text('Apply', style: GoogleFonts.openSans(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),),
                                  const SizedBox(width: 8,),
                                  const Icon(Icons.check_circle, color: Colors.white, size: 20,)
                                ],)),
                            ),
                          ),
                          SizedBox(width: 20,)
                        ],
                      ),
                      SizedBox(height: 15,),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25, top: 8.0, bottom: 8.0),
                        child: CommunicationTextfield(hint: 'Sub', controller: SubjectCont, validator: null, header: 'Subject:', width: double.infinity,),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25, top: 8.0, bottom: 8.0),
                        child: CommunicationTextfield(hint: 'Type Your Message Here...', controller: msgController, validator: null, header: 'Message:', width: double.infinity, height: 300,),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(width: 15,),
                          SizedBox(
                            height: 45,
                            child: ElevatedButton(
                                style:  const ButtonStyle(
                                    elevation: MaterialStatePropertyAll(2),
                                    backgroundColor: MaterialStatePropertyAll(Color(0xffFFFFFF))),
                                onPressed: (){}, child: Row(
                              children: [
                                Text('Cancel', style: GoogleFonts.openSans(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xff37D1D3)),),
                              ],)
                            ),
                          ),
                          SizedBox(width: 15,),
                          SizedBox(
                            height: 45,
                            child: ElevatedButton(
                                style:  const ButtonStyle(
                                    elevation: MaterialStatePropertyAll(3),
                                    backgroundColor: MaterialStatePropertyAll(Color(0xff37D1D3))),
                                onPressed: (){
                                  AlertSuccessPopUp();

                                }, child: Row(
                              children: [
                                Text('Send', style: GoogleFonts.openSans(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),),
                                const SizedBox(width: 8,),
                                const Icon(Icons.mail_lock, color: Colors.white, size: 20,)
                              ],)
                            ),
                          ),
                          SizedBox(width: 25,),
                        ],)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );

  }
  void fetchBlockNames() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Room').get();
    List<String> names = querySnapshot.docs.map((doc) => doc.get('blockname') as String).toSet().toList();
    setState(() {
      blockNames = names;
      selectedBlock = 'Select the value';
    });
  }
  void fetchRoomNames(String blockName) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Room').where('blockname', isEqualTo: blockName).get();
    List<String> roomNames = querySnapshot.docs.map((doc) => doc.get('roomnumber') as String).toList();
    setState(() {
      roomNumbers = roomNames;
      selectedRoom = 'Select the value';
    });
  }
  void fetchPhoneNumber() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('Users').get();
    List<String> fetchedPhoneNumbers = querySnapshot.docs
        .map((doc) => doc.get('phone') as String)
        .toList();
    setState(() {
      selectedPhoneNum = 'Select Phone Number';
      phoneNumbers = fetchedPhoneNumbers; // Update the state variable correctly
    });
  }
  void fetchPincode() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('Users').get();
    List<String> fetchedPincode = querySnapshot.docs
        .map((doc) => doc.get('pincode') as String)
        .toList();
    setState(() {
      selectedPincode = 'Select Phone Number';
      pincodes = fetchedPincode;
    });
  }
//   Pop Up for the Message send
  Future<void> AlertSuccessPopUp() async {
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
              KText(text:'', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
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
            height: 330,
            width: 500,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // SizedBox(
                    //     width: 200,
                    //     child: Image.asset('assets/ui-design-/images/Messaging-cuate .png')),
                    // Positioned(
                    //   left:-20,
                    //   child: SizedBox(
                    //       width: 100,
                    //       child: Image.asset('assets/ui-design-/images/frameL.png')),
                    // ),
                    // Positioned(
                    //   right: -20,
                    //   child: SizedBox(
                    //       width: 100,
                    //       child: Image.asset('assets/ui-design-/images/FrameR.png')),
                    // ),
                    SizedBox(width: 400,
                    child: Image.asset('assets/ui-design-/images/FrameFull.png'),
                    )
                  ],
                ),
                KText(text: 'Message Sent Successfully ! ', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 16))
              ,SizedBox(height: 8,),
               SizedBox(child:

               KText(text: 'Your message has been successfully sent.', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xff262626).withOpacity(0.8))),

                 ),
               SizedBox(height: 20,),
                SizedBox(
                  height: 40,
                  width: 120,
                  child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff1DA644))),
                      onPressed: (){
                        Navigator.pop(context);
                      }, child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          KText(text:'Done', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, color: Colors.white),),
                       CircleAvatar(backgroundColor: Colors.transparent,radius: 13,backgroundImage: AssetImage('assets/ui-design-/images/Ok.png',),)
                        ],
                      )),
                )
              ],
            ),
          )
        );
      },
    );
  }



}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_icons/animate_icons.dart';
import 'package:hms_ikia/Constants/constants.dart';
import 'package:hms_ikia/Views/ComNotifications.dart';
import 'package:hms_ikia/Views/SMSPage.dart';
import 'package:hms_ikia/Views/asset_tab.dart';
import 'package:hms_ikia/Views/birthday_wishes.dart';
import 'package:hms_ikia/Views/block_name.dart';
import 'package:hms_ikia/Views/complains.dart';
import 'package:hms_ikia/Views/email.dart';
import 'package:hms_ikia/Views/entry.dart';
import 'package:hms_ikia/Views/fees.dart';
import 'package:hms_ikia/Views/records.dart';
import 'package:hms_ikia/Views/resident_tab.dart';
import 'package:hms_ikia/Views/rooms.dart';
import 'package:hms_ikia/Views/userPermission.dart';
import 'package:hms_ikia/Views/vistor.dart';
import 'package:hms_ikia/widgets/kText.dart';
import 'package:animate_do/animate_do.dart';
import 'MessTimeTable.dart';
import 'dashboard.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});
  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}
class _HomeDrawerState extends State<HomeDrawer> {
  int dawer = 0;
  var pages;
  bool isOn = false;
  @override
  void initState() {
    //addinglist();
    getHostelDetails();
    getroleDetail();
    setState(() {
      pages = const Dashboard();
    });
    c1 = AnimateIconController();
    c2 = AnimateIconController();
    c3 = AnimateIconController();
    c4 = AnimateIconController();
    c5 = AnimateIconController();
    c6 = AnimateIconController();
    // TODO: implement initState
    super.initState();
  }
  ExpansionTileController admissioncon= new ExpansionTileController();
  ExpansionTileController studdentcon= new ExpansionTileController();
  ExpansionTileController staffcon= new ExpansionTileController();
  ExpansionTileController attdencecon= new ExpansionTileController();
  ExpansionTileController feescon= new ExpansionTileController();
  ExpansionTileController examcon= new ExpansionTileController();
  ExpansionTileController hrcon= new ExpansionTileController();
  ExpansionTileController noticescon= new ExpansionTileController();
  ExpansionTileController timetable= new ExpansionTileController();
  bool col1=false;
  bool col2=false;
  bool col3=false;
  bool col4=false;
  bool col5=false;
  bool col6=false;
  bool col7=false;
  bool col8=false;
  bool col9=false;
  String pagename="";
  late AnimateIconController c1, c2, c3, c4, c5, c6;
  bool onEndIconPress(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: KText(text:"onEndIconPress called",style: TextStyle(),),
        duration: Duration(seconds: 1),
      ),
    );
    return true;
  }
  bool onStartIconPress(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: KText(text:"onStartIconPress called",style: TextStyle()),
        duration: Duration(seconds: 1),
      ),
    );
    return true;
  }
  String hostellogo = '';
  String hostelname = '';

  getHostelDetails() async {
    var hostel = await FirebaseFirestore.instance.collection('HostelDetails').get();
    setState(() {
      hostellogo = hostel.docs.first.get("logo");
      hostelname = hostel.docs.first.get("hostelname");
    });
  }
  getroleDetail() async {
    var roleDetail = await FirebaseFirestore.instance.collection('Roles').where('username', isEqualTo: FirebaseAuth.instance.currentUser!.email).get();
    setState(() {
      modules = roleDetail.docs[0]['modules'];
    });
  }
  List modules = [];

  @override
  Widget build(BuildContext context) {
    final double width=MediaQuery.of(context).size.width;
    final double height=MediaQuery.of(context).size.height;
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: width/5.939,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(),
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: width/5.00,
                      height: height,
                      decoration: const BoxDecoration(
                         borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                        color: Colors.white,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              width: width/4.878,
                              height: height/6.57,
                              child: Row(
                                children: [
                                  // Image.asset("assets/imagevidh.png"),
                                  Row(
                                    children: [
                                      const SizedBox(width:8),
                                      GestureDetector(
                                        onTap: (){
                                          print("Clicked");
                                          //fordatabase();
                                        },
                                        child: Container(
                                            width: 55,
                                            child: CachedNetworkImage(imageUrl: hostellogo)
                                        ),
                                      ),
                                      const SizedBox(width:10),
                                      KText(text:
                                      hostelname,
                                        style: GoogleFonts.kanit(
                                            fontSize: 23,
                                            fontWeight: FontWeight.w600,
                                            //color:Color(0xffb80d38)
                                            color:Colors.black
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            /// dashboard
                            Visibility(
                              visible: modules.contains('Dashboard'),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    child: AnimatedContainer(
                                      height: 35,
                                      duration: const Duration(milliseconds: 700),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding:  EdgeInsets.only(left: dawer == 0 ? 10.0 :0),
                                      child: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          AnimatedContainer(
                                            curve: Curves.fastOutSlowIn,
                                            duration: const Duration(milliseconds: 700),
                                            padding: const EdgeInsets.only(left: 50),
                                            width:  dawer == 0
                                                ? 200 : 0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: dawer == 0
                                                  ? Constants().primaryAppColor : Colors.transparent,
                                            ),
                                          ),
                                          // dashboard
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                pages=const Dashboard();
                                                dawer=0;
                                                col1=false;
                                                col2=false;
                                                col3=false;
                                                col4=false;
                                                col5=false;
                                                col6=false;
                                                col7=false;
                                                col8=false;
                                                col9=false;
                                                pagename="";
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: KText(text:
                                                  "Dashboard",
                                                    style: GoogleFonts.openSans(
                                                        fontSize: width/95,
                                                        fontWeight: FontWeight.w500,
                                                        color: dawer == 0 ?  Colors.white : const Color(0xff9197B3)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5,),
                                ],
                              ),
                            ),
                            /// Resident Management
                            Visibility(
                              visible: modules.contains("Resident Management"),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    child: AnimatedContainer(
                                      height: 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding:  EdgeInsets.only(left: dawer == 1 ? 10.0 :0),
                                      duration: const Duration(milliseconds: 700),
                                      child: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          AnimatedContainer(
                                            curve: Curves.fastOutSlowIn,
                                            duration: const Duration(milliseconds: 700),
                                            padding: const EdgeInsets.only(left: 50),
                                            width:  dawer == 1
                                                ? 200 : 0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: dawer == 1
                                                  ? Constants().primaryAppColor : Colors.transparent,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                pages=const Resident_Tab();
                                                dawer=1;
                                                col1=false;
                                                col2=false;
                                                col3=false;
                                                col4=false;
                                                col5=false;
                                                col6=false;
                                                col7=false;
                                                col8=false;
                                                col9=false;
                                                pagename="";
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: KText(text:
                                                  "Resident Management",
                                                    style: GoogleFonts.openSans(
                                                        fontSize: width/95,
                                                        fontWeight: FontWeight.w500,
                                                        color: dawer == 1 ?  Colors.white : const Color(0xff9197B3)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                ],
                              ),
                            ),
                            /// Entry and records
                            Visibility(
                              visible: modules.contains('Entry & Records'),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    child: AnimatedContainer(
                                      height: 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding:  EdgeInsets.only(left: dawer == 2 ? 10.0 :0),
                                      duration: const Duration(milliseconds: 700),
                                      child: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          AnimatedContainer(
                                            curve: Curves.fastOutSlowIn,
                                            duration: const Duration(milliseconds: 700),
                                            padding: const EdgeInsets.only(left: 50),
                                            width:  dawer == 2
                                                ? 200 : 0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: dawer == 2
                                                  ? Constants().primaryAppColor : Colors.transparent,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                pages=const Entry();
                                                dawer=2;
                                                col1=false;
                                                col2=false;
                                                col3=false;
                                                col4=false;
                                                col5=false;
                                                col6=false;
                                                col7=false;
                                                col8=false;
                                                col9=false;
                                                pagename="";
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: KText(text:
                                                  "Entry & Records",
                                                    style: GoogleFonts.openSans(
                                                        fontSize: width/95,
                                                        fontWeight: FontWeight.w500,
                                                        color: dawer == 2 ?  Colors.white : const Color(0xff9197B3)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                ],
                              ),
                            ),
                            /// Block
                            Visibility(
                              visible: modules.contains('Block'),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    child: AnimatedContainer(
                                      height: 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding:  EdgeInsets.only(left: dawer == 12 ? 10.0 :0),
                                      duration: const Duration(milliseconds: 700),
                                      child: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          AnimatedContainer(
                                            curve: Curves.fastOutSlowIn,
                                            duration: const Duration(milliseconds: 700),
                                            padding: const EdgeInsets.only(left: 50),
                                            width:  dawer == 12
                                                ? 200 : 0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: dawer == 12
                                                  ? Constants().primaryAppColor : Colors.transparent,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                pages=const BlockName();
                                                dawer=12;
                                                col1=false;
                                                col2=false;
                                                col3=false;
                                                col4=false;
                                                col5=false;
                                                col6=false;
                                                col7=false;
                                                col8=false;
                                                col9=false;
                                                pagename="";
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: KText(text:
                                                  "Block",
                                                    style: GoogleFonts.openSans(
                                                        fontSize: width/95,
                                                        fontWeight: FontWeight.w500,
                                                        color: dawer == 12 ?  Colors.white : const Color(0xff9197B3)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 5,),
                                ],
                              ),
                            ),
                            ///Room and bed
                            Visibility(
                              visible: modules.contains('Room and Bed Allocation'),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    child: AnimatedContainer(
                                      height: 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding:  EdgeInsets.only(left: dawer == 3 ? 10.0 :0),
                                      duration: const Duration(milliseconds: 700),
                                      child: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          AnimatedContainer(
                                            curve: Curves.fastOutSlowIn,
                                            duration: const Duration(milliseconds: 700),
                                            padding: const EdgeInsets.only(left: 50),
                                            width:  dawer == 3
                                                ? 200 : 0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: dawer == 3
                                                  ? Constants().primaryAppColor : Colors.transparent,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                pages=const Rooms();
                                                dawer=3;
                                                col1=false;
                                                col2=false;
                                                col3=false;
                                                col4=false;
                                                col5=false;
                                                col6=false;
                                                col7=false;
                                                col8=false;
                                                col9=false;
                                                pagename="";
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: KText(text:
                                                  "Room & Bed Allocation",
                                                    style: GoogleFonts.openSans(
                                                        fontSize: width/95,
                                                        fontWeight: FontWeight.w500,
                                                        color: dawer == 3 ?  Colors.white : const Color(0xff9197B3)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 5,),
                                ],
                              ),
                            ),
                            /// Asset Management
                            Visibility(
                              visible: modules.contains('Asset Management'),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    child: AnimatedContainer(
                                      height: 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding:  EdgeInsets.only(left: dawer == 8 ? 10.0 :0),
                                      duration: const Duration(milliseconds: 700),
                                      child: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          AnimatedContainer(
                                            curve: Curves.fastOutSlowIn,
                                            duration: const Duration(milliseconds: 700),
                                            padding: const EdgeInsets.only(left: 50),
                                            width:  dawer == 8
                                                ? 200 : 0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: dawer == 8
                                                  ? Constants().primaryAppColor : Colors.transparent,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                pages= const AssetManagement();
                                                dawer=8;
                                                col1=false;
                                                col2=false;
                                                col3=false;
                                                col4=false;
                                                col5=false;
                                                col6=false;
                                                col7=false;
                                                col8=false;
                                                col9=false;
                                                pagename="";
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: KText(text:
                                                  "Asset Management",
                                                    style: GoogleFonts.openSans(
                                                        fontSize: width/95,
                                                        fontWeight: FontWeight.w500,
                                                        color: dawer == 8 ?  Colors.white : const Color(0xff9197B3)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 5,),
                                ],
                              ),
                            ),
                            /// Attendance
                            Visibility(
                              visible: modules.contains('Attendance'),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    child: AnimatedContainer(
                                      height: 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding:  EdgeInsets.only(left: dawer == 4 ? 10.0 :0),
                                      duration: const Duration(milliseconds: 700),
                                      child: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          AnimatedContainer(
                                            curve: Curves.fastOutSlowIn,
                                            duration: const Duration(milliseconds: 700),
                                            padding: const EdgeInsets.only(left: 50),
                                            width:  dawer == 4
                                                ? 200 : 0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: dawer == 4
                                                  ? Constants().primaryAppColor : Colors.transparent,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                pages=const Records();
                                                dawer=4;
                                                col1=false;
                                                col2=false;
                                                col3=false;
                                                col4=false;
                                                col5=false;
                                                col6=false;
                                                col7=false;
                                                col8=false;
                                                col9=false;
                                                pagename="";
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: KText(text:
                                                  "Attendance",
                                                    style: GoogleFonts.openSans(
                                                        fontSize: width/95,
                                                        fontWeight: FontWeight.w500,
                                                        color: dawer == 4 ?  Colors.white : const Color(0xff9197B3)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 5,),
                                ],
                              ),
                            ),
                            /// Fees & Billing
                            Visibility(
                              visible: modules.contains('Fees and Billing'),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    child: AnimatedContainer(
                                      height: 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding:  EdgeInsets.only(left: dawer == 5 ? 10.0 :0),
                                      duration: const Duration(milliseconds: 700),
                                      child: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          AnimatedContainer(
                                            curve: Curves.fastOutSlowIn,
                                            duration: const Duration(milliseconds: 700),
                                            padding: const EdgeInsets.only(left: 50),
                                            width:  dawer == 5
                                                ? 200 : 0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: dawer == 5
                                                  ? Constants().primaryAppColor : Colors.transparent,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                pages = const FeesPage();
                                                dawer=5;
                                                col1=false;
                                                col2=false;
                                                col3=false;
                                                col4=false;
                                                col5=false;
                                                col6=false;
                                                col7=false;
                                                col8=false;
                                                col9=false;
                                                pagename="";
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: KText(text:
                                                  "Fees & Billing",
                                                    style: GoogleFonts.openSans(
                                                        fontSize: width/95,
                                                        fontWeight: FontWeight.w500,
                                                        color: dawer == 5 ?  Colors.white : const Color(0xff9197B3)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 5,),
                                ],
                              ),
                            ),
                            /// Visitor Management
                            Visibility(
                              visible: modules.contains('Visitor Management'),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    child: AnimatedContainer(
                                      height: 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding:  EdgeInsets.only(left: dawer == 10 ? 10.0 :0),
                                      duration: const Duration(milliseconds: 700),
                                      child: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          AnimatedContainer(
                                            curve: Curves.fastOutSlowIn,
                                            duration: const Duration(milliseconds: 700),
                                            padding: const EdgeInsets.only(left: 50),
                                            width:  dawer == 10
                                                ? 200 : 0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: dawer == 10
                                                  ? Constants().primaryAppColor : Colors.transparent,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                pages = const Visitor_Page();
                                                dawer=10;
                                                col1=false;
                                                col2=false;
                                                col3=false;
                                                col4=false;
                                                col5=false;
                                                col6=false;
                                                col7=false;
                                                col8=false;
                                                col9=false;
                                                pagename="";
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: KText(text:
                                                  "Visitor Management",
                                                    style: GoogleFonts.openSans(
                                                        fontSize: width/95,
                                                        fontWeight: FontWeight.w500,
                                                        color: dawer == 10 ?  Colors.white : const Color(0xff9197B3)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              const SizedBox(height: 5,),

                                ],
                              ),
                            ),
                            /// communication
                            Visibility(
                              visible: modules.contains('Email') || modules.contains('Sms') || modules.contains('Notifications') ? true : false,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    child: AnimatedContainer(
                                      // height:  dawer == 9
                                      //     ? 170 : 35,
                                      height: dawer == 9 && isOn == true ? 170 : 40,

                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding:  EdgeInsets.only(left: dawer == 9 ? 10.0 :0),
                                      duration: const Duration(milliseconds: 400),
                                      child: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          AnimatedContainer(
                                            curve: Curves.fastOutSlowIn,
                                            duration: const Duration(milliseconds: 400),
                                            padding: const EdgeInsets.only(left: 50),
                                            width:  dawer == 9
                                                ? 200 : 0,
                                            // height: dawer == 9
                                            //     ? 170 : 35,
                                            height: isOn == true && dawer == 9 ? 170 : 40,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: dawer == 9
                                                  ? Constants().primaryAppColor : Colors.transparent,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              isOn = !isOn;
                                              setState(() {
                                                dawer=9;
                                                col1=false;
                                                col2=false;
                                                col3=false;
                                                col4=false;
                                                col5=false;
                                                col6=false;
                                                col7=false;
                                                col8=false;
                                                col9=false;
                                                pagename="";
                                              });
                                            },
                                            child: Column(
                                              children: [
                                                const SizedBox(height: 8),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 8.0),
                                                      child: Container(
                                                        width: 160,
                                                        child: KText(text:
                                                        "Communication",
                                                          style: GoogleFonts.openSans(
                                                              fontSize: width/95,
                                                              fontWeight: FontWeight.w500,
                                                              color: dawer == 9 ?  Colors.white : const Color(0xff9197B3)),
                                                        ),
                                                      ),
                                                    ),
                                                    Icon(Icons.arrow_drop_down,color: dawer == 9 ?  Colors.white : const Color(0xff9197B3),)
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                InkWell(
                                                  onTap: (){
                                                    setState(() {
                                                      pagename = "Email";
                                                      pages= const EmailPage();
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 180,
                                                    height: 35,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20),
                                                      color: pagename == "Email"
                                                          ? Colors.white : Colors.transparent,
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 8.0),
                                                          child: Container(
                                                            width: 160,
                                                            child: KText(
                                                              text:
                                                            "Email",
                                                              style: GoogleFonts.openSans(
                                                                  fontSize: width/95,
                                                                  fontWeight: FontWeight.w500,
                                                                  color: pagename == "Email"
                                                                      ?  Constants().primaryAppColor : Colors.white ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                InkWell(
                                                  onTap: (){
                                                    setState(() {
                                                      pagename = "SMS";
                                                      pages= const SMSPage();
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 180,
                                                    height: 35,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20),
                                                      color: pagename == "SMS"
                                                          ? Colors.white : Colors.transparent,
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 8.0),
                                                          child: Container(
                                                            width: 160,
                                                            child: KText(
                                                              text:
                                                              "SMS",
                                                              style: GoogleFonts.openSans(
                                                                  fontSize: width/95,
                                                                  fontWeight: FontWeight.w500,
                                                                  color: pagename == "SMS"
                                                                      ?  Constants().primaryAppColor : Colors.white ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                InkWell(
                                                  onTap: (){
                                                    setState(() {
                                                      pagename = "Notifications";
                                                      pages= const NotificationsPage();
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 180,
                                                    height: 35,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20),
                                                      color: pagename == "Notifications"
                                                          ? Colors.white : Colors.transparent,
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 8.0),
                                                          child: Container(
                                                            width: 160,
                                                            child: KText(
                                                              text:
                                                              "Notifications",
                                                              style: GoogleFonts.openSans(
                                                                  fontSize: width/95,
                                                                  fontWeight: FontWeight.w500,
                                                                  color: pagename == "Notifications"
                                                                      ?  Constants().primaryAppColor : Colors.white ),
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
                                        ],
                                      ),
                                    ),
                                  ),
                                                          const SizedBox(height: 5,),
                                ],
                              ),
                            ),
                            /// user permission
                            Visibility(
                              visible: modules.contains('User Permissions'),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    child: AnimatedContainer(
                                      height: 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding:  EdgeInsets.only(left: dawer == 11 ? 10.0 :0),
                                      duration: const Duration(milliseconds: 700),
                                      child: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          AnimatedContainer(
                                            curve: Curves.fastOutSlowIn,
                                            duration: const Duration(milliseconds: 700),
                                            padding: const EdgeInsets.only(left: 50),
                                            width:  dawer == 11
                                                ? 200 : 0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: dawer == 11
                                                  ? Constants().primaryAppColor : Colors.transparent,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                // pages = Dashboard2(currentRole: widget.currentRole, sessionStateStream: widget.sessionStateStream);
                                                pages = const userPermission();
                                                dawer=11;
                                                col1=false;
                                                col2=false;
                                                col3=false;
                                                col4=false;
                                                col5=false;
                                                col6=false;
                                                col7=false;
                                                col8=false;
                                                col9=false;
                                                pagename="";
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: KText(text:
                                                  "User Permissions",
                                                    style: GoogleFonts.openSans(
                                                        fontSize: width/95,
                                                        fontWeight: FontWeight.w500,
                                                        color: dawer == 11 ?  Colors.white : const Color(0xff9197B3)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 5,),
                                ],
                              ),
                            ),
                            /// mess time table
                            Visibility(
                              visible: modules.contains('Mess Time Table'),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    child: AnimatedContainer(
                                      height: 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding:  EdgeInsets.only(left: dawer == 13 ? 10.0 :0),
                                      duration: const Duration(milliseconds: 700),
                                      child: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          AnimatedContainer(
                                            curve: Curves.fastOutSlowIn,
                                            duration: const Duration(milliseconds: 700),
                                            padding: const EdgeInsets.only(left: 50),
                                            width:  dawer == 13
                                                ? 200 : 0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: dawer == 13
                                                  ? Constants().primaryAppColor : Colors.transparent,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                // pages = Dashboard2(currentRole: widget.currentRole, sessionStateStream: widget.sessionStateStream);
                                                pages = const MessTimeTable();
                                                dawer=13;
                                                col1=false;
                                                col2=false;
                                                col3=false;
                                                col4=false;
                                                col5=false;
                                                col6=false;
                                                col7=false;
                                                col8=false;
                                                col9=false;
                                                pagename="";
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: KText(text:
                                                  "Mess TimeTable",
                                                    style: GoogleFonts.openSans(
                                                        fontSize: width/95,
                                                        fontWeight: FontWeight.w500,
                                                        color: dawer == 13 ?  Colors.white : const Color(0xff9197B3)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5,),
                                ],
                              ),
                            ),
                            /// Complaints
                            Visibility(
                              visible: modules.contains('Complaints'),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    child: AnimatedContainer(
                                      height: 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding:  EdgeInsets.only(left: dawer == 14 ? 10.0 :0),
                                      duration: const Duration(milliseconds: 700),
                                      child: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          AnimatedContainer(
                                            curve: Curves.fastOutSlowIn,
                                            duration: const Duration(milliseconds: 700),
                                            padding: const EdgeInsets.only(left: 50),
                                            width:  dawer == 14
                                                ? 200 : 0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: dawer == 14
                                                  ? Constants().primaryAppColor : Colors.transparent,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                // pages = Dashboard2(currentRole: widget.currentRole, sessionStateStream: widget.sessionStateStream);
                                                pages = const Complaints();
                                                dawer=14;
                                                col1=false;
                                                col2=false;
                                                col3=false;
                                                col4=false;
                                                col5=false;
                                                col6=false;
                                                col7=false;
                                                col8=false;
                                                col9=false;
                                                pagename="";
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: KText(text:
                                                  "Complaints",
                                                    style: GoogleFonts.openSans(
                                                        fontSize: width/95,
                                                        fontWeight: FontWeight.w500,
                                                        color: dawer == 14 ?  Colors.white : const Color(0xff9197B3)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5,),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: modules.contains("Birthday Wishes"),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    child: AnimatedContainer(
                                      height: 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding:  EdgeInsets.only(left: dawer == 15 ? 10.0 :0),
                                      duration: const Duration(milliseconds: 700),
                                      child: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          AnimatedContainer(
                                            curve: Curves.fastOutSlowIn,
                                            duration: const Duration(milliseconds: 700),
                                            padding: const EdgeInsets.only(left: 50),
                                            width:  dawer == 15
                                                ? 200 : 0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: dawer == 15
                                                  ? Constants().primaryAppColor : Colors.transparent,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                // pages = Dashboard2(currentRole: widget.currentRole, sessionStateStream: widget.sessionStateStream);
                                                pages = const BirthdayWishes();
                                                dawer=15;
                                                col1=false;
                                                col2=false;
                                                col3=false;
                                                col4=false;
                                                col5=false;
                                                col6=false;
                                                col7=false;
                                                col8=false;
                                                col9=false;
                                                pagename="";
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: KText(text:
                                                  "Birthday Wishes",
                                                    style: GoogleFonts.openSans(
                                                        fontSize: width/95,
                                                        fontWeight: FontWeight.w500,
                                                        color: dawer == 15 ?  Colors.white : const Color(0xff9197B3)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5,),
                                ],
                              ),
                            ),



                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
         Padding(
            padding: const EdgeInsets.only(left: 0.0,top: 0),
            child: FadeInRight(
              child: Container(
                width: width/1.205,
                height: height/1,
                child: pages,
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_icons/animate_icons.dart';
import 'package:hms_ikia/Constants/constants.dart';
import 'package:hms_ikia/Views/ComNotifications.dart';
import 'package:hms_ikia/Views/SMSPage.dart';
import 'package:hms_ikia/Views/asset_tab.dart';
import 'package:hms_ikia/Views/block_name.dart';
import 'package:hms_ikia/Views/email.dart';
import 'package:hms_ikia/Views/entry.dart';
import 'package:hms_ikia/Views/fees.dart';
import 'package:hms_ikia/Views/login_page.dart';
import 'package:hms_ikia/Views/records.dart';
import 'package:hms_ikia/Views/resident_tab.dart';
import 'package:hms_ikia/Views/rooms.dart';
import 'package:hms_ikia/Views/vistor.dart';
import 'package:hms_ikia/widgets/kText.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:animate_do/animate_do.dart';
import 'dashboard.dart';


class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {


  int dawer = 0;
  var pages;
  @override
  void initState() {
    //addinglist();
    getHostelDetails();
    setState(() {
     pages=Dashboard();
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
      SnackBar(
        content: KText(text:"onEndIconPress called",style: TextStyle(),),
        duration: Duration(seconds: 1),
      ),
    );
    return true;
  }

  bool onStartIconPress(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: KText(text:"onStartIconPress called",style: TextStyle()),
        duration: Duration(seconds: 1),
      ),
    );
    return true;
  }


  String churchLogo = '';
  getHostelDetails() async {
    var church = await FirebaseFirestore.instance.collection('AdminDetails').get();
    setState(() {
      churchLogo = church.docs.first.get("logo");
    });

  }



  @override
  Widget build(BuildContext context) {
    final double width=MediaQuery.of(context).size.width;
    final double height=MediaQuery.of(context).size.height;
    return Scaffold(
      body: Row(
        children: [
          Container(
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
                      decoration: BoxDecoration(
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
                                      SizedBox(width:8),
                                      GestureDetector(
                                        onTap: (){
                                          print("Clicked");
                                          //fordatabase();
                                        },
                                        child: Container(
                                            width: 55,

                                            child: CachedNetworkImage(imageUrl: churchLogo)

                                        ),
                                      ),
                                      SizedBox(width:10),

                                      KText(text:
                                      " IKIA Hostel",
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

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: AnimatedContainer(

                                height: 35,
                                duration: Duration(milliseconds: 700),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),

                                ),
                                padding:  EdgeInsets.only(left: dawer == 0 ? 10.0 :0),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    AnimatedContainer(
                                      curve: Curves.fastOutSlowIn,
                                      duration: Duration(milliseconds: 700),
                                      padding: EdgeInsets.only(left: 50),
                                      width:  dawer == 0
                                          ? 200 : 0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: dawer == 0
                                            ? Constants().primaryAppColor : Colors.transparent,
                                      ),

                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          pages=Dashboard();
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
                                                  color: dawer == 0 ?  Colors.white : Color(0xff9197B3)),
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

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: AnimatedContainer(

                                height: 35,

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),

                                ),
                                padding:  EdgeInsets.only(left: dawer == 1 ? 10.0 :0),
                                duration: Duration(milliseconds: 700),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    AnimatedContainer(
                                      curve: Curves.fastOutSlowIn,
                                      duration: Duration(milliseconds: 700),
                                      padding: EdgeInsets.only(left: 50),
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
                                          pages=Resident_Tab();
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
                                                  color: dawer == 1 ?  Colors.white : Color(0xff9197B3)),
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
                            // Entry and records
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: AnimatedContainer(
                                height: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding:  EdgeInsets.only(left: dawer == 2 ? 10.0 :0),
                                duration: Duration(milliseconds: 700),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    AnimatedContainer(
                                      curve: Curves.fastOutSlowIn,
                                      duration: Duration(milliseconds: 700),
                                      padding: EdgeInsets.only(left: 50),
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
                                          pages=Entry();
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
                                                  color: dawer == 2 ?  Colors.white : Color(0xff9197B3)),
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
                            // Block
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: AnimatedContainer(
                                height: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding:  EdgeInsets.only(left: dawer == 12 ? 10.0 :0),
                                duration: Duration(milliseconds: 700),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    AnimatedContainer(
                                      curve: Curves.fastOutSlowIn,
                                      duration: Duration(milliseconds: 700),
                                      padding: EdgeInsets.only(left: 50),
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
                                          pages=BlockName();
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
                                                  color: dawer == 12 ?  Colors.white : Color(0xff9197B3)),
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
                            // This is Room and bed
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: AnimatedContainer(
                                height: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding:  EdgeInsets.only(left: dawer == 3 ? 10.0 :0),
                                duration: Duration(milliseconds: 700),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    AnimatedContainer(
                                      curve: Curves.fastOutSlowIn,
                                      duration: Duration(milliseconds: 700),
                                      padding: EdgeInsets.only(left: 50),
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
                                          pages=Rooms();
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
                                                  color: dawer == 3 ?  Colors.white : Color(0xff9197B3)),
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

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: AnimatedContainer(

                                height: 35,

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),

                                ),
                                padding:  EdgeInsets.only(left: dawer == 8 ? 10.0 :0),
                                duration: Duration(milliseconds: 700),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    AnimatedContainer(
                                      curve: Curves.fastOutSlowIn,
                                      duration: Duration(milliseconds: 700),
                                      padding: EdgeInsets.only(left: 50),
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
                                          pages= AssetManagement();
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
                                                  color: dawer == 8 ?  Colors.white : Color(0xff9197B3)),
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

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: AnimatedContainer(

                                height: 35,

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),

                                ),
                                padding:  EdgeInsets.only(left: dawer == 4 ? 10.0 :0),
                                duration: Duration(milliseconds: 700),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    AnimatedContainer(
                                      curve: Curves.fastOutSlowIn,
                                      duration: Duration(milliseconds: 700),
                                      padding: EdgeInsets.only(left: 50),
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
                                          pages=Records();
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
                                                  color: dawer == 4 ?  Colors.white : Color(0xff9197B3)),
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


                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: AnimatedContainer(

                                height: 35,

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),

                                ),
                                padding:  EdgeInsets.only(left: dawer == 5 ? 10.0 :0),
                                duration: Duration(milliseconds: 700),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    AnimatedContainer(
                                      curve: Curves.fastOutSlowIn,
                                      duration: Duration(milliseconds: 700),
                                      padding: EdgeInsets.only(left: 50),
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
                                          pages = FeesPage();
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
                                                  color: dawer == 5 ?  Colors.white : Color(0xff9197B3)),
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



                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: AnimatedContainer(

                                height: 35,

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),

                                ),
                                padding:  EdgeInsets.only(left: dawer == 10 ? 10.0 :0),
                                duration: Duration(milliseconds: 700),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    AnimatedContainer(
                                      curve: Curves.fastOutSlowIn,
                                      duration: Duration(milliseconds: 700),
                                      padding: EdgeInsets.only(left: 50),
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
                                          pages = Visitor_Page();
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
                                                  color: dawer == 10 ?  Colors.white : Color(0xff9197B3)),
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







                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: AnimatedContainer(

                                height:  dawer == 9
                                    ? 170 : 35,

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),

                                ),
                                padding:  EdgeInsets.only(left: dawer == 9 ? 10.0 :0),
                                duration: Duration(milliseconds: 400),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    AnimatedContainer(
                                      curve: Curves.fastOutSlowIn,
                                      duration: Duration(milliseconds: 400),
                                      padding: EdgeInsets.only(left: 50),
                                      width:  dawer == 9
                                          ? 200 : 0,
                                      height: dawer == 9
                                          ? 170 : 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: dawer == 9
                                            ? Constants().primaryAppColor : Colors.transparent,
                                      ),

                                    ),
                                    InkWell(
                                      onTap: () {
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
                                          SizedBox(height: 8),
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
                                                        color: dawer == 9 ?  Colors.white : Color(0xff9197B3)),
                                                  ),
                                                ),
                                              ),
                                              Icon(Icons.arrow_drop_down,color: dawer == 9 ?  Colors.white : Color(0xff9197B3),)
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          InkWell(
                                            onTap: (){
                                              setState(() {
                                                pagename = "Email";
                                                pages= EmailPage();
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
                                          SizedBox(height: 8),
                                          InkWell(
                                            onTap: (){
                                              setState(() {
                                                pagename = "SMS";
                                                pages= SMSPage();
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
                                          SizedBox(height: 8),
                                          InkWell(
                                            onTap: (){
                                              setState(() {
                                                pagename = "Notifications";
                                                pages= NotificationsPage();
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
                            SizedBox(height: 5,),

                           /* Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: AnimatedContainer(

                                height: 35,

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),

                                ),
                                padding:  EdgeInsets.only(left: dawer == 6 ? 10.0 :0),
                                duration: Duration(milliseconds: 700),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    AnimatedContainer(
                                      curve: Curves.fastOutSlowIn,
                                      duration: Duration(milliseconds: 700),
                                      padding: EdgeInsets.only(left: 50),
                                      width:  dawer == 6
                                          ? 200 : 0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: dawer == 6
                                            ? Constants().primaryAppColor : Colors.transparent,
                                      ),

                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          //pages = Dashboard2(currentRole: widget.currentRole, sessionStateStream: widget.sessionStateStream);
                                          dawer=6;
                                          col1=false;
                                          pagename="";

                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: KText(text:
                                            "Leave Application Tracking",
                                              style: GoogleFonts.openSans(
                                                  fontSize: width/95,
                                                  fontWeight: FontWeight.w500,
                                                  color: dawer == 6 ?  Colors.white : Color(0xff9197B3)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 5,),*/


                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: AnimatedContainer(

                                height: 35,

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),

                                ),
                                padding:  EdgeInsets.only(left: dawer == 11 ? 10.0 :0),
                                duration: Duration(milliseconds: 700),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    AnimatedContainer(
                                      curve: Curves.fastOutSlowIn,
                                      duration: Duration(milliseconds: 700),
                                      padding: EdgeInsets.only(left: 50),
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
                                          //pages = Dashboard2(currentRole: widget.currentRole, sessionStateStream: widget.sessionStateStream);
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
                                                  color: dawer == 11 ?  Colors.white : Color(0xff9197B3)),
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

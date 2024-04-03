
import 'package:animate_do/animate_do.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_ikia/Views/resident_add_view.dart';
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hms_ikia/Constants/constants.dart';
import 'package:hms_ikia/widgets/TextPersonalDetails.dart';
import 'package:hms_ikia/widgets/customtextfield.dart';
import 'package:hms_ikia/widgets/kText.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/userMiniDetails.dart';
class Resident_Tab extends StatefulWidget {
  const Resident_Tab({super.key});

  @override
  State<Resident_Tab> createState() => _Resident_TabState();
}

class _Resident_TabState extends State<Resident_Tab> {
  // list for the export data

  // for the search one
  TextEditingController searchNamePhone = TextEditingController();
  bool adduser = false;
  void updateDisplay(bool newValue) {
    setState(() {
      adduser = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1512;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return adduser == false? Padding(
      padding: const EdgeInsets.all(15.0),
      child: FadeInRight(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // frame5222yEd (120:330)
                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 51*fem),
                width: double.infinity,
                height: 70*fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // frame22Vyf (41:665)
                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 690*fem, 0*fem),
                      height: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // welcomeeswarane5s (41:666)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 9*fem),
                            child: KText(
                              text:'Resident Management',
                              style: GoogleFonts.openSans (
                                fontSize: 28*ffem,
                                fontWeight: FontWeight.w700,
                                height: 1.3625*ffem/fem,
                                color: const Color(0xff262626),
                              ),
                            ),
                          ),
                          KText(
                            // effortlesslymanageyourusersx6Z (41:667)
                            text: '“EFFORTLESSLY MANAGE YOUR USERS”',
                            style: GoogleFonts.openSans (
                              fontSize: 16*ffem,
                              fontWeight: FontWeight.w600,
                              height: 1.3625*ffem/fem,
                              color: const Color(0xa5262626),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
              Container(
                // frame5095jws (59:1626)
                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 24*fem),
                padding: EdgeInsets.fromLTRB(24*fem, 24*fem, 25*fem, 24*fem),
                width: double.infinity,
                height: 104*fem,
                decoration: BoxDecoration (
                  border: Border.all(color: const Color(0x11000000)),
                  color: const Color(0xffffffff),
                  borderRadius: BorderRadius.circular(24*fem),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      // frame5089ENq (55:1427)
                      onPressed: () {
                        setState(() {
                          adduser=true;
                        });
                      },
                      style: TextButton.styleFrom (
                        padding: EdgeInsets.zero,
                      ),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(24*fem, 16*fem, 24*fem, 16*fem),
                        height: double.infinity,
                        decoration: BoxDecoration (
                          color: const Color(0xff37d1d3),
                          borderRadius: BorderRadius.circular(99*fem),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x4c000000),
                              offset: Offset(0*fem, 1*fem),
                              blurRadius: 1.5*fem,
                            ),
                            BoxShadow(
                              color: const Color(0x3f32325d),
                              offset: Offset(0*fem, 2*fem),
                              blurRadius: 2.5*fem,
                            ),
                          ],
                        ),
                        child: Row(
                          // the add new resident button with Icon
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              // addnewresidentVJm (55:1416)
                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 10*fem, 0*fem),
                              child: KText(
                                text: 'Add New Resident',
                                style: GoogleFonts.openSans (
                                  fontSize: 16*ffem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.3625*ffem/fem,
                                  color: const Color(0xffffffff),
                                ),
                              ),
                            ),
                            SizedBox(
                              // addusermaleCU5 (59:1857)
                              width: 24*fem,
                              height: 24*fem,
                              child: Image.asset(
                                'assets/ui-design-/images/add-user-male.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 164*fem,
                    ),
                          SizedBox(
                      width: 164*fem,
                    ),
                Container(
                  height: 60,
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
                  ],
                ),
              ),
              Container(
                // frame5109Ydj (59:1858)
                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 24*fem),
                padding: EdgeInsets.fromLTRB(24*fem, 24*fem, 24*fem, 24*fem),
                width: double.infinity,
                height: 110*fem,
                decoration: BoxDecoration (
                  border: Border.all(color: const Color(0x11000000)),
                  color: const Color(0xffffffff),
                  borderRadius: BorderRadius.circular(24*fem),
                ),
                child: CustomTextField(header: '' , hint: 'Search Name, Phone...', height: 50, width: 300, onChanged: (value) {
                  setState(() {

                }
                );},suffixIcon: Icons.search,controller: searchNamePhone, fillColor: const Color(0xffF5F5F5), validator: (String) {
              },)
              ),
              SingleChildScrollView(
                child: Container(
                  // frame51086Pf (59:1825)
                  padding: EdgeInsets.fromLTRB(0*fem, 24*fem, 0*fem, 22.5*fem),
                  width: double.infinity,
                  // height: 628*fem,
                  decoration: BoxDecoration (
                    border: Border.all(color: const Color(0x19262626)),
                    color: const Color(0xffffffff),
                    borderRadius: BorderRadius.circular(24*fem),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // frame5091BR7 (55:1495)
                        margin: EdgeInsets.fromLTRB(22*fem, 0*fem, 58*fem, 23*fem),
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              // no73s (55:1496)
                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 88*fem, 0*fem),
                              child: KText(
                                text:
                                'No.',
                                style: GoogleFonts.openSans (
                                  fontSize: 20*ffem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.3625*ffem/fem,
                                  color: const Color(0xff262626),
                                ),
                              ),
                            ),
                            Container(
                              // profilepU5 (55:1497)
                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 101*fem, 0*fem),
                              child: KText(
                                text:
                                'Profile',
                                style: GoogleFonts.openSans (
                
                                  fontSize: 20*ffem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.3625*ffem/fem,
                                  color: const Color(0xff262626),
                                ),
                              ),
                            ),
                            Container(
                              // nameYQ5 (55:1498)
                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 101*fem, 0*fem),
                              child: KText(
                               text: 'Name',
                                style: GoogleFonts.openSans (
                
                                  fontSize: 20*ffem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.3625*ffem/fem,
                                  color: const Color(0xff262626),
                                ),
                              ),
                            ),
                            Container(
                              // status47X (55:1499)
                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 101*fem, 0*fem),
                              child: KText(
                               text: 'Status',
                                style: GoogleFonts.openSans (
                
                                  fontSize: 20*ffem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.3625*ffem/fem,
                                  color: const Color(0xff262626),
                                ),
                              ),
                            ),
                            Container(
                              // phonenoNtu (55:1500)
                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 108*fem, 0*fem),
                              child: KText(
                                text:'Phone No',
                                style: GoogleFonts.openSans (
                                  fontSize: 20*ffem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.3625*ffem/fem,
                                  color: const Color(0xff262626),
                                ),
                              ),
                            ),
                            Container(
                              // pincodehwB (55:1501)
                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 89*fem, 0*fem),
                              child: KText(
                               text: 'Pin Code',
                                style: GoogleFonts.openSans (
                                  fontSize: 20*ffem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.3625*ffem/fem,
                                  color: const Color(0xff262626),
                                ),
                              ),
                            ),
                            KText(
                              // actionsdpq (55:1502)
                              text:'Actions',
                              style: GoogleFonts.openSans (
                
                                fontSize: 20*ffem,
                                fontWeight: FontWeight.w700,
                                height: 1.3625*ffem/fem,
                                color: const Color(0xff262626),
                              ),
                            ),
                          ],
                        ),
                      ),

                      StreamBuilder(
                        stream: FirebaseFirestore.instance.collection("Users").orderBy("timestamp", descending: true).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            // this is matched one with the search
                            List<DocumentSnapshot> matchedData = [];
                            // this is remaining one
                            List<DocumentSnapshot> remainingData = [];
                            if (searchNamePhone.text.isNotEmpty) {
                              // Separate the snapshot data based on the search text
                              snapshot.data!.docs.forEach((doc) {
                                final name = doc["firstName"].toString().toLowerCase();
                                final phone = doc["phone"].toString().toLowerCase();
                                final searchText = searchNamePhone.text.toLowerCase();
                                if (name.contains(searchText)
                                    ||
                                    phone.contains(searchText)) {
                                  matchedData.add(doc);
                                } else {
                                  remainingData.add(doc);
                                }
                              });
                              // Sort the matched data
                              matchedData.sort((a, b) {
                                final nameA = a["firstName"].toString().toLowerCase();
                                final nameB = b["firstName"].toString().toLowerCase();
                                final searchText = searchNamePhone.text.toLowerCase();
                                return nameA.compareTo(nameB);
                              });
                            }

                            else {
                              // If search query is empty, display original data
                              remainingData = snapshot.data!.docs;
                            }
                            // Concatenate matched data and remaining data
                            List<DocumentSnapshot> combinedData = [...matchedData, ...remainingData];
                            print(searchNamePhone);
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                // if (searchNamePhone.text.isNotEmpty && index < filteredData.length) {
                                  if(snapshot.hasData){
                                    final document = combinedData[index];
                                  return Container(
                                    // frame5102azy (59:1668)
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 22.5*fem),
                                    padding: EdgeInsets.fromLTRB(31*fem, 24*fem, 24*fem, 25.5*fem),
                                    width: double.infinity,
                                    height: 89.5*fem,
                                    child: SizedBox(
                                      // group38unM (59:1664)
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            // autogroupyk4d49T (bNj71yThevXP1WVcqYk4d)
                                            padding: EdgeInsets.fromLTRB(0*fem, 0*fem, 57*fem, 0*fem),
                                            height: double.infinity,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                // serial number one
                                                Container(
                                                  // Nvq (59:1635)
                                                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 95*fem, 0*fem),
                                                  child: KText(
                                                    text:
                                                    (index+1).toString(),
                                                    style: GoogleFonts.openSans (
                                                      fontSize: 16*ffem,
                                                      fontWeight: FontWeight.w700,
                                                      height: 1.3625*ffem/fem,
                                                      color: const Color(0xcc262626),
                                                    ),
                                                  ),
                                                ),
                                                // image
                                                Container(
                                                  // maskgroupHnu (59:1659)
                                                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 95*fem, 0*fem),
                                                  width: 80*fem,
                                                  height: 40*fem,
                                                  child: Image.network(
                                                    // snap.data!.docs[index]["imageUrl"],
                                                    document['imageUrl'],
                                                    width: 40*fem,
                                                    height: 40*fem,
                                                  ),
                                                ),
                                                Container(
                                                  // sandheepsoWM (59:1636)
                                                  width: 150*fem,
                                                  height: 40*fem,
                                                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 10*fem, 0*fem),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 8),
                                                    child: KText(
                                                      // snap.data!.docs[index]["firstName"],
                                                      text:document["firstName"],
                                                      style: GoogleFonts.openSans (
                                                        fontSize: 16*ffem,
                                                        fontWeight: FontWeight.w600,
                                                        height: 1.3625*ffem/fem,
                                                        color: const Color(0xcc262626),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  // frame5096XSM (59:1640)
                                                  margin: EdgeInsets.fromLTRB(0*fem, 6*fem, 98*fem, 6*fem),
                                                  width: 68*fem,
                                                  height: double.infinity,
                                                  decoration: BoxDecoration (
                                                    color: const Color(0xffddffe6),
                                                    borderRadius: BorderRadius.circular(64*fem),
                                                  ),
                                                  child: Center(
                                                    child: KText(
                                                     text: 'Active',
                                                      style: GoogleFonts.openSans (
                                                        fontSize: 16*ffem,
                                                        fontWeight: FontWeight.w600,
                                                        height: 1.3625*ffem/fem,
                                                        color: const Color(0xff1da543),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  // QFF (59:1641)
                                                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 125*fem, 0*fem),
                                                  child: KText(
                                                    // snap.data!.docs[index]["phone"],
                                                  text:  document["phone"],
                                                    style: GoogleFonts.openSans (
                                                      fontSize: 16*ffem,
                                                      fontWeight: FontWeight.w600,
                                                      height: 1.3625*ffem/fem,
                                                      color: const Color(0xcc262626),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 30*fem, 0*fem),
                                                  child: KText(
                                                    // Kd7 (59:1642)
                                                    // snapshot.data!.docs[index]["pincode"],
                                                   text: document["pincode"],
                                                    style: GoogleFonts.openSans (
                                                      fontSize: 16*ffem,
                                                      fontWeight: FontWeight.w600,
                                                      height: 1.3625*ffem/fem,
                                                      color: const Color(0xcc262626),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            // frame5100UF7 (59:1656)
                                            height: double.infinity,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: (){
                                                    print('Edit Button');
                                                    setuserdata(snapshot.data!.docs[index].id);
                                                    _showMyDialog(context,snapshot.data!.docs[index].id);
                                                  },
                                                  child: Container(
                                                    // frame5099ppm (59:1652)
                                                    padding: EdgeInsets.fromLTRB(8*fem, 8*fem, 8*fem, 8*fem),
                                                    height: double.infinity,
                                                    decoration: BoxDecoration (
                                                      color: const Color(0xfff5f5f5),
                                                      borderRadius: BorderRadius.circular(20*fem),
                                                    ),
                                                    child: Center(
                                                      // editxg5 (74:88)
                                                      child: SizedBox(
                                                        width: 24*fem,
                                                        height: 24*fem,
                                                        child: Image.asset(
                                                          'assets/ui-design-/images/edit-WK7.png',
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 16*fem,
                                                ),
                                                // View Button

                                                InkWell(
                                                  onTap: (){print('View Button');
                                                  //   passing the ID
                                                  ShowProfile(context, snapshot.data!.docs[index]);
                                                    // BuildContext context, UserData userData
                                                    // ShowProfileModal(context);
                                                  },
                                                  child: Container(
                                                    // frame5097gc5 (59:1647)
                                                    padding: EdgeInsets.fromLTRB(8*fem, 8*fem, 8*fem, 8*fem),
                                                    height: double.infinity,
                                                    decoration: BoxDecoration (
                                                      color: const Color(0xfff5f5f5),
                                                      borderRadius: BorderRadius.circular(20*fem),
                                                    ),
                                                    child: Center(
                                                      // eyeckd (74:73)
                                                      child: SizedBox(
                                                        width: 24*fem,
                                                        height: 24*fem,
                                                        child: Image.asset(
                                                          'assets/ui-design-/images/eye-iiy.png',
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 16*fem,
                                                ),
                                                // Delete Button
                                                InkWell(
                                                  onTap: (){
                                                    print('Delete Button');
                                                    ForDeleteDialog(context,snapshot.data!.docs[index].id);
                                                  },
                                                  child: Container(
                                                    // frame5098jaM (59:1648)
                                                    padding: EdgeInsets.fromLTRB(8*fem, 8*fem, 8*fem, 8*fem),
                                                    height: double.infinity,
                                                    decoration: BoxDecoration (
                                                      color: const Color(0xfff5f5f5),
                                                      borderRadius: BorderRadius.circular(20*fem),
                                                    ),
                                                    child: Center(
                                                      // deleteGaH (74:83)
                                                      child: SizedBox(
                                                        width: 24*fem,
                                                        height: 24*fem,
                                                        child: Image.asset(
                                                          'assets/ui-design-/images/delete-1Tj.png',
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                  else {
                                  // final document = snapshot.data!.docs[index];
                                    final document = combinedData[index];
                                  // Build UI for original snapshot data
                                  return Container(
                                    // frame5102azy (59:1668)
                                    margin: EdgeInsets.fromLTRB(
                                        0 * fem, 0 * fem, 0 * fem, 22.5 * fem),
                                    padding: EdgeInsets.fromLTRB(
                                        31 * fem, 24 * fem, 24 * fem,
                                        25.5 * fem),
                                    width: double.infinity,
                                    height: 89.5 * fem,
                                    child: SizedBox(
                                      // group38unM (59:1664)
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: [
                                          Container(
                                            // autogroupyk4d49T (bNj71yThevXP1WVcqYk4d)
                                            padding: EdgeInsets.fromLTRB(
                                                0 * fem, 0 * fem, 57 * fem,
                                                0 * fem),
                                            height: double.infinity,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .center,
                                              children: [
                                                // serial number one
                                                Container(
                                                  // Nvq (59:1635)
                                                  margin: EdgeInsets.fromLTRB(
                                                      0 * fem, 0 * fem,
                                                      95 * fem, 0 * fem),
                                                  child: KText(
                                                    text: (index + 1).toString(),
                                                    style: GoogleFonts.openSans(
                                                      fontSize: 16 * ffem,
                                                      fontWeight: FontWeight
                                                          .w700,
                                                      height: 1.3625 * ffem /
                                                          fem,
                                                      color: const Color(
                                                          0xcc262626),
                                                    ),
                                                  ),
                                                ),
                                                // image
                                                Container(
                                                  // maskgroupHnu (59:1659)
                                                  margin: EdgeInsets.fromLTRB(
                                                      0 * fem, 0 * fem,
                                                      95 * fem, 0 * fem),
                                                  width: 80 * fem,
                                                  height: 40 * fem,
                                                  child: Image.network(
                                                    // snap.data!
                                                    //     .docs[index]["imageUrl"],
                                                    document['imageUrl'],
                                                    width: 40 * fem,
                                                    height: 40 * fem,
                                                  ),
                                                ),
                                                Container(
                                                  // sandheepsoWM (59:1636)
                                                  width: 150 * fem,
                                                  height: 40 * fem,
                                                  margin: EdgeInsets.fromLTRB(
                                                      0 * fem, 0 * fem,
                                                      10 * fem, 0 * fem),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .only(top: 8),
                                                    child: KText(
                                                      // snap.data!.docs[index]["firstName"],
                                                    text:  document["firstName"],
                                                      style: GoogleFonts
                                                          .openSans(
                                                        fontSize: 16 * ffem,
                                                        fontWeight: FontWeight
                                                            .w600,
                                                        height: 1.3625 * ffem /
                                                            fem,
                                                        color: const Color(
                                                            0xcc262626),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  // frame5096XSM (59:1640)
                                                  margin: EdgeInsets.fromLTRB(
                                                      0 * fem, 6 * fem,
                                                      98 * fem, 6 * fem),
                                                  width: 68 * fem,
                                                  height: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                        0xffddffe6),
                                                    borderRadius: BorderRadius
                                                        .circular(64 * fem),
                                                  ),
                                                  child: Center(
                                                    child: KText(
                                                      text:'Active',
                                                      style: GoogleFonts
                                                          .openSans(
                                                        fontSize: 16 * ffem,
                                                        fontWeight: FontWeight
                                                            .w600,
                                                        height: 1.3625 * ffem /
                                                            fem,
                                                        color: const Color(
                                                            0xff1da543),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  // QFF (59:1641)
                                                  margin: EdgeInsets.fromLTRB(
                                                      0 * fem, 0 * fem,
                                                      105 * fem, 0 * fem),
                                                  child: KText(
                                                    // snap.data!.docs[index]["phone"],
                                                   text: document["phone"],
                                                    style: GoogleFonts.openSans(
                                                      fontSize: 16 * ffem,
                                                      fontWeight: FontWeight
                                                          .w600,
                                                      height: 1.3625 * ffem /
                                                          fem,
                                                      color: const Color(
                                                          0xcc262626),
                                                    ),
                                                  ),
                                                ),
                                                KText(
                                                  // Kd7 (59:1642)
                                                  text:snapshot.data!
                                                      .docs[index]["pincode"],
                                                  style: GoogleFonts.openSans(
                                                    fontSize: 16 * ffem,
                                                    fontWeight: FontWeight.w600,
                                                    height: 1.3625 * ffem / fem,
                                                    color: const Color(
                                                        0xcc262626),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            // frame5100UF7 (59:1656)
                                            height: double.infinity,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .center,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    print('Edit Button');
                                                    setuserdata(snapshot.data!
                                                        .docs[index].id);
                                                    _showMyDialog(context, snapshot
                                                        .data!.docs[index].id);
                                                  },
                                                  child: Container(
                                                    // frame5099ppm (59:1652)
                                                    padding: EdgeInsets
                                                        .fromLTRB(
                                                        8 * fem, 8 * fem,
                                                        8 * fem, 8 * fem),
                                                    height: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xfff5f5f5),
                                                      borderRadius: BorderRadius
                                                          .circular(20 * fem),
                                                    ),
                                                    child: Center(
                                                      // editxg5 (74:88)
                                                      child: SizedBox(
                                                        width: 24 * fem,
                                                        height: 24 * fem,
                                                        child: Image.asset(
                                                          'assets/ui-design-/images/edit-WK7.png',
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 16 * fem,
                                                ),
                                                // View Button
                                                InkWell(
                                                  onTap: () {
                                                    print('View Button');
                                                    //   passing the ID
                                                    ShowProfile(context, snapshot
                                                        .data!.docs[index]);
                                                    // BuildContext context, UserData userData
                                                    // ShowProfileModal(context);
                                                  },
                                                  child: Container(
                                                    // frame5097gc5 (59:1647)
                                                    padding: EdgeInsets
                                                        .fromLTRB(
                                                        8 * fem, 8 * fem,
                                                        8 * fem, 8 * fem),
                                                    height: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xfff5f5f5),
                                                      borderRadius: BorderRadius
                                                          .circular(20 * fem),
                                                    ),
                                                    child: Center(
                                                      // eyeckd (74:73)
                                                      child: SizedBox(
                                                        width: 24 * fem,
                                                        height: 24 * fem,
                                                        child: Image.asset(
                                                          'assets/ui-design-/images/eye-iiy.png',
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 16 * fem,
                                                ),
                                                // Delete Button
                                                InkWell(
                                                  onTap: () {
                                                    print('Delete Button');
                                                    ForDeleteDialog(
                                                        context, snapshot.data!
                                                        .docs[index].id);
                                                  },
                                                  child: Container(
                                                    // frame5098jaM (59:1648)
                                                    padding: EdgeInsets
                                                        .fromLTRB(
                                                        8 * fem, 8 * fem,
                                                        8 * fem, 8 * fem),
                                                    height: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xfff5f5f5),
                                                      borderRadius: BorderRadius
                                                          .circular(20 * fem),
                                                    ),
                                                    child: Center(
                                                      // deleteGaH (74:83)
                                                      child: SizedBox(
                                                        width: 24 * fem,
                                                        height: 24 * fem,
                                                        child: Image.asset(
                                                          'assets/ui-design-/images/delete-1Tj.png',
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                              },

                            );



                          } else {
                            return const CircularProgressIndicator(); // or any other loading indicator
                          }
                        },
                      )

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ) : ResidentAddForm(displayFirstWidget: adduser,updateDisplay: updateDisplay,);
  }





  // For Update (Here is the UI)
  TextEditingController firstName = new TextEditingController();
  TextEditingController middleName = new TextEditingController();
  TextEditingController lastName = new TextEditingController();
  TextEditingController dob = new TextEditingController();
  TextEditingController bloodgroup = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController mobile = new TextEditingController();
  TextEditingController aadhaar = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController country = new TextEditingController();
  TextEditingController state = new TextEditingController();
  TextEditingController city = new TextEditingController();
  TextEditingController pincode = new TextEditingController();
  TextEditingController parentname = new TextEditingController();
  TextEditingController parentmobile = new TextEditingController();
  TextEditingController parentOccupation = new TextEditingController();
  TextEditingController userid = new TextEditingController();
  TextEditingController roomnumber = new TextEditingController();
  TextEditingController blockname = new TextEditingController();
  List<String> prefix=["Select Prefix","Mr.","Ms.","Mrs"];
  List<String> gender=["Select Gender","Male","Female","Transgender"];
  String selectedprefix="Select Prefix";
  String selectedprefix2="Select Prefix";
  String selectedgender="Select Gender";
  File? Url;
  var Uploaddocument;
  String imgUrl = "";
  addImage() {
    InputElement input = FileUploadInputElement() as InputElement
      ..accept = 'image/*';
    input.click();
    input.onChange.listen((event) {
      final file = input.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) async {
        setState(() {
          Url = file;
          Uploaddocument = reader.result;
          imgUrl = "";
        });
        imageupload();
      });
    });
  }

  imageupload() async {
    var snapshot = await FirebaseStorage.instance.ref().child('Images').child(
        "${Url!.name}").putBlob(Url);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      imgUrl = downloadUrl;
    });
  }

  // Under this Dialoge all those Textfields will be their for update
  Future<void> _showMyDialog(BuildContext con,id) async {
    double baseWidth = 1512;
    double fem = MediaQuery.of(con).size.width / baseWidth;
    double ffem = fem * 0.97;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  // frame5171zgd (87:1710)
                  padding: EdgeInsets.fromLTRB(64*fem, 71*fem, 64*fem, 76*fem),
                  width: double.infinity,
                  decoration: BoxDecoration (
                    border: Border.all(color: const Color(0x30262626)),
                    color: const Color(0xffffffff),
                    borderRadius: BorderRadius.circular(24*fem),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // frame5169JBX (87:1509)
                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 388*fem, 46*fem),
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 35.0),
                              child: KText(
                                // addresidentdetailsvyb (87:1511)
                                text:'Update Resident Details',
                                style: GoogleFonts.openSans (
                                  fontSize: 24*ffem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.3625*ffem/fem,
                                  color: const Color(0xff000000),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        // frame5155DSu (87:1513)
                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 30.5*fem),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              // frame5126M3K (87:1514)
                              margin: EdgeInsets.fromLTRB(414*fem, 0*fem, 414*fem, 44*fem),
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    // frame51255zu (87:1515)
                                    margin: EdgeInsets.fromLTRB(10*fem, 0*fem, 10*fem, 19*fem),
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          // group39DrD (87:1516)
                                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 12*fem),
                                          padding: EdgeInsets.fromLTRB(25.67*fem, 25.67*fem, 25.67*fem, 25.67*fem),
                                          width: 160,
                                          decoration: BoxDecoration (
                                            border: Border.all(color: const Color(0x38262626)),
                                            color: const Color(0xffe5feff),
                                            borderRadius: BorderRadius.circular(100),
                                          ),
                                          child: Center(
                                            // imageuploadbro1gzh (87:1518)
                                            child: SizedBox(
                                              width: 124.67*fem,
                                              height: 124.67*fem,
                                              child: Uploaddocument==null? Image.asset(
                                                'assets/ui-design-/images/image-upload-bro-1.png',
                                                fit: BoxFit.cover,
                                              ) : Image.memory(
                                                Uint8List.fromList(
                                                  base64Decode(
                                                    Uploaddocument!.split(',').last,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          // uploadresidentphoto150px150pxn (87:1519)
                                          constraints: BoxConstraints (
                                            maxWidth: 155*fem,
                                          ),
                                          child: KText(
                                            text:'Upload Resident Photo\n( 150px * 150px)',
                                            style: GoogleFonts.openSans (
                                              fontSize: 14*ffem,
                                              fontWeight: FontWeight.w600,
                                              height: 1.3625*ffem/fem,
                                              color: const Color(0x7f262626),
                                            ),
                                            // textAlign: TextAlign.center,

                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      addImage();
                                    },
                                    child: Container(
                                      // frame5116sZP (87:1520)
                                      padding: EdgeInsets.fromLTRB(24*fem, 16*fem, 24*fem, 16*fem),
                                      width: double.infinity,
                                      decoration: BoxDecoration (
                                        border: Border.all(color: const Color(0xff37d1d3)),
                                        borderRadius: BorderRadius.circular(152*fem),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            // chooseimagebVP (87:1521)
                                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 12*fem, 0*fem),
                                            child: KText(
                                             text: 'Choose Image',
                                              style: GoogleFonts.openSans (
                                                fontSize: 16*ffem,
                                                fontWeight: FontWeight.w700,
                                                height: 1.3625*ffem/fem,
                                                color: const Color(0xff37d1d3),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            // photogalleryKAV (87:1522)
                                            width: 24*fem,
                                            height: 24*fem,
                                            child: Image.asset(
                                              'assets/ui-design-/images/photo-gallery.png',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // CustomTextField(header:)
                                ],
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: KText(
                               text: 'Personal Details',
                                style: GoogleFonts.openSans (
                                  fontSize: 20*ffem,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xff000000),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                // firstnameSVK (87:1540)
                                child: KText(
                                  text: "Prefix",
                                  style: GoogleFonts.openSans (
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff262626),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(
                                  width: 220,
                                  height: 50,
                                  decoration: BoxDecoration (
                                    border: Border.all(color: const Color(0x7f262626)),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0,right: 6),
                                    child:  DropdownButtonHideUnderline(
                                      child:
                                      DropdownButtonFormField2<
                                          String>(
                                        isExpanded: true,
                                        hint: KText(
                                         text: 'Prefix', style:
                                        GoogleFonts.openSans (
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0x7f262626),
                                        ),
                                        ),
                                        items: prefix
                                            .map((String
                                        item) =>
                                            DropdownMenuItem<
                                                String>(
                                              value: item,
                                              child: KText(
                                               text: item,
                                                style:
                                                GoogleFonts.openSans (
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            )).toList(),
                                        value:
                                        selectedprefix,
                                        onChanged:
                                            (String? value) {
                                          setState(() {
                                            selectedprefix =
                                            value!;
                                          });
                                        },
                                        buttonStyleData:
                                        const ButtonStyleData(
                                        ),
                                        menuItemStyleData:
                                        const MenuItemStyleData(
                                        ),
                                        decoration:
                                        const InputDecoration(
                                            border:
                                            InputBorder
                                                .none),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 18,),
                          CustomTextField(header: "First Name",hint: "Enter first name",controller: firstName,validator: null,),
                          const SizedBox(width: 18,),
                          CustomTextField(header: "Middle Name",hint: "Enter middle name",controller: middleName,validator: null,),
                          const SizedBox(width: 18,),
                          CustomTextField(header: "Last Name",hint: "Enter last name",controller: lastName,validator: null,),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                // firstnameSVK (87:1540)
                                child: KText(
                                 text: "Date of Birth",
                                  style: GoogleFonts.openSans (
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,

                                    color: const Color(0xff262626),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(
                                  width: 220 ,
                                  height: 50,
                                  decoration: BoxDecoration (
                                    border: Border.all(color: const Color(0x7f262626)),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0,right: 6),
                                    child: TextFormField(
                                      cursorColor: Constants().primaryAppColor,
                                      controller: dob,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Select date of birth",
                                        hintStyle: GoogleFonts.openSans (
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0x7f262626),
                                        ),
                                      ),

                                      style: GoogleFonts.openSans (

                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,

                                        color: Colors.black,
                                      ),

                                      readOnly:
                                      true,
                                      onTap:
                                          () async {
                                        print("fdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfd");
                                        DateTime? pickedDate = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime
                                                .now(),
                                            firstDate: DateTime(
                                                1950),
                                            //DateTime.now() - not to allow to choose before today.
                                            lastDate: DateTime(
                                                2100));
                                        print("pickedDate");
                                        print(pickedDate);
                                        if (pickedDate != null) {
                                          //pickedDate output format => 2021-03-10 00:00:00.000
                                          String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                                          //formatted date output using intl package =>  2021-03-16

                                          // Calculate age difference
                                          /*   DateTime currentDate = DateTime.now();
                      Duration difference = currentDate.difference(pickedDate);
                      int age = (difference.inDays / 365).floor();*/
                                          print('Age: years');
                                          print(formattedDate);
                                          print("fdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfd");
                                          setState(() {
                                            dob.text = formattedDate; //set output date to TextField value.
                                          });


                                        } else {}
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 18,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                // firstnameSVK (87:1540)

                                child: KText(
                                  text:"Gender",
                                  style: GoogleFonts.openSans (

                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,

                                    color: const Color(0xff262626),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(


                                  width: 220,
                                  height: 50,
                                  decoration: BoxDecoration (
                                    border: Border.all(color: const Color(0x7f262626)),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0,right: 6),
                                    child:  DropdownButtonHideUnderline(

                                      child:
                                      DropdownButtonFormField2<
                                          String>(
                                        isExpanded: true,
                                        hint: KText(
                                         text: 'Select Gender', style:
                                        GoogleFonts.openSans (

                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,

                                          color: const Color(0x7f262626),
                                        ),
                                        ),
                                        items: gender
                                            .map((String
                                        item) =>
                                            DropdownMenuItem<
                                                String>(
                                              value: item,
                                              child: KText(
                                              text:  item,
                                                style:
                                                GoogleFonts.openSans (

                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,


                                                ),
                                              ),
                                            )).toList(),
                                        value:
                                        selectedgender,
                                        onChanged:
                                            (String? value) {
                                          setState(() {
                                            selectedgender =
                                            value!;
                                          });
                                        },
                                        buttonStyleData:
                                        const ButtonStyleData(


                                        ),
                                        menuItemStyleData:
                                        const MenuItemStyleData(

                                        ),
                                        decoration:
                                        const InputDecoration(
                                            border:
                                            InputBorder
                                                .none),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 18,),
                          CustomTextField(header: "Blood Group",hint: "Enter bloob group",controller: bloodgroup,validator: null,),
                          const SizedBox(width: 18,),
                        ],
                      ),
                      const SizedBox(height: 25,),

                      SizedBox(
                        width: double.infinity,
                        child: KText(
                          text:'Contact Details',
                          style: GoogleFonts.openSans (

                            fontSize: 20*ffem,
                            fontWeight: FontWeight.w700,

                            color: const Color(0xff000000),
                          ),
                        ),
                      ),

                      const Divider(),
                      const SizedBox(height: 18,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomTextField(header: "Phone Number",hint: "Enter phone number",controller: phone,validator: null,),
                          const SizedBox(width: 18,),
                          CustomTextField(header: "Mobile Number",hint: "Enter mobile number",controller: mobile,validator: null,),
                          const SizedBox(width: 18,),
                          CustomTextField(header: "Aadhaar Number",hint: "Enter aadhaar name",controller: aadhaar,validator: null,),
                          const SizedBox(width: 18,),
                          CustomTextField(header: "Email",hint: "Enter email-id",controller: email,validator: null,),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomTextField(header: "Address",hint: "Enter student full address",controller: address,validator: null,
                            width: 696,
                          ),
                          const SizedBox(width: 18,),
                          CustomTextField(header: "Country",hint: "Select country",controller: country,validator: null,),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomTextField(header: "State",hint: "Select state",controller: state,validator: null,),
                          const SizedBox(width: 18,),
                          CustomTextField(header: "City",hint: "Select City",controller: city,validator: null,),
                          const SizedBox(width: 18,),
                          CustomTextField(header: "Pin Code",hint: "Enter pin code",controller: pincode,validator: null,),
                          const SizedBox(width: 18,),
                        ],
                      ),

                      const SizedBox(height: 25,),

                      SizedBox(
                        width: double.infinity,
                        child: KText(
                          text: 'Parent/Guardian Details',
                          style: GoogleFonts.openSans (

                            fontSize: 20*ffem,
                            fontWeight: FontWeight.w700,

                            color: const Color(0xff000000),
                          ),
                        ),
                      ),

                      const Divider(),


                      const SizedBox(height: 18,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                // firstnameSVK (87:1540)

                                child: KText(
                                 text: "Prefix",
                                  style: GoogleFonts.openSans (

                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,

                                    color: const Color(0xff262626),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(


                                  width: 220,
                                  height: 50,
                                  decoration: BoxDecoration (
                                    border: Border.all(color: const Color(0x7f262626)),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0,right: 6),
                                    child:  DropdownButtonHideUnderline(

                                      child:
                                      DropdownButtonFormField2<
                                          String>(
                                        isExpanded: true,
                                        hint: KText(
                                          text: 'Prefix', style:
                                        GoogleFonts.openSans (

                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,

                                          color: const Color(0x7f262626),
                                        ),
                                        ),
                                        items: prefix
                                            .map((String
                                        item) =>
                                            DropdownMenuItem<
                                                String>(
                                              value: item,
                                              child: KText(
                                               text: item,
                                                style:
                                                GoogleFonts.openSans (

                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,


                                                ),
                                              ),
                                            )).toList(),
                                        value:
                                        selectedprefix2,
                                        onChanged:
                                            (String? value) {
                                          setState(() {
                                            selectedprefix2 =
                                            value!;
                                          });
                                        },
                                        buttonStyleData:
                                        const ButtonStyleData(


                                        ),
                                        menuItemStyleData:
                                        const MenuItemStyleData(

                                        ),
                                        decoration:
                                        const InputDecoration(
                                            border:
                                            InputBorder
                                                .none),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 18,),
                          CustomTextField(header: "Parent/Guardian Name",hint: "Enter full name",controller: parentname,validator: null,),
                          const SizedBox(width: 18,),
                          CustomTextField(header: "Mobile Number",hint: "Enter mobile number",controller: parentmobile,validator: null,),
                          const SizedBox(width: 18,),
                          CustomTextField(header: "Occupation",hint: "Enter parent occupation",controller: parentOccupation,validator: null,),
                        ],
                      ),



                      const SizedBox(height: 25,),

                      SizedBox(
                        width: double.infinity,
                        child: KText(
                          text: 'Room Details',
                          style: GoogleFonts.openSans (

                            fontSize: 20*ffem,
                            fontWeight: FontWeight.w700,

                            color: const Color(0xff000000),
                          ),
                        ),
                      ),

                      const Divider(),



                      const SizedBox(height: 18,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomTextField(header: "User ID",hint: "IKIA0001",controller: userid,validator: null,),
                          const SizedBox(width: 18,),
                          CustomTextField(header: "Room Number",hint: "Select Room",controller: roomnumber,validator: null,),
                          const SizedBox(width: 18,),
                          CustomTextField(header: "Block Name",hint: "Select Block",controller: blockname,validator: null,),
                          const SizedBox(width: 18,),
                        ],
                      ),

                      const SizedBox(height: 18,),

                      const Divider(),


                      const SizedBox(height: 28,),

                      Row(
                        children: [
                          InkWell(
                            onTap: (){
                             Navigator.of(context).pop();
                            },
                            child: Container(
                              child: Row(
                                children: [
                                  Icon(Icons.arrow_back_ios_new,color: Constants().primaryAppColor,),
                                  KText(text: "Back", style: GoogleFonts.openSans(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13,
                                      color: Constants().primaryAppColor
                                  ))
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 600,),
                          InkWell(
                            onTap: (){
                              updateuser(id);
                            },
                            child: Container(
                              width: 100,
                              height: 37,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Constants().primaryAppColor
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  KText(text: "Save", style: GoogleFonts.openSans(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13,
                                      color: Colors.white
                                  ) ),
                                  const Icon(Icons.file_copy,color: Colors.white)
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 15,),
                          Container(
                            width: 100,
                            height: 37,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Constants().primaryAppColor
                                ),
                                color: Colors.white
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                KText(text: "Reset", style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                    color: Constants().primaryAppColor
                                ) ),
                                Icon(Icons.restart_alt,color: Constants().primaryAppColor)
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )

        );
      },
    );
  }
  // Update UI stuff finished
  // for Update (Functionalities)
  setuserdata(id) async {
    // creating a variable to store the Users data dynamically... using thier ID
    var docu = await FirebaseFirestore.instance.collection("Users").doc(id).get();
    Map<String,dynamic> ? val = docu.data();
    setState(() {
    firstName.text=val!["firstName"];
    middleName.text=val["middleName"];
    lastName.text=val["lastName"];
    dob.text=val["dob"];
    bloodgroup.text=val["bloodgroup"];
    phone.text=val["phone"];
    mobile.text=val["mobile"];
    aadhaar.text=val["aadhaar"];
    email.text=val["email"];
    address.text=val["address"];
    country.text=val["country"];
    state.text=val["state"];
    city.text=val["city"];
    pincode.text=val["pincode"];
    parentname.text=val["parentname"];
    parentmobile.text=val["parentmobile"];
    parentOccupation.text=val["parentOccupation"];
    userid.text=val["userid"];
    roomnumber.text=val["roomnumber"];
    blockname.text=val["blockname"];
    imgUrl=val["imageUrl"];
     selectedprefix=val["prefix"];
     selectedprefix2=val["parentprefix"];
     selectedgender=val["gender"];
});
  }
  // for update passing (id to get the EXACT person)
  updateuser(id){
    FirebaseFirestore.instance.collection("Users").doc(id).set({
      "prefix":selectedprefix,
      "firstName" :firstName.text,
      "middleName" : middleName.text,
      "lastName" : lastName.text,
      "dob" :dob.text,
      "gender":selectedgender,
      "bloodgroup" : bloodgroup.text,
      "phone" : phone.text,
      "mobile" : mobile.text,
      "aadhaar" : aadhaar.text,
      "email" : email.text,
      "address" : address.text,
      "country" : country.text,
      "state" : state.text,
      "city" : city.text,
      "pincode" : pincode.text,
      "parentprefix":selectedprefix2,
      "parentname" : parentname.text,
      "parentmobile" : parentmobile.text,
      "parentOccupation" : parentOccupation.text,
      "userid" : userid.text,
      "roomnumber" : roomnumber.text,
      "blockname" : blockname.text,
      "imageUrl":imgUrl,
      "status" : false,
      "uid" : '',
      "timestamp":DateTime.now().millisecondsSinceEpoch
    });
    Successdialog();
  }
  // for update success dialog
  Successdialog(){
    double width = MediaQuery.of(context).size.width;
    return AwesomeDialog(
      width: width/3.035555555555556,
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Resident Updated Successfully',
      btnOkOnPress: () {
     Navigator.of(context).pop();
      },
    )..show();
  }

//   for delete dialog first
  getUserId(id) async{
    var docu = await FirebaseFirestore.instance.collection("Users").doc(id).get();
  }

  //  BuildContext con,id
  Future<void> ForDeleteDialog(BuildContext con,id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(20))),
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
                          ),),
                      )
                  ],),
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
                  ],),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 20),
                    child: KText( text:'Are you sure you want to delete this asset record?', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 17),),
                  ),
                    KText(text:'Once deleted, it cannot be recovered.', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 17),),
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
                        }, child: KText(text:'Cancel', style: GoogleFonts.openSans(fontSize: 17, fontWeight: FontWeight.w700, color: const Color(0xff262626).withOpacity(0.8)),)),
                  ),
                  const SizedBox(width: 20,),
                  Container(
                    width: 130,
                    height: 42,
                    child: ElevatedButton(
                        style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xffF12D2D))),
                        onPressed: ()async{
                          deleteUserData(id);
                          Navigator.pop(context);
                          DeletedSuccesfullyDialog();
                        }, child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        KText(text:'Delete',style: GoogleFonts.openSans(fontSize: 17, fontWeight: FontWeight.w700, color: const Color(0xffFFFFFF))),
                        const Icon(Icons.delete, size: 18, color: Color(0xffFFFFFF),)
                      ],
                    )),
                  ),
                ],)
                ],),
              ),
            ),
          )
        );
      },
    );
  }

  deleteUserData(id)async{
   await FirebaseFirestore.instance.collection("Users").doc(id).delete();
}
  DeletedSuccesfullyDialog(){
    double width = MediaQuery.of(context).size.width;
    return AwesomeDialog(
      width: width/3.035555555555556,
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Resident Deleted Successfully',
      btnOkOnPress: () {
        Navigator.of(context).pop();
      },
    )..show();
  }
  // BuildContext con,id


  Future<void> ShowProfile(BuildContext con, DocumentSnapshot userData) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
         return  SingleChildScrollView(
          child: AlertDialog(
              contentPadding: EdgeInsets.zero,
              shape:  const RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(20))),
              content: SingleChildScrollView(
                child: ClipRRect(
                  borderRadius:  const BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    padding: EdgeInsets.zero,
                    color: Colors.white,
                    height: 800,
                    width: 750,
                    child:  Padding(
                      padding:  const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Resident  Details',style: GoogleFonts.openSans(fontWeight: FontWeight.w700, color: Colors.black, fontSize: 18),),
                              InkWell(
                                onTap: (){Navigator.pop(context);},
                                child: const CircleAvatar(
                                  backgroundColor: Color(0xffF5F6F7), radius: 20, child: Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Icon(Icons.close, color: Colors.grey, size: 18,
                                  ),
                                ),),
                              )
                            ],),
                          Padding(
                            padding: const EdgeInsets.only(top: 25, bottom: 25),
                            child:
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: 420,
                                  child: ClipRRect(
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      child: Container(height: 390, color: const Color(0xff37D1D3), width: 260,
                                        child:   Column(children: [
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
                                                    left: 75,
                                                    top: 65,
                                                    child: SizedBox(
                                                      // height: 230,
                                                      // width: 130,
                                                        child:

                                                        // CircleAvatar(radius: 65,backgroundImage:
                                                        // AssetImage('assets/ui-design-/images/d-portrait-high-school-teenager-photoroom-1.png',
                                                        //  ),
                                                        // )

                                                        CircleAvatar(
                                                          backgroundColor: const Color(0xffF5F6F7),
                                                          radius: 62,
                                                          child: userData['imageUrl'] != null
                                                              ? Image.network(
                                                            userData['imageUrl']!,
                                                            // width: 200,
                                                            // height: 200,
                                                            fit: BoxFit.cover,
                                                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                                              if (loadingProgress == null) {
                                                                return child;
                                                              } else {
                                                                return Center(
                                                                  child: CircularProgressIndicator(
                                                                    value: loadingProgress.expectedTotalBytes != null
                                                                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                                        : null,
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                                              return const Icon(Icons.error); // Placeholder icon for error case
                                                            },
                                                          )
                                                              : const Placeholder(), // Use Placeholder widget if imageUrl is null
                                                        ),
                                                    ),
                                                  ),
                                                ],),
                                              Padding(
                                                padding: const EdgeInsets.all(10),
                                                child: Column(children: [
                                                  UserMiniDetails(IconName: Icons.contact_mail, iName: 'User ID                : '  , userDet: '   ${userData['userid']}',),
                                                   const SizedBox(height: 8,),
                                                   UserMiniDetails(IconName: Icons.phone, iName: 'Phone Number  :      ',userDet: '${userData['phone']}'),
                                                  const SizedBox(height: 8,),
                                                  const SizedBox(height: 8,),
                                                    const Padding(
                                                    padding: EdgeInsets.only(top: 3, bottom: 3),
                                                    child: SizedBox(
                                                        height: 30,
                                                        child:
                                                        Image(image: AssetImage('assets/ui-design-/images/Group 84.png')
                                                        )
                                                      // Image.network(userData['imageUrl'])
                                                    ),
                                                  )
                                                ],),
                                              )
                                            ],)
                                        ],),
                                      )),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: 245,
                                      width: 380,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          border: Border.all(color: Colors.grey.withOpacity(0.4), width: 0.9)),
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.center,

                                          children: [
                                            KText(text:'Resident Personal Details', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, color: Colors.black, fontSize: 18),),
                                            const Padding(
                                              padding: EdgeInsets.only(left: 15, right: 15),
                                              child: Divider(thickness: 1, color: Colors.grey,),
                                            ),
                                             PersonalDetailsText(DHeading: 'First Name            :', UserData: '     ${userData['firstName']}'),
                                             PersonalDetailsText(DHeading: 'Middle Name        :', UserData:'     ${userData['middleName']}'),
                                             PersonalDetailsText(DHeading: 'Last Name             :', UserData: '     ${userData['lastName']}'),
                                             PersonalDetailsText(DHeading: 'Blood Group          :', UserData: '     ${userData['bloodgroup']}'),
                                             PersonalDetailsText(DHeading: 'Gender                   :', UserData: '     ${userData['gender']}'),
                                             PersonalDetailsText(DHeading: 'Date Of Birth         :', UserData: '     ${userData['dob']}'),
                                          ]) ,
                                    ),
                                    const SizedBox(height: 15,),
                                    Container(
                                      height: 160,
                                      width: 380,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          border: Border.all(color: Colors.grey, width: 0.8)),
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            KText(text:'Resident Parent / Guardian Details', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, color: Colors.black, fontSize: 18),),
                                            const Padding(
                                              padding: EdgeInsets.only(left: 20, right: 20),
                                              child: Divider(thickness: 1, color: Colors.grey,),
                                            ),
                                             PersonalDetailsText(DHeading: 'Gaurdian Name     :', UserData: '     ${userData['parentname']}'),
                                             PersonalDetailsText(DHeading: 'Mobile Number     :', UserData:'     ${userData['mobile']}'),
                                             PersonalDetailsText(DHeading: 'Occupation             :', UserData: '     ${userData['parentOccupation']}'),
                                          ]) ,
                                    ),
                                  ],)
                              ],),
                          ),

                          Container(
                            height: 245,
                            // width: 350,
                            // width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: Colors.grey, width: 0.8)),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 385,
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.center,

                                      children: [
                                        KText(text:'Resident Contact Details', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, color: Colors.black, fontSize: 18),),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 15, right: 15),
                                          child: Divider(thickness: 1, color: Colors.grey,),
                                        ),
                                         PersonalDetailsText(DHeading: 'Phone Number         :', UserData: '     ${userData['phone']}'),
                                         PersonalDetailsText(DHeading: 'Mobile Number        :', UserData:'     ${userData['mobile']}'),
                                         PersonalDetailsText(DHeading: 'Aadhaar Number        :', UserData: '     ${userData['aadhaar']}'),
                                         PersonalDetailsText(DHeading: 'Email                           :', UserData: '     ${userData['email']}')
                                        // const PersonalDetailsText(DHeading: 'Email                           :', UserData: '       sample@gmail.com'),
                                      ]),
                                ),
                                 Expanded(
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 60,),
                                        PersonalDetailsText(DHeading: 'Address         :', UserData: '     ${userData['address']}'),
                                        PersonalDetailsText(DHeading: 'Country         :', UserData:'     ${userData['country']}'),
                                        PersonalDetailsText(DHeading: 'State              :', UserData: '     ${userData['state']}'),
                                        PersonalDetailsText(DHeading: 'City                :', UserData: '       ${userData['city']}'),
                                        PersonalDetailsText(DHeading: 'Pin Code        :', UserData: '       ${userData['pincode']}'),
                                      ]),
                                ),
                              ],
                            ) ,
                          ),
                        ],),
                    ),
                  ),
                ),
              )
          ),
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
        position:  const RelativeRect.fromLTRB(60, 190, 15, 55),
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

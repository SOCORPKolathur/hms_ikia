
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_ikia/Views/resident_add_tab.dart';
import 'package:hms_ikia/Views/resident_add_view.dart';

class Resident_Tab extends StatefulWidget {
  const Resident_Tab({super.key});

  @override
  State<Resident_Tab> createState() => _Resident_TabState();
}

class _Resident_TabState extends State<Resident_Tab> {

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
                            child: Text(
                              'Resident Management',
                              style: GoogleFonts.openSans (

                                fontSize: 28*ffem,
                                fontWeight: FontWeight.w700,
                                height: 1.3625*ffem/fem,
                                color: Color(0xff262626),
                              ),
                            ),
                          ),
                          Text(
                            // effortlesslymanageyourusersx6Z (41:667)
                            '“EFFORTLESSLY MANAGE YOUR USERS”',
                            style: GoogleFonts.openSans (

                              fontSize: 16*ffem,
                              fontWeight: FontWeight.w600,
                              height: 1.3625*ffem/fem,
                              color: Color(0xa5262626),
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
                  border: Border.all(color: Color(0x11000000)),
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.circular(24*fem),
                ),
                child: Row(
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
                          color: Color(0xff37d1d3),
                          borderRadius: BorderRadius.circular(99*fem),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x4c000000),
                              offset: Offset(0*fem, 1*fem),
                              blurRadius: 1.5*fem,
                            ),
                            BoxShadow(
                              color: Color(0x3f32325d),
                              offset: Offset(0*fem, 2*fem),
                              blurRadius: 2.5*fem,
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              // addnewresidentVJm (55:1416)
                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 10*fem, 0*fem),
                              child: Text(
                                'Add New Resident',
                                style: GoogleFonts.openSans (

                                  fontSize: 16*ffem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.3625*ffem/fem,
                                  color: Color(0xffffffff),
                                ),
                              ),
                            ),
                            Container(
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
                    Container(
                      // frame1886q (55:1393)
                      padding: EdgeInsets.fromLTRB(24*fem, 16*fem, 20*fem, 16*fem),
                      height: double.infinity,
                      decoration: BoxDecoration (
                        color: Color(0xfff5f5f5),
                        borderRadius: BorderRadius.circular(85*fem),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // searchnamephonedZP (55:1394)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 125*fem, 0*fem),
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.openSans (

                                  fontSize: 16*ffem,
                                  fontWeight: FontWeight.w600,
                                  height: 1.3618164062*ffem/fem,
                                  color: Color(0xa5262626),
                                ),
                                children: [
                                  TextSpan(
                                    text: 'SEARCH',
                                    style: GoogleFonts.openSans (

                                      fontSize: 16*ffem,
                                      fontWeight: FontWeight.w600,
                                      height: 1.3625*ffem/fem,
                                      color: Color(0xa5262626),
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ',
                                    style: GoogleFonts.openSans (

                                      fontSize: 16*ffem,
                                      fontWeight: FontWeight.w600,
                                      height: 1.3625*ffem/fem,
                                      color: Color(0xa5262626),
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'N',
                                    style: GoogleFonts.openSans (

                                      fontSize: 16*ffem,
                                      fontWeight: FontWeight.w600,
                                      height: 1.3625*ffem/fem,
                                      color: Color(0xa5262626),
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'am',
                                    style: GoogleFonts.openSans (

                                      fontSize: 16*ffem,
                                      fontWeight: FontWeight.w600,
                                      height: 1.3625*ffem/fem,
                                      color: Color(0xa5262626),
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'e, phone.... ',
                                    style: GoogleFonts.openSans (

                                      fontSize: 16*ffem,
                                      fontWeight: FontWeight.w600,
                                      height: 1.3625*ffem/fem,
                                      color: Color(0xa5262626),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            // search55w (55:1395)
                            width: 24*fem,
                            height: 24*fem,
                            child: Image.asset(
                              'assets/ui-design-/images/search-nrZ.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 164*fem,
                    ),
                    Container(
                      // frame5090oXj (55:1430)
                      padding: EdgeInsets.fromLTRB(24*fem, 16*fem, 24*fem, 16*fem),
                      height: double.infinity,
                      decoration: BoxDecoration (
                        color: Color(0xff37d1d3),
                        borderRadius: BorderRadius.circular(99*fem),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x4c000000),
                            offset: Offset(0*fem, 1*fem),
                            blurRadius: 1.5*fem,
                          ),
                          BoxShadow(
                            color: Color(0x3f32325d),
                            offset: Offset(0*fem, 2*fem),
                            blurRadius: 2.5*fem,
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // exportdatag5j (55:1431)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 10*fem, 0*fem),
                            child: Text(
                              'Export Data',
                              style: GoogleFonts.openSans (

                                fontSize: 16*ffem,
                                fontWeight: FontWeight.w700,
                                height: 1.3625*ffem/fem,
                                color: Color(0xffffffff),
                              ),
                            ),
                          ),
                          Container(
                            // databaseexportbyP (59:1856)
                            width: 24*fem,
                            height: 24*fem,
                            child: Image.asset(
                              'assets/ui-design-/images/database-export.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // frame5109Ydj (59:1858)
                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 24*fem),
                padding: EdgeInsets.fromLTRB(24*fem, 24*fem, 24*fem, 24*fem),
                width: double.infinity,
                height: 104*fem,
                decoration: BoxDecoration (
                  border: Border.all(color: Color(0x11000000)),
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.circular(24*fem),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // frame18EmT (59:1862)
                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 450*fem, 0*fem),
                      padding: EdgeInsets.fromLTRB(24*fem, 16*fem, 23*fem, 16*fem),
                      height: double.infinity,
                      decoration: BoxDecoration (
                        color: Color(0xfff5f5f5),
                        borderRadius: BorderRadius.circular(85*fem),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // searchpagesYXF (59:1863)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 180*fem, 0*fem),
                            child: Text(
                              'SEARCH PAGES....',
                              style: GoogleFonts.openSans (

                                fontSize: 16*ffem,
                                fontWeight: FontWeight.w600,
                                height: 1.3625*ffem/fem,
                                color: Color(0xa5262626),
                              ),
                            ),
                          ),
                          Container(
                            // searchFgZ (59:1864)
                            width: 24*fem,
                            height: 24*fem,
                            child: Image.asset(
                              'assets/ui-design-/images/search-mDF.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // frame5110nwP (59:1882)
                      margin: EdgeInsets.fromLTRB(0*fem, 14*fem, 0*fem, 13.5*fem),
                      height: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // group138EZ (59:1868)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 0.5*fem),
                            padding: EdgeInsets.fromLTRB(6*fem, 6*fem, 6*fem, 6*fem),
                            height: 28*fem,
                            decoration: BoxDecoration (
                              border: Border.all(color: Color(0xff37d1d3)),
                              color: Color(0xffffffff),
                              borderRadius: BorderRadius.circular(14*fem),
                            ),
                            child: Center(
                              // chevronright2aq (59:1870)
                              child: SizedBox(
                                width: 16*fem,
                                height: 16*fem,
                                child: Image.asset(
                                  'assets/ui-design-/images/chevron-right.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16*fem,
                          ),
                          Container(
                            // frame5109YJH (59:1871)
                            margin: EdgeInsets.fromLTRB(0*fem, 0.5*fem, 0*fem, 0*fem),
                            height: 28*fem,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  // Tg9 (59:1872)
                                  '1',
                                  style: GoogleFonts.openSans (

                                    fontSize: 20*ffem,
                                    fontWeight: FontWeight.w700,
                                    height: 1.3625*ffem/fem,
                                    color: Color(0xff37d1d3),
                                  ),
                                ),
                                SizedBox(
                                  width: 12*fem,
                                ),
                                Container(
                                  // aEy (59:1873)
                                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 1*fem),
                                  child: Text(
                                    '2',
                                    style: GoogleFonts.openSans (

                                      fontSize: 16*ffem,
                                      fontWeight: FontWeight.w600,
                                      height: 1.3625*ffem/fem,
                                      color: Color(0xcc262626),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 12*fem,
                                ),
                                Container(
                                  // 5hX (59:1874)
                                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 1*fem),
                                  child: Text(
                                    '3',
                                    style: GoogleFonts.openSans (

                                      fontSize: 16*ffem,
                                      fontWeight: FontWeight.w600,
                                      height: 1.3625*ffem/fem,
                                      color: Color(0xcc262626),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 12*fem,
                                ),
                                Container(
                                  // bQy (59:1875)
                                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 1*fem),
                                  child: Text(
                                    '4',
                                    style: GoogleFonts.openSans (

                                      fontSize: 16*ffem,
                                      fontWeight: FontWeight.w600,
                                      height: 1.3625*ffem/fem,
                                      color: Color(0xcc262626),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 12*fem,
                                ),
                                Text(
                                  // JqB (59:1876)
                                  '........',
                                  style: GoogleFonts.openSans (

                                    fontSize: 20*ffem,
                                    fontWeight: FontWeight.w600,
                                    height: 1.3625*ffem/fem,
                                    color: Color(0xcc262626),
                                  ),
                                ),
                                SizedBox(
                                  width: 12*fem,
                                ),
                                Container(
                                  // r61 (59:1877)
                                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 1*fem),
                                  child: Text(
                                    '12',
                                    style: GoogleFonts.openSans (

                                      fontSize: 16*ffem,
                                      fontWeight: FontWeight.w600,
                                      height: 1.3625*ffem/fem,
                                      color: Color(0xcc262626),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 12*fem,
                                ),
                                Container(
                                  // xPw (59:1878)
                                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 1*fem),
                                  child: Text(
                                    '13',
                                    style: GoogleFonts.openSans (

                                      fontSize: 16*ffem,
                                      fontWeight: FontWeight.w600,
                                      height: 1.3625*ffem/fem,
                                      color: Color(0xcc262626),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 16*fem,
                          ),
                          Container(
                            // group144C5 (59:1879)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 0.5*fem),
                            padding: EdgeInsets.fromLTRB(6*fem, 6*fem, 6*fem, 6*fem),
                            height: 28*fem,
                            decoration: BoxDecoration (
                              border: Border.all(color: Color(0xff37d1d3)),
                              color: Color(0xffffffff),
                              borderRadius: BorderRadius.circular(14*fem),
                            ),
                            child: Center(
                              // chevronrightMS5 (59:1881)
                              child: SizedBox(
                                width: 16*fem,
                                height: 16*fem,
                                child: Image.asset(
                                  'assets/ui-design-/images/chevron-right-N8M.png',
                                  fit: BoxFit.contain,
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
              Container(
                // frame51086Pf (59:1825)
                padding: EdgeInsets.fromLTRB(0*fem, 24*fem, 0*fem, 22.5*fem),
                width: double.infinity,
                height: 628*fem,
                decoration: BoxDecoration (
                  border: Border.all(color: Color(0x19262626)),
                  color: Color(0xffffffff),
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
                            child: Text(
                              'No.',
                              style: GoogleFonts.openSans (

                                fontSize: 20*ffem,
                                fontWeight: FontWeight.w700,
                                height: 1.3625*ffem/fem,
                                color: Color(0xff262626),
                              ),
                            ),
                          ),
                          Container(
                            // profilepU5 (55:1497)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 101*fem, 0*fem),
                            child: Text(
                              'Profile',
                              style: GoogleFonts.openSans (

                                fontSize: 20*ffem,
                                fontWeight: FontWeight.w700,
                                height: 1.3625*ffem/fem,
                                color: Color(0xff262626),
                              ),
                            ),
                          ),
                          Container(
                            // nameYQ5 (55:1498)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 101*fem, 0*fem),
                            child: Text(
                              'Name',
                              style: GoogleFonts.openSans (

                                fontSize: 20*ffem,
                                fontWeight: FontWeight.w700,
                                height: 1.3625*ffem/fem,
                                color: Color(0xff262626),
                              ),
                            ),
                          ),
                          Container(
                            // status47X (55:1499)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 101*fem, 0*fem),
                            child: Text(
                              'Status',
                              style: GoogleFonts.openSans (

                                fontSize: 20*ffem,
                                fontWeight: FontWeight.w700,
                                height: 1.3625*ffem/fem,
                                color: Color(0xff262626),
                              ),
                            ),
                          ),
                          Container(
                            // phonenoNtu (55:1500)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 108*fem, 0*fem),
                            child: Text(
                              'Phone No',
                              style: GoogleFonts.openSans (

                                fontSize: 20*ffem,
                                fontWeight: FontWeight.w700,
                                height: 1.3625*ffem/fem,
                                color: Color(0xff262626),
                              ),
                            ),
                          ),
                          Container(
                            // pincodehwB (55:1501)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 89*fem, 0*fem),
                            child: Text(
                              'Pin Code',
                              style: GoogleFonts.openSans (

                                fontSize: 20*ffem,
                                fontWeight: FontWeight.w700,
                                height: 1.3625*ffem/fem,
                                color: Color(0xff262626),
                              ),
                            ),
                          ),
                          Text(
                            // actionsdpq (55:1502)
                            'Actions',
                            style: GoogleFonts.openSans (

                              fontSize: 20*ffem,
                              fontWeight: FontWeight.w700,
                              height: 1.3625*ffem/fem,
                              color: Color(0xff262626),
                            ),
                          ),
                        ],
                      ),
                    ),


                    StreamBuilder(stream: FirebaseFirestore.instance.collection("Users").orderBy("timestamp",descending: true).snapshots(),
                        builder: (context,snap){
                      return ListView.builder(
                        shrinkWrap: true,
                          itemCount: snap.data!.docs.length,
                          itemBuilder: (context,index){

                        return Container(
                          // frame5102azy (59:1668)
                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 22.5*fem),
                          padding: EdgeInsets.fromLTRB(31*fem, 24*fem, 24*fem, 25.5*fem),
                          width: double.infinity,
                          height: 89.5*fem,
                          child: Container(
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
                                      Container(
                                        // Nvq (59:1635)
                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 114*fem, 0*fem),
                                        child: Text(
                                          (index+1).toString(),
                                          style: GoogleFonts.openSans (

                                            fontSize: 16*ffem,
                                            fontWeight: FontWeight.w700,
                                            height: 1.3625*ffem/fem,
                                            color: Color(0xcc262626),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        // maskgroupHnu (59:1659)
                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 98*fem, 0*fem),
                                        width: 80*fem,
                                        height: 40*fem,
                                        child: Image.network(
                                          snap.data!.docs[index]["imageUrl"],
                                          width: 40*fem,
                                          height: 40*fem,
                                        ),
                                      ),
                                      Container(
                                        // sandheepsoWM (59:1636)
                                        width: 150*fem,
                                        height: 40*fem,
                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 0*fem),
                                        child: Text(
                                          snap.data!.docs[index]["firstName"],
                                          style: GoogleFonts.openSans (

                                            fontSize: 16*ffem,
                                            fontWeight: FontWeight.w600,
                                            height: 1.3625*ffem/fem,
                                            color: Color(0xcc262626),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        // frame5096XSM (59:1640)
                                        margin: EdgeInsets.fromLTRB(0*fem, 6*fem, 98*fem, 6*fem),
                                        width: 68*fem,
                                        height: double.infinity,
                                        decoration: BoxDecoration (
                                          color: Color(0xffddffe6),
                                          borderRadius: BorderRadius.circular(64*fem),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Active',
                                            style: GoogleFonts.openSans (

                                              fontSize: 16*ffem,
                                              fontWeight: FontWeight.w600,
                                              height: 1.3625*ffem/fem,
                                              color: Color(0xff1da543),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        // QFF (59:1641)
                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 123*fem, 0*fem),
                                        child: Text(
                                          snap.data!.docs[index]["phone"],
                                          style: GoogleFonts.openSans (

                                            fontSize: 16*ffem,
                                            fontWeight: FontWeight.w600,
                                            height: 1.3625*ffem/fem,
                                            color: Color(0xcc262626),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        // Kd7 (59:1642)
                                        snap.data!.docs[index]["pincode"],
                                        style: GoogleFonts.openSans (

                                          fontSize: 16*ffem,
                                          fontWeight: FontWeight.w600,
                                          height: 1.3625*ffem/fem,
                                          color: Color(0xcc262626),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  // frame5100UF7 (59:1656)
                                  height: double.infinity,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        // frame5099ppm (59:1652)
                                        padding: EdgeInsets.fromLTRB(8*fem, 8*fem, 8*fem, 8*fem),
                                        height: double.infinity,
                                        decoration: BoxDecoration (
                                          color: Color(0xfff5f5f5),
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
                                      SizedBox(
                                        width: 16*fem,
                                      ),
                                      Container(
                                        // frame5097gc5 (59:1647)
                                        padding: EdgeInsets.fromLTRB(8*fem, 8*fem, 8*fem, 8*fem),
                                        height: double.infinity,
                                        decoration: BoxDecoration (
                                          color: Color(0xfff5f5f5),
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
                                      SizedBox(
                                        width: 16*fem,
                                      ),
                                      Container(
                                        // frame5098jaM (59:1648)
                                        padding: EdgeInsets.fromLTRB(8*fem, 8*fem, 8*fem, 8*fem),
                                        height: double.infinity,
                                        decoration: BoxDecoration (
                                          color: Color(0xfff5f5f5),
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });

                    }),


                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ) : ResidentAddForm(displayFirstWidget: adduser,updateDisplay: updateDisplay,);
  }
}

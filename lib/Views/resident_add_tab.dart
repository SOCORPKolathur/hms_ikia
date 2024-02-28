
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/customtextfield.dart';



class Resident_Form extends StatefulWidget {
  final Function(bool) updateDisplay;
  final bool displayFirstWidget;
   Resident_Form({required this.displayFirstWidget,required this.updateDisplay});

  @override
  State<Resident_Form> createState() => _Resident_FormState();
}

class _Resident_FormState extends State<Resident_Form> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 1512;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
        Container(
        // frame5223yp9 (120:343)
        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 24*fem),
        width: double.infinity,
        height: 65*fem,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // frame22uC1 (90:3420)
              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 699*fem, 0*fem),
              height: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // residentdetailsq5f (90:3421)
                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 10*fem),
                    child: Text(
                      'ADD RESIDENT DETAILS',
                      style: GoogleFonts.openSans (
                        
                        fontSize: 24*ffem,
                        fontWeight: FontWeight.w700,
                        height: 1.3625*ffem/fem,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                  Text(
                    // effortlesslymanageyouruserswPb (90:3422)
                    '“Effortlessly manage your users”',
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
            // frame5171zgd (87:1710)
            padding: EdgeInsets.fromLTRB(64*fem, 71*fem, 64*fem, 76*fem),
            width: double.infinity,
            decoration: BoxDecoration (
            border: Border.all(color: Color(0x30262626)),
            color: Color(0xffffffff),
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
            InkWell(

              onTap: (){
                widget.updateDisplay(!widget.displayFirstWidget);
                print("Clicked");
              },
              child: Container(
              // chevrondown1rd (87:1510)
              margin: EdgeInsets.fromLTRB(0*fem, 3*fem, 364*fem, 0*fem),
              width: 24*fem,
              height: 24*fem,
              child: Icon(Icons.arrow_back_ios_new_rounded)
              ),
            ),
            Text(
            // addresidentdetailsvyb (87:1511)
            'Add Resident Details',
            style: GoogleFonts.openSans (
            
            fontSize: 24*ffem,
            fontWeight: FontWeight.w700,
            height: 1.3625*ffem/fem,
            color: Color(0xff000000),
            ),
            ),
            ],
            ),
            ),
            Container(
            // frame5170sP3 (87:1512)
            width: double.infinity,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Container(
            // frame5155DSu (87:1513)
            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 70.5*fem),
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
            width: double.infinity,
            decoration: BoxDecoration (
            border: Border.all(color: Color(0x38262626)),
            color: Color(0xffe5feff),
            borderRadius: BorderRadius.circular(88*fem),
            ),
            child: Center(
            // imageuploadbro1gzh (87:1518)
            child: SizedBox(
            width: 124.67*fem,
            height: 124.67*fem,
            child: Image.asset(
            'assets/ui-design-/images/image-upload-bro-1.png',
            fit: BoxFit.cover,
            ),
            ),
            ),
            ),
            Container(
            // uploadresidentphoto150px150pxn (87:1519)
            constraints: BoxConstraints (
            maxWidth: 155*fem,
            ),
            child: Text(
            'Upload Resident Photo\n( 150px * 150px)',
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans (
            
            fontSize: 14*ffem,
            fontWeight: FontWeight.w600,
            height: 1.3625*ffem/fem,
            color: Color(0x7f262626),
            ),
            ),
            ),
            ],
            ),
            ),
            Container(
            // frame5116sZP (87:1520)
            padding: EdgeInsets.fromLTRB(24*fem, 16*fem, 24*fem, 16*fem),
            width: double.infinity,
            decoration: BoxDecoration (
            border: Border.all(color: Color(0xff37d1d3)),
            borderRadius: BorderRadius.circular(152*fem),
            ),
            child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Container(
            // chooseimagebVP (87:1521)
            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 12*fem, 0*fem),
            child: Text(
            'Choose Image',
            style: GoogleFonts.openSans (
            
            fontSize: 16*ffem,
            fontWeight: FontWeight.w700,
            height: 1.3625*ffem/fem,
            color: Color(0xff37d1d3),
            ),
            ),
            ),
            Container(
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
               // CustomTextField(header:)
            ],
            ),
            ),
            Container(
            // frame51534Ny (87:1524)
            width: double.infinity,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Container(
            // frame5149DFs (87:1525)
            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 46.5*fem),
            width: double.infinity,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Container(
            // frame5147M7B (87:1526)
            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 46.5*fem),
            width: double.infinity,
            height: 381.5*fem,
            child: Container(
            // frame51446Kf (87:1527)
            width: double.infinity,
            height: 332*fem,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Container(
            // frame5143dqP (87:1528)
            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 30.5*fem),
            width: double.infinity,
            height: 52.5*fem,
            child: Text(
            'Resident Details',
            style: GoogleFonts.openSans (
            
            fontSize: 20*ffem,
            fontWeight: FontWeight.w700,
            height: 1.3625*ffem/fem,
            color: Color(0xff000000),
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
            ],
            ),
            ),

            ],
            ),
            ),
            ],
            ),
            )]
        
            ),
      ),
    );
  }
}

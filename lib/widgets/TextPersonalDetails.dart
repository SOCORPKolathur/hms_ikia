import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalDetailsText extends StatefulWidget {
  final String DHeading;
  final String UserData;
  const PersonalDetailsText({super.key, required this.DHeading, required this.UserData});

  @override
  State<PersonalDetailsText> createState() => _PersonalDetailsTextState();
}

class _PersonalDetailsTextState extends State<PersonalDetailsText> {
  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          children: [
          Text(widget.DHeading, style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 15,color: Colors.black.withOpacity(0.9))),
          Expanded(child: Text(widget.UserData,style: GoogleFonts.openSans(fontWeight: FontWeight.w600,  fontSize: 15,color: Colors.black.withOpacity(0.6))))
        ],),
      );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_ikia/Constants/constants.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final TextEditingController? controller;
  final String? header;
  final String? Function(String?)? validator;
  final String? Function(String?)? onSubmitted;
  final double? width;
  CustomTextField(
      {super.key,
        required this.hint,
        this.header,
        required this.controller,
        required this.validator,
         this.onSubmitted,
         this.width,
      });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          // firstnameSVK (87:1540)

          child: Text(
            widget.header!,
            style: GoogleFonts.openSans (

              fontSize: 14,
              fontWeight: FontWeight.w600,

              color: Color(0xff262626),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(


            width: widget.width == null ?220 :  widget.width,
            height: 50,
            decoration: BoxDecoration (
              border: Border.all(color: Color(0x7f262626)),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0,right: 6),
              child: TextFormField(
                cursorColor: Constants().primaryAppColor,
                controller: widget.controller,
                onFieldSubmitted: widget.onSubmitted,
                validator: widget.validator,

                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.hint,
                  hintStyle: GoogleFonts.openSans (

                    fontSize: 12,
                    fontWeight: FontWeight.w600,

                    color: Color(0x7f262626),
                  ),
                ),

                style: GoogleFonts.openSans (

                  fontSize: 13,
                  fontWeight: FontWeight.w600,

                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

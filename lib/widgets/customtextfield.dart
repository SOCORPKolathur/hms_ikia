import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for TextInputFormatter
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_ikia/Constants/constants.dart';

import 'kText.dart';
//
// class CustomTextField extends StatefulWidget {
//   final String hint;
//   final TextEditingController? controller;
//   final String? header;
//   final IconData? preffixIcon;
//   final IconData? suffixIcon;
//   final Color? hintColor;
//   final Color? fillColor;
//   final Color? prefixColor;
//   final Color? suffixColor;
//   final void Function(String)? onChanged;
//   final Function()? onTap;
//   final List<TextInputFormatter>? inputFormatters; // Allow null
//   final Function()? onPressed;
//   final String? Function(String?)? validator;
//   final String? Function(String?)? onSubmitted;
//   final String? Function()? functionHere;
//   final bool? readOrwrite;
//   final double? width;
//   final double? height;
//
//   CustomTextField({
//     Key? key,
//     this.fillColor,
//     this.onTap,
//     this.hintColor,
//     required this.hint,
//     this.preffixIcon,
//     this.suffixIcon,
//     this.header,
//     required this.controller,
//     required this.validator,
//     this.onSubmitted,
//     this.width,
//     this.height,
//     this.prefixColor,
//     this.suffixColor,
//     this.onChanged,
//     this.readOrwrite,
//     this.onPressed,
//     this.functionHere,
//     this.inputFormatters,
//   }) : super(key: key);
//
//   @override
//   State<CustomTextField> createState() => _CustomTextFieldState();
// }
//
// class _CustomTextFieldState extends State<CustomTextField> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         if (widget.header != '')
//           Padding(
//             padding: const EdgeInsets.only(left: 10),
//             child: Container(
//               child:
//               Row(
//                 children: [
//                   Text(
//                     widget.header!,
//                     style: GoogleFonts.openSans(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xff262626),
//                     ),
//                   ),
// if(widget.validator != null)
//                   Text(
//                     '  *Required this',
//                     style: GoogleFonts.openSans(
//                       fontStyle: FontStyle.italic,
//                       fontSize: 10,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xffF12D2D),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         else
//           SizedBox(),
//         Padding(
//           padding: EdgeInsets.only(top: widget.header != '' ? 8.0 : 0),
//           child: Container(
//             width: widget.width == null ? 220 : widget.width,
//             height: widget.height == null ? 50 : widget.height,
//             decoration: BoxDecoration(
//               color: widget.fillColor == null ? Colors.white : widget.fillColor,
//               borderRadius: BorderRadius.circular(30),
//               border: Border.all(color: Color(0x7f262626)),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.only(left: 15, right: 20),
//               child: TextFormField(
//                 onTap: () {},
//                 inputFormatters: widget.inputFormatters != null ? widget.inputFormatters : [],
//                 cursorColor: Constants().primaryAppColor,
//                 onChanged: widget.onChanged,
//                 controller: widget.controller,
//                 readOnly: widget.readOrwrite == null ? widget.readOrwrite == false : widget.readOrwrite == true,
//                 onFieldSubmitted: widget.onSubmitted,
//                 validator: widget.validator,
//                 decoration: InputDecoration(
//                   prefixIcon: widget.preffixIcon != null
//                       ? IconButton(
//                     onPressed: () {
//                       print('Just');
//                       widget.functionHere?.call();
//                     },
//                     icon: Icon(widget.preffixIcon, color: widget.prefixColor),
//                   )
//                       : null,
//                   suffixIcon: Icon(widget.suffixIcon, color: widget.suffixColor),
//                   border: InputBorder.none,
//                   hintText: widget.hint,
//                   hintStyle: GoogleFonts.openSans(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                     color: widget.hintColor == null ? Color(0x7f262626) : widget.hintColor,
//                   ),
//                 ),
//                 style: GoogleFonts.openSans(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart'; // Import for TextInputFormatter
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hms_ikia/Constants/constants.dart';
class CustomTextField extends StatefulWidget {
  final String hint;
  final TextEditingController? controller;
  final String? header;
  final IconData? preffixIcon;
  final IconData? suffixIcon;
  final Color? hintColor;
  final Color? fillColor;
  final Color? prefixColor;
  final Color? suffixColor;
  final void Function(String)? onChanged;
  final Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final Function()? onPressed;
  final String? Function(String?)? validator;
  final String? Function(String?)? onSubmitted;
  final String? Function()? functionHere;
  final bool? readOrwrite;
  final double? width;
  final double? height;
  final bool? showError;
  final String? ErrorMsg;

  CustomTextField({
    Key? key,
    this.fillColor,
    this.onTap,
    this.hintColor,
    required this.hint,
    this.preffixIcon,
    this.suffixIcon,
    this.header,
    required this.controller,
    required this.validator,
    this.onSubmitted,
    this.width,
    this.height,
    this.prefixColor,
    this.suffixColor,
    this.onChanged,
    this.readOrwrite,
    this.onPressed,
    this.functionHere,
    this.inputFormatters,
    this.showError, this.ErrorMsg, // Make showError optional
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.header != '')
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Container(
              child: Row(
mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  KText(
                   text: widget.header!,
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff262626),
                    ),
                  ),
                  if (widget.showError != null && widget.showError! && (widget.validator != null))
                    KText(
                      // '  *Required this',
                      text: widget.ErrorMsg == null ? '*Required' : widget.ErrorMsg.toString(),
                      style: GoogleFonts.openSans(
                        fontStyle: FontStyle.italic,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xffF12D2D),
                      ),
                    ),
                ],
              ),
            ),
          )
        else
          SizedBox(),
        Padding(
          padding: EdgeInsets.only(top: widget.header != '' ? 8.0 : 0),
          child: Container(
            width: widget.width == null ? 220 : widget.width,
            height: widget.height == null ? 50 : widget.height,
            decoration: BoxDecoration(
              color: widget.fillColor == null ? Colors.white : widget.fillColor,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Color(0x7f262626)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 20),
              child: TextFormField(
                onTap: () {},
                inputFormatters: widget.inputFormatters != null ? widget.inputFormatters : [],
                cursorColor: Constants().primaryAppColor,
                onChanged: widget.onChanged,
                controller: widget.controller,
                readOnly: widget.readOrwrite == null ? widget.readOrwrite == false : widget.readOrwrite == true,
                onFieldSubmitted: widget.onSubmitted,
                validator: widget.validator,
                decoration: InputDecoration(
                  prefixIcon: widget.preffixIcon != null
                      ? IconButton(
                    onPressed: () {
                      print('Just');
                      widget.functionHere?.call();
                    },
                    icon: Icon(widget.preffixIcon, color: widget.prefixColor),
                  )
                      : null,
                  suffixIcon: Icon(widget.suffixIcon, color: widget.suffixColor),
                  border: InputBorder.none,
                  hintText: widget.hint,
                  hintStyle: GoogleFonts.openSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: widget.hintColor == null ? Color(0x7f262626) : widget.hintColor,
                  ),
                ),
                style: GoogleFonts.openSans(
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

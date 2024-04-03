
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_ikia/widgets/kText.dart';

import 'ContainerIcon.dart';
class ReusableHeader extends StatefulWidget {
  final String Headertext;
  final String SubHeadingtext;
  const ReusableHeader({super.key, required this.Headertext, required this.SubHeadingtext});

  @override
  State<ReusableHeader> createState() => _ReusableHeaderState();
}

class _ReusableHeaderState extends State<ReusableHeader> {
  @override
  Widget build(BuildContext context) {
    return   Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KText(text:widget.Headertext,
              style: GoogleFonts.openSans(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
        //     KText(text: widget.Headertext, style: GoogleFonts.openSans(
        //   fontSize: 28,
        //   fontWeight: FontWeight.w700,
        //   color: Colors.black,
        // ),),


            const SizedBox(height: 8,),
            KText(text:widget.SubHeadingtext, style: GoogleFonts.openSans(),),
          ],),
        //  const SizedBox(
        //   width: 150,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     children: [
        //       ContainerIcon(imagePath: 'assets/ui-design-/images/doorbell-bg.png'),
        //       ContainerIcon(imagePath: 'assets/ui-design-/images/translator.png'),
        //       ContainerIcon(imagePath: 'assets/ui-design-/images/gear.png'),
        //     ],),
        // )
      ],);
  }
}

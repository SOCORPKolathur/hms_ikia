


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_ikia/widgets/kText.dart';
import 'package:lottie/lottie.dart';



class NodataWidget extends StatefulWidget {
  const NodataWidget({Key? key}) : super(key: key);

  @override
  State<NodataWidget> createState() => _NodataWidgetState();
}

class _NodataWidgetState extends State<NodataWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        height: 400,
        child: Column(
          children: [
            Container(
              child: Lottie.asset("assets/nodata.json"),
            ),

            KText(text: "No Data Available", style: GoogleFonts.openSans(
              fontWeight: FontWeight.bold,
            ),)
          ],
        ),
      ),
    );
  }
}

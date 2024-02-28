import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_ikia/Constants/constants.dart';
import 'package:url_launcher/url_launcher.dart';


class DeveloperCardWidget extends StatelessWidget {
  const DeveloperCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final Uri toLaunch =
        Uri.parse("http://ardigitalsolutions.co/");
        if (!await launchUrl(toLaunch,
          mode: LaunchMode.externalApplication,
        )) {
          throw Exception('Could not launch $toLaunch');
        }
      },
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
              //color: Colors.white,
              color: Color(0xfffdff8c),
              borderRadius: BorderRadius.circular(12),
              border:Border.all(color: Constants().primaryAppColor,)
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 27,
                  child: Image.asset(
                      "assets/Untitled-2.png",

                  ),
                ),
                SizedBox(width: 10),
                Text(
                  "IKIA - ",
                  style: GoogleFonts.poppins(
                    //color: Colors.black,
                    color: Color(0xffb80d38),
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                // CircleAvatar(
                //   backgroundColor: Colors.white,
                //   child: Center(
                //     child: ClipRRect(
                //       borderRadius: BorderRadius.circular(100),
                //       child: Image.network(
                //         churchLogo,
                //         height: 40,
                //         width: 40,
                //       ),
                //     ),
                //   ),
                // ),
                Text(
                  "Version 1.0.0.1 Developed by AR Digital Solutions @ 2023. All Rights Reserved",
                  style: GoogleFonts.poppins(
                    color: Color(0xffb80d38),
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_ikia/Constants/constants.dart';
import 'package:hms_ikia/widgets/kText.dart';
import 'package:url_launcher/url_launcher.dart';


class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 170.75, vertical: height / 81.375),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: width/68.3),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back,color:Color(0xffb80d38)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width / 170.75,
                        //vertical: height / 81.375,
                      ),
                      child: KText(
                        text: "About Us",
                        style: GoogleFonts.openSans(
                          fontSize: width/37.94,
                          fontWeight: FontWeight.w900,
                          color: Color(0xffb80d38),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width / 170.75,
                    // vertical: height / 81.375,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Material(
                            elevation: 3,
                            borderRadius: BorderRadius.circular(12),
                            shadowColor: Constants().primaryAppColor,
                            child: Container(
                              height: height/7.3,
                              width: width/5.464,
                              decoration: BoxDecoration(
                                  color:Color(0xfffdff8c),
                                  borderRadius: BorderRadius.circular(12),
                                  border:Border.all(color: Color(0xfffdff8c),)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    //"Version",
                                    "IKIA",
                                    style: GoogleFonts.poppins(
                                      color: Color(0xffb80d38),
                                      fontWeight: FontWeight.w600,
                                      fontSize: width/68.3,
                                    ),),
                                  ChoiceChip(
                                    label: Text("V1.0.0.1",style: TextStyle(color: Colors.white),),
                                    onSelected: (bool selected) {
                                      setState(() {
                                      });
                                    },
                                    selectedColor: Color(0xffb80d38),
                                    shape: StadiumBorder(
                                        side: BorderSide(
                                          color: Constants().primaryAppColor,)),
                                    backgroundColor: Colors.white,
                                    labelStyle: TextStyle(color: Colors.black),
                                    elevation: 1.5, selected: true,),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: height/32.55),
                          KText(
                            text: "AR Digital Solutions",
                            style: GoogleFonts.openSans(
                              fontSize: width/54.64,
                              fontWeight: FontWeight.w600,
                              color: Color(0xffb80d38),
                            ),
                          ),
                          SizedBox(height: height/32.55),
                          SizedBox(
                            height: height/3.17,
                            width: size.width / 2.5,
                            child: Column(
                              children: [
                                Text(
                                  "We are System Integrators who aim to increase the capabilities of people and the performance of the organizations we serve.\nWe aim to travel with our customers throughout their journey helping them to evolve their business and inspiring them to redefine their current business mode",
                                  style: GoogleFonts.poppins(
                                    color: Color(0xffb80d38),
                                    fontWeight: FontWeight.w500,
                                    fontSize: width/68.3,
                                  ),
                                ),
                                /* SizedBox(height: height/32.55),
                              Text(
                                "",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: width/75.88888888888889,
                                ),
                              )*/
                              ],
                            ),
                          )
                        ],
                      ),
                      Container(
                          height: height/1.302,
                          width: size.width / 2.5,
                          child: Center(
                            child: Container(
                              // child: Lottie.asset(
                              //   height: height/1.302,
                              //   "assets/about_us.json",
                              // ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(1000),
                                child: Image.asset("assets/Logo F.png"),
                              ),
                            ),
                          )
                      )
                    ],
                  ),
                ),
                //SizedBox(height: height/65.1),
                SizedBox(height: height/65.1),
                SizedBox(height: height/65.1),
                SizedBox(height: height/65.1),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: width/34.15),
                    Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xfffdff8c),
                            borderRadius: BorderRadius.circular(12),
                            border:Border.all(color: Constants().primaryAppColor,)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Help Desk :",
                                style: GoogleFonts.poppins(
                                  color: Color(0xffb80d38),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: height/65.1),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: height/9.3,
                                    width: width/19.51428571428571,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/help_desk.png"
                                            )
                                        )
                                    ),
                                  ),
                                  SizedBox(width: width/136.6),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.phone,color: Color(0xffb80d38),),
                                          SizedBox(width: width/136.6),
                                          Card("+919884890121")
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(CupertinoIcons.globe,color: Color(0xffb80d38),),
                                          SizedBox(width: width/136.6),
                                          InkWell(
                                              onTap: () async {
                                                final Uri toLaunch =
                                                Uri.parse("http://ardigitalsolutions.co/");
                                                if (!await launchUrl(toLaunch,
                                                  mode: LaunchMode.externalApplication,
                                                )) {
                                                  throw Exception('Could not launch $toLaunch');
                                                }
                                              },
                                              child: Card("http://ardigitalsolutions.co/")
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.alternate_email,color: Color(0xffb80d38),),
                                          SizedBox(width: width/136.6),
                                          Card("satishkumar@ardigitalsolutions.co"),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Row(
                    //   children: [
                    //     SizedBox(width: width/34.15),
                    //     InkWell(
                    //       onTap: () async {
                    //         // setState(() {
                    //         //   isViewTerms = true;
                    //         // });
                    //         Navigator.push(context, MaterialPageRoute(builder: (ctx) => const TermsPage()));
                    //       },
                    //       child: Material(
                    //         elevation: 3,
                    //         borderRadius: BorderRadius.circular(12),
                    //         child: Container(
                    //           width: 300,
                    //           decoration: BoxDecoration(
                    //               color: Color(0xfffdff8c),
                    //               borderRadius: BorderRadius.circular(12),
                    //               border:Border.all(color: Constants().primaryAppColor,)
                    //           ),
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(4.0),
                    //             child: Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 Row(
                    //                   mainAxisAlignment: MainAxisAlignment.start,
                    //                   children: [
                    //                     Container(
                    //                       height: 30,
                    //                       width: 30,
                    //                       decoration: BoxDecoration(
                    //                           image: DecorationImage(
                    //                               image: AssetImage(
                    //                                   "assets/tandc.png"
                    //                               )
                    //                           )
                    //                       ),
                    //                     ),
                    //                     SizedBox(width: width/136.6),
                    //                     Text(
                    //                       "Terms & Conditions",
                    //                       style: GoogleFonts.poppins(
                    //                         color: Color(0xffb80d38),
                    //                         fontSize: width /97.57142857142857,
                    //                         fontWeight: FontWeight.w600,
                    //                       ),
                    //                     )
                    //                   ],
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
                SizedBox(height: height/65.1),
                Center(
                  child: Column(
                    children: [
                      Material(
                        elevation: 3,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 80,
                          width: width / 1.75,
                          decoration: BoxDecoration(
                            //color: Colors.white,
                              color: Color(0xfffdff8c),
                              borderRadius: BorderRadius.circular(12),
                              border:Border.all(color: Constants().primaryAppColor,)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 60,
                                child: Image.asset(
                                  "assets/Untitled-2.png",
                                ),
                              ),
                              Center(
                                child: Text(
                                  "IKIA\nDeveloped By\nAR Digital Solutions @ 2023",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: Color(0xffb80d38),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/tandc.png"
                                              )
                                          )
                                      ),
                                    ),
                                    InkWell(
                                      onTap: (){
                                        //Navigator.push(context, MaterialPageRoute(builder: (ctx)=> const TermsPage()));
                                      },
                                      child: Text(
                                        "Terms & Conditions",
                                        style: GoogleFonts.poppins(
                                          color: Color(0xffb80d38),
                                          fontSize: width /97.57142857142857,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
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
        )
    );
  }
  Widget Card(String value){
    double width = MediaQuery.of(context).size.width;
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: Color(0xfffdff8c),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                value,
                style: GoogleFonts.poppins(
                  color: Color(0xffb80d38),
                  fontSize: width /97.57142857142857,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

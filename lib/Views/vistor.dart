import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/ReusableHeader.dart';
import '../widgets/ReusableRoomContainer.dart';
import '../widgets/customtextfield.dart';
import 'package:flutter_svg/flutter_svg.dart';


class Visitor_Page extends StatefulWidget {
  const Visitor_Page({super.key});

  @override
  State<Visitor_Page> createState() => _Visitor_PageState();
}

class _Visitor_PageState extends State<Visitor_Page> {
  final TextEditingController searchVisitors = TextEditingController();
  final Color _svgColor = Colors.blue;
  @override
  Widget build(BuildContext context) {
    return  FadeInRight(
      child:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Image.asset("assets/Visitor Management.png"),
              const ReusableHeader(Headertext: 'Fees Register ', SubHeadingtext: '"Manage Easily Residents Records"'),
              const SizedBox(height: 20,),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //   Container(
              //     decoration: const BoxDecoration(color: Color(0xff034D7F), borderRadius: BorderRadius.all(Radius.circular(20))),
              //     height: 270,
              //     width: 360,
              //     // color: Color(0xff034D7F),
              //     child: Stack(
              //       children: [
              //         Positioned(
              //           top: 192,
              //           left: 260,
              //           child: SizedBox(
              //               height: 100,
              //               width: 200,
              //               child: Image.asset('assets/ui-design-/images/Group 98.png')),
              //         ),
              //         Positioned(
              //        left: -20,
              //           top: -20,
              //           child: SizedBox(
              //             height: 75,
              //               width: 75,
              //
              //               child: Image.asset('assets/ui-design-/images/Ellipse 31.png')),
              //         ),
              //
              //         Positioned(
              //           top: 130,
              //           left: 250,
              //           child: SizedBox(
              //              width: 100,
              //               child: Image.asset('assets/ui-design-/images/Vector 38 (1).png')),
              //         ),
              //         Positioned(
              //           top: 40,
              //           child: Column(
              //             children: [
              //               Row(
              //                 crossAxisAlignment: CrossAxisAlignment.center,
              //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                 children: [
              //                   const SizedBox(width: 80,),
              //
              //                   CircleAvatar(
              //                     backgroundColor: const Color(0xffB5E1FF),
              //                       radius: 40,
              //                       child: Padding(
              //                         padding:  const EdgeInsets.all(15),
              //                         child: Image.asset('assets/ui-design-/images/Waiting Room.png'),
              //                       )),
              //                   const SizedBox(width: 30,),
              //                   Text('18', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 65, color: Colors.white),),
              //                   const SizedBox(width: 30,),
              //
              //
              //                 ],
              //               ),
              //               const SizedBox(height: 20,),
              //
              //               SizedBox(
              //                   width: 200,
              //                   child: Text('Today Total Visitors', style: GoogleFonts.openSans(fontSize: 25, fontWeight: FontWeight.w600, color: Colors.white),))
              //
              //             ],
              //
              //           ),
              //         ),
              //       ],
              //     ),
              //
              //   ),
              //   Container(
              //     decoration: const BoxDecoration(color: Color(0xff1DA644), borderRadius: BorderRadius.all(Radius.circular(20))),
              //     height: 270,
              //     width: 360,
              //     // color: Color(0xff034D7F),
              //     child: Stack(
              //       children: [
              //         Positioned(
              //           top: 192,
              //           left: 260,
              //           child: SizedBox(
              //               height: 100,
              //               width: 200,
              //               child: Image.asset('assets/ui-design-/images/Group 98.png')),
              //         ),
              //         Positioned(
              //           left: -20,
              //           top: -20,
              //           child: SizedBox(
              //               height: 75,
              //               width: 75,
              //
              //               child: Image.asset('assets/ui-design-/images/Ellipse 31.png')),
              //         ),
              //
              //         Positioned(
              //           top: 130,
              //           left: 250,
              //           child: SizedBox(
              //               width: 100,
              //               child: Image.asset('assets/ui-design-/images/Vector 38 (1).png')),
              //         ),
              //         Positioned(
              //           top: 40,
              //           child: Column(
              //             children: [
              //               Row(
              //                 crossAxisAlignment: CrossAxisAlignment.center,
              //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                 children: [
              //                   const SizedBox(width: 80,),
              //
              //                   CircleAvatar(
              //                       backgroundColor: const Color(0xffB5E1FF),
              //                       radius: 40,
              //                       child: Padding(
              //                         padding:  const EdgeInsets.all(15),
              //                         child: Image.asset('assets/ui-design-/images/Waiting Room.png'),
              //                       )),
              //                   const SizedBox(width: 30,),
              //                   Text('18', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 65, color: Colors.white),),
              //                   const SizedBox(width: 30,),
              //
              //
              //                 ],
              //               ),
              //               const SizedBox(height: 20,),
              //
              //               SizedBox(
              //                   width: 200,
              //                   child: Text('Today Total Visitors', style: GoogleFonts.openSans(fontSize: 25, fontWeight: FontWeight.w600, color: Colors.white),))
              //
              //             ],
              //
              //           ),
              //         ),
              //       ],
              //     ),
              //
              //   ),
              //   Container(
              //     decoration: const BoxDecoration(color: Color(0xffF12D2D), borderRadius: BorderRadius.all(Radius.circular(20))),
              //     height: 270,
              //     width: 360,
              //     // color: Color(0xff034D7F),
              //     child: Stack(
              //       children: [
              //         Positioned(
              //           top: 192,
              //           left: 260,
              //           child: SizedBox(
              //               height: 100,
              //               width: 200,
              //               child: Image.asset('assets/ui-design-/images/Group 98.png')),
              //         ),
              //         Positioned(
              //           left: -20,
              //           top: -20,
              //           child: SizedBox(
              //               height: 75,
              //               width: 75,
              //
              //               child: Image.asset('assets/ui-design-/images/Ellipse 31.png')),
              //         ),
              //
              //         Positioned(
              //           top: 130,
              //           left: 250,
              //           child: SizedBox(
              //               width: 100,
              //               child: Image.asset('assets/ui-design-/images/Vector 38 (1).png')),
              //         ),
              //         Positioned(
              //           top: 40,
              //           child: Column(
              //             children: [
              //               Row(
              //                 crossAxisAlignment: CrossAxisAlignment.center,
              //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                 children: [
              //                   const SizedBox(width: 80,),
              //
              //                   CircleAvatar(
              //                       backgroundColor: const Color(0xffB5E1FF),
              //                       radius: 40,
              //                       child: Padding(
              //                         padding:  const EdgeInsets.all(15),
              //                         child: Image.asset('assets/ui-design-/images/Waiting Room.png'),
              //                       )),
              //                   const SizedBox(width: 30,),
              //                   Text('18', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 65, color: Colors.white),),
              //                   const SizedBox(width: 30,),
              //
              //
              //                 ],
              //               ),
              //               const SizedBox(height: 20,),
              //
              //               SizedBox(
              //                   width: 200,
              //                   child: Text('Today Total Visitors', style: GoogleFonts.openSans(fontSize: 25, fontWeight: FontWeight.w600, color: Colors.white),))
              //
              //             ],
              //
              //           ),
              //         ),
              //       ],
              //     ),
              //   )
              // ],),
               const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ReusableRoomContainer(
                    firstColor: Color(0xff034d7f),
                    secondColor: Color(0xff058be5),
                    totalRooms: '40',
                    title: 'Today Total Visitors',
                    waveImg: 'assets/ui-design-/images/Vector 38 (1).png', roomImg: 'assets/ui-design-/images/Group 70.png',
                  ),
                  ReusableRoomContainer(
                    firstColor: Color(0xff0e4d1f),
                    secondColor: Color(0xff1b9a3f),
                    totalRooms: '20',
                    title: 'Today Visitors  Check In',
                    waveImg: 'assets/ui-design-/images/Vector 37 (3).png', roomImg: 'assets/ui-design-/images/Group 71.png',
                  ),
                  ReusableRoomContainer(

                    firstColor: Color(0xff971c1c),
                    secondColor: Color(0xffe22a2a),
                    totalRooms: '20',
                    title: 'Today Visitors Check Out',
                    waveImg: 'assets/ui-design-/images/Vector 36 (3).png', roomImg: 'assets/ui-design-/images/Group 72.png',
                  ),
                ],
              ),

              const SizedBox(height: 20,),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color:  const Color(0xff262626).withOpacity(0.10)),
                  borderRadius: BorderRadius.circular(30),
                ),
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // SizedBox(width: 20,),
                    Padding(
                      padding:  const EdgeInsets.only(left: 20),
                      child: CustomTextField(hint: 'search Visitors Name, No....',  controller: searchVisitors, validator: null, fillColor: const Color(0xffF5F5F5),header: '', width: 335, preffixIcon: Icons.search,height: 45, ),
                    ),
                    SizedBox.fromSize(size:  const Size(0, 0),),
                    Padding(
                      padding:  const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 44,
                            // width: 100,
                            child: ElevatedButton(
                                style:  const ButtonStyle(
                                    elevation: MaterialStatePropertyAll(2),
                                    backgroundColor: MaterialStatePropertyAll(Color(0xff37D1D3))),
                                onPressed: (){}, child:
                            Row(
                              children: [
                                 const Text('Add Visitors', style: TextStyle(color: Colors.white),), SizedBox.fromSize(size: const Size(8,0),),  CircleAvatar(radius: 12,backgroundColor: Colors.transparent,
                                  child: Image.asset('assets/ui-design-/images/Waiting Room.png')
                                )
                              ],)
                            ),
                          ),
                          SizedBox.fromSize(size: const Size(23,0),),
                          Container(
                            height: 44,
                            // width: 100,
                            child: ElevatedButton(
                                style: const ButtonStyle(
                                    elevation: MaterialStatePropertyAll(2),
                                    backgroundColor: MaterialStatePropertyAll(Color(0xffFD7E50))),
                                onPressed: (){}, child:
                            Row(
                              children: [
                                 const Text('Export Data', style: TextStyle(color: Colors.white),), SizedBox.fromSize(size: const Size(8,0),),  CircleAvatar(radius: 12,backgroundColor: Colors.transparent,
                                  child: Center(child: SvgPicture.asset('assets/ui-design-/images/Database Export.svg', color: _svgColor, semanticsLabel: 'SVG Image',width: 100)
                                  ),
                                )
                              ],)
                            ),
                          ),

                        ],),
                    )
                  ],),),


         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Container(
             decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20)
             ),
               border: Border.all(color: Colors.blue)
             ),
             height: 500,
             width: double.infinity,
           child:

           Padding(
             padding: const EdgeInsets.all(15),
             child:

             Column(
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                   Container(
                       height: 50,
                       width: 100,
                       child: Center(child: Text('S.No', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),
                       )
                       )),
                     Container(

                         height: 50,
                         width: 100,
                         child: Center(child: Text('ID', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),))),
                     Container(

                         height: 50,
                         width: 150,
                         child: Center(child: Text('Visitor Name', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),))),

                     Container(

                         height: 50,
                         width: 100,
                         child: Center(child: Text('Phone No', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),))),

                     Container(

                         height: 50,
                         width: 100,
                         child: Center(child: Text('Purpose', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),))),
                     Container(
                         height: 50,
                         width: 200,
                         child: Center(child: Text('Check In/Check Out', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),))),
                     Container(
                         height: 50,
                         width: 130,
                         child: Center(child: Text('Status', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),))),

                     Container(
                         height: 50,
                         width: 100,
                         child: Center(child: Text('Actions', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),))),
                 ],),

                 Container(color: const Color(0xff262626).withOpacity(0.1), width: double.infinity, height: 2,),
                 ListView(
                   shrinkWrap: true,
                   children: [
                     Column(
                       children: [
                         Padding(
                           padding: const EdgeInsets.only(top: 10, bottom: 10),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Container(
                                   height: 50,
                                   width: 100,
                                   child: Center(child: Text('1.', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),
                               Container(
                                   height: 50,
                                   width: 100,
                                   child: Center(child: Text('24578GH', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),
                               Container(
                                   height: 50,
                                   width: 150,
                                   child: Center(child: Text('Sandheep S', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),
                               Container(

                                   height: 50,
                                   width: 100,
                                   child: Center(child: Text('9859237982', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),

                               Container(
                                   height: 50,
                                   width: 100,
                                   child: Center(child: Text('Delivery', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),

                               Container(
                                   height: 50,
                                   width: 200,
                                   child: Center(child: Text('10:00 Pm - 10:45 Pm', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),
                               Container(
                                   height: 50,
                                   width: 130,
                                   child: Center(child: ElevatedButton(
                                     style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xffFFD3D3))),
                                     onPressed: () {  }, child: Text('Check out', style: GoogleFonts.openSans(color: const Color(0xffF12D2D), fontSize: 15),),)
                                   )
                               ),
                               Container(
                                   height: 50,
                                   width: 100,
                                   child: Center(
                                       child: Row(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: [
                                           CircleAvatar(
                                             radius: 12,
                                             backgroundColor: const Color(0xffF5F5F5),

                                             child: Padding(
                                               padding: const EdgeInsets.all(3),
                                               child: Image.asset('assets/ui-design-/images/edit.png'),
                                             ),
                                           ),
                                           const SizedBox(width: 8,),
                                           CircleAvatar(
                                             radius: 12,
                                             backgroundColor: const Color(0xffF5F5F5),
                                             child: Padding(
                                               padding: const EdgeInsets.all(3),
                                               child: Image.asset('assets/ui-design-/images/eye-8QM.png'),
                                             ),
                                           ),
                                         ],)
                                   )),
                             ],),
                         ),
                         Container(color: const Color(0xff262626).withOpacity(0.1), width: double.infinity, height: 2,),

                       ],
                     ),
                     Column(
                       children: [
                         Padding(
                           padding: const EdgeInsets.only(top: 10, bottom: 10),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Container(
                                   height: 50,
                                   width: 100,
                                   child: Center(child: Text('2.', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),
                               Container(
                                   height: 50,
                                   width: 100,
                                   child: Center(child: Text('24578GH', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),
                               Container(
                                   height: 50,
                                   width: 150,
                                   child: Center(child: Text('Sandheep S', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),
                               Container(

                                   height: 50,
                                   width: 100,
                                   child: Center(child: Text('9859237982', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),

                               Container(

                                   height: 50,
                                   width: 100,
                                   child: Center(child: Text('Delivery', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),

                               Container(

                                   height: 50,
                                   width: 200,
                                   child: Center(child: Text('10:00 Pm - 10:45 Pm', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),
                               Container(
                                   height: 50,
                                   width: 130,
                                   child: Center(child: ElevatedButton(
                                     style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xffDDFFE7))),
                                     onPressed: () {  }, child: Text('Check In', style: GoogleFonts.openSans(color: const Color(0xff1DA644), fontSize: 15),),)
                                   )
                               ),
                               Container(
                                   height: 50,
                                   width: 100,
                                   child: Center(
                                       child: Row(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: [
                                           CircleAvatar(
                                             radius: 12,
                                             backgroundColor: const Color(0xffF5F5F5),

                                             child: Padding(
                                               padding: const EdgeInsets.all(3),
                                               child: Image.asset('assets/ui-design-/images/edit.png'),
                                             ),
                                           ),
                                           const SizedBox(width: 8,),
                                           CircleAvatar(
                                             radius: 12,
                                             backgroundColor: const Color(0xffF5F5F5),
                                             child: Padding(
                                               padding: const EdgeInsets.all(3),
                                               child: Image.asset('assets/ui-design-/images/eye-8QM.png'),
                                             ),
                                           ),
                                         ],)
                                   )),
                             ],),
                         ),
                         Container(color: const Color(0xff262626).withOpacity(0.1), width: double.infinity, height: 2,),

                       ],
                     ),
                     Column(
                       children: [
                         Padding(
                           padding: const EdgeInsets.only(top: 10, bottom: 10),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Container(
                                   height: 50,
                                   width: 100,
                                   child: Center(child: Text('2.', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),
                               Container(
                                   height: 50,
                                   width: 100,
                                   child: Center(child: Text('24578GH', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),
                               Container(
                                   height: 50,
                                   width: 150,
                                   child: Center(child: Text('Sandheep S', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),
                               Container(

                                   height: 50,
                                   width: 100,
                                   child: Center(child: Text('9859237982', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),

                               Container(

                                   height: 50,
                                   width: 100,
                                   child: Center(child: Text('Delivery', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),

                               Container(

                                   height: 50,
                                   width: 200,
                                   child: Center(child: Text('10:00 Pm - 10:45 Pm', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),
                               Container(
                                   height: 50,
                                   width: 130,
                                   child: Center(child: ElevatedButton(
                                     style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xffDDFFE7))),
                                     onPressed: () {  }, child: Text('Check In', style: GoogleFonts.openSans(color: const Color(0xff1DA644), fontSize: 15),),)
                                   )
                               ),
                               Container(
                                   height: 50,
                                   width: 100,
                                   child: Center(
                                       child: Row(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: [
                                           CircleAvatar(
                                             radius: 12,
                                             backgroundColor: const Color(0xffF5F5F5),

                                             child: Padding(
                                               padding: const EdgeInsets.all(3),
                                               child: Image.asset('assets/ui-design-/images/edit.png'),
                                             ),
                                           ),
                                           const SizedBox(width: 8,),
                                           CircleAvatar(
                                             radius: 12,
                                             backgroundColor: const Color(0xffF5F5F5),
                                             child: Padding(
                                               padding: const EdgeInsets.all(3),
                                               child: Image.asset('assets/ui-design-/images/eye-8QM.png'),
                                             ),
                                           ),
                                         ],)
                                   )),
                             ],),
                         ),
                         Container(color: const Color(0xff262626).withOpacity(0.1), width: double.infinity, height: 2,),

                       ],
                     ),
                     Column(
                       children: [
                         Padding(
                           padding: const EdgeInsets.only(top: 10, bottom: 10),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Container(
                                   height: 50,
                                   width: 100,
                                   child: Center(child: Text('1.', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),
                               Container(
                                   height: 50,
                                   width: 100,
                                   child: Center(child: Text('24578GH', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),
                               Container(
                                   height: 50,
                                   width: 150,
                                   child: Center(child: Text('Sandheep S', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),
                               Container(

                                   height: 50,
                                   width: 100,
                                   child: Center(child: Text('9859237982', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),

                               Container(

                                   height: 50,
                                   width: 100,
                                   child: Center(child: Text('Delivery', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),

                               Container(

                                   height: 50,
                                   width: 200,
                                   child: Center(child: Text('10:00 Pm - 10:45 Pm', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),
                               Container(
                                   height: 50,
                                   width: 130,
                                   child: Center(child: ElevatedButton(
                                     style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xffFFD3D3))),
                                     onPressed: () {  }, child: Text('Check out', style: GoogleFonts.openSans(color: const Color(0xffF12D2D), fontSize: 15),),)
                                   )
                               ),
                               Container(
                                   height: 50,
                                   width: 100,
                                   child: Center(
                                       child: Row(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: [
                                           CircleAvatar(
                                             radius: 12,
                                             backgroundColor: const Color(0xffF5F5F5),

                                             child: Padding(
                                               padding: const EdgeInsets.all(3),
                                               child: Image.asset('assets/ui-design-/images/edit.png'),
                                             ),
                                           ),
                                           const SizedBox(width: 8,),
                                           CircleAvatar(
                                             radius: 12,
                                             backgroundColor: const Color(0xffF5F5F5),
                                             child: Padding(
                                               padding: const EdgeInsets.all(3),
                                               child: Image.asset('assets/ui-design-/images/eye-8QM.png'),
                                             ),
                                           ),
                                         ],)
                                   )),
                             ],),
                         ),
                         Container(color: const Color(0xff262626).withOpacity(0.1), width: double.infinity, height: 2,),

                       ],
                     ),

                   ],
                 )


               ],
             ),

           ),
           ),

         )



            ],
          ),
        ),
      ),
    );
  }
}

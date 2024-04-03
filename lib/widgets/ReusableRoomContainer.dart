import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_ikia/widgets/kText.dart';

class ReusableRoomContainer extends StatefulWidget {
  final Color firstColor;
  final Color secondColor;


  // text
  final String totalRooms;
  final String title;
  // Image
  final String waveImg;
  final String roomImg;


  const ReusableRoomContainer({super.key, required this.firstColor, required this.secondColor, required this.totalRooms, required this.title, required this.waveImg, required this.roomImg});
  @override
  State<ReusableRoomContainer> createState() => _ReusableRoomContainerState();
}
class _ReusableRoomContainerState extends State<ReusableRoomContainer> {
  @override
  Widget build(BuildContext context) {
    return  Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 207,
          width: 305,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: <Color>[
              widget.firstColor,
                          widget.secondColor,
            ]),
            borderRadius: BorderRadius.circular(23),
            color: Colors.green,
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          child: Container(

              width: 60,
              child: Image.asset("assets/ui-design-/images/Top.png")),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
              width: 60,
              child: Image.asset("assets/ui-design-/images/Down.png")),
        ),
        
        // for the Text
        Positioned(
          right: 70,
          top: 40,
          child: Container(
              width: 60,
              child: KText(text:widget.totalRooms, style: TextStyle(fontSize: 45,fontWeight: FontWeight.w900,color: Colors.white, letterSpacing: 2))
          ),
        ),

        Positioned(
          right: 30,
          bottom: 70,

          child: Container(
              width: 80,
              // "assets/ui-design-/images/wave.png"
              child: Image.asset(widget.waveImg)),
        ),

        Positioned(
          left: 55,
          top: 40,
          child: Container(
              width: 60,
              // "assets/ui-design-/images/wave.png"
    // 'assets/ui-design-/images/Group 90.png'
              child: Image.asset(widget.roomImg)),
        ),

        Padding(
          padding: const EdgeInsets.only(right: 80,top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              SizedBox(
                  width: 170,
                  child: KText(text: widget.title,style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 21,color: Colors.white, letterSpacing: 1),))
            ],
          ),
        )
      ],
    );

    //   Column(
    //   children: [
    //     Container(
    //       decoration:  BoxDecoration(
    //           gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment(0.9, 1,), colors: <Color>[
    //             widget.firstColor,
    //             widget.secondColor,
    //             widget.thirdColor,
    //             widget.forthColor,
    //           ])
    //           , borderRadius: const BorderRadius.all(Radius.circular(20)) ),
    //       height: 267, width: 345,
    //       child:
    //
    //       Stack(
    //         // alignment: Alignment.center,
    //         children: [
    //           const Positioned(
    //             bottom: 100,
    //       child: SizedBox(
    //       height: 68,
    //         child: Image(image: AssetImage('assets/ui-design-/images/Top.png')),
    //       )),
    //
    //           Stack(
    //             alignment: Alignment.center,
    //             children: [
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 const CircleAvatar(
    //                   radius: 35,
    //                   backgroundColor: Colors.white,
    //                   child: Padding(
    //                     padding: EdgeInsets.all(15),
    //                     child:
    //
    //                     SizedBox(
    //                         height: 80,
    //                         child: Image(image: AssetImage('assets/ui-design-/images/Room.png'),)),
    //                   ),),
    //                 Text(widget.totalRooms, style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 45, color: Colors.white),)
    //               ],),
    //           ],),
    //
    //
    //           Text(widget.title),
    //           SizedBox(width: 110, child: Image(image: AssetImage(widget.waveImg)),),
    //
    //      const Stack(
    //        alignment: Alignment.center,
    //        children: [
    //        SizedBox(
    //        height: 68,
    //        child: Image(image: AssetImage('assets/ui-design-/images/Top.png')),
    //      )
    //      ],)
    //
    //
    //
    //
    //
    //
    //
    //
    //         ],
    //       ),
    //
    //
    //
    //
    //
    //
    //     //   Column(
    //     //       crossAxisAlignment: CrossAxisAlignment.start,
    //     //       children: [
    //     //         const SizedBox(height: 68, child: Image(image: AssetImage('assets/ui-design-/images/Top.png')),),
    //     //         Row(
    //     //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //     //           children: [
    //     //             const CircleAvatar(
    //     //               radius: 35,
    //     //               backgroundColor: Colors.white,
    //     //               child: Padding(
    //     //                 padding: EdgeInsets.all(15),
    //     //                 child: SizedBox(
    //     //                     height: 80,
    //     //                     child: Image(image: AssetImage('assets/ui-design-/images/Room.png'),)),
    //     //               ),),
    //     //             Text(widget.totalRooms, style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 45, color: Colors.white),)
    //     //           ],),
    //     //         SizedBox(height: 17,),
    //     //         Row(
    //     //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //     //           children: [
    //     //             SizedBox(
    //     //                 width: 100,
    //     //                 child: Text(widget.title,style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 21, color: Colors.white))),
    //     //              SizedBox(width: 110, child: Image(image: AssetImage(widget.waveImg)),)
    //     //           //   'assets/ui-design-/images/Wave.png'
    //     //           ],),
    //     //         const Row(
    //     //           mainAxisAlignment: MainAxisAlignment.end,
    //     //           children: [
    //     //             SizedBox(height: 82, child: Image(image: AssetImage('assets/ui-design-/images/Down.png')),),
    //     //           ],)
    //     //       ]),
    //     ),
    //   ],
    // );
  }
}
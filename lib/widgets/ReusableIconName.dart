// import 'package:flutter/material.dart';
//
// class IconWithName extends StatefulWidget {
//   //  Pr means Profile Section
//   //  T means Title
//
//   // Icons
//   final IconData? PrDateIcon;
//   final IconData? PrTimeIcon;
//   final IconData ?PrStatusIcon;
//   // Icons Name
//   final String TPrDate;
//   final String TPrTime;
//   final String TStatus;
//   // For Color
//   final Color? textColor;
//
//
//   const IconWithName({super.key, required this.PrDateIcon, required this.PrTimeIcon, required this.PrStatusIcon, required this.TPrDate, required this.TPrTime, required this.TStatus, this.textColor,});
//
//   @override
//   State<IconWithName> createState() => _IconWithNameState();
// }
//
// class _IconWithNameState extends State<IconWithName> {
//   @override
//   Widget build(BuildContext context) {
//     // Main Row Like a Container
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         // Mini Row
//         Row(children: [
//           Icon(widget.PrDateIcon, color: const Color(0xff262626).withOpacity(0.7), size: 20,), const SizedBox(width: 5,), Text(widget.TPrDate, style: TextStyle(fontWeight: FontWeight.w700, color: const Color(0xff262626).withOpacity(0.7)
//           ),
//           ),
//         ],),
//         Row(children: [
//           Icon(widget.PrTimeIcon, color: const Color(0xff262626).withOpacity(0.7),size: 20,), const SizedBox(width: 5,), Text(widget.TPrTime,style: TextStyle(fontWeight: FontWeight.w700, color: const Color(0xff262626).withOpacity(0.7)
//           ),),
//         ],),
//         Row(children: [
//           Icon(widget.PrStatusIcon, color: const Color(0xff262626).withOpacity(0.7),size: 20,), const SizedBox(width: 5,), Text(widget.TStatus,style: TextStyle(fontWeight: FontWeight.w700, color: widget.textColor
//           ),),
//         ],),
//       ],
//     );
//   }
// }
//
// // Date time and status without icon
// // DTS means Date time status
// class DTS extends StatefulWidget {
//   // tColor means Text Color
//   final Color? tColor;
//   const DTS({super.key, this.tColor});
//   @override
//   State<DTS> createState() => _DTSState();
// }
// class _DTSState extends State<DTS> {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//      const Row(children: [
//        Text('15-03-2024', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black),)
//      ],),
//
//       const Row(children: [
//         Text('10:00 Am', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black)),
//       ],),
//
//       Row(children: [
//         Text( 'Check In', style: TextStyle(fontWeight: FontWeight.w800, color: widget.tColor == null? const Color(0xff262626).withOpacity(0.7) : widget.tColor),)
//       ],)
//     ],);
//   }
// }
//

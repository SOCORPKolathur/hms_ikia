// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
//
// class ReusableDropdown4Commu extends StatefulWidget {
//   final List<String> dropDownItems;
//   final String? selectedDropdown;
//   final String hintText;
//   final Function(String?) onChanged;
//   const ReusableDropdown4Commu({super.key, required this.dropDownItems, this.selectedDropdown, required this.hintText, required this.onChanged});
//
//   @override
//
//   State<ReusableDropdown4Commu> createState() => _ReusableDropdown4CommuState();
// }
//
// class _ReusableDropdown4CommuState extends State<ReusableDropdown4Commu> {
//   late String? selectedDropdown;
//
//   @override
//   void initState() {
//     super.initState();
//     selectedDropdown = widget.selectedDropdown;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return  Padding(
//       padding: const EdgeInsets.only(top: 8.0),
//       child: Container(
//         width: 250,
//         height: 55,
//         decoration: const BoxDecoration (
//
//           border: Border(
//             bottom: BorderSide(width: 1.5, color: Color(0x7f262626) ),
//           ),
//           // borderRadius: BorderRadius.horizontal(right: Radius.circular(10), left: Radius.circular(10))
//         ),
//         child: Padding(
//           padding: const EdgeInsets.only(left: 12.0,right: 6),
//           child:  DropdownButtonHideUnderline(
//             child:
//             DropdownButtonFormField2<
//                 String>(
//               iconStyleData: const IconStyleData(icon: Icon(Icons.keyboard_arrow_down_outlined)),
//               isExpanded: true,
//               hint: Text(
//                 'Prefix', style:
//               GoogleFonts.openSans (
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: const Color(0x7f262626),
//               ),
//               ),
//               items: DropDownHeading
//                   .map((String
//               item) =>
//                   DropdownMenuItem<
//                       String>(
//                     value: item,
//                     child: Text(
//                       item,
//                       style:
//                       GoogleFonts.openSans (
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   )).toList(),
//               value:
//               SelectedDropdown,
//               onChanged:
//                   (String? value) {
//                 setState(() {
//                   SelectedDropdown =
//                   value!;
//                 });
//               },
//               buttonStyleData:
//               const ButtonStyleData(
//               ),
//               menuItemStyleData:
//               const MenuItemStyleData(
//               ),
//               decoration:
//               const InputDecoration(
//                   border:
//                   InputBorder
//                       .none),
//             ),
//           ),
//         ),
//       ),
//     ),
//
//
//   }
// }










import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//
// class ReusableDropdown4Commu extends StatefulWidget {
//   final List<String> dropDownItems;
//   final String? selectedDropdown;
//   final String hintText;
//   // final Function(String?)? onChanged;
//   final Function() onChanged;
//   const ReusableDropdown4Commu({
//     Key? key,
//     required this.dropDownItems,
//     required this.hintText,
//     required this.onChanged,
//     this.selectedDropdown,
//   }) : super(key: key);
//
//   @override
//   State<ReusableDropdown4Commu> createState() => _ReusableDropdown4CommuState();
// }
//
// class _ReusableDropdown4CommuState extends State<ReusableDropdown4Commu> {
//   late String? selectedDropdown;
//
//   @override
//   void initState() {
//     super.initState();
//     selectedDropdown = widget.selectedDropdown;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 8.0),
//       child: Container(
//         width: 250,
//         height: 55,
//         decoration: BoxDecoration(
//           border: Border(
//             bottom: BorderSide(width: 1.5, color: Color(0x7f262626).withOpacity(0.2)),
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.only(left: 12.0, right: 6),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButtonFormField2<String>(
//               iconStyleData: const IconStyleData(icon: Icon(Icons.keyboard_arrow_down_outlined)),
//               isExpanded: true,
//               hint: Text(
//                 widget.hintText,
//                 style: GoogleFonts.openSans(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600,
//                   color: const Color(0x7f262626),
//                 ),
//               ),
//               items: widget.dropDownItems
//                   .map((String item) => DropdownMenuItem<String>(
//                 value: item,
//                 child: Text(
//                   item,
//                   style: GoogleFonts.openSans(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ))
//                   .toList(),
//               value: selectedDropdown,
//               onChanged: (value) {
//                 widget.onChanged(value);
//                 setState(() {
//                   selectedDropdown = value;
//                 });
//                 // widget.onChanged(value);
//               },
//               buttonStyleData: const ButtonStyleData(),
//               menuItemStyleData: const MenuItemStyleData(),
//               decoration: const InputDecoration(border: InputBorder.none),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



class ReusableDropdown4Commu extends StatefulWidget {
  final List<String> dropDownItems;
  final String? selectedDropdown;
  final String hintText;
  final Function(String?) onChanged;

  const ReusableDropdown4Commu({
    Key? key,
    required this.dropDownItems,
    required this.hintText,
    required this.onChanged,
    this.selectedDropdown,
  }) : super(key: key);

  @override
  State<ReusableDropdown4Commu> createState() => _ReusableDropdown4CommuState();
}

class _ReusableDropdown4CommuState extends State<ReusableDropdown4Commu> {
  late String? selectedDropdown;

  @override
  void initState() {
    super.initState();
    selectedDropdown = widget.selectedDropdown;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0,left: 10,),
      child: Container(
        width: 250,
        height: 55,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.5, color: Color(0x7f262626).withOpacity(0.2)),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 6),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField2<String>(
              iconStyleData: const IconStyleData(icon: Icon(Icons.keyboard_arrow_down_outlined)),
              isExpanded: true,
              hint: Text(
                widget.hintText,
                style: GoogleFonts.openSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0x7f262626),
                ),
              ),
              items: widget.dropDownItems
                  .map((String item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: GoogleFonts.openSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ))
                  .toList(),
              value: selectedDropdown,
              onChanged: (value) {
                widget.onChanged(value); // Call the callback function
                setState(() {
                  selectedDropdown = value;
                });
              },
              buttonStyleData: const ButtonStyleData(),
              menuItemStyleData: const MenuItemStyleData(),
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
        ),
      ),
    );
  }
}

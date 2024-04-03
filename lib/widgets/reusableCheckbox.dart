// import 'package:flutter/material.dart';
//
// class ReusableCheckBoxTxt extends StatefulWidget {
//   final String text;
//   final bool initialValue;
//   final ValueChanged<bool> onChanged;
//
//   const ReusableCheckBoxTxt({
//     required this.text,
//     this.initialValue = false,
//     required this.onChanged, required bool disabled,
//   }) : super();
//
//   @override
//   State<ReusableCheckBoxTxt> createState() => _ReusableCheckBoxTxtState();
// }
//
// class _ReusableCheckBoxTxtState extends State<ReusableCheckBoxTxt> {
//   late bool _value;
//
//   @override
//   void initState() {
//     super.initState();
//     _value = widget.initialValue;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
//       child: Row(
//         children: [
//           Checkbox(
//
//             checkColor: Colors.white,
//             activeColor: Color(0xff37D1D3),
//             // fillColor: MaterialStatePropertyAll(Color(0xff37D1D3)),
//             value: _value,
//             onChanged: (newValue) {
//               setState(() {
//                 _value = newValue!;
//               });
//               if (widget.onChanged != null) {
//                 widget.onChanged(newValue!);
//               }
//             },
//           ),
//           SizedBox(width: 3),
//           SizedBox(
//               child: Text(widget.text)),
//         ],
//       ),
//     );
//   }
// }






import 'package:flutter/material.dart';

class ReusableCheckBoxTxt extends StatefulWidget {
  final String text;
  final bool initialValue;
  final ValueChanged<bool>? onChanged;
   bool disabled;

   ReusableCheckBoxTxt({
    required this.text,
    this.initialValue = false,
    this.onChanged,
    required this.disabled,
  });

  @override
  State<ReusableCheckBoxTxt> createState() => _ReusableCheckBoxTxtState();
}

class _ReusableCheckBoxTxtState extends State<ReusableCheckBoxTxt> {


  var value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
      child: Row(
        children: [
          Checkbox(
            checkColor: Colors.white,
            activeColor: Color(0xff37D1D3),



            value: value ==null ?widget.disabled : value,

            onChanged: widget.disabled
                ? null
                : (newValue) {
              setState(() {
                value = newValue!;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(newValue!);
              }
            },
          ),
          SizedBox(width: 3),
          SizedBox(
            child: Text(widget.text),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class UserMiniDetails extends StatefulWidget {
  final IconData IconName;
  final String iName;
  final String ?userDet;
  const UserMiniDetails({super.key, required this.IconName, this.userDet, required this.iName});

  @override
  State<UserMiniDetails> createState() => _UserMiniDetailsState();
}

class _UserMiniDetailsState extends State<UserMiniDetails> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(0),
      child: Row(children: [
        Icon(widget.IconName, size: 19, color: Colors.white,), SizedBox(width: 6,), RichText(text: TextSpan(children: [
          TextSpan(text: widget.iName, style: TextStyle(fontSize: 13,color: Color(0xffFFFFFF))), TextSpan(text: widget.userDet == null ? '' : widget.userDet, style: TextStyle(color: Color(0xffFFFFFF),fontWeight: FontWeight.w600, fontSize: 13))
        ]))

      ],),
    );
  }
}

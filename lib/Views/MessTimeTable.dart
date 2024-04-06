import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:hms_ikia/widgets/ReusableHeader.dart';

class MessTimeTable extends StatefulWidget {
  const MessTimeTable({super.key});
  @override
  State<MessTimeTable> createState() => _MessTimeTableState();
}
class _MessTimeTableState extends State<MessTimeTable> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    return FadeInRight(
      child: const Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ReusableHeader(Headertext: 'Mess Time Table', SubHeadingtext: 'Manage mess time table')

            ],
          ),
        ),
      ),
    );
  }
}

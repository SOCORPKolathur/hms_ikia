import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';



class Visitor_Page extends StatefulWidget {
  const Visitor_Page({super.key});

  @override
  State<Visitor_Page> createState() => _Visitor_PageState();
}

class _Visitor_PageState extends State<Visitor_Page> {
  @override
  Widget build(BuildContext context) {
    return  FadeInRight(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/Visitor Management.png"),
            ],
          ),
        ),
      ),
    );;
  }
}

import 'package:flutter/material.dart';

class ContainerIcon extends StatefulWidget {
  // final IconData ? threeIcon;
  final String imagePath;
  const ContainerIcon({super.key, required this.imagePath});

  @override
  State<ContainerIcon> createState() => _ContainerIconState();
}

class _ContainerIconState extends State<ContainerIcon> {
  @override
  Widget build(BuildContext context) {
    return

      Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 35,
          width: 35,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(50)),
              boxShadow:[
                // BoxShadow(blurRadius: 19, color: Color(0xff000000).withOpacity(0.5), offset: Offset(2,16))
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: Offset(4,4)
                )
              ],

          ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          child: Container(
            height: 20,
            width: 20,
            
            child: Image.asset(widget.imagePath, fit: BoxFit.contain,scale: 0.5,),

          ),
        )
      ],
    );


  }
}

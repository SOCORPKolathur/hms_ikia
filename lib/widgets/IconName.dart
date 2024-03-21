import 'package:flutter/material.dart';

class IconName extends StatefulWidget {
  final IconData NameWithIcon;
  final String name;

  const IconName({super.key, required this.NameWithIcon, required this.name});

  @override
  State<IconName> createState() => _IconNameState();
}

class _IconNameState extends State<IconName> {
  @override
  Widget build(BuildContext context) {
    return
      Row(children: [
        Icon(widget.NameWithIcon, color: Colors.white,), Text(widget.name),

      ],);
  }
}

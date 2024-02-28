import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class AssetManagement extends StatefulWidget {
  const AssetManagement({super.key});

  @override
  State<AssetManagement> createState() => _AssetManagementState();
}

class _AssetManagementState extends State<AssetManagement> {
  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/assetui.png"),
            ],
          ),
        ),
      ),
    );;
  }
}

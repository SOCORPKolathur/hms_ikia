import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_ikia/widgets/ReusableHeader.dart';
import 'package:hms_ikia/widgets/ReusableRoomContainer.dart';
import 'package:hms_ikia/widgets/customtextfield.dart';

import '../widgets/RUsableCommunication.dart';

class BlockName extends StatefulWidget {
  const BlockName({super.key});

  @override
  State<BlockName> createState() => _BlockNameState();
}

class _BlockNameState extends State<BlockName> {
  // Textfield Roomname
  final TextEditingController blockController = TextEditingController();




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
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ReusableHeader(Headertext: 'Create Block Here',
                  SubHeadingtext: '"Manage Easily Block Records"'),
              SizedBox.fromSize(size: const Size(0, 10),),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color(0xff262626).withOpacity(0.10)),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 20, top: 10, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CustomTextField(hint: 'Block Name Goes Here...',
                          controller: blockController,
                          fillColor: const Color(0xffF5F5F5),
                          validator: null,
                          header: '',
                          width: 335,
                          preffixIcon: Icons.search,
                          height: 45,),
                      ),
                      SizedBox(
                        height: 40,
                        child: ElevatedButton(
                            style: const ButtonStyle(
                                elevation: MaterialStatePropertyAll(3),
                                backgroundColor: MaterialStatePropertyAll(
                                    Color(0xff37D1D3))),
                            onPressed: () {
                            //   function to create the block
                            //   createBlock(context);
                              if(blockController.text == ''){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please Enter the Block Name'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );

                              }else{
                                createBlock(context);
                              }
                            },
                            child: Row(
                          children: [
                            Text('Create Block', style: GoogleFonts.openSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),),
                            const SizedBox(width: 8,),
                            const CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.white,
                              child: Center(child: Icon(
                                Icons.add, color: Color(0xff37D1D3),
                                size: 13,)),)
                          ],)),
                      )
                    ],),

                ),
              ),
              const SizedBox(height: 20,),
              Container(height: 500, width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color(0xff262626).withOpacity(0.10)),
                    borderRadius: BorderRadius.circular(30),
                  ),


                child: Column(
                  children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    Container(
                width:500,
                        child: Center(child:  Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: Text('S.No', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18,color: Colors.black),),
                        ))),
                    Container(
                        width: 500,
                        child: Center(child: Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: Text('Name',style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18,color: Colors.black),),
                        ))),
                  ],),
             SizedBox(height: 8,),
             Divider(color: Colors.black, thickness: 0.1,),

             const SizedBox(height: 15,),
                    StreamBuilder(stream: FirebaseFirestore.instance.collection('Block').snapshots(), builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var documents = snapshot.data!.docs;
                        // Sort documents alphabetically based on 'blockname' field
                        documents.sort((a, b) => (a['blockname'] as String).compareTo(b['blockname'] as String));
                        return ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                          var data = documents[index].data();
                          int serialNumber = index + 1;
                          return
                            Padding(
                              padding: const EdgeInsets.only(top: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                Container(
                                    width: 500,
                                    child: Center(child: Text('${serialNumber}', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16),))),
                                Container(
                                    width: 500,
                                    child: Center(child: Text(data['blockname'],style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16),))),
                              ],),
                            );

                        }, itemCount: documents.length);
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },),
                  ],)
              )
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> CreateBlock() async {
  //   try {
  //     await FirebaseFirestore.instance.collection('Block').add({
  //       'blockname' :blockController.text,
  //       'timeStamp' : DateTime.now().millisecondsSinceEpoch,
  //     });
  //      blockController.clear();
  //     print('Main collection created successfully!');
  //   } catch (e) {
  //     print('Error creating main collection: $e');
  //   }
  // }

  Future<void> createBlock(BuildContext context) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Block')
          .where('blockname', isEqualTo: blockController.text)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        // Show snackbar if block with the same name already exists
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Block with this name already exists!'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // Add block to Firestore if no duplicates found
        await FirebaseFirestore.instance.collection('Block').add({
          'blockname': blockController.text,
          'timeStamp': DateTime.now().millisecondsSinceEpoch,
        });
        blockController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Block created successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error creating main collection: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating main collection: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }


}

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_ikia/widgets/ReusableHeader.dart';
import 'package:hms_ikia/widgets/ReusableRoomContainer.dart';
import 'package:hms_ikia/widgets/customtextfield.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
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
                              if(blockController.text == ''){
                                showTopSnackBar(
                                  Overlay.of(context),
                                  CustomSnackBar.error(
                                    backgroundColor: Color(0xffFD7E50),
                                    message:
                                    "Please Enter the Block Name",
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
                width:300,
                        child: Center(child:  Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: Text('S.No', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18,color: Colors.black),),
                        ))),
                    Container(
                        width: 300,
                        child: Center(child: Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: Text('Name',style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18,color: Colors.black),),
                        ))),
                      Container(
                          width: 300,
                          child: Center(child: Padding(
                            padding: const EdgeInsets.only(top: 18),
                            child: Text('Action',style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18,color: Colors.black),),
                          ))),
                    ],),
             SizedBox(height: 8,),
             Divider(color: Colors.black, thickness: 0.1,),
             const SizedBox(height: 15,),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('Block').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var documents = snapshot.data!.docs;
                          // Sort documents alphabetically based on 'blockname' field
                          documents.sort((a, b) => (a['blockname'] as String).compareTo(b['blockname'] as String));
                          return ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var data = documents[index].data();
                              //got the id here
                              String blockId = documents[index].id;
                              int serialNumber = index + 1;
                              return Padding(
                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                child: InkWell(
                                  onTap: () {
                                    print(snapshot.data!.docs[index]['blockname']);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 300,
                                        child: Center(
                                          child: Text(
                                            '${serialNumber}',
                                            style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 300,
                                        child: Center(
                                          child: Text(
                                            data['blockname'],
                                            style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 300,
                                        child: Center(
                                          child: SizedBox(
                                            width: 120,
                                            child: ElevatedButton(
                                              style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xffF12D2D))),
                                              child: Row(children: [
                                                Icon(Icons.delete, color: Colors.white,size: 20,),
                                                SizedBox(width: 5,),
                                                Text('Delete', style: GoogleFonts.openSans(color: Colors.white, fontWeight: FontWeight.w500),)
                                              ],),onPressed: (){
                                                 ForDeleteDialog(context, blockId);
                                            },),
                                          ),
                                        ),
                                      ),
                                      // Container(
                                      //   width: 300,
                                      //   child: Center(
                                      //     child: InkWell(
                                      //       onTap: () {
                                      //         ForDeleteDialog(context, blockId); // Pass document ID to delete function
                                      //         print('Doc ID:- $blockId');
                                      //         print('UserName:- ${data['blockname']}');
                                      //       },
                                      //       // child: Icon(Icons.delete, color: Colors.red),
                                      //       child: ElevatedButton(
                                      //         style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xffF12D2D))),
                                      //
                                      //         child: Row(children: [
                                      //         Icon(Icons.delete),
                                      //         Text('Delete')
                                      //       ],),onPressed: (){
                                      //
                                      //       },)
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: documents.length,
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
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
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message:
            "Block with this name already exists!",
          ),
        );
      } else {
        // Add block to Firestore if no duplicates found
        await FirebaseFirestore.instance.collection('Block').add({
          'blockname': blockController.text,
          'timeStamp': DateTime.now().millisecondsSinceEpoch,
        });
        blockController.clear();
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(
            backgroundColor: Color(0xff3ac6cf),
            message:
            "Block created successfully!",
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

  Future<void> ForDeleteDialog(BuildContext con, String documentId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          content: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Container(
              padding: EdgeInsets.zero,
              color: Colors.white,
              height: 350,
              width: 550,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: CircleAvatar(
                            backgroundColor: Color(0xffF5F6F7), radius: 20, child: Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(Icons.close, color: Colors.grey, size: 18,),
                          ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 130,
                          width: 130,
                          child: Image.asset('assets/ui-design-/images/DeleteL.png'),
                        ),
                        SizedBox(
                          height: 150,
                          width: 150,
                          child: Image.asset('assets/ui-design-/images/deleteCenter.png'),
                        ),
                        SizedBox(
                          height: 130,
                          width: 130,
                          child: Image.asset('assets/ui-design-/images/DeleteR.png'),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 20),
                      child: Text('Are you sure you want to delete this asset record?', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 17),),
                    ),
                    Text('Once deleted, it cannot be recovered.', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 17),),
                    const SizedBox(height: 25,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 130,
                          height: 42,
                          child: ElevatedButton(
                            style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xffF5F5F5))),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: Text('Cancel', style: GoogleFonts.openSans(fontSize: 17, fontWeight: FontWeight.w700, color: const Color(0xff262626).withOpacity(0.8)),),
                          ),
                        ),
                        const SizedBox(width: 20,),
                        Container(
                          width: 130,
                          height: 42,
                          child: ElevatedButton(
                            style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xffF12D2D))),
                            onPressed: () async {
                              try {
                                await FirebaseFirestore.instance.collection('Block').doc(documentId).delete();
                                showTopSnackBar(
                                  Overlay.of(context),
                                  CustomSnackBar.success(
                                    backgroundColor: Color(0xff3ac6cf),
                                    message:
                                    "Block Deleted successfully!",
                                  ),
                                );
                                Navigator.pop(context); // Close the dialog
                              } catch (e) {
                                // Show an error message if deletion fails
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error deleting block: $e'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            },


                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('Delete',style: GoogleFonts.openSans(fontSize: 17, fontWeight: FontWeight.w700, color: const Color(0xffFFFFFF))),
                                const Icon(Icons.delete, size: 18, color: Color(0xffFFFFFF),)
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }


}

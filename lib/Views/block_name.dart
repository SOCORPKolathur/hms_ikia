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
import '../widgets/kText.dart';
class BlockName extends StatefulWidget {
  const BlockName({super.key});
  @override
  State<BlockName> createState() => _BlockNameState();
}
class _BlockNameState extends State<BlockName> {
  // Textfield Roomname
  final TextEditingController searchBlock = TextEditingController();
  final TextEditingController blockname = TextEditingController();
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
                        child: CustomTextField(hint: 'Search Block Here',
                          controller: searchBlock,
                          fillColor: const Color(0xffF5F5F5),
                          validator: null,
                          onChanged: (value){
                          setState(() {

                          });
                          },
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
                              BlockPopUp();
                              // if(blockController.text == ''){
                              //   showTopSnackBar(
                              //     Overlay.of(context),
                              //     CustomSnackBar.error(
                              //       backgroundColor: Color(0xffFD7E50),
                              //       message:
                              //       "Please Enter the Block Name",
                              //     ),
                              //   );
                              // }else{
                              //   // createBlock(context);
                              // }


                            },
                            child: Row(
                          children: [
                            KText(text:'Create Block', style: GoogleFonts.openSans(
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
                          child: KText(text:'S.No', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18,color: Colors.black),),
                        ))),
                    Container(
                        width: 300,
                        child: Center(child: Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: KText(text:'Name',style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18,color: Colors.black),),
                        ))),
                      Container(
                          width: 300,
                          child: Center(child: Padding(
                            padding: const EdgeInsets.only(top: 18),
                            child: KText(text:'Action',style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18,color: Colors.black),),
                          ))),
                    ],),
             SizedBox(height: 8,),
             Divider(color: Colors.black, thickness: 0.1,),
             const SizedBox(height: 15,),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('Block').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          // this is matched one with the search
                          List<DocumentSnapshot> matchedData = [];
                          // this is remaining one
                          List<DocumentSnapshot> remainingData = [];
                          if(searchBlock.text.isNotEmpty){
                            // Separate the snapshot data based on the search text
                            snapshot.data!.docs.forEach((doc) {
                              final blockName = doc["blockname"].toString().toLowerCase();
                              final searchText = searchBlock.text.toLowerCase();
                              if (blockName.contains(searchText)) {
                                matchedData.add(doc);
                              } else {
                                remainingData.add(doc);
                              }
                            });

                            // Sort the matched data
                            matchedData.sort((a, b) {
                              final nameA = a["blockname"].toString().toLowerCase();
                              final nameB = b["blockname"].toString().toLowerCase();
                              final searchText = searchBlock.text.toLowerCase();
                              return nameA.compareTo(nameB);
                            });

                          }else{
                            // If search query is empty, display original data
                            remainingData = snapshot.data!.docs;
                          }
                          // Concatenate matched data and remaining data
                          List<DocumentSnapshot> combinedData = [...matchedData, ...remainingData];
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              if(snapshot.hasData){
                                final document = combinedData[index];
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
                                            child: KText(
                                              text:'${serialNumber}',
                                              style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 300,
                                          child: Center(
                                            child: KText(
                                              text:document['blockname'],
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
                                                  KText(text:'Delete', style: GoogleFonts.openSans(color: Colors.white, fontWeight: FontWeight.w500),)
                                                ],),onPressed: (){
                                                ForDeleteDialog(context, document.id);
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
                              }
                            },
                            // itemCount: documents.length,
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                    // StreamBuilder(
                    //   stream: FirebaseFirestore.instance.collection('Block').snapshots(),
                    //   builder: (context, snapshot) {
                    //     if (snapshot.hasData) {
                    //       var documents = snapshot.data!.docs;
                    //       documents.sort((a, b) => (a['blockname'] as String).compareTo(b['blockname'] as String));
                    //       if (blockController.text.isNotEmpty) {
                    //         setState(() {
                    //           documents = documents.where((doc) => doc['blockname'].toString().toLowerCase().contains(blockController.text.toLowerCase())).toList();
                    //         });
                    //       }
                    //       return ListView.builder(
                    //         shrinkWrap: true,
                    //         itemBuilder: (context, index) {
                    //           var data = documents[index].data();
                    //           String blockId = documents[index].id;
                    //           int serialNumber = index + 1;
                    //           return Padding(
                    //             padding: const EdgeInsets.only(top: 10, bottom: 10),
                    //             child: InkWell(
                    //               onTap: () {
                    //                 print(snapshot.data!.docs[index]['blockname']);
                    //               },
                    //               child: Row(
                    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                 children: [
                    //                   Container(
                    //                     width: 300,
                    //                     child: Center(
                    //                       child: Text(
                    //                         '${serialNumber}',
                    //                         style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   Container(
                    //                     width: 300,
                    //                     child: Center(
                    //                       child: Text(
                    //                         data['blockname'],
                    //                         style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   Container(
                    //                     width: 300,
                    //                     child: Center(
                    //                       child: SizedBox(
                    //                         width: 120,
                    //                         child: ElevatedButton(
                    //                           style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xffF12D2D))),
                    //                           child: Row(children: [
                    //                             Icon(Icons.delete, color: Colors.white,size: 20,),
                    //                             SizedBox(width: 5,),
                    //                             Text('Delete', style: GoogleFonts.openSans(color: Colors.white, fontWeight: FontWeight.w500),)
                    //                           ],),
                    //                           onPressed: () {
                    //                             ForDeleteDialog(context, blockId);
                    //                           },
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           );
                    //         },
                    //         itemCount: documents.length,
                    //       );
                    //     } else {
                    //       return const CircularProgressIndicator();
                    //     }
                    //   },
                    // ),
                  ],)
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> createBlock(BuildContext context) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Block')
          .where('blockname', isEqualTo: blockname.text)
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
          'blockname': blockname.text,
          'timeStamp': DateTime.now().millisecondsSinceEpoch,
        });
        blockname.clear();
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(
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
          content: KText(text:'Error creating main collection: $e', style: GoogleFonts.openSans()),
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
                      child: KText(text:'Are you sure you want to delete this block?', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 17),),
                    ),
                    KText(text: 'Once deleted, it cannot be recovered.', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 17),),
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
                            child: KText(text: 'Cancel', style: GoogleFonts.openSans(fontSize: 17, fontWeight: FontWeight.w700, color: const Color(0xff262626).withOpacity(0.8)),),
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
                                    content: KText(text:'Error deleting block: $e', style: GoogleFonts.openSans(),),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            },


                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                KText(text:'Delete',style: GoogleFonts.openSans(fontSize: 17, fontWeight: FontWeight.w700, color: const Color(0xffFFFFFF))),
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
  Future<void> BlockPopUp() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: const Color(0xffFFFFFF),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              KText(text:'Create Block', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 30, width: 30,
                  // here the Cross Icon
                  child:  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 38,
                        width: 38,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          boxShadow:[
                            BoxShadow(
                                color: Color(0xfff5f6f7),
                                blurRadius: 5,
                                spreadRadius: 1,
                                offset: Offset(4,4)
                            )
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                        child: Container(
                          height: 20,
                          width: 20,
                          child: Image.asset('assets/ui-design-/images/Multiply.png', fit: BoxFit.contain,scale: 0.5,),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),

          content: Container(
            width: 400,
            height: 170,
            child: Column(
              children: [
                const SizedBox(height: 10,),
                Divider(color: const Color(0xff262626).withOpacity(0.1), thickness: 1, height: 0.5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // block name
                          Padding(
                            padding: const EdgeInsets.only(bottom: 0, top: 0),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(text:'Block Name', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 10, top: 10),
                                        child: CustomTextField(
                                          hint: 'Block Name',
                                          controller: blockname,
                                          fillColor: Colors.white,
                                          validator: null,
                                          header: '',
                                          width: 250,
                                          height: 45,
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      SizedBox(
                                        height: 40,
                                        child: ElevatedButton(
                                          style: const ButtonStyle(
                                              elevation: MaterialStatePropertyAll(3),
                                              backgroundColor: MaterialStatePropertyAll(Color(0xff37D1D3))
                                          ),
                                          onPressed: () {
                                            if(blockname.text == ''){
                                              showTopSnackBar(
                                                Overlay.of(context),
                                                const CustomSnackBar.error(
                                                  backgroundColor: Color(0xffFD7E50),
                                                  message:
                                                  "Please Enter the Block Name",
                                                ),
                                              );
                                            }else{
                                              createBlock(context);
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              KText(
                                                text:'Add Block',
                                                style: GoogleFonts.openSans(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              const CircleAvatar(
                                                radius: 8,
                                                backgroundColor: Colors.white,
                                                child: Center(
                                                  child: Icon(
                                                    Icons.add,
                                                    color: Color(0xff37D1D3),
                                                    size: 13,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

}

import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_ikia/widgets/ReusableHeader.dart';

import '../Constants/constants.dart';
import '../widgets/ReusableRoomContainer.dart';
import '../widgets/customtextfield.dart';
import '../widgets/kText.dart';

class Complaints extends StatefulWidget {
  const Complaints({super.key});
  @override
  State<Complaints> createState() => _ComplaintsState();
}
class _ComplaintsState extends State<Complaints> {
  // text controller
  final TextEditingController searchComplaints = TextEditingController();

  String selectedStatus = "Select Status";

  List<String> status=["Select Status","on process","In Complete","Completed"];
  String _getFormattedDate() {
    final now = DateTime.now();
    // final formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final formattedDate =
        "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";
    return formattedDate;
  }

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
            children: [
              const ReusableHeader(Headertext: 'Complains', SubHeadingtext: 'Complains...'),
               const SizedBox(height: 25,),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Complaints').snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    List<DocumentSnapshot> complaints = snapshot.data!.docs;
                    int todayComplaint = 0;
                    int completedComplaints = 0;
                    int incompleteComplaints = 0;

                    // Loop through all complaints to categorize them
                    for (var complaint in complaints) {
                      // Check if the complaint is for today
                      if (complaint['date'] == _getFormattedDate()) {
                        todayComplaint++;
                      }
                      // Check the status of the complaint and categorize it
                      if (complaint['status'] == 'Completed') {
                        completedComplaints++;
                      } else {
                        incompleteComplaints++;
                      }
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ReusableRoomContainer(
                          firstColor: Color(0xff034d7f),
                          secondColor: Color(0xff058be5),
                          title: 'Complaints',
                          totalRooms: todayComplaint.toString().padLeft(2,"0"),
                          waveImg: 'assets/ui-design-/images/Vector 38 (1).png',
                          roomImg: 'assets/ui-design-/images/Group 70.png',
                        ),
                        ReusableRoomContainer(
                          firstColor: Color(0xff0e4d1f),
                          secondColor: Color(0xff1b9a3f),
                          totalRooms: completedComplaints.toString().padLeft(2,"0"),
                          title: 'Completed',
                          waveImg: 'assets/ui-design-/images/Vector 37 (3).png',
                          roomImg: 'assets/ui-design-/images/Group 71.png',
                        ),
                        ReusableRoomContainer(
                          firstColor: Color(0xff971c1c),
                          secondColor: Color(0xffe22a2a),
                          totalRooms: incompleteComplaints.toString().padLeft(2,"0"),
                          title: 'In Complete',
                          waveImg: 'assets/ui-design-/images/Vector 36 (3).png',
                          roomImg: 'assets/ui-design-/images/Group 72.png',
                        ),
                      ],
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),



               const SizedBox(height: 20,),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color:  const Color(0xff262626).withOpacity(0.10)),
                  borderRadius: BorderRadius.circular(30),
                ),
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // SizedBox(width: 20,),
                    Padding(
                      padding:  const EdgeInsets.only(left: 20),
                      child: CustomTextField(hint: 'Search Complaints here...',  controller: searchComplaints, validator: null, fillColor: const Color(0xffF5F5F5),header: '', width: 335, preffixIcon: Icons.search,height: 45, onChanged: (value){
                        setState(() {

                        });
                      }, ),
                    ),
                    SizedBox.fromSize(size:  const Size(0, 0),),
                    Padding(
                      padding:  const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox.fromSize(size: const Size(23,0),),
                          SizedBox(
                            height: 45,
                            child: ElevatedButton(
                                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff37D1D3))),
                                onPressed: (){

                                }, child: Row(
                              children: [
                                KText(text:'Export Data', style: GoogleFonts.openSans(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white),),
                                const SizedBox(width: 4,),
                                SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: Image.asset('assets/ui-design-/images/Database Export.png'))
                              ],
                            )),
                          )
                        ],),
                    )
                  ],),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20)
                  ),
                      border: Border.all(color: const Color(0xff262626).withOpacity(0.1))
                  ),
                  constraints: const BoxConstraints(
                    minHeight: 100,
                    maxHeight: 1000,
                  ),
                  width: double.infinity,
                  child:
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child:
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                height: 50,
                                width: 80,
                                child: Center(child: KText(text:'S.No', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),
                                )
                                )),
                            SizedBox(
                                height: 50,
                                width: 170,
                                child: Center(child: KText(text:'Complaint Reason', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),))),
                            SizedBox(
                                height: 50,
                                width: 100,
                                child: Center(child: KText(text:'Category', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),))),
                            SizedBox(
                                height: 50,
                                width: 120,
                                child: Center(child: KText(text:'Priority', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),))),
                            SizedBox(
                                height: 50,
                                width: 120,
                                child: Center(child: KText(text:'Date', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),))),
                            SizedBox(
                                height: 50,
                                width: 120,
                                child: Center(child: KText(text:'Time', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),))),
                            SizedBox(
                                height: 50,
                                width: 120,
                                child: Center(child: KText(text:'Status', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),))),
                            SizedBox(
                                height: 50,
                                width: 130,
                                child: Center(child: KText(text:'Action', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),))),

                          ],),
                        Container(color: const Color(0xff262626).withOpacity(0.1), width: double.infinity, height: 2,),
                      //   Stream Builder
                        StreamBuilder(stream: FirebaseFirestore.instance.collection('Complaints').snapshots(), builder: (context, snapshot) {
                          if(snapshot.hasData){
                            return ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                              int serialNumber = index + 1;
                              final data = snapshot.data!.docs[index];
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            height: 50,
                                            width: 80,
                                            child: Center(child: Text('$serialNumber.', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),
                                        SizedBox(
                                            height: 50,
                                            width: 170,
                                            child: Center(child: KText(text:data['reason'], style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),
                                        SizedBox(
                                            height: 50,
                                            width: 100,
                                            child: Center(child: KText(text:data['category'],style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),
                                        SizedBox(
                                            height: 50,
                                            width: 120,
                                            child: Center(child: KText(text:data['priority'], style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),

                                        SizedBox(
                                            height: 50,
                                            width: 120,
                                            child: Center(child: KText(text:data['date'], style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),

                                        SizedBox(
                                            height: 50,
                                            width: 120,
                                            child: Center(child: KText(text:data['time'], style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8)),))),

                                        data['status'] == 'In Complete' ?

                                        SizedBox(
                                            height: 50,
                                            width: 120,
                                            child: Center(child: KText(text:data['status'], style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color:Colors.red
                                            ),
                                            )
                                            )
                                        ) :

                                        SizedBox(
                                            height: 50,
                                            width: 120,
                                            child: Center(child: KText(text:data['status'], style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color:Colors.green
                                            ),
                                            )
                                            )
                                        ) ,




                                        Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: SizedBox(
                                            width: 130,

                                            child: ElevatedButton(
                                                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff39cad0))),
                                                onPressed: (){
                                            complaintDetail(context, snapshot.data!
                                                .docs[index]);
                                            }, child: KText(text:'Details', style: GoogleFonts.openSans(color: Colors.white),)),
                                          ),
                                        )
                                      ],),
                                  ),
                                  Container(color: const Color(0xff262626).withOpacity(0.1), width: double.infinity, height: 2,),
                                ],
                              );
                            },
                            itemCount: snapshot.data!.docs.length,
                            );
                          }
                      else{
                        return const CircularProgressIndicator();
                          }
                        },)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
//   Complaints Details

 //  Future<void> complaintDetail(BuildContext con, DocumentSnapshot userData) async {
 //    String selectedStatus = userData['status'];
 //
 //    return showDialog<void>(
 //        context: context,
 //        barrierDismissible: false,
 //        builder: (BuildContext context) {
 //          return AlertDialog(
 //            elevation: 0,
 //            backgroundColor: const Color(0xffFFFFFF),
 //            title: Row(
 //              mainAxisAlignment: MainAxisAlignment.spaceBetween,
 //              children: [
 //                KText(text:'Complaint Details', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
 //                InkWell(
 //                  onTap: () => Navigator.pop(context),
 //                  child: SizedBox(
 //                    height: 30, width: 30,
 //                    child:  Stack(
 //                      alignment: Alignment.center,
 //                      children: [
 //                        Container(
 //                          height: 38,
 //                          width: 38,
 //                          decoration: const BoxDecoration(
 //                            color: Colors.white,
 //                            borderRadius: BorderRadius.all(Radius.circular(50)),
 //                            boxShadow:[
 //                              BoxShadow(
 //                                  color: Color(0xfff5f6f7),
 //                                  blurRadius: 5,
 //                                  spreadRadius: 1,
 //                                  offset: Offset(4,4)
 //                              )
 //                            ],
 //                          ),
 //                        ),
 //                        ClipRRect(
 //                          borderRadius: const BorderRadius.all(Radius.circular(50)),
 //                          child: SizedBox(
 //                            height: 20,
 //                            width: 20,
 //                            child: Image.asset('assets/ui-design-/images/Multiply.png', fit: BoxFit.contain,scale: 0.5,),
 //                          ),
 //                        )
 //                      ],
 //                    ),
 //                  ),
 //                ),
 //              ],
 //            ),
 //
 //            content: SingleChildScrollView(
 //              child: SizedBox(
 //                width: 380,
 //                height: 330,
 //                child: Column(
 //                  crossAxisAlignment: CrossAxisAlignment.start,
 //                  children: [
 //                    const Divider(color: Colors.grey, height: 10,),
 //                    Row(
 //                      children: [
 //                        SizedBox(
 //                            width: 150,
 //                            child: KText(text:'User Name', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)),
 //                        SizedBox(
 //                            width: 70,
 //                            child: Center(child: Text(':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
 //                        SizedBox(
 //
 //                            width: 150,
 //                            child: KText(text: userData['username'],style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)),
 //                      ],
 //                    ),
 //                    const SizedBox(height: 4,),
 //                    Row(
 //                      children: [
 //                        SizedBox(
 //                            width: 150,
 //                            child: KText(text:'User Id', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)),
 //                        SizedBox(
 //                            width: 70,
 //                            child: Center(child: KText(text:':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
 //                        SizedBox(
 //                            width: 150,
 //                            child: KText(text:userData['userId'],style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)),
 //                      ],
 //                    ),
 //                    const SizedBox(height: 4,),
 //                    Row(
 //                      children: [
 //                        SizedBox(
 //                            width: 150,
 //                            child: KText(text:'Reason', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)),
 //                        SizedBox(
 //                            width: 70,
 //                            child: Center(child: KText(text:':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
 //                        SizedBox(
 //                            width: 150,
 //                            child: KText(text:userData['reason'],style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)),
 //                      ],
 //                    ),
 //                    const SizedBox(height: 4,),
 //                    Row(
 //                      children: [
 //                        SizedBox(
 //                            width: 150,
 //                            child: KText(text:'Priority', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)),
 //                        SizedBox(
 //                            width: 70,
 //                            child: Center(child: KText(text:':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
 //                        SizedBox(
 //                            width: 150,
 //                            child: KText(text:userData['priority'],style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)),
 //                      ],
 //                    ),
 //                    const SizedBox(height: 4,),
 //                    Row(
 //                      children: [
 //                        SizedBox(
 //                            width: 150,
 //                            child: KText(text:'Date', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)),
 //                        SizedBox(
 //                            width: 70,
 //                            child: Center(child: KText(text:':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
 //                        SizedBox(
 //                            width: 150,
 //                            child: KText(text:userData['date'],style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)),
 //                      ],
 //                    ),
 //                    const SizedBox(height: 4,),
 //                    Row(
 //                      children: [
 //                        SizedBox(
 //                            width: 150,
 //                            child: KText(text:'Time', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)),
 //                        SizedBox(
 //                            width: 70,
 //                            child: Center(child: KText(text:':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
 //                        SizedBox(
 //                            width: 150,
 //                            child: KText(text:userData['time'],style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)),
 //                      ],
 //                    ),
 //                    const SizedBox(height: 4,),
 //                    Row(
 //                      children: [
 //                        SizedBox(
 //                            width: 150,
 //                            child: KText(text:'Status', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)),
 //                        SizedBox(
 //                            width: 70,
 //                            child: Center(child: KText(text:':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
 //                        SizedBox(
 //                            width: 150,
 //                            child: KText(text:userData['status'],style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)),
 //                      ],
 //                    ),
 //                    const SizedBox(height: 14,),
 //                    const Text('Change Status', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
 //                    const Divider(color: Colors.grey, height: 10,),
 //
 //                    Padding(
 //                      padding: const EdgeInsets.only(top: 8.0),
 //                      child: Container(
 //                        width: 180,
 //                        height: 50,
 //                        decoration: BoxDecoration (
 //                          border: Border.all(color: const Color(0x7f262626)),
 //                          borderRadius: BorderRadius.circular(30),
 //                        ),
 //                        child: Padding(
 //                          padding: const EdgeInsets.only(left: 12.0,right: 6),
 //                          child:  DropdownButtonHideUnderline(
 //                            child:
 //                            DropdownButtonFormField2<
 //                                String>(
 //                              isExpanded: true,
 //                              hint: Text(
 //                                'Select Status', style:
 //                              GoogleFonts.openSans (
 //                                fontSize: 12,
 //                                fontWeight: FontWeight.w600,
 //                                color: const Color(0x7f262626),
 //                              ),
 //                              ),
 //                              items: status
 //                                  .map((String
 //                              item) =>
 //                                  DropdownMenuItem<
 //                                      String>(
 //                                    value: item,
 //                                    child: Text(
 //                                      item,
 //                                      style:
 //                                      GoogleFonts.openSans (
 //                                        fontSize: 12,
 //                                        fontWeight: FontWeight.w600,
 //                                      ),
 //                                    ),
 //                                  )).toList(),
 //                              value:
 //                              selectedStatus,
 //                              onChanged:
 //                                  (String? value) {
 //                                setState(() {
 //                                  selectedStatus = '';
 //                                  selectedStatus =
 //                                  value!;
 //                                });
 //
 //                              },
 //                              buttonStyleData:
 //                              const ButtonStyleData(
 //                              ),
 //                              menuItemStyleData:
 //                              const MenuItemStyleData(
 //
 //                              ),
 //                              decoration:
 //                              const InputDecoration(
 //                                  border:
 //                                  InputBorder
 //                                      .none),
 //                            ),
 //                          ),
 //                        ),
 //                      ),
 //                    ),
 //
 // const SizedBox(height: 10,),
 //                    Row(
 //                      mainAxisAlignment: MainAxisAlignment.end,
 //                      children: [
 //                        ElevatedButton(
 //                            style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff39cad0))),
 //                            onPressed: () async {
 //                              await FirebaseFirestore.instance.collection('Complaints').doc(userData.id).update({'status': selectedStatus});
 //                              // Close the dialog
 //                              Navigator.pop(context);
 //
 //                            }, child: KText(text:'Update', style: GoogleFonts.openSans(color: Colors.white),))
 //                      ],
 //                    )
 //                  ],
 //                ),
 //              ),
 //            ),
 //          );
 //        },
 //      );
 //    }




  Future<void> complaintDetail(BuildContext con, DocumentSnapshot userData) async {
    String selectedStatus = userData['status'];
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
                KText(text: 'Complaint Details', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18)),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: SizedBox(
                    height: 30, width: 30,
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
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: Image.asset('assets/ui-design-/images/Multiply.png', fit: BoxFit.contain, scale: 0.5,),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),

            content: SingleChildScrollView(
              child: SizedBox(
                width: 380,
                height: 330,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(color: Colors.grey, height: 10,),
                    Row(
                      children: [
                        SizedBox(
                            width: 150,
                            child: KText(text:'User Name', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)
                        ),
                        SizedBox(
                            width: 70,
                            child: Center(child: Text(':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))
                        ),
                        SizedBox(
                            width: 150,
                            child: KText(text: userData['username'],style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)
                        ),
                      ],
                    ),
                    const SizedBox(height: 4,),
                    Row(
                      children: [
                        SizedBox(
                            width: 150,
                            child: KText(text:'User Id', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)
                        ),
                        SizedBox(
                            width: 70,
                            child: Center(child: KText(text:':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))
                        ),
                        SizedBox(
                            width: 150,
                            child: KText(text:userData['userId'],style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)
                        ),
                      ],
                    ),
                    const SizedBox(height: 4,),
                    Row(
                      children: [
                        SizedBox(
                            width: 150,
                            child: KText(text:'Reason', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)
                        ),
                        SizedBox(
                            width: 70,
                            child: Center(child: KText(text:':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))
                        ),
                        SizedBox(
                            width: 150,
                            child: KText(text:userData['reason'],style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)
                        ),
                      ],
                    ),
                    const SizedBox(height: 4,),
                    Row(
                      children: [
                        SizedBox(
                            width: 150,
                            child: KText(text:'Priority', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)
                        ),
                        SizedBox(
                            width: 70,
                            child: Center(child: KText(text:':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))
                        ),
                        SizedBox(
                            width: 150,
                            child: KText(text:userData['priority'],style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)
                        ),
                      ],
                    ),
                    const SizedBox(height: 4,),
                    Row(
                      children: [
                        SizedBox(
                            width: 150,
                            child: KText(text:'Date', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)
                        ),
                        SizedBox(
                            width: 70,
                            child: Center(child: KText(text:':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))
                        ),
                        SizedBox(
                            width: 150,
                            child: KText(text:userData['date'],style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)
                        ),
                      ],
                    ),
                    const SizedBox(height: 4,),
                    Row(
                      children: [
                        SizedBox(
                            width: 150,
                            child: KText(text:'Time', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)
                        ),
                        SizedBox(
                            width: 70,
                            child: Center(child: KText(text:':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))
                        ),
                        SizedBox(
                            width: 150,
                            child: KText(text:userData['time'],style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)
                        ),
                      ],
                    ),
                    const SizedBox(height: 4,),
                    Row(
                      children: [
                        SizedBox(
                            width: 150,
                            child: KText(text:'Status', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),)
                        ),
                        SizedBox(
                            width: 70,
                            child: Center(child: KText(text:':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))
                        ),
                        SizedBox(
                            width: 150,
                            child: KText(text:userData['status'],style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)
                        ),
                      ],
                    ),
                    const SizedBox(height: 14,),
                    const Text('Change Status', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                    const Divider(color: Colors.grey, height: 10,),

                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        width: 180,
                        height: 50,
                        decoration: BoxDecoration (
                          border: Border.all(color: const Color(0x7f262626)),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0,right: 6),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField2<String>(
                              isExpanded: true,
                              hint: Text(
                                'Select Status', style: GoogleFonts.openSans (
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0x7f262626),
                              ),
                              ),
                              items: status.map((String item) =>
                                  DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: GoogleFonts.openSans (
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )).toList(),
                              value: selectedStatus,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedStatus = '';
                                  selectedStatus = value!;
                                });
                              },
                              buttonStyleData: const ButtonStyleData(),
                              menuItemStyleData: const MenuItemStyleData(),
                              decoration: const InputDecoration(
                                  border: InputBorder.none
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // ElevatedButton(
                        //     style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff39cad0))),
                        //     onPressed: () async {
                        //       await FirebaseFirestore.instance.collection('Complaints').doc(userData.id).update({'status': selectedStatus});
                        //       Navigator.pop(context);
                        //     },
                        //     child: KText(text: 'Update', style: GoogleFonts.openSans(color: Colors.white),)
                        // )

                        // ElevatedButton(
                        //     style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff39cad0))),
                        //     onPressed: () async {
                        //       await FirebaseFirestore.instance.collection('Complaints').doc(userData.id).update({'status': selectedStatus});
                        //
                        //       // Retrieve the FCM token from the Users collection using the userData['userId']
                        //       DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('Users').doc('oXjAcnvco6ev6pbNLjQF').get();
                        //       String token = userSnapshot['fcmToken'];
                        //
                        //       // Send the push notification
                        //       sendPushMessage(token: token, body: 'Your complaint status has been updated', title: 'Complaint Status Updated');
                        //
                        //       Navigator.pop(context);
                        //     },
                        //     child: KText(text: 'Update', style: GoogleFonts.openSans(color: Colors.white),)
                        // )



                        ///getting id
                        ElevatedButton(
                            style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff39cad0))),
                            onPressed: () async {
                              await FirebaseFirestore.instance.collection('Complaints').doc(userData.id).update({'status': selectedStatus});
                              QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance.collection('Users').where('uid', isEqualTo: userData['uid']).get();

                              if (userQuerySnapshot.docs.isNotEmpty) {
                                String token = userQuerySnapshot.docs.first['fcmToken'];

                                // Send the push notification
                                sendPushMessage(token: token, body: 'Your complaint status has been updated to "${selectedStatus}"', title: 'Complaint Status Updated');
                              } else {
                                print('User not found');
                                // Handle the case where the user is not found
                              }

                              Navigator.pop(context);
                            },
                            child: KText(text: 'Update', style: GoogleFonts.openSans(color: Colors.white),)
                        )


                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }
    );
  }


  void sendPushMessage({required String token, required String body, required String title}) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
          'key=${Constants.apiKeyForNotification}',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': body, 'title': title},
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }
}

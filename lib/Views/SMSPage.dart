import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/RUsableCommunication.dart';
import '../widgets/ReusableHeader.dart';
import '../widgets/communicationTextfield.dart';
import '../widgets/customtextfield.dart';

class SMSPage extends StatefulWidget {
  const SMSPage({super.key});

  @override
  State<SMSPage> createState() => _SMSPageState();
}

class _SMSPageState extends State<SMSPage> {
  final TextEditingController searchSms = TextEditingController();
  final TextEditingController leaveAlert = TextEditingController();
  final TextEditingController message = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Image.asset("assets/sms.png"),
              const ReusableHeader(Headertext: 'Asset Management ', SubHeadingtext: '"Manage Easily Your Assets"'),
              const SizedBox(height: 10,),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xff262626).withOpacity(0.10)),
                  borderRadius: BorderRadius.circular(30),
                ),
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // SizedBox(width: 20,),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: CustomTextField(hint: 'Search Sms..',  controller: searchSms, validator: null, fillColor: const Color(0xffF5F5F5),header: '', width: 335, preffixIcon: Icons.search,height: 45, ),
                    ),
                    SizedBox.fromSize(size: const Size(0, 0),),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 44,
                            // width: 100,
                            child: ElevatedButton(
                                style: const ButtonStyle(
                                    elevation: MaterialStatePropertyAll(2),
                                    backgroundColor: MaterialStatePropertyAll(Color(0xff37D1D3))),
                                onPressed: (){}, child:
                            const Row(
                              children: [
                                Text('Search', style: TextStyle(color: Colors.white),), SizedBox(width: 10,), Icon(Icons.search, color: Colors.white,)
                              ],)
                            ),
                          ),

                          SizedBox.fromSize(size: const Size(23,0),),
                          SizedBox(
                            height: 44,
                            // width: 100,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: const MaterialStatePropertyAll(Color(0xffFD7E50)),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50),
                                      )
                                  ),
                                  // elevation: MaterialStatePropertyAll(2),
                                ),
                                onPressed: (){}, child:
                            const Row(
                              children: [
                                Text('View SMS', style: TextStyle(color: Colors.white),), SizedBox(width: 10,), Icon(Icons.remove_red_eye_outlined, color: Colors.white,)
                              ],)
                            ),
                          ),
                        ],),
                    )
                  ],),),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 800,
                  decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff262626).withOpacity(0.10)),
                        borderRadius: BorderRadius.circular(30),
                      ),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReusableDropdown4Commu(dropDownItems: ['Hostel', 'School', 'police'], hintText: 'Notify Type', onChanged: (value){}),
                        ReusableDropdown4Commu(dropDownItems: ['Hostel', 'School', 'police'], hintText: 'Person', onChanged: (value){}),
                        ReusableDropdown4Commu(dropDownItems: ['Hostel', 'School', 'police'], hintText: 'Block No', onChanged: (value){}),
                        ReusableDropdown4Commu(dropDownItems: ['Hostel', 'School', 'police'], hintText: 'Room No', onChanged: (value){}),
                      ],),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReusableDropdown4Commu(dropDownItems: ['Hostel', 'School', 'police'], hintText: 'Gender', onChanged: (value){}),
                        ReusableDropdown4Commu(dropDownItems: ['Hostel', 'School', 'police'], hintText: 'Blood Group', onChanged: (value){}),
                        ReusableDropdown4Commu(dropDownItems: ['Hostel', 'School', 'police'], hintText: 'Phone Number', onChanged: (value){}),
                        ReusableDropdown4Commu(dropDownItems: ['Hostel', 'School', 'police'], hintText: 'Pin Code', onChanged: (value){}),
                      ],),

                    Container(
                      decoration: BoxDecoration(
                        // border: Border.all(color: const Color(0xff262626).withOpacity(0.10)
                        // ),
                        border: Border(
                          bottom: BorderSide(width: 1.5, color: const Color(0x7f262626).withOpacity(0.2)),
                        ),

                      ),
                      child:
                      SizedBox(
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 45,
                              child: ElevatedButton(
                                  style:  const ButtonStyle(
                                      elevation: MaterialStatePropertyAll(3),
                                      backgroundColor: MaterialStatePropertyAll(Color(0xff37D1D3))),
                                  onPressed: (){}, child: Row(
                                children: [
                                  Text('Apply', style: GoogleFonts.openSans(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),),
                                  const SizedBox(width: 8,),
                                  const Icon(Icons.check_circle, color: Colors.white, size: 20,)
                                ],)
                              ),
                            ),
                            const SizedBox(width: 20,)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 18,),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25, top: 8.0, bottom: 8.0),
                      child: CommunicationTextfield(hint: 'Sub', controller: leaveAlert, validator: null, header: 'Subject:', width: double.infinity,),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25, top: 8.0, bottom: 8.0),
                      child:
                      CommunicationTextfield(hint: 'Type Your Message Here...', controller: message, validator: null, header: 'Message:', width: double.infinity, height: 300,),

                    ),
                  ],),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}

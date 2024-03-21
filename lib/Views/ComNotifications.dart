import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/RUsableCommunication.dart';
import '../widgets/ReusableHeader.dart';
import '../widgets/communicationTextfield.dart';
import '../widgets/customtextfield.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  static const IconData notifications = IconData(0xe44f, fontFamily: 'MaterialIcons');
  final TextEditingController SubjectCont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const ReusableHeader(
                  Headertext: 'Notifications',
                  SubHeadingtext: '"Connect and collaborate effortlessly"'),
              SizedBox.fromSize(size: const Size(0, 10)),
              //   a mini container for view email button
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xff262626).withOpacity(0.10)),
                  borderRadius: BorderRadius.circular(30),
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
                                backgroundColor: MaterialStatePropertyAll(Color(0xffE2CB3F))),
                            onPressed: (){}, child: Row(
                          children: [
                            Text('View Notification', style: GoogleFonts.openSans(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),),
                            const SizedBox(width: 8,),
                            const Icon(Icons.notifications, color: Colors.white, size: 20,)
                          ],)
                        ),
                      ),

                      const SizedBox(width: 20,)

                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Text('Send Alert Notification', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 800,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(color: const Color(0xff262626).withOpacity(0.1))),
                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReusableDropdown4Commu(dropDownItems: ['Hostel', 'School', 'police'], hintText: 'Select Yours', onChanged: (value){}),
                          ReusableDropdown4Commu(dropDownItems: ['Hostel', 'School', 'police'], hintText: 'Select Yours', onChanged: (value){}),
                          ReusableDropdown4Commu(dropDownItems: ['Hostel', 'School', 'police'], hintText: 'Select Yours', onChanged: (value){}),
                          ReusableDropdown4Commu(dropDownItems: ['Hostel', 'School', 'police'], hintText: 'Select Yours', onChanged: (value){}),
                        ],),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReusableDropdown4Commu(dropDownItems: ['Hostel', 'School', 'police'], hintText: 'Select Yours', onChanged: (value){}),
                          ReusableDropdown4Commu(dropDownItems: ['Hostel', 'School', 'police'], hintText: 'Select Yours', onChanged: (value){}),
                          ReusableDropdown4Commu(dropDownItems: ['Hostel', 'School', 'police'], hintText: 'Select Yours', onChanged: (value){}),
                          ReusableDropdown4Commu(dropDownItems: ['Hostel', 'School', 'police'], hintText: 'Select Yours', onChanged: (value){}),
                        ],),
                      const SizedBox(height: 10,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            child:  SizedBox(
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
                                ],)),
                            ),

                          ),
                          SizedBox(width: 20,)

                        ],
                      ),
                      SizedBox(height: 15,),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25, top: 8.0, bottom: 8.0),
                        child: CommunicationTextfield(hint: 'Sub', controller: SubjectCont, validator: null, header: 'Subject:', width: double.infinity,),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25, top: 8.0, bottom: 8.0),
                        child: CommunicationTextfield(hint: 'Type Your Message Here...', controller: SubjectCont, validator: null, header: 'Message:', width: double.infinity, height: 300,),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(width: 15,),

                          SizedBox(
                            height: 45,
                            child: ElevatedButton(

                                style:  const ButtonStyle(

                                    elevation: MaterialStatePropertyAll(2),
                                    backgroundColor: MaterialStatePropertyAll(Color(0xffFFFFFF))),
                                onPressed: (){}, child: Row(
                              children: [
                                Text('Cancle', style: GoogleFonts.openSans(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xff37D1D3)),),



                              ],)
                            ),
                          ),
                          SizedBox(width: 15,),
                          SizedBox(
                            height: 45,
                            child: ElevatedButton(
                                style:  const ButtonStyle(
                                    elevation: MaterialStatePropertyAll(3),
                                    backgroundColor: MaterialStatePropertyAll(Color(0xff37D1D3))),
                                onPressed: (){}, child: Row(
                              children: [
                                Text('Send', style: GoogleFonts.openSans(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),),
                                const SizedBox(width: 8,),
                                const Icon(Icons.mail_lock, color: Colors.white, size: 20,)
                              ],)
                            ),
                          ),
                          SizedBox(width: 25,),




                        ],)




                    ],
                  ),
                ),
              )









            ],
          ),
        ),
      ),
    );

  }
}

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/ReusableHeader.dart';
import '../widgets/customtextfield.dart';
import '../widgets/userMiniDetails.dart';

class FeesPage extends StatefulWidget {
  const FeesPage({super.key});
  @override
  State<FeesPage> createState() => _FeesPageState();
}

class _FeesPageState extends State<FeesPage> {
  final TextEditingController ResidentName = TextEditingController();

  final List<String> NotifyType = [
    'Male',
    'Female',
  ];
  String? selectedNotify;

  List<Map<String, dynamic>> searchSuggestions = [];

  void fetchUsers() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Users').get();
    setState(() {
      searchSuggestions = snapshot.docs.map((doc) => {
        'name': doc['firstName'] as String,
        'docId': doc.id,
        'userid': doc['userid'] as String,
        'phone' : doc['phone']as String,
        'profilePicture': doc['imageUrl'] as String,
        'status' : doc['status'] as bool
      }).toList();
    }
    );
  }


  @override
  Widget build(BuildContext context) {
    return  FadeInRight(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Image.asset("assets/fees.png"),
              // Image.asset("assets/fees.png"),
              const ReusableHeader(Headertext: 'Fees Register ', SubHeadingtext: '"Manage Easily Residents Records"'),
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
                  child: CustomTextField(hint: 'Search Resident Name',  controller: ResidentName, validator: null, fillColor: const Color(0xffF5F5F5),header: '', width: 335, preffixIcon: Icons.search,height: 45,
                    onChanged: (value) {
                      setState(() {
                        if(value.isEmpty){
                          fetchUsers();
                          print('values Emp');
                        }
                        else{
                          searchSuggestions = searchSuggestions.where((user) => user['name'].toLowerCase().contains(value.toLowerCase())).toList();
                          print('getting data');
                          print(value);}
                        print(searchSuggestions);
                        print('ide');
                      }
                      );
                    },

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: CustomTextField(hint: 'Search Resident User ID',  controller: ResidentName, validator: null, fillColor: const Color(0xffF5F5F5),header: '', width: 335, preffixIcon: Icons.search,height: 45, ),
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
                        Row(
                          children: [
                            const Text('Search', style: TextStyle(color: Colors.white),),
                            SizedBox.fromSize(size: const Size(8,0),),
                            const Icon(Icons.search)
                              ],)
                        ),
                      ),
                      SizedBox.fromSize(size: const Size(23,0),),
                      SizedBox(
                        height: 44,
                        // width: 100,
                        child:
                        Container(
                          height: 44,
                          // width: 100,
                          child:
                          ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      side:
                                      const BorderSide(color: Color(0xff37D1D3)
                                      )
                                  )
                              ),
                              // elevation: MaterialStatePropertyAll(2),
                            ),
                            onPressed: () {},
                            child: Row(
                              children: [
                                const Text('Reset', style: TextStyle(color: Color(0xff37D1D3))),
                                SizedBox.fromSize(size: const Size(8, 0)),
                                const Icon(Icons.recycling, size: 18, color: Color(0xff37D1D3)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],),
                )
              ],
            ),
          ),
              const SizedBox(height: 10,),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xff262626).withOpacity(0.10)),
                  borderRadius: BorderRadius.circular(30),
                ),
                child:
                 Row(children: [
                   Padding(
                     padding:  const EdgeInsets.all(20.0),
                     child: Container(
                       height: 420,
                       width: 300,
                       decoration: const BoxDecoration(
                           color: Color(0xff37D1D3),

                           borderRadius: BorderRadius.all(Radius.circular(10))),
                       child: ClipRRect(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Stack(
                               children: [
                                 const Padding(
                                   padding: EdgeInsets.only(top: 10, bottom: 10, left: 35),
                                   child: SizedBox(
                                       height: 220,
                                       child: Image(image: AssetImage('assets/ui-design-/images/framee.png'))),
                                 ),
                                 Positioned(
                                   left: 95,
                                   top: 68,
                                   child: SizedBox(
                                     child: CircleAvatar(
                                       radius: 62,
                                       backgroundColor: const Color(0xffF5F6F7),
                                       child: Image.asset('assets/ui-design-/images/d-portrait-high-school-teenager-photoroom-1.png'),)
                                   ),
                                 ),
                               ],),
                             const Padding(
                               padding: EdgeInsets.all(10),
                               child: Column(children: [
                                 UserMiniDetails(IconName: Icons.contact_mail, iName: 'User ID                : '  , userDet: '   832983',),
                                 SizedBox(height: 8,),
                                 UserMiniDetails(IconName: Icons.phone, iName: 'Phone Number  :      ',userDet: '9391020012'),
                                 SizedBox(height: 48,),
                                 Padding(
                                   padding: EdgeInsets.only(top: 3, bottom: 3),
                                   child: SizedBox(
                                       height: 35,
                                       child:
                                       Image(image: AssetImage('assets/ui-design-/images/Group 84.png')
                                       )
                                   ),
                                 )
                               ],),
                             )
                           ],),
                       ),
                     ),
                   ),
                 //  right side
                   Container(
                     height: 600,
                     width: 750,
                     decoration: BoxDecoration(
                       // color: Colors.blue,
                       border: Border.all(color: const Color(0xff262626).withOpacity(0.10)),
                   ),
                     child:
                     Padding(
                       padding: const EdgeInsets.all(20),
                       child: Column(children: [
                         // Export Button
                         Row(
                           mainAxisAlignment: MainAxisAlignment.end,
                           children: [
                             SizedBox(
                               height: 40,
                               child: ElevatedButton(
                                 style:  const ButtonStyle(
                                     elevation: MaterialStatePropertyAll(3),
                                     backgroundColor: MaterialStatePropertyAll(Color(0xff37D1D3))),
                                 onPressed: () {
                                 },
                                 child: Row(children: [
                                   Text('Export Data', style: GoogleFonts.openSans(color: Colors.white),),
                                    const Icon(Icons.downloading, color: Colors.white,)
                                 ],),
                               ),
                             )
                           ],),
                        SizedBox(height: 20,),
                          Row(children: [
                            Text('Selected Fees                    :     ', style: GoogleFonts.openSans(fontWeight: FontWeight.w600 ),),
                       const SizedBox(height: 30),
                       // Container(
                       //   width: 510,
                       //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
                       //   child: DropdownButtonFormField2<String>(
                       //     value: selectedValue,
                       //     isExpanded: true,
                       //     decoration: InputDecoration(
                       //       contentPadding: const EdgeInsets.symmetric(vertical: 16),
                       //       border: OutlineInputBorder(
                       //         borderRadius: BorderRadius.circular(15),
                       //       ),
                       //     ),
                       //     hint: const Text(
                       //       'Monthly',
                       //       style: TextStyle(fontSize: 14),
                       //     ),
                       //     items: genderItems
                       //         .map((item) => DropdownMenuItem<String>(
                       //       value: item,
                       //       child: Text(
                       //         item,
                       //         style: const TextStyle(
                       //           fontSize: 14,
                       //         ),
                       //       ),
                       //     ))
                       //         .toList(),
                       //        validator: (value){
                       //          if (value == null) {
                       //            return 'Please select gender.';
                       //          }
                       //          return null;
                       //        },
                       //     onChanged: (value) {
                       //       setState(() {
                       //         value = selectedValue;
                       //       });
                       //     },
                       //     buttonStyleData: const ButtonStyleData(
                       //       padding: EdgeInsets.only(right: 8),
                       //     ),
                       //     iconStyleData: const IconStyleData(
                       //       icon: Icon(
                       //         Icons.arrow_drop_down,
                       //         color: Colors.black45,
                       //       ),
                       //       iconSize: 24,
                       //     ),
                       //     dropdownStyleData: DropdownStyleData(
                       //       decoration: BoxDecoration(
                       //         borderRadius: BorderRadius.circular(15),
                       //       ),
                       //     ),
                       //     menuItemStyleData: const MenuItemStyleData(
                       //       padding: EdgeInsets.symmetric(horizontal: 16),
                       //     ),
                       //   ),
                       // )
                       //
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container(
                                width: 430,
                                height: 50,
                                decoration: BoxDecoration (
                                  border: Border.all(color: const Color(0x7f262626)),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12.0,right: 6),
                                  child:  DropdownButtonHideUnderline(
                                    child:
                                    DropdownButtonFormField2<
                                        String>(
                                      isExpanded: true,
                                      hint: Text(
                                        'Prefix', style:
                                      GoogleFonts.openSans (
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0x7f262626),
                                      ),
                                      ),
                                      items: NotifyType
                                          .map((String
                                      item) =>
                                          DropdownMenuItem<
                                              String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style:
                                              GoogleFonts.openSans (
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          )).toList(),
                                      value:
                                      selectedNotify,
                                      onChanged:
                                          (String? value) {
                                        setState(() {
                                          selectedNotify =
                                          value!;
                                        });
                                      },
                                      buttonStyleData:
                                      const ButtonStyleData(
                                      ),
                                      menuItemStyleData:
                                      const MenuItemStyleData(
                                      ),
                                      decoration:
                                      const InputDecoration(
                                          border:
                                          InputBorder
                                              .none),
                                    ),
                                  ),
                                ),
                              ),
                            ),


                          ]
                         ,),
                         const SizedBox(height: 25,),
                         Row(children: [
                            Text('Patment Method              :     ',style: GoogleFonts.openSans(fontWeight: FontWeight.w600 )),
                           const SizedBox(height: 30),
                           Padding(
                             padding: const EdgeInsets.only(top: 8.0),
                             child: Container(
                               width: 430,
                               height: 50,
                               decoration: BoxDecoration (
                                 border: Border.all(color: const Color(0x7f262626)),
                                 borderRadius: BorderRadius.circular(30),
                               ),
                               child: Padding(
                                 padding: const EdgeInsets.only(left: 12.0,right: 6),
                                 child:  DropdownButtonHideUnderline(
                                   child:
                                   DropdownButtonFormField2<
                                       String>(
                                     isExpanded: true,
                                     hint: Text(
                                       'Prefix', style:
                                     GoogleFonts.openSans (
                                       fontSize: 12,
                                       fontWeight: FontWeight.w600,
                                       color: const Color(0x7f262626),
                                     ),
                                     ),
                                     items: NotifyType
                                         .map((String
                                     item) =>
                                         DropdownMenuItem<
                                             String>(
                                           value: item,
                                           child: Text(
                                             item,
                                             style:
                                             GoogleFonts.openSans (
                                               fontSize: 12,
                                               fontWeight: FontWeight.w600,
                                             ),
                                           ),
                                         )).toList(),
                                     value:
                                     selectedNotify,
                                     onChanged:
                                         (String? value) {
                                       setState(() {
                                         selectedNotify =
                                         value!;
                                       });
                                     },
                                     buttonStyleData:
                                     const ButtonStyleData(
                                     ),
                                     menuItemStyleData:
                                     const MenuItemStyleData(
                                     ),
                                     decoration:
                                     const InputDecoration(
                                         border:
                                         InputBorder
                                             .none),
                                   ),
                                 ),
                               ),
                             ),
                           ),

                         ],),
                         const SizedBox(height: 15,),
                         Row(children: [
                            Text('Payment Amount             :     ',style: GoogleFonts.openSans(fontWeight: FontWeight.w600 )),
                           const SizedBox(height: 30),
                           Padding(
                             padding: const EdgeInsets.only(top: 8.0),
                             child: Container(
                               width: 430,
                               height: 50,
                               decoration: BoxDecoration (
                                 border: Border.all(color: const Color(0x7f262626)),
                                 borderRadius: BorderRadius.circular(30),
                               ),
                               child: Padding(
                                 padding: const EdgeInsets.only(left: 12.0,right: 6),
                                 child:  DropdownButtonHideUnderline(
                                   child:
                                   DropdownButtonFormField2<
                                       String>(
                                     isExpanded: true,
                                     hint: Text(
                                       'Prefix', style:
                                     GoogleFonts.openSans (
                                       fontSize: 12,
                                       fontWeight: FontWeight.w600,
                                       color: const Color(0x7f262626),
                                     ),
                                     ),
                                     items: NotifyType
                                         .map((String
                                     item) =>
                                         DropdownMenuItem<
                                             String>(
                                           value: item,
                                           child: Text(
                                             item,
                                             style:
                                             GoogleFonts.openSans (
                                               fontSize: 12,
                                               fontWeight: FontWeight.w600,
                                             ),
                                           ),
                                         )).toList(),
                                     value:
                                     selectedNotify,
                                     onChanged:
                                         (String? value) {
                                       setState(() {
                                         selectedNotify =
                                         value!;
                                       });
                                     },
                                     buttonStyleData:
                                     const ButtonStyleData(
                                     ),
                                     menuItemStyleData:
                                     const MenuItemStyleData(
                                     ),
                                     decoration:
                                     const InputDecoration(
                                         border:
                                         InputBorder
                                             .none),
                                   ),
                                 ),
                               ),
                             ),
                           ),

                         ],),
                         const SizedBox(height: 15,),

                         SizedBox(

                           // width: 200,
                           child: Row(children: [
                              Text('Previous Payments          :     ',style: GoogleFonts.openSans(fontWeight: FontWeight.w600 )),
                            Container(
                              width: 510,

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                               children: [

                               SizedBox(
                                   width: 80,
                                   child: Text('Date', style: GoogleFonts.openSans(fontWeight: FontWeight.w600,),)),

                               SizedBox(child: Text('Fees Type', style: GoogleFonts.openSans(fontWeight: FontWeight.w600,color: Color(0xff262626).withOpacity(0.8)))),

                               SizedBox(child: Text('Amount', style: GoogleFonts.openSans(fontWeight: FontWeight.w600,))),

                               SizedBox(child: Text('Method', style: GoogleFonts.openSans(fontWeight: FontWeight.w600,))),
                                                         ],),
                            )
                           ],),
                         ),
                         const SizedBox(height: 15,),
                         Padding(
                           padding: const EdgeInsets.only(left: 145),
                           child: Container(
                             width: 510,
                             // color: Colors.blue,
                             child: Row(
                               // crossAxisAlignment: CrossAxisAlignment.end,
                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                               children: [
                                 SizedBox(
                                     width: 125,
                                     child: Text('12/02/2024', style: GoogleFonts.openSans(fontWeight: FontWeight.w600,color: Color(0xff262626).withOpacity(0.8)),)),
                                 Container(
                                   width: 120,
                                     child: Center(child: Text('Hostel Rent', style: GoogleFonts.openSans(fontWeight: FontWeight.w600,color: Color(0xff262626).withOpacity(0.8))))),
                                 Padding(
                                   padding: const EdgeInsets.only(left: 10, right: 40),
                                   child: Container(
                                       width: 60,
                                       child: Center(child: Text('8500/-', style: GoogleFonts.openSans(fontWeight: FontWeight.w600,color: Color(0xff262626).withOpacity(0.8))))),
                                 ),
                                 Text('Cash', style: GoogleFonts.openSans(fontWeight: FontWeight.w600,color: Color(0xff262626).withOpacity(0.8))),
                               ],),
                           ),
                         ),

                         SizedBox(height: 10,),
                         Padding(
                           padding: const EdgeInsets.only(left: 145),
                           child: Container(
                             width: 510,
                             // color: Colors.blue,
                             child: Row(
                               // crossAxisAlignment: CrossAxisAlignment.end,
                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                               children: [
                                 SizedBox(
                                     width: 120,
                                     child: Text('12/02/2024', style: GoogleFonts.openSans(fontWeight: FontWeight.w600,color: Color(0xff262626).withOpacity(0.8)),)),
                                 Container(
                                     width: 120,
                                     child: Center(child: Text('Hostel Rent', style: GoogleFonts.openSans(fontWeight: FontWeight.w600,color: Color(0xff262626).withOpacity(0.8))))),
                                 Padding(
                                   padding: const EdgeInsets.only(left: 10, right: 40),
                                   child: Container(
                                       width: 60,
                                       child: Center(child: Text('8500/-', style: GoogleFonts.openSans(fontWeight: FontWeight.w600,color: Color(0xff262626).withOpacity(0.8))))),
                                 ),
                                 Text('Cash', style: GoogleFonts.openSans(fontWeight: FontWeight.w600,color: Color(0xff262626).withOpacity(0.8))),
                               ],),
                           ),
                         ),

                       ],),
                     ),
                   )
                 ],)
              )
            ],
          ),
        ),
      ),
    );
  }
}

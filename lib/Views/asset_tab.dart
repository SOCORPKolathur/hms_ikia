import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_ikia/widgets/ReusableHeader.dart';
import 'package:hms_ikia/widgets/customtextfield.dart';
import 'package:intl/intl.dart';

import '../Constants/constants.dart';

class AssetManagement extends StatefulWidget {
  const AssetManagement({super.key});

  @override
  State<AssetManagement> createState() => _AssetManagementState();
}

class _AssetManagementState extends State<AssetManagement> {
  // residentname
  TextEditingController AssetsNameSearch = new TextEditingController();
  TextEditingController AssetName = new TextEditingController();
  // Date
  TextEditingController DateController = new TextEditingController();
  TextEditingController ApproximateVal = new TextEditingController();
  TextEditingController gender = new TextEditingController();
  TextEditingController amcDateController = new TextEditingController();
  TextEditingController insuranceDateController = new TextEditingController();



  // for normal
  DateTime ? _selectedDate;
  // for Insurance Date
  DateTime ? _selectedInsuranceDate ;
  // for AMC dateController
  DateTime ? _selectedAmcDate;

  // normal one
  Future<void> _selectDate(BuildContext context) async{
    final DateTime ? picked = await showDatePicker(context: context, firstDate: DateTime(1900), lastDate: DateTime.now());
    if(picked != null){
      setState(() {
        _selectedDate = picked;

        print('normal date $_selectedDate');
        DateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  // for Insurance date
  Future<void> _insuranceDate(BuildContext context) async{
    final DateTime ? picked = await showDatePicker(context: context, firstDate: DateTime(1900), lastDate: DateTime.now());
    if(picked != null){
      print(picked);
      setState(() {
        _selectedInsuranceDate = picked;
        insuranceDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        print('Insurance date: $_selectedInsuranceDate');
      });
    }
  }

  Future<void> _amcDate(BuildContext context) async{
    final DateTime ? picked = await showDatePicker(context: context, firstDate: DateTime(1900), lastDate: DateTime.now());
    if(picked != null){
      setState(() {
        _selectedAmcDate = picked;
        amcDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        print('amcDate $_selectedAmcDate');
      });
    }
  }


  List<String> assetsCategory = [
    'Furniture',
    'Electronics',
    'Appliances',
    'Vehicles',
  ];

  List<String> damageLevel = [
    'Minor',
    'Moderate',
    'Severe',
  ];

  List<String> selectProduct = [
    'Bed',
    'Chair',
    'Table',
    'Refrigerator',
  ];

  String? selectedAssetsCategory;
  String? selectedDamageLevel;
  String? selectedProduct;


  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Image.asset("assets/assetui.png"),
              const ReusableHeader(Headertext: 'Asset Management ',
                  SubHeadingtext: '"Manage Easily Your Assets"'),
              const SizedBox(height: 10,),

              Container(
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color(0xff262626).withOpacity(0.10)),
                  borderRadius: BorderRadius.circular(30),
                ),
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // SizedBox(width: 20,),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: CustomTextField(hint: 'Search Resident Name',
                        controller: AssetsNameSearch,
                        validator: null,
                        fillColor: const Color(0xffF5F5F5),
                        header: '',
                        width: 335,
                        preffixIcon: Icons.search,
                        height: 45,),
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
                                    backgroundColor: MaterialStatePropertyAll(
                                        Color(0xff37D1D3))),
                                onPressed: () {
                                  AssetDetailPopUp(context);
                                }, child:
                            Row(
                              children: [
                                const Text('Add Assets',
                                  style: TextStyle(color: Colors.white),),
                                SizedBox.fromSize(size: const Size(8, 0),),
                                const CircleAvatar(radius: 12,
                                  backgroundColor: Colors.white,
                                  child: Center(child: Icon(
                                    Icons.add, color: Color(0xff37D1D3),)),)
                              ],)
                            ),
                          ),
                          SizedBox.fromSize(size: const Size(23, 0),),
                          SizedBox(
                            height: 44,
                            // width: 100,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: const MaterialStatePropertyAll(
                                      Color(0xffF12D2D)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              50),
                                          side: const BorderSide(
                                              color: Color(0xffF12D2D))
                                      )
                                  ),
                                ),
                                onPressed: () {
                                  print('assetDamage');
                                  AssetDamagePopUp();
                                }, child:
                            const Row(
                              children: [
                                Text('Report Damage',
                                  style: TextStyle(color: Colors.white),),
                                SizedBox(width: 10,),
                                Icon(Icons.water_damage_rounded,
                                  color: Colors.white,)
                              ],)
                            ),
                          ),

                        ],),
                    )
                  ],),),
              const SizedBox(height: 20,),
              //   2nd Big Container starts here
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xfff5f5f5),
                  border: Border.all(
                      color: const Color(0xff262626).withOpacity(0.10)),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(children: [
                  Container(
                    // color: Colors.white,
                    height: 250,
                    width: 450,
                    child:
                    Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            decoration: const BoxDecoration(color: Colors.white,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10))),
                            width: 200,
                            height: 75,
                            child:
                            // total
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Total', style: GoogleFonts.openSans(
                                    color: const Color(0xff262626).withOpacity(
                                        0.8),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 19)),
                                Text('45,000', style: GoogleFonts.openSans(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 19),)
                              ],),

                          ),


                          Container(
                            decoration: const BoxDecoration(color: Colors.white,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10))),
                            width: 200,
                            height: 75,
                            // utilized
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Utilized', style: GoogleFonts.openSans(
                                    color: const Color(0xff262626).withOpacity(
                                        0.8),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 19)),
                                Text('24,000', style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 19,
                                    color: const Color(0xff37D1D3)),)
                              ],),
                          ),

                        ],),
                      const SizedBox(height: 10,),
                      // second row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            decoration: const BoxDecoration(color: Colors.white,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10))),
                            width: 200,
                            height: 75,
                            child:
                            // Unutilized
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Unutilized', style: GoogleFonts.openSans(
                                    color: const Color(0xff262626).withOpacity(
                                        0.8),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 19)),
                                Text('21,120', style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xffFD7E50),
                                    fontSize: 19),)
                              ],),
                          ),
                          Container(
                            decoration: const BoxDecoration(color: Colors.white,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10))),
                            width: 200,
                            height: 75,
                            // damaged
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Damaged', style: GoogleFonts.openSans(
                                    color: const Color(0xff262626).withOpacity(
                                        0.8),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 19)),
                                Text('567', style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xffF12D2D),
                                    fontSize: 19))
                              ],),
                          ),
                        ],)
                    ],),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(13),
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.white,
                            borderRadius: BorderRadius.all(
                                Radius.circular(30))),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Expense Monitor',
                                      style: GoogleFonts.openSans(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 19,
                                          color: const Color(0xff262626)),),
                                    const SizedBox(height: 40,),
                                    Text('Total Expense',
                                        style: GoogleFonts.openSans(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 19,
                                            color: const Color(0xff262626))),
                                    const SizedBox(height: 7,),

                                    Text('9,78,79,827',
                                        style: GoogleFonts.openSans(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 19,
                                            color: const Color(0xff37D1D3))),
                                    const SizedBox(height: 30,),

                                    Text('Unpaid Payments',
                                        style: GoogleFonts.openSans(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 19,
                                            color: Colors.grey)),
                                    Text('₹ 5,24,45,685',
                                        style: GoogleFonts.openSans(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 19,
                                            color: const Color(0xffF12D2D)))
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                children: [
                                  // first container
                                  Container(
                                    height: 100,
                                    width: 250,
                                    decoration: BoxDecoration(
                                      // color: Color(0xfff5f5f5),
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceEvenly,
                                      children: [
                                        Text('Highest Expense',
                                          style: GoogleFonts.openSans(
                                              color: Colors.black54,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),),
                                        Text('Beds',
                                          style: GoogleFonts.openSans(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                              fontSize: 17),),
                                        Text('₹ 24,45,685',
                                            style: GoogleFonts.openSans(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 24,
                                                color: const Color(0xff37D1D3),
                                                letterSpacing: 1.2))
                                      ],),
                                  ),
                                  // Second Container
                                  Container(
                                    height: 100,
                                    width: 250,
                                    decoration: BoxDecoration(
                                      // color: Color(0xfff5f5f5),
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceEvenly,
                                      children: [
                                        Text('Lowest Expense',
                                          style: GoogleFonts.openSans(
                                              color: Colors.black54,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),),
                                        Text('Irons',
                                          style: GoogleFonts.openSans(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                              fontSize: 17),),
                                        Text('₹ 4,45,685',
                                            style: GoogleFonts.openSans(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 24,
                                                color: const Color(0xffE2CB3F),
                                                letterSpacing: 1.2))
                                      ],),

                                  ),
                                ],
                              )
                            ],),
                        ),
                      ),
                    ),
                  ),
                ],),


              ),
              const SizedBox(height: 10,),
              //   3rd big container starts here
              Container(
                height: 400,
                width: double.infinity,
                decoration: BoxDecoration(
                  // color: Color(0xfff5f5f5),
                  color: Colors.white,
                  border: Border.all(
                      color: const Color(0xff262626).withOpacity(0.10)),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(children: [
                  // Left Container
                  Padding(padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 400,
                      width: 550,
                      decoration: const BoxDecoration(color: Color(0xfff5f5f5),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'Category ',
                                  style: GoogleFonts.openSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                  children: <TextSpan>[
                                    TextSpan(text: '56',
                                        style: GoogleFonts.openSans(
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xff37D1D3),
                                            fontSize: 20)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 40,
                                child:
                                TextButton(
                                  style: TextButton.styleFrom(
                                      side: const BorderSide(
                                          width: 2, color: Color(0xff37D1D3)),
                                      padding: const EdgeInsets.all(10),
                                      foregroundColor: const Color(0xff37D1D3),
                                      textStyle: const TextStyle(fontSize: 20)),
                                  child: Row(
                                    children: [
                                      const Text('Add Category',
                                        style: TextStyle(
                                            color: Color(0xff37D1D3)),),
                                      SizedBox.fromSize(
                                        size: const Size(8, 0),),
                                      const CircleAvatar(radius: 12,
                                        backgroundColor: Color(0xff37D1D3),
                                        child: Center(child: Icon(
                                          Icons.add, color: Colors.white,)),)
                                    ],),
                                  onPressed: () {},
                                ),
                              ),
                            ],),
                          SizedBox(height: 20,),
                          Expanded(
                            child: GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10.0,
                                // mainAxisSpacing: 10.0,
                              ),
                              itemCount: 6,
                              itemBuilder: (BuildContext context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    width: 70, height: 30,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center,
                                              children: [
                                                Text('Bed',
                                                    style: GoogleFonts.openSans(
                                                        fontWeight: FontWeight
                                                            .w500,
                                                        fontSize: 16,
                                                        color: const Color(
                                                            0xff262626))),
                                                Text('67',
                                                  style: GoogleFonts.openSans(
                                                      fontWeight: FontWeight
                                                          .w800,
                                                      fontSize: 18),),
                                              ],),
                                            const Icon(
                                              Icons.chevron_right_outlined,
                                              size: 30,)

                                          ]),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )

                        ],),
                      ),
                    ),
                  ),
                  // Right Container
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        height: 700,
                        width: double.infinity,
                        decoration: const BoxDecoration(color: Color(
                            0xfff5f5f5),
                            borderRadius: BorderRadius.all(
                                Radius.circular(30))),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Recent Entry Records',
                                style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20),),
                              SizedBox(height: 15,),
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,

                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          height: 100,
                                          width: 300,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .center,
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 15, bottom: 15),
                                                  child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .start,
                                                      children: [
                                                        Text('Bed',
                                                          style: GoogleFonts
                                                              .openSans(
                                                              fontSize: 15,
                                                              color: Colors
                                                                  .grey,
                                                              fontWeight: FontWeight
                                                                  .w600),),
                                                        // SizedBox(height: 10,),
                                                        Row(children: [
                                                          Container(
                                                              width: 100,
                                                              child: Text(
                                                                'Double Bed with kitchen',
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                    fontSize: 15,
                                                                    color: Color(
                                                                        0xff262626),
                                                                    fontWeight: FontWeight
                                                                        .w700),)),
                                                          SizedBox(width: 10,),
                                                          Text('₹ 4,526',
                                                            style: GoogleFonts
                                                                .openSans(
                                                                fontSize: 15,
                                                                color: Color(
                                                                    0xff262626),
                                                                fontWeight: FontWeight
                                                                    .w700),)
                                                        ],)
                                                      ]),
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                  child:
                                                  TextButton(
                                                    style: TextButton.styleFrom(
                                                        side: const BorderSide(
                                                            width: 1.3,
                                                            color: Color(
                                                                0xff37D1D3)),
                                                        padding: const EdgeInsets
                                                            .all(10),
                                                        foregroundColor: const Color(
                                                            0xff37D1D3),
                                                        textStyle: const TextStyle(
                                                            fontSize: 20)),
                                                    child: Row(
                                                      children: [
                                                        const Text('Details',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xff37D1D3)),),
                                                        SizedBox.fromSize(
                                                          size: const Size(
                                                              8, 0),),
                                                        Icon(Icons
                                                            .keyboard_arrow_right_outlined,
                                                          color: Color(
                                                              0xff37D1D3),)
                                                      ],),
                                                    onPressed: () {},
                                                  ),
                                                )

                                              ],),
                                          )
                                      ),
                                    );
                                  }, itemCount: 3,
                                ),
                              )
                            ],
                          ),
                        ),

                      ),
                    ),
                  ),
                ],),

              )
            ],
          ),
        ),
      ),
    );
  }

//   Asset Damage
//   Future<void> AssetDamagePopUp() async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text('Add Room'),
//               InkWell(
//                 onTap: () => Navigator.pop(context),
//                 child: Icon(Icons.no_accounts),
//               ),
//             ],
//           ),
//           content: Container(
//             width: 700,
//             height: 250,
//             child: Column(
//               children: [
//                 Divider(color: Colors.grey, thickness: 2, height: 0.5),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8.0),
//                       child: Container(
//                         width: 220,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           border: Border.all(color: const Color(0x7f262626),),
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 12.0, right: 6),
//                           child: DropdownButtonHideUnderline(
//                             child: DropdownButtonFormField<String>(
//                               isExpanded: true,
//                               hint: const Text(
//                                 'Assets Catogory',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w600,
//                                   color: Color(0x7f262626),
//                                 ),
//                               ),
//                               items: assetsCategory.map((String item) {
//                                 return DropdownMenuItem<String>(
//                                   value: item,
//                                   child: Text(
//                                     item,
//                                     style: const TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                               value: selectedAssetsCategory,
//                               onChanged: (String? value) {
//                                 setState(() {
//                                   selectedAssetsCategory = value!;
//                                 });
//                               },
//                               decoration: const InputDecoration(
//                                   border: InputBorder.none),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8.0),
//                       child: Container(
//                         width: 220,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           border: Border.all(color: const Color(0x7f262626),),
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 12.0, right: 6),
//                           child: DropdownButtonHideUnderline(
//                             child: DropdownButtonFormField<String>(
//                               isExpanded: true,
//                               hint: const Text(
//                                 'Select Damage Level',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w600,
//                                   color: Color(0x7f262626),
//                                 ),
//                               ),
//                               items: damageLevel.map((String item) {
//                                 return DropdownMenuItem<String>(
//                                   value: item,
//                                   child: Text(
//                                     item,
//                                     style: const TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                               value: selectedDamageLevel,
//                               onChanged: (String? value) {
//                                 setState(() {
//                                   selectedDamageLevel = value!;
//                                 });
//                               },
//                               decoration: const InputDecoration(
//                                   border: InputBorder.none),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8.0),
//                       child: Container(
//                         width: 220,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           border: Border.all(color: const Color(0x7f262626),),
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 12.0, right: 6),
//                           child: DropdownButtonHideUnderline(
//                             child: DropdownButtonFormField<String>(
//                               isExpanded: true,
//                               hint: const Text(
//                                 'Assets Catogory',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w600,
//                                   color: Color(0x7f262626),
//                                 ),
//                               ),
//                               items: selectProduct.map((String item) {
//                                 return DropdownMenuItem<String>(
//                                   value: item,
//                                   child: Text(
//                                     item,
//                                     style: const TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                               value: selectedProduct,
//                               onChanged: (String? value) {
//                                 setState(() {
//                                   selectedProduct = value!;
//                                 });
//                               },
//                               decoration: const InputDecoration(
//                                   border: InputBorder.none),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8.0),
//                       child: Container(
//                         width: 220,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           border: Border.all(color: const Color(0x7f262626),),
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 12.0, right: 6),
//                           child: DropdownButtonHideUnderline(
//                             child: DropdownButtonFormField<String>(
//                               isExpanded: true,
//                               hint: const Text(
//                                 'Assets Catogory',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w600,
//                                   color: Color(0x7f262626),
//                                 ),
//                               ),
//                               items: selectProduct.map((String item) {
//                                 return DropdownMenuItem<String>(
//                                   value: item,
//                                   child: Text(
//                                     item,
//                                     style: const TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                               value: selectedProduct,
//                               onChanged: (String? value) {
//                                 setState(() {
//                                   selectedProduct = value!;
//                                 });
//                               },
//                               decoration: const InputDecoration(
//                                   border: InputBorder.none),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8.0),
//                       child: Container(
//                         width: 420,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           border: Border.all(color: const Color(0x7f262626),),
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 12.0, right: 6),
//                           child: DropdownButtonHideUnderline(
//                             child: DropdownButtonFormField<String>(
//                               isExpanded: true,
//                               hint: const Text(
//                                 'Assets Catogory',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w600,
//                                   color: Color(0x7f262626),
//                                 ),
//                               ),
//                               items: selectProduct.map((String item) {
//                                 return DropdownMenuItem<String>(
//                                   value: item,
//                                   child: Text(
//                                     item,
//                                     style: const TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                               value: selectedProduct,
//                               onChanged: (String? value) {
//                                 setState(() {
//                                   selectedProduct = value!;
//                                 });
//                               },
//                               decoration: const InputDecoration(
//                                   border: InputBorder.none),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//
//
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Container(
//                       height: 40,
//                       child: ElevatedButton(
//                         style: ButtonStyle(
//                             elevation: MaterialStatePropertyAll(0.4),
//                             backgroundColor: MaterialStatePropertyAll(Color(0xfff5f6f7))),
//                         onPressed: () {
//                         },
//                         child: Text('Cancle', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, color: Color(0xff37d1d3)),),
//                       ),
//                     ),
//                     SizedBox(width: 20,),
//                     Container(
//                       height: 40,
//                       child: ElevatedButton(
//                         style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xffF12D2D))),
//                         onPressed: () {
//                         },
//                         child: Row(
//                           children: [
//                             Text('Report Damage', style: GoogleFonts.openSans(color: Color(0xffFFFFFF), fontWeight: FontWeight.w600),),
//                             SizedBox(
//                                 height: 20, width:20,
//                                 child: Image.asset('assets/ui-design-/images/Factory Breakdown.png')),
//
//                           ],
//                         ),
//                       ),
//                     ),
//
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

  Future<void> AssetDamagePopUp() async {
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
              Text('Add Room', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
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
            width: 700,
            height: 350,
            child: Column(
              children: [
                const SizedBox(height: 10,),
                Divider(color: const Color(0xff262626).withOpacity(0.1), thickness: 1, height: 0.5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // 1st
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // block name
                          Text('Select Assets Category', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, top: 10),
                            child: Container(
                              width: 220,
                              height: 46,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all( width: 1.5, color: const Color(0x7f262626).withOpacity(0.3)
                                )
                                ,borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0, right: 6),
                                child: DropdownButtonHideUnderline(

                                  child: DropdownButtonFormField<String>(
                                    dropdownColor: Colors.white,
                                    elevation: 1,
                                    focusColor: Colors.white,
                                    isExpanded: true,
                                    hint: const Text(
                                      'Select Category',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    items: assetsCategory.map((String item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            color: Color(0x7f262626),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    value: selectedAssetsCategory,
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedAssetsCategory = value!;
                                      });
                                    },
                                    decoration: const InputDecoration(border: InputBorder.none),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 2nd
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // block name
                          Text('Select Damage Level', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, top: 10),
                            child: Container(
                              width: 220,
                              height: 46,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all( width: 1.5, color: const Color(0x7f262626).withOpacity(0.3)
                                )
                                ,borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0, right: 6),
                                child: DropdownButtonHideUnderline(

                                  child: DropdownButtonFormField<String>(
                                    dropdownColor: Colors.white,
                                    elevation: 1,
                                    focusColor: Colors.white,
                                    isExpanded: true,
                                    hint: const Text(
                                      'Select Category',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    items: damageLevel.map((String item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            color: Color(0x7f262626),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    value: selectedDamageLevel,
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedDamageLevel = value!;
                                      });
                                    },
                                    decoration: const InputDecoration(border: InputBorder.none),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 3rd
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // block name
                          Text('Select Product', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, top: 10),
                            child: Container(
                              width: 220,
                              height: 46,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all( width: 1.5, color: const Color(0x7f262626).withOpacity(0.3)
                                )
                                ,borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0, right: 6),
                                child: DropdownButtonHideUnderline(

                                  child: DropdownButtonFormField<String>(
                                    dropdownColor: Colors.white,
                                    elevation: 1,
                                    focusColor: Colors.white,
                                    isExpanded: true,
                                    hint: const Text(
                                      'Select Category',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    items: selectProduct.map((String item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            color: Color(0x7f262626),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    value: selectedProduct,
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedProduct = value!;
                                      });
                                    },
                                    decoration: const InputDecoration(border: InputBorder.none),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // block name
                          Text('Select Product', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, top: 10),
                            child: Container(
                              width: 220,
                              height: 46,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all( width: 1.5, color: const Color(0x7f262626).withOpacity(0.3)
                                )
                                ,borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0, right: 6),
                                child: DropdownButtonHideUnderline(

                                  child: DropdownButtonFormField<String>(
                                    dropdownColor: Colors.white,
                                    elevation: 1,
                                    focusColor: Colors.white,
                                    isExpanded: true,
                                    hint: const Text(
                                      'Select Category',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    items: selectProduct.map((String item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            color: Color(0x7f262626),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    value: selectedProduct,
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedProduct = value!;
                                      });
                                    },
                                    decoration: const InputDecoration(border: InputBorder.none),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // block name
                          Text('Select Product', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, top: 10),
                            child: Container(
                              width: 440,
                              height: 46,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all( width: 1.5, color: const Color(0x7f262626).withOpacity(0.3)
                                )
                                ,borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0, right: 6),
                                child: DropdownButtonHideUnderline(

                                  child: DropdownButtonFormField<String>(
                                    dropdownColor: Colors.white,
                                    elevation: 1,
                                    focusColor: Colors.white,
                                    isExpanded: true,
                                    hint: const Text(
                                      'Select Category',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    items: selectProduct.map((String item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            color: Color(0x7f262626),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    value: selectedProduct,
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedProduct = value!;
                                      });
                                    },
                                    decoration: const InputDecoration(border: InputBorder.none),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),




                  ],),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 40,
                      child: ElevatedButton(
                        style: const ButtonStyle(
                            elevation: MaterialStatePropertyAll(0),
                            backgroundColor: MaterialStatePropertyAll(Color(0xfff5f6f7))),
                        onPressed: (){}, child:
                      Text(
                        'Cancle',
                        style: GoogleFonts.openSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff37D1D3),
                        ),
                      ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        style: const ButtonStyle(
                            elevation: MaterialStatePropertyAll(3),
                            backgroundColor: MaterialStatePropertyAll(Color(0xfff12d2d))
                        ),
                        onPressed: () {
                        },
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Report Damage',
                                  style: GoogleFonts.openSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 8,),
                                SizedBox(
                                    height: 20, width: 20,
                                    child: Image.asset('assets/ui-design-/images/Factory Breakdown.png'))
                              ],
                            ),
                            const SizedBox(width: 8),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        );
      },
    );
  }
//   for adding assets
  Future<void> AssetDetailPopUp(BuildContext context) async {
    double baseWidth = 1512;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 0,
          content: SingleChildScrollView(
            child:
            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // frame5223yp9 (120:343)
                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 24*fem),
                    width: double.infinity,
                    height: 65*fem,
                    child: Row(
                      children: [
                        Center(
                          child: Container(
                            // frame22uC1 (90:3420)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 0*fem),
                            height: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    // color: Colors.pink,
                                    width: 1100,
                                    // residentdetailsq5f (90:3421)
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 10*fem),
                                    child:
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // Text('                                                                            '),
                                        Text(
                                          'Add Asset Details',
                                          style: GoogleFonts.openSans (
                                            fontSize: 24*ffem,
                                            fontWeight: FontWeight.w700,
                                            height: 1.3625*ffem/fem,
                                            color: const Color(0xff000000),
                                          ),
                                        ),
                                        SizedBox(width: 410,),
                                      //   here Icon

                                        Container(
                                          child: InkWell(
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
                                        ),



                                      ],
                                    ),


                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  Container(
                    // frame5171zgd (87:1710)
                    padding: EdgeInsets.fromLTRB(64*fem, 71*fem, 64*fem, 76*fem),
                    width: double.infinity,
                    decoration: BoxDecoration (
                      // border: Border.all(color: const Color(0x30262626)),
                      color: const Color(0xffffffff),
                      borderRadius: BorderRadius.circular(24*fem),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // frame5169JBX (87:1509)
                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 388*fem, 2*fem),
                          width: double.infinity,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  // addresidentdetailsvyb (87:1511)
                                  'Asset Photo',
                                  style: GoogleFonts.openSans (
                                    fontSize: 21*ffem,
                                    fontWeight: FontWeight.w700,
                                    height: 1.3625*ffem/fem,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Divider(color: Colors.grey.withOpacity(0.5), thickness: 0.7),
                        ),
                        SizedBox(height: 15,),
                        Container(
                          // frame5155DSu (87:1513)
                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 30.5*fem),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                // frame5126M3K (87:1514)
                                margin: EdgeInsets.fromLTRB(414*fem, 0*fem, 414*fem, 44*fem),
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      // frame51255zu (87:1515)
                                      margin: EdgeInsets.fromLTRB(10*fem, 0*fem, 10*fem, 19*fem),
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            // group39DrD (87:1516)
                                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 12*fem),
                                            padding: EdgeInsets.fromLTRB(25.67*fem, 25.67*fem, 25.67*fem, 25.67*fem),
                                            width: 160,
                                            decoration: BoxDecoration (
                                              border: Border.all(color: const Color(0x38262626)),
                                              color: const Color(0xffe5feff),
                                              borderRadius: BorderRadius.circular(100),
                                            ),
                                            child: Center(
                                              // imageuploadbro1gzh (87:1518)
                                              child: SizedBox(
                                                width: 124.67*fem,
                                                height: 124.67*fem,
                                                child:  Image.asset(
                                                  'assets/ui-design-/images/image-upload-bro-1.png',
                                                  fit: BoxFit.cover,
                                                )
                                              ),
                                            ),
                                          ),
                                          Container(
                                            // uploadresidentphoto150px150pxn (87:1519)
                                            constraints: BoxConstraints (
                                              maxWidth: 155*fem,
                                            ),
                                            child: Text(
                                              'Upload Resident Photo\n( 150px * 150px)',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.openSans (
                                                fontSize: 14*ffem,
                                                fontWeight: FontWeight.w600,
                                                height: 1.3625*ffem/fem,
                                                color: const Color(0x7f262626),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: (){
                                        // addImage();
                                      },
                                      child: Container(
                                        // frame5116sZP (87:1520)
                                        padding: EdgeInsets.fromLTRB(24*fem, 16*fem, 24*fem, 16*fem),
                                        width: double.infinity,
                                        decoration: BoxDecoration (
                                          border: Border.all(color: const Color(0xff37d1d3)),
                                          borderRadius: BorderRadius.circular(152*fem),
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              // chooseimagebVP (87:1521)
                                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 12*fem, 0*fem),
                                              child: Text(
                                                'Choose Image',
                                                style: GoogleFonts.openSans (
                                                  fontSize: 16*ffem,
                                                  fontWeight: FontWeight.w700,
                                                  height: 1.3625*ffem/fem,
                                                  color: const Color(0xff37d1d3),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              // photogalleryKAV (87:1522)
                                              width: 24*fem,
                                              height: 24*fem,
                                              child: Image.asset(
                                                'assets/ui-design-/images/photo-gallery.png',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // CustomTextField(header:)
                                  ],
                                ),
                              ),
                              // Assets Details (Heading)
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Container(
                                  width: double.infinity,
                                  child: Text(
                                    'Assets Details',
                                    style: GoogleFonts.openSans (
                                      fontSize: 20*ffem,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xff000000),
                                    ),
                                  ),
                                ),
                              ),
                            //   divider
                              Padding(
                                padding: const EdgeInsets.only(left: 5, right: 5),
                                child: Divider(color: Colors.grey.withOpacity(0.5), thickness: 0.7),
                              ),
                              SizedBox(height: 10,),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 18,),
                            CustomTextField(header: "Asset Name",hint: "Enter the Asset name",controller: AssetName,validator: null,),



                            const SizedBox(width: 18,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  child: Text(
                    '',
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff262626),
                    ),
                  ),
                ),
              ),
              // noamrl date one
              Padding(
                padding: EdgeInsets.only(),
                child: Container(
                  width: 220,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Color(0x7f262626)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0, right: 0),
                    child: TextFormField(
                      onTap: () {
                      },
                      cursorColor: Constants().primaryAppColor,
                      controller: DateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                          onPressed: () {
                            _selectDate(context);

                          },
                          icon: Icon(Icons.calendar_month),
                        ),
                        border: InputBorder.none,
                        hintText: "Date", // Default hint
                        hintStyle: GoogleFonts.openSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0x7f262626),
                        ),
                      ),
                      style: GoogleFonts.openSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 18,),
                            CustomTextField(header: "Approximate Vale",hint: "Enter the Amount",controller: ApproximateVal,validator: null,),
                            const SizedBox(width: 18,),
                            CustomTextField(header: "Verifier",hint: "Enter Gender",controller: gender,validator: null,),
                          ],
                        ),
                        SizedBox(height: 20,),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 18,),
                            // CustomTextField(header: "AMC Date",hint: "Enter middle name",controller: amcDateController,validator: null,),
                            //
                            // AMC
                            Padding(
                              padding: EdgeInsets.only(),
                              child: Container(
                                width: 220,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: Color(0x7f262626)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 0.0, right: 0),
                                  child: TextFormField(
                                    onTap: () {
                                    },
                                    cursorColor: Constants().primaryAppColor,
                                    controller: amcDateController,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      prefixIcon: IconButton(
                                        onPressed: () {
                                          _amcDate(context);
                                          print(_selectedAmcDate);
                                        },
                                        icon: Icon(Icons.calendar_month),
                                      ),
                                      border: InputBorder.none,
                                      hintText: "Date", // Default hint
                                      hintStyle: GoogleFonts.openSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0x7f262626),
                                      ),
                                    ),
                                    style: GoogleFonts.openSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: 18,),
                            // Insurance
                            Padding(
                              padding: EdgeInsets.only(),
                              child: Container(
                                width: 220,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: Color(0x7f262626)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 0.0, right: 0),
                                  child: TextFormField(
                                    onTap: () {
                                    },
                                    cursorColor: Constants().primaryAppColor,
                                    controller: insuranceDateController,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      prefixIcon: IconButton(
                                        onPressed: () {
                                          _insuranceDate(context);
                                          print(_selectedInsuranceDate);
                                        },
                                        icon: Icon(Icons.calendar_month),
                                      ),
                                      border: InputBorder.none,
                                      hintText: "Date", // Default hint
                                      hintStyle: GoogleFonts.openSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0x7f262626),
                                      ),
                                    ),
                                    style: GoogleFonts.openSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Divider(color: Colors.grey.withOpacity(0.5), thickness: 0.7),
                        ),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Icon(Icons.arrow_back_ios, color: Color(0xff37D1D3)),
                              InkWell(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                  child: Text('Back', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: Color(0xff37D1D3)),))
                            ],),


                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 120,
                                  height: 42,
                                  child: ElevatedButton(
                                    style: const ButtonStyle(
                                        elevation: MaterialStatePropertyAll(0),
                                        backgroundColor: MaterialStatePropertyAll(Color(0xfff5f6f7))),
                                    onPressed: (){
                                    }, child:
                                  Text(
                                    'Cancle',
                                    style: GoogleFonts.openSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xff37D1D3),
                                    ),
                                  ),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    style: const ButtonStyle(
                                        elevation: MaterialStatePropertyAll(3),
                                        backgroundColor: MaterialStatePropertyAll(Color(0xff37D1D3))
                                    ),
                                    onPressed: () {
                                    },
                                    child: Row(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Add',
                                              style: GoogleFonts.openSans(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(width: 8,),
                                            SizedBox(
                                                height: 20, width: 20,
                                                child: Image.asset('assets/ui-design-/images/Uninstalling Updates.png'))
                                          ],
                                        ),
                                        const SizedBox(width: 8),

                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),


                          ],
                        )
                      ],
                    ),
                  )
                ]
            ),
          ),
         );
      },
    );
  }











// create a assets
  final CollectionReference assetsCollection =
  FirebaseFirestore.instance.collection('assets');
  Future<void> addAsset() async {
    try {
      await assetsCollection.add({
        'Assetname': AssetName.text,
        'Date': DateController.text,
        'Amount': int.parse(ApproximateVal.text),
        'Verifier': gender.text,
        'amcdate': amcDateController.text,
        'insurancedate': insuranceDateController.text,
      });
      // Clear TextFields after adding asset
      AssetName.clear();
      DateController.clear();
      ApproximateVal.clear();
      gender.clear();
      amcDateController.clear();
      insuranceDateController.clear();
    } catch (e) {
      print("Error adding asset: $e");
    }
  }

}




import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:animate_do/animate_do.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_ikia/widgets/ReusableHeader.dart';
import 'package:hms_ikia/widgets/customtextfield.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Constants/constants.dart';
import '../widgets/kText.dart';

class AssetManagement extends StatefulWidget {
  const AssetManagement({super.key});

  @override
  State<AssetManagement> createState() => _AssetManagementState();
}

class _AssetManagementState extends State<AssetManagement> {

  int total = 0;
  int goodOne = 0;
  int damaged = 0;
  int waitingforAMC = 0;

  var todayDate = "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";

  List<String> AssetNames = [];
  String selectedAssetName = "Select Name";
  List<String> filters=["All","Good one","Damaged", "waiting for AMC"];
  String selectedFilter="All";
  late bool filterStatus;

  // residentname
  TextEditingController AssetsNameSearch = new TextEditingController();
  TextEditingController AssetName = new TextEditingController();
  // Date
  TextEditingController DateController = new TextEditingController();
  TextEditingController ApproximateVal = new TextEditingController();
  TextEditingController verifierController = new TextEditingController();
  TextEditingController amcDateController = new TextEditingController();
  TextEditingController insuranceDateController = new TextEditingController();
  TextEditingController quantityController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();
  TextEditingController location = new TextEditingController();

  File? Url;
  var Uploaddocument;
  String imgUrl = "";

  File? pUrl;
  var UploadPdfDocument;
  String pdfUrl = "";

  addImage() {
    InputElement input = FileUploadInputElement() as InputElement
      ..accept = 'image/*';
    input.click();
    input.onChange.listen((event) {
      final file = input.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) async {
        setState(() {
          Url = file;
          Uploaddocument = reader.result;
          imgUrl = "";
        });
        imageupload();
      });
    });
  }

  imageupload() async {
    var snapshot = await FirebaseStorage.instance.ref().child('Images').child(
        "${Url!.name}").putBlob(Url);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      imgUrl = downloadUrl;
    });
  }


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
        DateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }
  // for Insurance date
  Future<void> _insuranceDate(BuildContext context) async{
    final DateTime ? picked = await showDatePicker(context: context, firstDate: DateTime.now(), lastDate:  DateTime(2040));
    if(picked != null){
      print(picked);
      setState(() {
        _selectedInsuranceDate = picked;
        insuranceDateController.text = DateFormat('dd-MM-yyyy').format(picked);
        print('Insurance date: $_selectedInsuranceDate');
      });
    }
  }
  Future<void> _amcDate(BuildContext context) async{
    final DateTime ? picked = await showDatePicker(context: context, firstDate: DateTime.now(), lastDate:  DateTime(2040));
    if(picked != null){
      setState(() {
        _selectedAmcDate = picked;
        amcDateController.text = DateFormat('dd-MM-yyyy').format(picked);
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
    '10%',
    '20%',
    '40%',
    '60%',
    '80%',
  ];

  List<String> repairable = [
'Yes', 'No'
  ];

  List<String> damageby = [
    'Manufacturing Defect',
    'Fire',
    'others'
  ];

  String? selectedAssetsCategory;
  String? selectedDamageLevel;
  String? selectedProduct;
  String? selectedRepairable;
  String? selectedDamagedby;

  @override
  void initState() {
    getAssetNames();
    getTotalAssets();
    damagedCount();
    goodOneCount();
    calculateAMCDateLength();
    getAMCDateLength();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    switch (selectedFilter) {
      case "Good one":
        filterStatus = false;
        break;
      case "Damaged":
        filterStatus = true;
        break;
      default:
        filterStatus = false;
        break;
    }


    return FadeInRight(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image.asset("assets/assetui.png"),
              const ReusableHeader(Headertext: 'Asset Management ',
                  SubHeadingtext: '"Manage Easily Your Assets"'),
              const SizedBox(height: 10,),
              Container(
                height: 90,
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
                      child: CustomTextField(hint: 'Search Assets...',
                        controller: AssetsNameSearch,
                        validator: null,
                        onChanged: (value) {
                          setState(() {

                          }
                          );
                        },
                        fillColor: const Color(0xffF5F5F5),
                        header: '',
                        width: 365,
                        preffixIcon: Icons.search,
                        height: 45,),
                    ),

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
                                  AssetName.clear();
                                  DateController.clear();
                                  ApproximateVal.clear();
                                  verifierController.clear();
                                  amcDateController.clear();
                                  insuranceDateController.clear();
                                  quantityController.clear();
                                  locationController.clear();
                                  addAssetPopUp(context);
                                }, child:
                            Row(
                              children: [
                                const KText(text:'Add Assets',
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
                                  setState(() {
                                    String? selectedAssetsCategory;
                                    String? selectedDamageLevel;
                                    String? selectedProduct;
                                    String? selectedRepairable;
                                    String? selectedDamagedby;
                                  });
                                  AssetDamagePopUp();

                                }, child:
                            const Row(
                              children: [
                                KText(text:'Report Damage',
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
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xfff5f5f5),
                  border: Border.all(
                      color: const Color(0xff262626).withOpacity(0.10)),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 21),
                  child: Row(children: [
                    Center(
                      child: Container(
                        // color: Colors.blue,
                        height: 250,
                        width: 1075,
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
                                  KText(text:'Total', style: GoogleFonts.openSans(
                                      color: const Color(0xff262626).withOpacity(
                                          0.8),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 19)),
                                  KText(text:total.toString().padLeft(3,"0"), style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 19),)
                                ],),
                            ),
                            Container(
                              decoration: const BoxDecoration(color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10))),
                              width: 260,
                              height: 75,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  KText(text:'Assets in good condition', style: GoogleFonts.openSans(
                                      color: const Color(0xff262626).withOpacity(
                                          0.8),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 19)),
                                  KText(text:goodOne.toString().padLeft(3,"0"),style: GoogleFonts.openSans(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 19,
                                      color: const Color(0xff37D1D3)),)
                                ],),
                            ),
                            Container(
                              decoration: const BoxDecoration(color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10))),
                              width: 200,
                              height: 75,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  KText(text:'Waiting for AMC', style: GoogleFonts.openSans(
                                      color: const Color(0xff262626).withOpacity(
                                          0.8),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 19)),
                                  KText(text:waitingforAMC.toString(), style: GoogleFonts.openSans(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 19,
                                      color: const Color(0xffFD7E50)),)
                                ],),
                            ),
                            Container(
                              decoration: const BoxDecoration(color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10))),
                              width: 200,
                              height: 75,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  KText(text:'Damaged', style: GoogleFonts.openSans(
                                      color: const Color(0xff262626).withOpacity(
                                          0.8),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 19)),
                                  KText(text:damaged.toString().padLeft(3,"0"), style: GoogleFonts.openSans(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 19,
                                      color: const Color(0xffF12D2D)),)
                                ],),
                            ),
                          ],),
                          const SizedBox(height: 10,),
                        ],),
                      ),
                    ),
                  ],),
                ),


              ),
              const SizedBox(height: 18,),
              /// 3rd Container
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text('Assets Records', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, color: Colors.black, fontSize: 17),),
                 /// dropdown
                 Padding(
                   padding: const EdgeInsets.only(top: 8.0),
                   child: Container(
                     width: 220,
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
                             'Filter', style:
                           GoogleFonts.openSans (
                             fontSize: 12,
                             fontWeight: FontWeight.w600,
                             color: const Color(0x7f262626),
                           ),
                           ),
                           items: filters
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
                           selectedFilter,
                           onChanged:
                               (String? value) {
                             setState(() {
                               selectedFilter =
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
               ],
             ),
              const SizedBox(height: 20,),
              Column(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18, right: 10),
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(color: const Color(0xff262626).withOpacity(0.10)), borderRadius: BorderRadius.circular(30) ),
                    child: SizedBox(
                      height: 40,
                      child:
                      Row(
                        children: [
                          Container(
                              width: 100,
                              child: Center(child: KText(text:'S.No', style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w700),))
                          ),

                          Container(
                              width: 130,

                              child: Center(child: KText(text:'Date', style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w700),))
                          ),

                          Container(
                              width: 130,

                              child: Center(child: KText(text:'AMC Date', style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w700),))
                          ),

                          Container(
                              width: 160,

                              child: Center(child: KText(text:'Assets', style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w700),))
                          ),



                          Container(
                              width: 160,

                              child: Center(child: KText(text:'Approximate Value', style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w700),))
                          ),

                          Container(
                              width: 160,

                              child: Center(child: KText(text:'Note', style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w700),))
                          ),

                          Container(
                              width: 200,

                              child: Center(child: KText(text:'Actions', style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w700),))
                          ),



                        ],
                      ),
                    ),
                  ),
                ),
              ],),



              StreamBuilder(  stream: selectedFilter == "All"
                  ? FirebaseFirestore.instance.collection('Assets').snapshots() :
              selectedFilter == "waiting for AMC" ? FirebaseFirestore.instance.collection('Assets').where('amcDate', isLessThan: todayDate).snapshots()
                  : FirebaseFirestore.instance.collection('Assets').where('isReport', isEqualTo:filterStatus ).snapshots(),
                builder: (context, snapshot) {
                if(snapshot.hasData){
                  // this is matched one with the search
                  List<DocumentSnapshot> matchedData = [];
                  // this is remaining one
                  List<DocumentSnapshot> remainingData = [];
                  if (AssetsNameSearch.text.isNotEmpty) {
                    snapshot.data!.docs.forEach((doc) {
                      final name = doc["assetName"]
                          .toString()
                          .toLowerCase();
                      final verifier = doc["verifier"]
                          .toString()
                          .toLowerCase();
                      final searchText = AssetsNameSearch.text
                          .toLowerCase();
                      if (name.contains(searchText)
                          ||
                          verifier.contains(searchText)) {
                        matchedData.add(doc);
                      } else {
                        remainingData.add(doc);
                      }
                    });
                    matchedData.sort((a, b) {
                      final nameA = a["assetName"]
                          .toString()
                          .toLowerCase();
                      final nameB = b["assetName"]
                          .toString()
                          .toLowerCase();
                      final searchText = AssetsNameSearch.text
                          .toLowerCase();
                      return nameA.compareTo(nameB);
                    });
                  }
                  else {
                    // If search query is empty, display original data
                    remainingData = snapshot.data!.docs;
                  }
                  List<DocumentSnapshot> combinedData = [
                    ...matchedData,
                    ...remainingData
                  ];
                  return Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Container(
                      height: 1000,
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        itemBuilder:(context, index) {
                          int serialNumber = index + 1;
                          var data = combinedData[index];
                          return  Row(
                            children: [
                              Container(
                                  width: 100,
                                  child: Center(child: KText(text:serialNumber.toString(), style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w600),))
                              ),
                              Container(
                                  width: 130,
                                  child: Center(child: KText(text:data['purchasedDate'], style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w600),))
                              ),
                              Container(
                                  width: 130,
                                  child: Center(child: KText(text:data['amcDate'], style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w600),))
                              ),
                              Container(
                                  width: 160,
                                  child: Center(child: KText(text:data['assetName'], style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w600),))
                              ),

                              Container(
                                  width: 160,
                                  child: Center(child: KText(text:data['approxValue'].toString(), style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w600),))
                              ),
                              Container(
                                  width: 160,
                                  child: Center(child: KText(text:data['location'], style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w600),))
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Container(
                                    width: 200,
                                    child:
                                     Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ///for edit
                                     InkWell(
                                       onTap: () {
                                         print('Edit Button');
                                         setData(snapshot.data!.docs[index].id);
                                         updateAssetDetail(context, snapshot.data!.docs[index].id);
                                       },
                                       child: Container(
                                         decoration: BoxDecoration(
                                             color: const Color(0xffF5F5F5),
                                             borderRadius: BorderRadius.circular(30)),
                                         height: 30, width:30,
                                         child: const CircleAvatar(
                                             backgroundColor: Color(0xffF5F5F5),
                                             child: Padding(
                                           padding: EdgeInsets.all(4),
                                           child: Image(image: AssetImage('assets/ui-design-/images/edit.png'),),
                                         )),
                                       ),
                                     ),
                                        const SizedBox(width: 10,),
                                        InkWell(
                                          onTap: (){
                                            AssetView( context, snapshot.data!
                                                .docs[index]);

                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: const Color(0xffF5F5F5),
                                                borderRadius: BorderRadius.circular(30)),
                                            height: 30, width:30,
                                            child: const CircleAvatar(
                                                backgroundColor: Color(0xffF5F5F5),
                                                child: Padding(
                                                  padding: EdgeInsets.all(4),
                                                  child: Image(image: AssetImage('assets/ui-design-/images/eye.png'),),
                                                )),
                                          ),
                                        ),
                                        const SizedBox(width: 10,),

                                        InkWell(
                                          onTap: (){
                                            ForDeleteDialog(
                                                context, snapshot.data!
                                                .docs[index].id);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: const Color(0xffF5F5F5),

                                                borderRadius: BorderRadius.circular(30)),
                                                                                 height: 30, width:30,
                                            child: const CircleAvatar(
                                              backgroundColor: Color(0xffF5F5F5),
                                                child: Padding(
                                                  padding: EdgeInsets.all(4),
                                                  child: Image(image: AssetImage('assets/ui-design-/images/delete-2Ds.png'),),
                                                )),
                                          ),
                                        ),
                                        const SizedBox(width: 10,),

                                    ],)
                                ),
                              ),



                            ],
                          );
                        },),
                    ),
                  );
                }else{
                  return const CircularProgressIndicator();
                }
              },)




            ],
          ),
        ),
      ),
    );
  }

  Future<void> AssetDamagePopUp() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
           builder: (context, setState) {
            return AlertDialog(
               elevation: 0,
               backgroundColor: const Color(0xffFFFFFF),
               title: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   KText(text:'Add Room', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
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
                               //  name
                               Padding(
                                 padding: const EdgeInsets.only(top: 20),
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     KText(text: 'Asset Name', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                                     Padding(
                                       padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                       child: Container(
                                         width: 220,
                                         height: 50,
                                         decoration: BoxDecoration(
                                           border: Border.all(color: const Color(0x7f262626)),
                                           borderRadius: BorderRadius.circular(30),
                                         ),
                                         child: Padding(
                                           padding: const EdgeInsets.only(left: 12.0, right: 10),
                                           child: DropdownButtonHideUnderline(
                                             child: DropdownButtonFormField<String>(
                                               isExpanded: true,
                                               hint: const KText(text:
                                               'Select Name',
                                                 style: TextStyle(
                                                   fontSize: 12,
                                                   fontWeight: FontWeight.w600,
                                                   color: Color(0x7f262626),
                                                 ),
                                               ),
                                               items: AssetNames.map((String item) {
                                                 return DropdownMenuItem<String>(
                                                   value: item,
                                                   child: KText(text:
                                                   item,
                                                     style: const TextStyle(
                                                       fontSize: 12,
                                                       fontWeight: FontWeight.w600,
                                                     ),
                                                   ),
                                                 );
                                               }).toList(),
                                               value: selectedAssetName,
                                               onChanged: (String? value) async {
                                                 setState(() {
                                                   selectedAssetName = value!;
                                                 });
                                                 var docu = await FirebaseFirestore.instance.collection('Assets').where('assetName', isEqualTo: selectedAssetName).get();
                                                 setState(() {
                                                   location.text = docu.docs[0]['location'];
                                                   // selectedResidentUserId = docu.docs[0]['userid'];
                                                   // selectedBlockName = docu.docs[0]['blockname'];
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
                         ),
                         // 2nd

                         Padding(
                           padding: const EdgeInsets.only(top: 30.0),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               KText(text: 'Location', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                               Padding(
                                 padding: const EdgeInsets.only(bottom: 10, top: 10),
                                 child: CustomTextField(
                                   hint: 'Location',
                                   readOrwrite: true,
                                   controller: location,
                                   fillColor: Colors.white,
                                   validator: null,
                                   header: '',
                                   width: 200,
                                   height: 45,
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
                               KText(text:'Select Damage Level', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
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
                                         hint: const KText(
                                           text: 'Select Category',
                                           style: TextStyle(
                                             fontSize: 12,
                                             fontWeight: FontWeight.w600,
                                             color: Colors.grey,
                                           ),
                                         ),
                                         items: damageLevel.map((String item) {
                                           return DropdownMenuItem<String>(
                                             value: item,
                                             child: KText(
                                               text: item,
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
                                 KText(text: 'Repairable', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
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
                                           hint: const KText(
                                             text:'Repairable',
                                             style: TextStyle(
                                               fontSize: 12,
                                               fontWeight: FontWeight.w600,
                                               color: Colors.grey,
                                             ),
                                           ),
                                           items: repairable.map((String item) {
                                             return DropdownMenuItem<String>(
                                               value: item,
                                               child: KText(
                                                 text: item,
                                                 style: const TextStyle(
                                                   color: Color(0x7f262626),
                                                   fontSize: 12,
                                                   fontWeight: FontWeight.w600,
                                                 ),
                                               ),
                                             );
                                           }).toList(),
                                           value: selectedRepairable,
                                           onChanged: (String? value) {
                                             setState(() {
                                               selectedRepairable = value!;
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
                                 KText(text: 'Damaged By', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
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
                                           hint: const KText(
                                             text: 'Select Level',
                                             style: TextStyle(
                                               fontSize: 12,
                                               fontWeight: FontWeight.w600,
                                               color: Colors.grey,
                                             ),
                                           ),
                                           items: damageby.map((String item) {
                                             return DropdownMenuItem<String>(
                                               value: item,
                                               child: KText(
                                                 text: item,
                                                 style: const TextStyle(
                                                   color: Color(0x7f262626),
                                                   fontSize: 12,
                                                   fontWeight: FontWeight.w600,
                                                 ),
                                               ),
                                             );
                                           }).toList(),
                                           value: selectedDamagedby,
                                           onChanged: (String? value) {
                                             setState(() {
                                               selectedDamagedby = value!;
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
                           KText(
                             text: 'Cancel',
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

             setState(() {
               // selectedDamagedby = 'Select Damage';
               // selectedRepairable = 'Repairable';
               // selectedAssetName = 'Select Name';
               // location.text = '';
               // selectedDamageLevel = '';
             }

                               );
                               reportAsset();
                               AssetAddedSuccessfully();
                             },
                             child: Row(
                               children: [
                                 Row(
                                   children: [
                                     KText(
                                       text: 'Report Damage',
                                       style: GoogleFonts.openSans(
                                         fontSize: 13,
                                         fontWeight: FontWeight.w600,
                                         color: Colors.white,
                                       ),
                                     ),
                                     const SizedBox(width: 8,),
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
      },
    );
  }
//   for adding assets
  Future<void> addAssetPopUp(BuildContext context) async {
    double baseWidth = 1512;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, set) {
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
                                            KText(
                                              text: 'Add Asset Details',
                                              style: GoogleFonts.openSans (
                                                fontSize: 24*ffem,
                                                fontWeight: FontWeight.w700,
                                                height: 1.3625*ffem/fem,
                                                color: const Color(0xff000000),
                                              ),
                                            ),
                                            const SizedBox(width: 410,),
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
                                    child: KText(
                                      // addresidentdetailsvyb (87:1511)
                                     text: 'Asset Photo',
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
                            const SizedBox(height: 15,),
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
                                                    child: Uploaddocument == null ? Image.asset(
                                                      'assets/ui-design-/images/image-upload-bro-1.png',
                                                      fit: BoxFit.cover,
                                                    ) : Image.memory(
                                                      Uint8List.fromList(
                                                        base64Decode(
                                                          Uploaddocument!.split(',')
                                                              .last,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                // uploadresidentphoto150px150pxn (87:1519)
                                                constraints: BoxConstraints (
                                                  maxWidth: 155*fem,
                                                ),
                                                child: KText(
                                                  text:'Upload Resident Photo\n( 150px * 150px)',
                                                  // textAlign: TextAlign.center,
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
                                          onTap: () {
                                            InputElement input = FileUploadInputElement() as InputElement
                                              ..accept = 'image/*';
                                            input.click();
                                            input.onChange.listen((event) {
                                              final file = input.files!.first;
                                              final reader = FileReader();
                                              reader.readAsDataUrl(file);
                                              reader.onLoadEnd.listen((event) async {
                                                set(() {
                                                  Url = file;
                                                  Uploaddocument = reader.result;
                                                  imgUrl = "";
                                                });
                                                // imageupload();
                                                var snapshot = await FirebaseStorage.instance.ref().child('Images').child(
                                                    "${Url!.name}").putBlob(Url);
                                                String downloadUrl = await snapshot.ref.getDownloadURL();
                                                set(() {
                                                  imgUrl = downloadUrl;
                                                });
                                              });
                                            });
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
                                                  child: KText(
                                                    text:'Choose Image',
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
                                      child: KText(
                                       text:'Assets Details',
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
                                  const SizedBox(height: 10,),
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
                    padding: const EdgeInsets.only(left: 10, bottom: 5),
                    child: Container(
                      child: KText(
                        text:'Purchased Date',
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff262626),
                        ),
                      ),
                    ),
                  ),
                  // noamrl date one
                  Padding(
                    padding: const EdgeInsets.only(),
                    child: Container(
                      width: 220,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: const Color(0x7f262626)),
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
                              icon: const Icon(Icons.calendar_month),
                            ),
                            border: InputBorder.none,
                            hintText: "Date", // Default hint
                            hintStyle: GoogleFonts.openSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0x7f262626),
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
                                CustomTextField(header: "Approximate Value",hint: "Enter the Amount",controller: ApproximateVal,validator: null,),
                                const SizedBox(width: 18,),
                                CustomTextField(header: "Verifier",hint: "Verifier Name",controller: verifierController,validator: null,),
                              ],
                            ),
                            const SizedBox(height: 20,),
                             Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 18,),
                                Padding(
                                  padding: const EdgeInsets.only(),
                                  child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('AMC Date',

                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xff262626),
                                        ),

                                      ),
                                      const SizedBox(height: 5,),

                                      Container(
                                        width: 220,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(30),
                                          border: Border.all(color: const Color(0x7f262626)),
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
                                                icon: const Icon(Icons.calendar_month),
                                              ),
                                              border: InputBorder.none,
                                              hintText: "Date", // Default hint
                                              hintStyle: GoogleFonts.openSans(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0x7f262626),
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
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 18,),
                                // Insurance
                                Padding(
                                  padding: const EdgeInsets.only(),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Insurance Date ( If Applicable ) ',

                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xff262626),
                                        ),


                                      ),
                                      const SizedBox(height: 5,),
                                      Container(
                                        width: 220,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(30),
                                          border: Border.all(color: const Color(0x7f262626)),
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
                                                icon: const Icon(Icons.calendar_month),
                                              ),
                                              border: InputBorder.none,
                                              hintText: "Date",

                                              hintStyle: GoogleFonts.openSans(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0x7f262626),
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
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 18,),

                                CustomTextField(header: "Quantity",hint: "Quantity...",controller: quantityController,validator: null,),
                                const SizedBox(width: 18,),

                                CustomTextField(header: "Location",hint: "Enter the Location",controller: locationController,validator: null,),
                                const SizedBox(width: 18,),



                              ],
                            ),




                            const SizedBox(height: 20,),
                            Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Divider(color: Colors.grey.withOpacity(0.5), thickness: 0.7),
                            ),

                            const SizedBox(height: 20,),

                            // Center(
                            //   child: InkWell(
                            //     onTap: () {
                            //       InputElement input = FileUploadInputElement() as InputElement
                            //         ..accept = 'image/*';
                            //       input.click();
                            //       input.onChange.listen((event) {
                            //         final file = input.files!.first;
                            //         final reader = FileReader();
                            //         reader.readAsDataUrl(file);
                            //         reader.onLoadEnd.listen((event) async {
                            //           set(() {
                            //             Url = file;
                            //             Uploaddocument = reader.result;
                            //             imgUrl = "";
                            //           });
                            //           // imageupload();
                            //           var snapshot = await FirebaseStorage.instance.ref().child('Images').child(
                            //               "${Url!.name}").putBlob(Url);
                            //           String downloadUrl = await snapshot.ref.getDownloadURL();
                            //           set(() {
                            //             imgUrl = downloadUrl;
                            //           });
                            //         });
                            //       });
                            //     },
                            //
                            //     child: Container(
                            //       // frame5116sZP (87:1520)
                            //       padding: EdgeInsets.fromLTRB(24*fem, 16*fem, 24*fem, 16*fem),
                            //       width: 250,
                            //       decoration: BoxDecoration (
                            //         border: Border.all(color: const Color(0xff37d1d3)),
                            //         borderRadius: BorderRadius.circular(152*fem),
                            //       ),
                            //       child: Row(
                            //
                            //         children: [
                            //           Container(
                            //             // chooseimagebVP (87:1521)
                            //             margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 12*fem, 0*fem),
                            //             child: KText(
                            //               text:'Upload Document',
                            //               style: GoogleFonts.openSans (
                            //                 fontSize: 16*ffem,
                            //                 fontWeight: FontWeight.w700,
                            //                 height: 1.3625*ffem/fem,
                            //                 color: const Color(0xff37d1d3),
                            //               ),
                            //             ),
                            //           ),
                            //           Container(
                            //             // photogalleryKAV (87:1522)
                            //             width: 24*fem,
                            //             height: 24*fem,
                            //             child: Image.asset(
                            //               'assets/ui-design-/images/photo-gallery.png',
                            //               fit: BoxFit.contain,
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // ),



                            Center(
                              child: InkWell(
                                onTap: () async {
                                  InputElement input = FileUploadInputElement() as InputElement
                                    ..accept = 'application/pdf'; // Specify accepted file types as PDF
                                  input.click();
                                  input.onChange.listen((event) async {
                                    final file = input.files!.first;
                                    print('File selected: ${file.name}');
                                    final reader = FileReader();
                                    reader.readAsDataUrl(file);
                                    reader.onLoadEnd.listen((event) async {
                                      set(() {
                                        pUrl = file;
                                        UploadPdfDocument = reader.result;
                                        pdfUrl = "";
                                      });
                                      // Upload the PDF file to Firebase Storage
                                      print('Uploading file...');
                                      var snapshot = await FirebaseStorage.instance.ref().child('Documents').child(
                                          file.name).putBlob(file);
                                      String downloadUrl = await snapshot.ref.getDownloadURL();
                                      print('Download URL: $downloadUrl');
                                      set(() {
                                        pdfUrl = downloadUrl;
                                      });
                                    });
                                  });
                                },

                                child: Container(
                                  padding: EdgeInsets.fromLTRB(24 * fem, 16 * fem, 24 * fem, 16 * fem),
                                  width: 250,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: const Color(0xff37d1d3)),
                                    borderRadius: BorderRadius.circular(152 * fem),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 12 * fem, 0 * fem),
                                        child: KText(
                                          text: 'Upload Document',
                                          style: GoogleFonts.openSans(
                                            fontSize: 16 * ffem,
                                            fontWeight: FontWeight.w700,
                                            height: 1.3625 * ffem / fem,
                                            color: const Color(0xff37d1d3),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 24 * fem,
                                        height: 24 * fem,
                                        child: Image.asset(
                                          'assets/ui-design-/images/photo-gallery.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),





                            const SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  const Icon(Icons.arrow_back_ios, color: Color(0xff37D1D3)),
                                  InkWell(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                      child: KText(text:'Back', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff37D1D3)),))
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
                                          Navigator.pop(context);
                                        }, child:
                                      KText(
                                        text:'Cancel',
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
                                          addAsset().then((value){
                                            AssetAddedSuccessfully();
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Row(
                                              children: [
                                                KText(
                                                  text: 'Add',
                                                  style: GoogleFonts.openSans(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(width: 8,),
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
          }
        );
      },
    );
  }
// create a assets
  final CollectionReference assetsCollection =
  FirebaseFirestore.instance.collection('Assets');
  Future<void> addAsset() async {
    try {
      await assetsCollection.add({
        'image' : imgUrl,
        'assetName': AssetName.text,
        'purchasedDate': DateController.text,
        'approxValue': int.parse(ApproximateVal.text),
        'verifier': verifierController.text,
        'amcDate': amcDateController.text,
        'insurancedate': insuranceDateController.text,
        'quantity': quantityController.text,
        'location': locationController.text,
        'pdfLink': pdfUrl,
        'isReport': false,
        'timestamp': DateTime.now().millisecondsSinceEpoch
      });
      // Clear TextFields after adding asset
      AssetName.clear();
      DateController.clear();
      ApproximateVal.clear();
      verifierController.clear();
      amcDateController.clear();
      insuranceDateController.clear();
      quantityController.clear();
      locationController.clear();
    } catch (e) {
      print("Error adding asset: $e");
    }
  }

  
  /// for edit 

  Future<void> updateAssetDetail(BuildContext context, id) async {
    double baseWidth = 1512;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (context, set) {
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
                                              KText(
                                                text: 'Update Asset Details',
                                                style: GoogleFonts.openSans (
                                                  fontSize: 24*ffem,
                                                  fontWeight: FontWeight.w700,
                                                  height: 1.3625*ffem/fem,
                                                  color: const Color(0xff000000),
                                                ),
                                              ),
                                              const SizedBox(width: 410,),
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
                                      child: KText(
                                        // addresidentdetailsvyb (87:1511)
                                        text: 'Asset Photo',
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
                              const SizedBox(height: 15,),
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
                                                      child: Uploaddocument == null ? Image.asset(
                                                        'assets/ui-design-/images/image-upload-bro-1.png',
                                                        fit: BoxFit.cover,
                                                      ) : Image.memory(
                                                        Uint8List.fromList(
                                                          base64Decode(
                                                            Uploaddocument!.split(',')
                                                                .last,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  // uploadresidentphoto150px150pxn (87:1519)
                                                  constraints: BoxConstraints (
                                                    maxWidth: 155*fem,
                                                  ),
                                                  child: KText(
                                                    text:'Upload Resident Photo\n( 150px * 150px)',
                                                    // textAlign: TextAlign.center,
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
                                            onTap: () {
                                              InputElement input = FileUploadInputElement() as InputElement
                                                ..accept = 'image/*';
                                              input.click();
                                              input.onChange.listen((event) {
                                                final file = input.files!.first;
                                                final reader = FileReader();
                                                reader.readAsDataUrl(file);
                                                reader.onLoadEnd.listen((event) async {
                                                  set(() {
                                                    Url = file;
                                                    Uploaddocument = reader.result;
                                                    imgUrl = "";
                                                  });
                                                  // imageupload();
                                                  var snapshot = await FirebaseStorage.instance.ref().child('Images').child(
                                                      "${Url!.name}").putBlob(Url);
                                                  String downloadUrl = await snapshot.ref.getDownloadURL();
                                                  set(() {
                                                    imgUrl = downloadUrl;
                                                  });
                                                });
                                              });
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
                                                    child: KText(
                                                      text:'Choose Image',
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
                                        child: KText(
                                          text:'Assets Details',
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
                                    const SizedBox(height: 10,),
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
                                        padding: const EdgeInsets.only(left: 10, bottom: 5),
                                        child: Container(
                                          child: KText(
                                            text:'Purchased Date',
                                            style: GoogleFonts.openSans(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xff262626),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // noamrl date one
                                      Padding(
                                        padding: const EdgeInsets.only(),
                                        child: Container(
                                          width: 220,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(30),
                                            border: Border.all(color: const Color(0x7f262626)),
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
                                                  icon: const Icon(Icons.calendar_month),
                                                ),
                                                border: InputBorder.none,
                                                hintText: "Date", // Default hint
                                                hintStyle: GoogleFonts.openSans(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(0x7f262626),
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
                                  CustomTextField(header: "Approximate Value",hint: "Enter the Amount",controller: ApproximateVal,validator: null,),
                                  const SizedBox(width: 18,),
                                  CustomTextField(header: "Verifier",hint: "Verifier Name",controller: verifierController,validator: null,),
                                ],
                              ),
                              const SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 18,),
                                  Padding(
                                    padding: const EdgeInsets.only(),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('AMC Date',

                                          style: GoogleFonts.openSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xff262626),
                                          ),

                                        ),
                                        const SizedBox(height: 5,),

                                        Container(
                                          width: 220,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(30),
                                            border: Border.all(color: const Color(0x7f262626)),
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
                                                  icon: const Icon(Icons.calendar_month),
                                                ),
                                                border: InputBorder.none,
                                                hintText: "Date", // Default hint
                                                hintStyle: GoogleFonts.openSans(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(0x7f262626),
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
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 18,),
                                  // Insurance
                                  Padding(
                                    padding: const EdgeInsets.only(),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Insurance Date ( If Applicable ) ',

                                          style: GoogleFonts.openSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xff262626),
                                          ),


                                        ),
                                        const SizedBox(height: 5,),
                                        Container(
                                          width: 220,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(30),
                                            border: Border.all(color: const Color(0x7f262626)),
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
                                                  icon: const Icon(Icons.calendar_month),
                                                ),
                                                border: InputBorder.none,
                                                hintText: "Date",

                                                hintStyle: GoogleFonts.openSans(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(0x7f262626),
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
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 18,),

                                  CustomTextField(header: "Quantity",hint: "Quantity...",controller: quantityController,validator: null,),
                                  const SizedBox(width: 18,),

                                  CustomTextField(header: "Location",hint: "Enter the Location",controller: locationController,validator: null,),
                                  const SizedBox(width: 18,),



                                ],
                              ),




                              const SizedBox(height: 20,),
                              Padding(
                                padding: const EdgeInsets.only(left: 5, right: 5),
                                child: Divider(color: Colors.grey.withOpacity(0.5), thickness: 0.7),
                              ),

                              const SizedBox(height: 20,),

                              // Center(
                              //   child: InkWell(
                              //     onTap: () {
                              //       InputElement input = FileUploadInputElement() as InputElement
                              //         ..accept = 'image/*';
                              //       input.click();
                              //       input.onChange.listen((event) {
                              //         final file = input.files!.first;
                              //         final reader = FileReader();
                              //         reader.readAsDataUrl(file);
                              //         reader.onLoadEnd.listen((event) async {
                              //           set(() {
                              //             Url = file;
                              //             Uploaddocument = reader.result;
                              //             imgUrl = "";
                              //           });
                              //           // imageupload();
                              //           var snapshot = await FirebaseStorage.instance.ref().child('Images').child(
                              //               "${Url!.name}").putBlob(Url);
                              //           String downloadUrl = await snapshot.ref.getDownloadURL();
                              //           set(() {
                              //             imgUrl = downloadUrl;
                              //           });
                              //         });
                              //       });
                              //     },
                              //
                              //     child: Container(
                              //       // frame5116sZP (87:1520)
                              //       padding: EdgeInsets.fromLTRB(24*fem, 16*fem, 24*fem, 16*fem),
                              //       width: 250,
                              //       decoration: BoxDecoration (
                              //         border: Border.all(color: const Color(0xff37d1d3)),
                              //         borderRadius: BorderRadius.circular(152*fem),
                              //       ),
                              //       child: Row(
                              //
                              //         children: [
                              //           Container(
                              //             // chooseimagebVP (87:1521)
                              //             margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 12*fem, 0*fem),
                              //             child: KText(
                              //               text:'Upload Document',
                              //               style: GoogleFonts.openSans (
                              //                 fontSize: 16*ffem,
                              //                 fontWeight: FontWeight.w700,
                              //                 height: 1.3625*ffem/fem,
                              //                 color: const Color(0xff37d1d3),
                              //               ),
                              //             ),
                              //           ),
                              //           Container(
                              //             // photogalleryKAV (87:1522)
                              //             width: 24*fem,
                              //             height: 24*fem,
                              //             child: Image.asset(
                              //               'assets/ui-design-/images/photo-gallery.png',
                              //               fit: BoxFit.contain,
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),



                              Center(
                                child: InkWell(
                                  onTap: () async {
                                    InputElement input = FileUploadInputElement() as InputElement
                                      ..accept = 'application/pdf'; // Specify accepted file types as PDF
                                    input.click();
                                    input.onChange.listen((event) async {
                                      final file = input.files!.first;
                                      print('File selected: ${file.name}');
                                      final reader = FileReader();
                                      reader.readAsDataUrl(file);
                                      reader.onLoadEnd.listen((event) async {
                                        set(() {
                                          pUrl = file;
                                          UploadPdfDocument = reader.result;
                                          pdfUrl = "";
                                        });
                                        // Upload the PDF file to Firebase Storage
                                        print('Uploading file...');
                                        var snapshot = await FirebaseStorage.instance.ref().child('Documents').child(
                                            file.name).putBlob(file);
                                        String downloadUrl = await snapshot.ref.getDownloadURL();
                                        print('Download URL: $downloadUrl');
                                        set(() {
                                          pdfUrl = downloadUrl;
                                        });
                                      });
                                    });
                                  },

                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(24 * fem, 16 * fem, 24 * fem, 16 * fem),
                                    width: 250,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0xff37d1d3)),
                                      borderRadius: BorderRadius.circular(152 * fem),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 12 * fem, 0 * fem),
                                          child: KText(
                                            text: 'Upload Document',
                                            style: GoogleFonts.openSans(
                                              fontSize: 16 * ffem,
                                              fontWeight: FontWeight.w700,
                                              height: 1.3625 * ffem / fem,
                                              color: const Color(0xff37d1d3),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 24 * fem,
                                          height: 24 * fem,
                                          child: Image.asset(
                                            'assets/ui-design-/images/photo-gallery.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),





                              const SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    const Icon(Icons.arrow_back_ios, color: Color(0xff37D1D3)),
                                    InkWell(
                                        onTap: (){
                                          Navigator.pop(context);
                                        },
                                        child: KText(text:'Back', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff37D1D3)),))
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
                                            Navigator.pop(context);
                                          }, child:
                                        KText(
                                          text:'Cancel',
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

                                            updateAssets(id);
                                            AssetAddedSuccessfully();
                                            // Navigator.pop(context);
                                          },
                                          child: Row(
                                            children: [
                                              Row(
                                                children: [
                                                  KText(
                                                    text: 'Add',
                                                    style: GoogleFonts.openSans(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8,),
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
            }
        );
      },
    );
  }
  setData(id) async {
    var docu = await FirebaseFirestore.instance.collection('Assets').doc(id).get();
    Map<String, dynamic>? val = docu.data();

    print("Retrieved data from Firestore: $val");

    setState(() {
      AssetName.text = val!["assetName"];
      DateController.text = val!["purchasedDate"];
      ApproximateVal.text = val!["approxValue"].toString();
      verifierController.text = val!["verifier"];
      amcDateController.text = val!["amcDate"];
      insuranceDateController.text = val!["insurancedate"]; // Corrected typo in key
      quantityController.text = val!["quantity"];
      locationController.text = val!["location"];
      imgUrl = val!['image'];
      pdfUrl = val!['pdfLink'];
    });

    print("Set data to text controllers successfully");
  }
  updateAssets(id){
    FirebaseFirestore.instance.collection('Assets').doc(id).update({
      "assetName" : AssetName.text,
      "purchasedDate" : DateController.text,
      "approxValue" : ApproximateVal.text,
      "verifier" : verifierController.text,
      "amcDate" : amcDateController.text,
      "insurancedate" : insuranceDateController.text,
      "quantity" : quantityController.text,
      "location" : locationController.text
    });
    // Successdialog();

  }

  /// view

  Future<void> AssetView(BuildContext con, DocumentSnapshot data) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: const Color(0xffFFFFFF),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
            height: 550,
            child: Column(

              children: [

                CircleAvatar(
                  backgroundColor: const Color(
                      0xffF5F6F7),
                  radius: 62,
                  backgroundImage: data['image'] !=
                      null
                      ? NetworkImage(
                    data['image']!,
                  )
                      :  const NetworkImage(''), // Use Placeholder widget if imageUrl is null
                ),

                const SizedBox(height: 20,),

                Text('Details Of Asset', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 17),),
                const SizedBox(height: 10,),
                Divider(color: const Color(0xff262626).withOpacity(0.1), thickness: 1, height: 0.5),
                const SizedBox(height: 10,),

                Row(
                  children: [
                    Container(
                        width: 150,
                        child: KText(text:'Asset Name', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, color: Colors.black, fontSize: 15),)),
                    Container(
                        width: 70,
                        child: Center(child: Text(':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
                    Container(

                        width: 150,
                        child: KText(text:'${data['assetName']}',style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)),
                  ],
                ),
                const SizedBox(height: 5,),
                Row(
                  children: [
                    Container(
                        width: 150,
                        child: KText(text:'Document', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, color: Colors.black, fontSize: 15),)),
                    Container(
                        width: 70,
                        child: Center(child: Text(':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),

                    InkWell(
                      onTap: (){
                        data['pdfLink'] != '' ?  _launchURL(data['pdfLink']) : ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('PDF link is empty'),
                          ),
                        );
                      },
                      child: Container(
                          width: 150,
                          child:
                         Container(
                           height: 30,
                           width: 120,
                           decoration: BoxDecoration (
                             border: Border.all(color: const Color(0xff37D1D3)),
                             color:  Colors.white,
                             borderRadius: BorderRadius.circular(100),
                           ),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             children: [
                             Text('Download', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff37D1D3)),),
                             const Icon(Icons.download, color: Color(0xff37D1D3), size: 22,)
                           ],),
                         )

                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5,),
                Row(
                  children: [
                    Container(
                        width: 150,
                        child: KText(text:'Purchased Date', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, color: Colors.black, fontSize: 15),)),
                    Container(
                        width: 70,
                        child: Center(child: Text(':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
                    Container(

                        width: 150,
                        child: KText(text:'${data['purchasedDate']}',style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)),
                  ],
                ),
                const SizedBox(height: 5,),
                Row(
                  children: [
                    Container(
                        width: 150,
                        child: KText(text:'AMC Date', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, color: Colors.black, fontSize: 15),)),
                    Container(
                        width: 70,
                        child: Center(child: Text(':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
                    Container(

                        width: 150,
                        child: KText(text:'${data['amcDate']}',style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)),
                  ],
                ),
                const SizedBox(height: 5,),
                Row(
                  children: [
                    Container(
                        width: 150,
                        child: KText(text:'Insurance Date', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, color: Colors.black, fontSize: 15),)),
                    Container(
                        width: 70,
                        child: Center(child: Text(':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
                    Container(

                        width: 150,
                        child: KText(text:'${data['insurancedate']}',style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)),
                  ],
                ),
                const SizedBox(height: 5,),
                Row(
                  children: [
                    Container(
                        width: 150,
                        child: KText(text:'Verifier', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, color: Colors.black, fontSize: 15),)),
                    Container(
                        width: 70,
                        child: Center(child: Text(':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
                    Container(

                        width: 150,
                        child: KText(text:'${data['verifier']}',style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)),
                  ],
                ),
                const SizedBox(height: 5,),
                Row(
                  children: [
                    Container(
                        width: 150,
                        child: KText(text:'Report', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, color: Colors.black, fontSize: 15),)),
                    Container(
                        width: 70,
                        child: Center(child: Text(':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
                    Container(

                        width: 150,
                        child: KText(text:'${data['isReport'] == true ? 'Issue' : ' Perfect'}',style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: data['isReport'] == true ? Colors.red : Colors.green),)),
                  ],
                ),
                const SizedBox(height: 5,),
                Row(
                  children: [
                    Container(
                        width: 150,
                        child: KText(text:'Quantity', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, color: Colors.black, fontSize: 15),)),
                    Container(
                        width: 70,
                        child: Center(child: Text(':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
                    Container(

                        width: 150,
                        child: KText(text:'${data['quantity']}',style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)),
                  ],
                ),
                const SizedBox(height: 5,),
                Row(
                  children: [
                    Container(
                        width: 150,
                        child: KText(text:'Location', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, color: Colors.black, fontSize: 15),)),
                    Container(
                        width: 70,
                        child: Center(child: Text(':', style: GoogleFonts.openSans(fontWeight: FontWeight.w600),))),
                    Container(

                        width: 150,
                        child: KText(text:'${data['location']}',style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: const Color(0xff262626).withOpacity(0.8)),)),
                  ],
                ),
                const SizedBox(height: 5,),
              ],
            ),
          ),
        );
      },
    );



  }
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  /// delete
  deleteUserData(id) async {
    await FirebaseFirestore.instance.collection("Assets").doc(id).delete();
  }

  Future<void> ForDeleteDialog(BuildContext con, id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            contentPadding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
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
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const CircleAvatar(
                              backgroundColor: Color(0xffF5F6F7),
                              radius: 20,
                              child: Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(
                                  Icons.close, color: Colors.grey, size: 18,),
                              ),),
                          )
                        ],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 130,
                            width: 130,
                            child: Image.asset(
                                'assets/ui-design-/images/DeleteL.png'),
                          ),
                          SizedBox(
                            height: 150,
                            width: 150,
                            child: Image.asset(
                                'assets/ui-design-/images/deleteCenter.png'),
                          ),
                          SizedBox(
                            height: 130,
                            width: 130,
                            child: Image.asset(
                                'assets/ui-design-/images/DeleteR.png'),
                          ),
                        ],),
                      Padding(
                        padding: const EdgeInsets.only(left: 40, right: 20),
                        child: KText(
                          text: 'Are you sure you want to delete this asset record?',
                          style: GoogleFonts.openSans(fontWeight: FontWeight
                              .w600, fontSize: 17),),
                      ),
                      KText(text: 'Once deleted, it cannot be recovered.',
                        style: GoogleFonts.openSans(
                            fontWeight: FontWeight.w600, fontSize: 17),),
                      const SizedBox(height: 25,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 130,
                            height: 42,

                            child: ElevatedButton(
                                style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Color(0xffF5F5F5))),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: KText(text: 'Cancel',
                                  style: GoogleFonts.openSans(fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xff262626)
                                          .withOpacity(0.8)),)),
                          ),
                          const SizedBox(width: 20,),
                          Container(
                            width: 130,
                            height: 42,
                            child: ElevatedButton(
                                style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Color(0xffF12D2D))),
                                onPressed: () async {
                                  deleteUserData(id);
                                  Navigator.pop(context);
                                  DeletedSuccesfullyDialog();
                                }, child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                KText(text: 'Delete',
                                    style: GoogleFonts.openSans(fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xffFFFFFF))),
                                const Icon(Icons.delete, size: 18,
                                  color: Color(0xffFFFFFF),)
                              ],
                            )),
                          ),
                        ],)
                    ],),
                ),
              ),
            )
        );
      },
    );
  }

  DeletedSuccesfullyDialog() {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return AwesomeDialog(
      width: width / 3.035555555555556,
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Asset Deleted Successfully',
      btnOkOnPress: () {
        // Navigator.pop(context);
      },
    )
      ..show();
  }
  AssetAddedSuccessfully() {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return AwesomeDialog(
      width: width / 3.035555555555556,
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Asset Added Successfully',
      btnOkOnPress: () {
        Navigator.pop(context);
      },
    )
      ..show();
  }





  /// report here
 final CollectionReference reportCollection =
    FirebaseFirestore.instance.collection('Reports');
  Future<void> reportAsset() async {
    var querySnapshot = await FirebaseFirestore.instance.collection('Assets').where('assetName', isEqualTo: selectedAssetName).get();
    if (querySnapshot.docs.isNotEmpty) {
      var documentSnapshot = querySnapshot.docs.first;
      try {
        await reportCollection.add({
          'assetName': selectedAssetName,
          'location': location.text,
          'damageLevel': selectedDamageLevel,
          'repairable': selectedRepairable,
          'damageBy': selectedDamagedby,
          'timestamp': DateTime.now().millisecondsSinceEpoch
        });
        await documentSnapshot.reference.update({
          'isReport': true,
        });
        AssetAddedSuccessfully() {
          double width = MediaQuery
              .of(context)
              .size
              .width;
          return AwesomeDialog(
            width: width / 3.035555555555556,
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.rightSlide,
            title: 'Asset Added Successfully',
            btnOkOnPress: () {
              Navigator.pop(context);
            },
          )
            ..show();
        }

      } catch (e) {
        print("Error adding report:- $e");
      }
    } else {
      print("No document :-$selectedAssetName");
    }


  }
  Future<void> getAssetNames() async {
    try {
      List<String> assetNames = ['Select Name'];
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Assets').get();
      querySnapshot.docs.forEach((doc) {
        String assetName = doc['assetName'];
        if (assetName != "") {
          assetNames.add(assetName);
        }
      });
      setState(() {
        AssetNames.addAll(assetNames);
      });
      print(assetNames);
    } catch (e) {
      print("Error fetching names: $e");
    }
  }
  Future<void> getTotalAssets() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Assets').get();
      int length = querySnapshot.docs.length;
      setState(() {
        total = length;
      });
    } catch (e) {
      print("Error getting Assets length: $e");
    }
  }
  Future<void> goodOneCount() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Assets').where('isReport', isEqualTo: false).get();
      int length = querySnapshot.docs.length;
      setState(() {
        goodOne = length;
      });
    } catch (e) {
      print("Error getting Assets length: $e");
    }
  }
  Future<void> damagedCount() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Assets').where('isReport', isEqualTo: true).get();
      int length = querySnapshot.docs.length;
      setState(() {
        damaged = length;
      });
    } catch (e) {
      print("Error getting Assets length: $e");
    }
  }
  Future<int> calculateAMCDateLength() async {
    try {
      DateTime today = DateTime.now();
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Assets').get();
      int amcDateCount = 0;
      querySnapshot.docs.forEach((doc) {
        String amcDateString = doc['amcDate'];
        DateTime amcDate = DateFormat('dd-MM-yyyy').parse(amcDateString);
        if (amcDate.isBefore(today)) {
          amcDateCount++;
        }
      });
      return amcDateCount;
    } catch (e) {
      print("Error calculating AMC date length: $e");
      return 0;
    }
  }
  Future<void> getAMCDateLength() async {
    int amcLength = await calculateAMCDateLength();
    setState(() {
      waitingforAMC = amcLength;
    });
  }






}






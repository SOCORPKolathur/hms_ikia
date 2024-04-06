import 'dart:convert';
import 'dart:html';
import 'dart:math';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_ikia/Constants/constants.dart';
import 'package:hms_ikia/widgets/customtextfield.dart';
import 'package:hms_ikia/widgets/kText.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

class ResidentAddForm extends StatefulWidget {
  final Function(bool) updateDisplay;
  final bool displayFirstWidget;
  ResidentAddForm({required this.displayFirstWidget,required this.updateDisplay});

  @override
  State<ResidentAddForm> createState() => _ResidentAddFormState();
}

class _ResidentAddFormState extends State<ResidentAddForm> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _firstNameKey = GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _gender = GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _bloodgroup = GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>>  _dob = GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _phonenumber = GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _aadharnum = GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _email = GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _address = GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _city = GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _pincode = GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _parentname = GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _parentnum = GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _userid = GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _blockname = GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _roomnumber = GlobalKey<FormFieldState<String>>();


  bool _firstNameError = false;
  bool _genderError = false;
  bool _bloodgroupError = false;
  bool _dobError = false;
  bool _phonenumError = false;
  bool _aadharError = false;
  bool _emailError = false;
  bool _addressError = false;
  bool _cityError = false;
  bool _pincodeError = false;
  bool _parentnameError = false;
  bool _parentnumError = false;
  bool _useridError = false;


  // used this in Update page too
  TextEditingController firstName = new TextEditingController();
  TextEditingController middleName = new TextEditingController();
  TextEditingController lastName = new TextEditingController();
  TextEditingController dob = new TextEditingController();
  TextEditingController bloodgroup = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController mobile = new TextEditingController();
  TextEditingController aadhaar = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController country = new TextEditingController();
  TextEditingController state = new TextEditingController();
  TextEditingController city = new TextEditingController();
  TextEditingController pincode = new TextEditingController();
  TextEditingController parentname = new TextEditingController();
  TextEditingController parentmobile = new TextEditingController();
  TextEditingController parentOccupation = new TextEditingController();
  TextEditingController userid = new TextEditingController();
  // roomno
  TextEditingController roomnumber = new TextEditingController();
  // blockname
  TextEditingController blockname = new TextEditingController();
  // used this in Update page too
  List<String> prefix=["Select Prefix","Mr.","Ms.","Mrs"];
  String selectedprefix="Select Prefix";

  List<String> BlockNames = [];
  String selectedBlockName = "Select Block Name";

  // List<String> BlockNames = [];
  List<String> RoomNames= [];
  // blockname list here
  Future<List<String>> getBlockNames() async {
    try {
      List<String> blockNames = ['Select Block Name'];
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Block').get();
      querySnapshot.docs.forEach((doc) {
        String blockName = doc['blockname'];
        if (blockName != null) {
          blockNames.add(blockName);
        }
      });
      print(blockNames);
      return blockNames;
    } catch (e) {
      print("Error fetching block names: $e");
      return [];
    }
  }
  void getRoomNames(String selectedBlockName) async {
    setState(() {
      blockRoomNames = ['Select Room Name']; // Reset room names
    });
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Room')
          .where('blockname', isEqualTo: selectedBlockName)
          .get();
      // Iterate through the documents and extract data
      querySnapshot.docs.forEach((doc) {
        String roomName = doc['roomnumber'];
        if (roomName != null) {
          setState(() {
            blockRoomNames.add(roomName);
          });
        }
      });
      print(blockRoomNames);
    } catch (e) {
      print("Error fetching room names: $e");
    }
  }
  List<String> blockRoomNames = ['Select Room Name'];
  // String selectedBlockName = "Select Block Name";
  String selectedRoomName = "Select Room Name";
  // Room name
  List<String> gender=["Select Gender","Male","Female","Transgender"];
  // used this in Update page too
  // block
  // String selectedBlockName = "Select Block Name";
  // String selectedRoomName = "Select Room Name";
  String selectedprefix2="Select Prefix";
  String selectedgender="Select Gender";
  File? Url;
  var Uploaddocument;
  String imgUrl = "";
  // used this in Update page too

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
  // used this in Update page too
  imageupload() async {
    var snapshot = await FirebaseStorage.instance.ref().child('Images').child(
        "${Url!.name}").putBlob(Url);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      imgUrl = downloadUrl;
    });
  }

  @override
  void initState() {
    setState(() {
      country.text="India";
      state.text="Tamil Nadu";
      city.text="Chennai";
      // getBlockNames();
      getRoomNames(selectedBlockName);
      getBlockNames().then((names) {
        setState(() {
          BlockNames.addAll(names);
        });
      }
      );
    });
    getuserid();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double baseWidth = 1512;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // frame22uC1 (90:3420)
                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 699*fem, 0*fem),
                      height: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // residentdetailsq5f (90:3421)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 10*fem),
                            child: Text(
                              'RESIDENT DETAILS',
                              style: GoogleFonts.openSans (
                                fontSize: 24*ffem,
                                fontWeight: FontWeight.w700,
                                height: 1.3625*ffem/fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                          Text(
                            // effortlesslymanageyouruserswPb (90:3422)
                            '“Effortlessly manage your users”',
                            style: GoogleFonts.openSans (

                              fontSize: 16*ffem,
                              fontWeight: FontWeight.w600,
                              height: 1.3625*ffem/fem,
                              color: const Color(0xa5262626),
                            ),
                          ),

                        ],
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
                  border: Border.all(color: const Color(0x30262626)),
                  color: const Color(0xffffffff),
                  borderRadius: BorderRadius.circular(24*fem),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // frame5169JBX (87:1509)
                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 388*fem, 46*fem),
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: (){
                                widget.updateDisplay(!widget.displayFirstWidget);
                                print("Clicked");
                              },
                              child: Container(
                                // chevrondown1rd (87:1510)
                                  margin: EdgeInsets.fromLTRB(0*fem, 3*fem, 364*fem, 0*fem),
                                  width: 24*fem,
                                  height: 24*fem,
                                  child: const Icon(Icons.arrow_back_ios_new_rounded)
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 35.0),
                              child: Text(
                                'Add Resident Details',
                                style: GoogleFonts.openSans (
                                  fontSize: 24*ffem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.3625*ffem/fem,
                                  color: const Color(0xff000000),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                                              child: Uploaddocument==null? Image.asset(
                                                'assets/ui-design-/images/image-upload-bro-1.png',
                                                fit: BoxFit.cover,
                                              ) : Image.memory(
                                                Uint8List.fromList(
                                                  base64Decode(
                                                    Uploaddocument!.split(',').last,
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
                                      addImage();
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
                            Container(
                              width: double.infinity,
                              child: Text(
                                'Personal Details',
                                style: GoogleFonts.openSans (
                                  fontSize: 20*ffem,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xff000000),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                // firstnameSVK (87:1540)
                                child: Text(
                                  "Prefix",
                                  style: GoogleFonts.openSans (
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff262626),
                                  ),
                                ),
                              ),
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
                                      child: DropdownButtonFormField2<
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
                                        items: prefix
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
                                        selectedprefix,
                                        onChanged:
                                        //     (String? value) {
                                        //   setState(() {
                                        //     selectedprefix =
                                        //     value!;
                                        //   });
                                        // },

                                            (String? value){
                                          setState(() {
                                            selectedprefix = value!;
                                            if(selectedprefix == 'Mr.') {
                                              gender.remove('Female');


                                              if(selectedgender == 'Female'){
                                                selectedgender = 'Male';
                                              }
                                            } else {
                                              if(!gender.contains('Female')) {
                                                gender.add('Female');
                                              }
                                            }

                                            if(selectedprefix == 'Ms.' || selectedprefix == 'Mrs') {
                                              gender.remove('Male');

                                              if(selectedgender == 'Male'){
                                                selectedgender = 'Female';
                                              }
                                            } else {
                                              if(!gender.contains('Male')) {
                                                gender.add('Male');
                                              }
                                            }

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
                              )
                            ],
                          ),
                          const SizedBox(width: 18,),
                          //First Name
                          CustomTextField(
                            key: _firstNameKey,
                            header: "*First Name",
                            hint: "Enter first name",
                            controller: firstName,
                            onChanged: (value) {
                              setState(() {
                                _firstNameError = value.trim().isEmpty;
                              });
                            },
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return null;
                              }
                              return null;
                            },
                            showError: _firstNameError,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                            ],
                          ),

                          const SizedBox(width: 18,),
                          CustomTextField(header: "Middle Name",hint: "Enter middle name",controller: middleName,validator: null,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                            ],
                          ),
                          const SizedBox(width: 18,),
                          CustomTextField(header: "Last Name",hint: "Enter last name",controller: lastName,validator: null,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              // firstnameSVK (87:1540)
                              child: Text(
                                "Date of Birth",
                                style: GoogleFonts.openSans (
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff262626),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container(
                                width: 220 ,
                                height: 50,
                                decoration: BoxDecoration (
                  border: Border.all(color: const Color(0x7f262626)),
                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0,right: 6),
                  child: TextFormField(
                    cursorColor: Constants().primaryAppColor,
                    controller: dob,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Select date of birth",
                      hintStyle: GoogleFonts.openSans (
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0x7f262626),
                      ),
                    ),

                    style: GoogleFonts.openSans (

                      fontSize: 13,
                      fontWeight: FontWeight.w600,

                      color: Colors.black,
                    ),
                    readOnly:
                    true,
                    onTap:
                        () async {
                          print("fdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfd");
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime
                              .now(),
                          firstDate: DateTime(
                              1950),
                          //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(
                              2100));
                      print("pickedDate");
                      print(pickedDate);
                      if (pickedDate != null) {
                        //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                        //formatted date output using intl package =>  2021-03-16
                        // Calculate age difference
                     /*   DateTime currentDate = DateTime.now();
                        Duration difference = currentDate.difference(pickedDate);
                        int age = (difference.inDays / 365).floor();*/
                        print('Age: years');
                        print(formattedDate);
                        print("fdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfd");
                          setState(() {
                            dob.text = formattedDate; //set output date to TextField value.
                          });
                      } else {}
                    },
                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                          const SizedBox(width: 18,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                // firstnameSVK (87:1540)
                                child: Text(
                                  "Gender",
                                  style: GoogleFonts.openSans (
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff262626),
                                  ),
                                ),
                              ),
                              //gender
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
                                          'Select Gender', style:
                                        GoogleFonts.openSans (
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0x7f262626),
                                        ),
                                        ),
                                        items: gender
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
                                        selectedgender,
                                        onChanged:
                                            (String? value) {
                                          setState(() {
                                            selectedgender =
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
                          const SizedBox(width: 18,),
                          CustomTextField(key: _bloodgroup,header: "*Blood Group",hint: "Enter blood group",controller: bloodgroup,
                            onChanged: (value) {
                              setState(() {
                                // Update _firstNameError only if the value becomes empty
                                _bloodgroupError = value.trim().isEmpty;
                              });
                            },
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return null;
                              }
                              return null;
                            },
                            showError: _bloodgroupError,
                          ),
                          const SizedBox(width: 18,),
                        ],
                      ),
                      const SizedBox(height: 25,),

                      Container(
                        width: double.infinity,
                        child: Text(
                          'Contact Details',
                          style: GoogleFonts.openSans (
                            fontSize: 20*ffem,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),

                      const Divider(),
                      const SizedBox(height: 18,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomTextField(
                            key: _phonenumber,
                            header: "*Phone Number",hint: "Enter phone number",controller: phone,
                            onChanged: (value) {
setState(() {
_phonenumError = value.trim().isEmpty;
});
},
validator: (String? value) {
if (value == null || value.isEmpty) {
return null;
}
return null;
},
showError: _phonenumError,


                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            ],
                          ),
                          const SizedBox(width: 18,),
                          CustomTextField(header: "Mobile Number",hint: "Enter mobile number",controller: mobile,validator: null,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            ],
                          ),
                          const SizedBox(width: 18,),
                          CustomTextField(
                            key: _aadharnum,
                            header: "*Aadhaar Number",hint: "Enter aadhaar number",controller: aadhaar,

                            onChanged: (value) {
setState(() {
// Update _firstNameError only if the value becomes empty
_aadharError = value.trim().isEmpty;
});
},
validator: (String? value) {
if (value == null || value.isEmpty) {
return null;
}
return null;
},
showError: _aadharError,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(12),
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            ],
                          ),
                          const SizedBox(width: 18,),

                          // CustomTextField(header: "Email",hint: "Enter email-id",controller: email,validator: null,
                          //
                          // ),

                          CustomTextField(
                            key: _email,
                            header: "*Email",
                            hint: "Enter email-id",
                            controller: email,
                            ErrorMsg: ' *Enter Valid Email',
                            onChanged: (value) {
                              setState(() {
                                _emailError = value.trim().isEmpty;
                              });
                            },
                            showError: _emailError,
                            validator: (String? value) {
                              if (value == null || value.isEmpty || !value.contains('@') || !value.endsWith('gmail.com')) {
                                return null;
                              }
                              return null;
                            },




// validator: (String? value) {
//   //   if (!value.contains('@') || !value.endsWith('gmail.com')) {
//   //     return 'Please enter a valid Gmail address';
//   //   }
//   //   return null;
//
// if (value == null || value.isEmpty) {
// return 'Please enter your first name';
// }
// return null;
// },
// showError: _emailError,
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomTextField(
                            key: _address,
                            header: "*Address",hint: "Enter student full address",controller: address,
                            onChanged: (value) {
setState(() {
// Update _firstNameError only if the value becomes empty
_addressError = value.trim().isEmpty;
});
},
validator: (String? value) {
if (value == null || value.isEmpty) {
return null;
}
return null;
},
showError: _addressError,
                          width: 696,
                          ),
                          const SizedBox(width: 18,),
                          CustomTextField(header: "Country",hint: "Select country",controller: country,validator: null,),
                             ],
                      ),

                      const SizedBox(height: 18,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomTextField(header: "State",hint: "Select state",controller: state,validator: null,),
                          const SizedBox(width: 18,),
                          CustomTextField(
                            key: _city,
                            header: "*City",hint: "Select City",controller: city,

                            onChanged: (value) {
setState(() {
// Update _firstNameError only if the value becomes empty
_cityError = value.trim().isEmpty;
});
},
validator: (String? value) {
if (value == null || value.isEmpty) {
return null;
}
return null;
},
showError: _cityError,


                          ),
                          const SizedBox(width: 18,),
                          CustomTextField(
                            key: _pincode,
                            header: "*Pin Code",hint: "Enter pin code",controller: pincode,
                            onChanged: (value) {
setState(() {
// Update _firstNameError only if the value becomes empty
_pincodeError = value.trim().isEmpty;
});
},
validator: (String? value) {
if (value == null || value.isEmpty) {
return null;
}
return null;
},
showError: _pincodeError,

                            inputFormatters: [
                              LengthLimitingTextInputFormatter(6),
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            ],
                          ),
                          const SizedBox(width: 18,),
                        ],
                      ),

                      const SizedBox(height: 25,),

                      Container(
                        width: double.infinity,
                        child: Text(
                          'Parent/Guardian Details',
                          style: GoogleFonts.openSans (
                            fontSize: 20*ffem,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                      const Divider(),
                      const SizedBox(height: 18,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                // firstnameSVK (87:1540)
                                child: Text(
                                  "Prefix",
                                  style: GoogleFonts.openSans (

                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,

                                    color: const Color(0xff262626),
                                  ),
                                ),
                              ),
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
                                          'Prefix', style:
                                        GoogleFonts.openSans (

                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,

                                          color: const Color(0x7f262626),
                                        ),
                                        ),
                                        items: prefix
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
                                        selectedprefix2,
                                        onChanged:
                                            (String? value) {
                                          setState(() {
                                            selectedprefix2 =
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
                          const SizedBox(width: 18,),
                          CustomTextField(
                            key: _parentname,
                            header: "Parent/Guardian Name",hint: "Enter full name",controller: parentname,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                            ],
                            onChanged: (value) {
setState(() {
// Update _firstNameError only if the value becomes empty
_parentnameError = value.trim().isEmpty;
});
},
validator: (String? value) {
if (value == null || value.isEmpty) {
return '';
}
return null;
},
showError: _parentnameError,


                          ),
                          const SizedBox(width: 18,),
                          CustomTextField(
                            key: _parentnum,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            ],
                            header: "*Mobile Number",hint: "Enter mobile number",controller: parentmobile,
                              onChanged: (value) {
setState(() {
// Update _firstNameError only if the value becomes empty
_parentnumError = value.trim().isEmpty;
});
},
validator: (String? value) {
if (value == null || value.isEmpty) {
return null;
}
return null;
},
showError: _parentnumError,
                          ),
                          const SizedBox(width: 18,),
                          CustomTextField(
                            header: "Occupation",hint: "Enter parent occupation",controller: parentOccupation,validator: null,),
                        ],
                      ),
                      const SizedBox(height: 25,),
                      Container(
                        width: double.infinity,
                        child: Text(
                          'Room Details',
                          style: GoogleFonts.openSans (
                            fontSize: 20*ffem,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                      const Divider(),
                      const SizedBox(height: 18,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomTextField(
                            readOrwrite: true,
                            key: _userid,
                            header: "*User ID",hint: "IKIA0001",controller: userid,
                              onChanged: (value) {
setState(() {
_useridError = value.trim().isEmpty;
});
},
validator: (String? value) {
if (value == null || value.isEmpty) {
return null;
}
return null;
},
showError: _useridError,

                            ),
                          const SizedBox(width: 18,),
                          //block name
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Block Name',   style: GoogleFonts.openSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff262626),
                              ),),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(
                                  width: 220,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: const Color(0x7f262626)),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0, right: 6),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButtonFormField<String>(
                                        isExpanded: true,
                                        hint: const Text(
                                          'Select Block Name',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0x7f262626),
                                          ),
                                        ),
                                        items: BlockNames.map((String item) {
                                          return DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        value: selectedBlockName,
                                        onChanged: (String? value) {
                                          setState(() {
                                            selectedBlockName = value!;
                                            selectedRoomName = "Select Room Name";
                                          });
                                          getRoomNames(selectedBlockName);
                                        },
                                        decoration: const InputDecoration(border: InputBorder.none),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 18,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Room No',   style: GoogleFonts.openSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff262626),
                              ),),

                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(
                                  width: 220,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: const Color(0x7f262626)),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0, right: 6),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButtonFormField<String>(
                                        isExpanded: true,
                                        hint: const Text(
                                          'Select Room Name',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0x7f262626),
                                          ),
                                        ),
                                        items: blockRoomNames.map((String item) {
                                          return DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        value: selectedRoomName,
                                        onChanged: (String? value) {
                                          setState(() {
                                            selectedRoomName = value!;
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
                        ],
                      ),
                      const SizedBox(height: 18,),
                      const Divider(),
                      const SizedBox(height: 28,),
                      Row(
                        children: [
                          InkWell(
                            onTap: (){
                              widget.updateDisplay(!widget.displayFirstWidget);
                            },
                            child: Container(
                              child: Row(
                                children: [
                                  Icon(Icons.arrow_back_ios_new,color: Constants().primaryAppColor,),
                                  KText(text: "Back", style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                    color: Constants().primaryAppColor
                                  ))
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 600,),
                          InkWell(
                            // onTap: () async {
                            //   final userBlockName = selectedBlockName;
                            //   final userRoomNumber = selectedRoomName;
                            //     if (userBlockName.isNotEmpty &&
                            //         userRoomNumber.isNotEmpty &&
                            //         firstName.text.isNotEmpty &&
                            //         phone.text.isNotEmpty &&
                            //         pincode.text.isNotEmpty &&
                            //          imgUrl.isNotEmpty) {
                            //       await matchBlockRoom(userBlockName, userRoomNumber);
                            //     } else {
                            //       print("Please provide both block name and room number.");
                            //       toastification.show(
                            //         backgroundColor: Color(0xffFF7E75FF),
                            //         context: context,
                            //         title: 'Please Fill all the requirements',
                            //         autoCloseDuration: const Duration(seconds: 5),
                            //       );
                            //     }
                            //
                            //   // adduser();
                            // },
                            // Inside the onTap callback of the save button
                            // Inside the onTap callback of the save button
                            onTap: () async {
                              // Validate the form
                              if (_formKey.currentState!.validate()) {
                                final userBlockName = selectedBlockName;
                                final userRoomNumber = selectedRoomName;
                                if (userBlockName.isNotEmpty &&
                                    userRoomNumber.isNotEmpty
                                )
                                {
                                  await matchBlockRoom(userBlockName, userRoomNumber);
                                } else {
                                  print("Please provide both block name and room number.");
                                  toastification.show(
                                    backgroundColor: Color(0xffFF7E75FF),
                                    context: context,
                                    title: 'Please Fill all the requirements',
                                    autoCloseDuration: const Duration(seconds: 5),
                                  );
                                }

                              } else {
                                setState(() {
                                  _firstNameError = firstName.text.isEmpty;
                                  _bloodgroupError = bloodgroup.text.isEmpty;
                                  _phonenumError = phone.text.isEmpty;
                                  _aadharError = aadhaar.text.isEmpty;
                                  _addressError = address.text.isEmpty;
                                  _pincodeError = pincode.text.isEmpty;
                                  _parentnameError = parentname.text.isEmpty;
                                  _parentnumError = parentmobile.text.isEmpty;
                                  _useridError = userid.text.isEmpty;
                                });
                              }

                            },
                            child: Container(
                              width: 100,
                              height: 37,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Constants().primaryAppColor
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  KText(text: "Save", style: GoogleFonts.openSans(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13,
                                      color: Colors.white
                                  ) ),
                                  const Icon(Icons.file_copy,color: Colors.white)
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 15,),
                          Container(
                            width: 100,
                            height: 37,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Constants().primaryAppColor
                              ),
                              color: Colors.white
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                KText(text: "Reset", style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                    color: Constants().primaryAppColor
                                ) ),
                                Icon(Icons.restart_alt,color: Constants().primaryAppColor)
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ]
        ),
      ),
    );
  }
  // To add details

  int usercount = 0;

  getuserid() async {
    var docu = await FirebaseFirestore.instance.collection("Users").orderBy("timestamp",descending: true).get();
    if(docu.docs.length > 0){
      setState(() {
        usercount = docu.docs[0]["usercount"] + 1;
        userid.text="IKIA${usercount.toString().padLeft(4,"0")}";

      });
    }else{
      setState(() {
        usercount = 1;
        userid.text="IKIA${(usercount).toString().padLeft(4,"0")}";
      });
    }

}
  adduser(){
    FirebaseFirestore.instance.collection("Users").doc().set({
      "prefix":selectedprefix,
      "blockname" : selectedBlockName,
      "roomnumber" : selectedRoomName,
     "firstName" :firstName.text,
     "middleName" : middleName.text,
    "lastName" : lastName.text,
    "dob" :dob.text,
      "gender":selectedgender,
    "bloodgroup" : bloodgroup.text,
    "phone" : phone.text,
    "mobile" : mobile.text,
    "aadhaar" : aadhaar.text,
    "email" : email.text,
    "address" : address.text,
    "country" : country.text,
    "state" : state.text,
    "city" : city.text,
    "pincode" : pincode.text,
      "parentprefix":selectedprefix2,
    "parentname" : parentname.text,
    "parentmobile" : parentmobile.text,
    "parentOccupation" : parentOccupation.text,
    "userid" : userid.text,
      "imageUrl":imgUrl,
      "fcmToken": "",
      "timestamp":DateTime.now().millisecondsSinceEpoch,
      "status" : false,
      "uid" : '',
      "usercount" : usercount,
    });
    Successdialog();
  }
  Successdialog(){
    double width = MediaQuery.of(context).size.width;
    return AwesomeDialog(
      width: width/3.035555555555556,
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Resident Added Successfully',
      btnOkOnPress: () {
        widget.updateDisplay(!widget.displayFirstWidget);
      },
    )..show();
  }
  Ageerror(){
    double width = MediaQuery.of(context).size.width;
    return AwesomeDialog(
      width: width/3.035555555555556,
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Age is too low',
      btnOkOnPress: () {
      },
    )..show();
  }
  Future<void> matchBlockRoom(String userBlockName, String userRoomNumber) async {
    final roomCollection = FirebaseFirestore.instance.collection('Room');
    final roomQuery = await roomCollection
        .where('blockname', isEqualTo: userBlockName)
        .where('roomnumber', isEqualTo: userRoomNumber)
        .get();
    if (roomQuery.docs.isNotEmpty) {
      final roomId = roomQuery.docs.first.id;
      final roomData = roomQuery.docs.first.data();
      final int bedCount = roomData['bedcount'];
      final int vacantCount = roomData['vacant'];

      final residentCollection = roomCollection.doc(roomId).collection('resident');
      final residentQuery = await residentCollection.get();

      if (residentQuery.docs.length < bedCount && vacantCount > 0) {
        // Subtract 1 from the vacant count
        final newVacantCount = vacantCount - 1;

        // Add user to the resident collection
        await adduser();
        await residentCollection.add({
          "dob": dob.text,
          "firstName": firstName.text,
          "phone": phone.text,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        });
        print('User added to resident collection in room $roomId');

        // Update the vacant count after adding a user
        await roomCollection.doc(roomId).update({
          'vacant': newVacantCount,
        });

        print('Vacant count updated to $newVacantCount');
      } else {
        toastification.show(
          backgroundColor: Color(0xffFF7E75FF),
          context: context,
          title: 'Room is full. Cannot add more residents.',
          autoCloseDuration: const Duration(seconds: 5),
        );
      }
    } else {
      print('Room not found for user: blockname:- $userBlockName *** roomnumber:- $userRoomNumber');
      toastification.show(
        backgroundColor: Color(0xffFF7E75FF),
        context: context,
        title: 'No Room is Available',
        autoCloseDuration: const Duration(seconds: 5),
      );
    }
  }


}
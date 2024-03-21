
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_ikia/Constants/constants.dart';
import 'package:hms_ikia/widgets/customtextfield.dart';
import 'package:hms_ikia/widgets/kText.dart';
import 'package:intl/intl.dart';


class EditInfoDetails extends StatefulWidget {
  final Function(bool) updateDisplay;
  final bool displayFirstWidget;
  EditInfoDetails({required this.displayFirstWidget,required this.updateDisplay});

  @override
  State<EditInfoDetails> createState() => _EditInfoDetailsState();
}

class _EditInfoDetailsState extends State<EditInfoDetails> {

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
  TextEditingController roomnumber = new TextEditingController();
  TextEditingController blockname = new TextEditingController();


  List<String> prefix=["Select Prefix","Mr.","Ms.","Mrs"];
  List<String> gender=["Select Gender","Male","Female","Transgender"];

  String selectedprefix="Select Prefix";
  String selectedprefix2="Select Prefix";
  String selectedgender="Select Gender";
  File? Url;
  var Uploaddocument;
  String imgUrl = "";

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

  @override
  void initState() {
    setState(() {
      country.text="India";
      state.text="Tamil Nadu";
      city.text="Chennai";
    });
    // TODO: implement initState
    super.initState();
  }


  Future<void> showMyDialog(BuildContext context) async {
    double baseWidth = 1512;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
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
                                  // addresidentdetailsvyb (87:1511)
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
                                          selectedprefix,
                                          onChanged:
                                              (String? value) {
                                            setState(() {
                                              selectedprefix =
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
                            CustomTextField(header: "First Name",hint: "Enter first name",controller: firstName,validator: null,),
                            const SizedBox(width: 18,),
                            CustomTextField(header: "Middle Name",hint: "Enter middle name",controller: middleName,validator: null,),
                            const SizedBox(width: 18,),
                            CustomTextField(header: "Last Name",hint: "Enter last name",controller: lastName,validator: null,),
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
                            CustomTextField(header: "Blood Group",hint: "Enter bloob group",controller: bloodgroup,validator: null,),
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
                            CustomTextField(header: "Phone Number",hint: "Enter phone number",controller: phone,validator: null,),
                            const SizedBox(width: 18,),
                            CustomTextField(header: "Mobile Number",hint: "Enter mobile number",controller: mobile,validator: null,),
                            const SizedBox(width: 18,),
                            CustomTextField(header: "Aadhaar Number",hint: "Enter aadhaar name",controller: aadhaar,validator: null,),
                            const SizedBox(width: 18,),
                            CustomTextField(header: "Email",hint: "Enter email-id",controller: email,validator: null,),
                          ],
                        ),

                        const SizedBox(height: 18,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomTextField(header: "Address",hint: "Enter student full address",controller: address,validator: null,
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
                            CustomTextField(header: "City",hint: "Select City",controller: city,validator: null,),
                            const SizedBox(width: 18,),
                            CustomTextField(header: "Pin Code",hint: "Enter pin code",controller: pincode,validator: null,),
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
                            CustomTextField(header: "Parent/Guardian Name",hint: "Enter full name",controller: parentname,validator: null,),
                            const SizedBox(width: 18,),
                            CustomTextField(header: "Mobile Number",hint: "Enter mobile number",controller: parentmobile,validator: null,),
                            const SizedBox(width: 18,),
                            CustomTextField(header: "Occupation",hint: "Enter parent occupation",controller: parentOccupation,validator: null,),
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
                            CustomTextField(header: "User ID",hint: "IKIA0001",controller: userid,validator: null,),
                            const SizedBox(width: 18,),
                            CustomTextField(header: "Room Number",hint: "Select Room",controller: roomnumber,validator: null,),
                            const SizedBox(width: 18,),
                            // CustomTextField(header: "Block Name",hint: "Select Block",controller: blockname,validator: null,),




                            const SizedBox(width: 18,),
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
                              onTap: (){
                                // adduser();
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
                  )

                ]

            ),

          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }



































  // before future
  @override
  Widget build(BuildContext context) {
    double baseWidth = 1512;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return const SizedBox();
  }

  adduser(){
    FirebaseFirestore.instance.collection("Users").doc().set({
      "prefix":selectedprefix,
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
      "roomnumber" : roomnumber.text,
      "blockname" : blockname.text,
      "imageUrl":imgUrl,
      "timestamp":DateTime.now().millisecondsSinceEpoch
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
}






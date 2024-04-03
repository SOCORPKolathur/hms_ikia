
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_ikia/Constants/constants.dart';

import '../widgets/customtextfield.dart';
import '../widgets/kText.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  @override
  void initState() {
    setHostelDetails('j9TCvPYC9Y6AzQeNcpH9', context);
    super.initState();
  }

  String ImgUrl = "";

  TextEditingController hostelname = TextEditingController();
  TextEditingController hostelphone = TextEditingController();
  TextEditingController hostelemail = TextEditingController();
  TextEditingController buildingno = TextEditingController();
  TextEditingController area = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController weblink = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController district = TextEditingController();
  TextEditingController state = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants().primaryAppColor,
        title: Text(
          "Setting",
          style: GoogleFonts.openSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Center(
                  child: Text(
                    'Update Hostel Details',
                    style: GoogleFonts.openSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff000000),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),

              Center(child: CircleAvatar(backgroundColor: Colors.transparent, radius: 100, backgroundImage: Uploaddocument==null?
              NetworkImage(ImgUrl) : MemoryImage(
                Uint8List.fromList(
                  base64Decode(
                    Uploaddocument!.split(',').last,
                  ),
                ),
              )as ImageProvider)),
              SizedBox(height: 15,),
              Center(child: Text('Upload Hostel Logo')),
              Center(child: Text('( 150px * 150px)')),
              SizedBox(height: 10,),
              Center(child:  ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Color(0xff37d1d3))
                ),
                onPressed: (){
                  addImage();


                }, child: const Text('Change Logo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
              ),),
                SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  CustomTextField(
                    header: "Hostel Name",
                    hint: "Hostel Name",
                    controller: hostelname,
                    validator: null,
                  ),
                  const SizedBox(height: 18),
                  CustomTextField(
                    header: "Hostel Phone Number",
                    hint: "Hostel Phone Number",
                    controller: hostelphone,
                    validator: null,
                  ),
                  const SizedBox(height: 18),
                  CustomTextField(
                    header: "Hostel Email",
                    hint: "Hostel Email",
                    controller: hostelemail,
                    validator: null,
                  ),
                  const SizedBox(height: 18),
                  CustomTextField(
                    header: "Building No",
                    hint: "Building No",
                    controller: buildingno,
                    validator: null,
                  ),
                  const SizedBox(height: 18),
                  CustomTextField(
                    header: "Area",
                    hint: "Enter Area",
                    controller: area,
                    validator: null,
                  ),
                ],
              ),
              SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [


                  CustomTextField(
                    header: "Pin Code",
                    hint: "Enter Pin Code",
                    controller: pincode,
                    validator: null,
                  ),
                  const SizedBox(height: 18),
                  CustomTextField(
                    header: "City",
                    hint: "Enter City",
                    controller: city,
                    validator: null,
                  ),
                  const SizedBox(height: 18),
                  CustomTextField(
                    header: "District",
                    hint: "Enter District",
                    controller: district,
                    validator: null,
                  ),
                  const SizedBox(height: 18),
                  CustomTextField(
                    header: "State",
                    hint: "Enter State",
                    controller: state,
                    validator: null,
                  ),
                  const SizedBox(height: 18),
                  CustomTextField(
                    header: "Website Link",
                    hint: "Website Link",
                    controller: weblink,
                    validator: null,
                  ),
                  const SizedBox(height: 30),
                ],
              ),

              SizedBox(height: 30,),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Color(0xff37d1d3))
                    ),
                    onPressed: (){
                      updateHostelDetails('j9TCvPYC9Y6AzQeNcpH9');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Hostel details updated'),
                        ),
                      );

                    }, child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Color(0xff37d1d3))
                    ),
                    onPressed: (){
                      Navigator.pop(context);

                    }, child: const Text('Update', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
                  ),
                  const SizedBox(width: 20),


                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
  Future<void> updateHostelDetails(String id) async {
    await FirebaseFirestore.instance.collection('HostelDetails').doc(id).update({
      "hostelname": hostelname.text,
      "hostelphone": hostelphone.text,
      "hostelemail": hostelemail.text,
      "buildingno": buildingno.text,
      "area": area.text,
      "pincode": pincode.text,
      "weblink": weblink.text,
      "city": city.text,
      "district": district.text,
      "state": state.text,
      "logo": ImgUrl,
    });
  }


  Future<void> setHostelDetails(String id, BuildContext context) async {
    var docSnapshot = await FirebaseFirestore.instance.collection('HostelDetails').doc(id).get();
    if (docSnapshot.exists) {
      var data = docSnapshot.data() as Map<String, dynamic>;
      setState(() {
        ImgUrl = data['logo'] ?? '';
        hostelname.text = data['hostelname'] ?? '';
        hostelphone.text = data['hostelphone'] ?? '';
        hostelemail.text = data['hostelemail'] ?? '';
        buildingno.text = data['buildingno'] ?? '';
        area.text = data['area'] ?? '';
        pincode.text = data['pincode'] ?? '';
        weblink.text = data['weblink'] ?? '';
        city.text = data['city'] ?? '';
        district.text = data['district'] ?? '';
        state.text = data['state'] ?? '';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hostel details not found'),
        ),
      );
    }
  }

  // for update passing (id to get the EXACT person)
  UpdateDetails(id){
    FirebaseFirestore.instance.collection("Users").doc(id).set({
      "hostelname":hostelname.text,
      "hostelphone" :hostelphone.text,
      "hostelemail" : hostelemail.text,
      "buildingno" : buildingno.text,
      "area" :area.text,
      "pincode" :pincode.text,
      "city" : city,
      "district" : district,
      "state":state,
      "weblink" :weblink.text,
    });
    // Successdialog();
  }


  File? Url;
  var Uploaddocument;
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
          ImgUrl = "";
        });
        imageupload();
      });
    });
  }
  // used this in Update page too
  imageupload() async {
    var snapshot = await FirebaseStorage.instance.ref().child('HostelLogos').child(
        "${Url!.name}").putBlob(Url);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      ImgUrl = downloadUrl;
    });
  }
}

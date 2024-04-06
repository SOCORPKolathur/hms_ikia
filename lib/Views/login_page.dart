import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_ikia/Views/drawer.dart';
import 'package:hms_ikia/widgets/customtextfield.dart';
import 'package:hms_ikia/widgets/kText.dart';

import '../Constants/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();

  @override
  void initState() {
    getHostelDetails();
    // TODO: implement initState
    super.initState();
  }
  String hostellogo = '';
  String hostelname = '';
  getHostelDetails() async {
    var hostel = await FirebaseFirestore.instance.collection('HostelDetails').get();
    setState(() {
      hostellogo = hostel.docs.first.get("logo");
      hostelname = hostel.docs.first.get("hostelname");
    });

  }
  bool passwordview = true;
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.centerRight,
        children: [
          Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.network("assets/Log In Page.png",fit: BoxFit.cover,)),
          Padding(
            padding: const EdgeInsets.only(right: 80.0,top: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                
                Padding(
                  padding: const EdgeInsets.only(right: 120.0,bottom: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          width:100,
                          child: Image.network(hostellogo)),
                      Text(hostelname,style: GoogleFonts.openSans(fontSize: 22,fontWeight: FontWeight.bold),),
                      Text("Management Admin",style: GoogleFonts.openSans(fontSize: 22,fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  KText(
                                    text: "Username",
                                    style: GoogleFonts.openSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff262626),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        Padding(
                          padding: EdgeInsets.only(top: 8.0 ),
                          child: Container(
                            width: 470,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Color(0x7f262626)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15, right: 20),
                              child: TextFormField(
                                onTap: () {},
                                autofillHints: [AutofillHints.username],
                                cursorColor: Constants().primaryAppColor,
                                onChanged: (val){

                                },
                                controller: username,
                                onFieldSubmitted: (val){

                                },
                                decoration: InputDecoration(
                                 // suffixIcon: Icon(widget.suffixIcon, color: widget.suffixColor),
                                  border: InputBorder.none,
                                  hintText: "Enter username",
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
                  /*  CustomTextField(
                      width: 470,
                      hint: "Enter username", controller: username, validator: (String? val ) {  }, header: "Username",),*/
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                KText(
                                  text: "Password",
                                  style: GoogleFonts.openSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff262626),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8.0 ),
                          child: Container(
                            width: 470,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Color(0x7f262626)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15, right: 20),
                              child: TextFormField(
                                onTap: () {},
                                obscureText: passwordview,
                                cursorColor: Constants().primaryAppColor,
                                onChanged: (val){

                                },
                                autofillHints: [AutofillHints.password],
                                controller: password,
                                onFieldSubmitted: (val){

                                },
                                decoration: InputDecoration(
                                   suffixIcon: InkWell(child: Icon(passwordview == true?Icons.remove_red_eye : Icons.remove_red_eye_outlined,),
                                     onTap: (){
                                     setState(() {
                                       passwordview=!passwordview;
                                     });
                                     },

                                   ),
                                  border: InputBorder.none,
                                  hintText: "Enter password",
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
                    /*  CustomTextField(
                      width: 470,
                      hint: "Enter username", controller: username, validator: (String? val ) {  }, header: "Username",),*/
                  ],
                ),
                SizedBox(height: 20,),
                InkWell(
                  onTap: (){
                      _signInWithEmailAndPassword();
                  },
                  child: Container(
                    width: 470,
                    height: 50,
                    decoration: BoxDecoration (
                        color:Constants().primaryAppColor,
                      border: Border.all(color:Constants().primaryAppColor),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                        child: Text("Login", style: GoogleFonts.openSans (

                          fontSize: 14,
                          fontWeight: FontWeight.w600,

                          color: Colors.white,
                        ),)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  bool _success=false;
  _signInWithEmailAndPassword() async {

    bool result = false;
    var auth=FirebaseAuth.instance;
    final User? user = (await auth.signInWithEmailAndPassword(
      email: username.text,
      password: password.text,
    ).catchError((e){
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    })).user;
    if (user != null) {
      TextInput.finishAutofillContext();
      setState(() {
        _success = true;
        result = true;
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeDrawer()));
        // _userEmail = user.uid;
        //Docuemntcheckfunction();
      });
    } else {
      setState(() {
        _success = false;
        result = false;
      });
    }
    return result;
  }

  final snackBar = SnackBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Color(0x19000000),
              spreadRadius: 2.0,
              blurRadius: 8.0,
              offset: Offset(2, 4),
            )
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.black),
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('Invalid Credentials !!', style: TextStyle(color: Colors.black)),
            ),
            const Spacer(),
            TextButton(onPressed: () => debugPrint("Undid"), child: Text("Undo"))
          ],
        )
    ),
  );
}

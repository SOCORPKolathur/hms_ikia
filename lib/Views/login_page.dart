import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_ikia/Views/drawer.dart';
import 'package:hms_ikia/widgets/customtextfield.dart';

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
              child: Image.asset("assets/loginfinal.png",fit: BoxFit.cover,)),
          Padding(
            padding: const EdgeInsets.only(right: 80.0,top: 280),
            child: Column(
              children: [
                CustomTextField(
                  width: 470,
                  hint: "Enter username", controller: username, validator: (String? val ) {  }, header: "Username",),
                SizedBox(height: 20,),
                CustomTextField(
                  width: 470,
                  hint: "Enter password", controller: password, validator: (String? val ) {  }, header: "Password",),
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

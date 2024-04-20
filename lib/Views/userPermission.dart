import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_ikia/widgets/ReusableHeader.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../widgets/customtextfield.dart';
import '../widgets/kText.dart';
import '../widgets/reusableCheckbox.dart';



class userPermission extends StatefulWidget {
  const userPermission({super.key});

  @override
  State<userPermission> createState() => _userPermissionState();
}

class _userPermissionState extends State<userPermission> {
  List<String> availableModules = [
    'Dashboard',
    'Resident Management',
    'Entry & Records',
    'Block',
    'Room and Bed Allocation',
    'Asset Management',
    'Attendance',
    'Fees and Billing',
    'Visitor Management',
    'Email',
    'Sms',
    'Notifications',
    'User Permissions',
    'Mess Time Table',
    'Complaints',
    'Birthday Wishes'
  ];

  Map<String, bool> moduleStates = {};

  // create role
  TextEditingController usernameCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  bool value = false;
  List<String> Roles = [];
  String selectedRole = "Select Role";
  List<String> selectedModules = [];

  @override
  void initState() {
    getUsernames().then((names) {
      setState(() {
        Roles.addAll(names);
      });
    });
    fetchRoleModules(selectedRole);
  }

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      child: Padding(
        padding:  const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
            const ReusableHeader(Headertext: '"Manage User Permission"', SubHeadingtext: '""',),
            // SizedBox(height: 4,),
            Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: Colors.grey)),
              child: Column(
                children: [
                  Container(height: 60,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      KText(text:'Manage Role Permission', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, color: Colors.black, fontSize: 17),),
                      Row(children: [
                        ElevatedButton(
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(Color(0xff37d1d3))
                          ),
                          onPressed: (){
                            ManageRolePopUp();

                          }, child: const KText(text:'Manage Role', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
                        ),
                        const SizedBox(width: 8,),
                        ElevatedButton(
                            style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(Color(0xff37d1d3))),
                            onPressed: (){
                              AddRolePopUp();
                            }, child: const KText(text:'Add Role', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)
                        )
                      ],)
                    ],),
                  ),
                  ),
                  const Divider(),
                  // SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                              // Select role Dropdown
                              KText(text:'Select Role', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10, top: 10),
                                child: Container(
                                  width: 270,
                                  height: 50,
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
                                        hint: const KText(text:
                                          'Select Role',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        items: Roles.map((String item) {
                                          return DropdownMenuItem<String>(
                                            value: item,
                                            child: KText(text:
                                              item,
                                              style: const TextStyle(
                                                color: Color(0x7f262626),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        value: selectedRole,
                                        onChanged: (String? value) {
                                          setState(() {
                                            selectedRole = value!;
                                            print("Selected role: $selectedRole");
                                          });
                                          fetchRoleModules(selectedRole);
                                        },
                                        decoration: const InputDecoration(border: InputBorder.none),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20,),
                            ],),
                          ],
                        ),
                      //   Modules
                        KText(text:'Modules', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 19),),
                        const Divider(),

                        Container(
                          width: 1250,
                          height: 170,
                          child: GridView.builder(
                            itemCount: availableModules.length,
                            itemBuilder: (context,index){
                              if(selectedRole == "admin@gmail.com") {
                                return Row(
                                  children: [
                                    Checkbox(
                                      checkColor: Colors.white,
                                      activeColor: const Color(0xff37D1D3),
                                      value: true,
                                      onChanged: (v){
                                      },
                                    ),
                                    const SizedBox(width: 3),
                                    SizedBox(
                                      child: KText(text:availableModules[index],style: GoogleFonts.openSans(),),
                                    ),
                                  ],
                                );
                              }
                              else {
                                return Container(


                                  child:Row(
                                    children: [
                                      Checkbox(
                                        checkColor: Colors.white,
                                        activeColor: const Color(0xff37D1D3),
                                        value: modulespermissions.contains(availableModules[index].toString()),
                                        onChanged: (newValue) {
                                          setState(() {
                                          if(newValue==true) {
                                            modulespermissions.add(availableModules[index].toString());
                                          }
                                          else{
                                            modulespermissions.remove(availableModules[index]);
                                          }
                                          });
                                        },
                                      ),
                                      const SizedBox(width: 3),
                                      SizedBox(
                                        child: KText(text:availableModules[index], style: GoogleFonts.openSans(),),
                                      ),
                                    ],
                                  ),

                                );
                              }
                            },


                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5,childAspectRatio: 9/2,),

                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                          /*  ElevatedButton(
                              onPressed: () {
                                selectedModules.clear();
                                for (var entry in moduleStates.entries) {
                                  if (entry.value) {
                                    selectedModules.add(entry.key);
                                  }
                                }
                                updateRolePermissions(selectedRole, selectedModules);
                              },
                              child: Text('Update'),
                            ),*/
                          ElevatedButton(
                            style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(Color(0xff37d1d3))
                            ),
                            onPressed: (){
                              updateRolePermissions(selectedRole, modulespermissions);
                              showTopSnackBar(
                                Overlay.of(context),
                                const CustomSnackBar.success(
                                  backgroundColor: Color(0xff1DA644),
                                  message:
                                  "User Permissions Added successfully",
                                ),
                              );

                            }, child: const KText(text:'Update', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
                          ),
                        ],)
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],),
        ),
      ),
    );
  }
  Future<List<String>> getUsernames() async {
    try {
      List<String> Username = ['Select Role'];
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Roles').get();
      querySnapshot.docs.forEach((doc) {
        String username = doc['username'];
        if (username != null) {
          Username.add(username);
        }
      });
      print(Username);
      return Username;
    } catch (e) {
      print("Error fetching Username: $e");
      return [];
    }
  }
//   for the add role popUP
  Future<void> AddRolePopUp() async {
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
              KText(text:'Add Role', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
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
            width: 500,
            height: 270,
            child: Column(
              children: [
                const SizedBox(height: 10,),
                Divider(color: const Color(0xff262626).withOpacity(0.1), thickness: 1, height: 0.5),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // KText(text:'Room Number', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, top: 10),
                        child: CustomTextField(
                          hint: 'User Name',
                          controller: usernameCont,
                          fillColor: Colors.white,
                          validator: null,
                          header: '',
                          width: 200,
                          height: 45,
                        ),
                      ),
                      // KText(text:'Room Number', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, top: 10),
                        child: CustomTextField(
                          hint: 'Password',
                          controller: passwordCont,
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
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 110,
                      height: 40,
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
                          if(usernameCont.text.isNotEmpty && passwordCont.text.isNotEmpty){
                             createFirebaseAccount(usernameCont.text, passwordCont.text);
                             Navigator.pop(context);
                             ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(
                                 content: KText(text:'Account Created Successfully', style: GoogleFonts.openSans(),),
                                 duration: const Duration(seconds: 2),
                               ),
                             );
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: KText(text:'Please Enter the Username & Password', style: GoogleFonts.openSans(),),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        child: Row(
                          children: [
                            KText(
                              text:'Create',
                              style: GoogleFonts.openSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.white,
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  color: Color(0xff37D1D3),
                                  size: 13,
                                ),
                              ),
                            ),
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

// create firebase auth
  Future<void> createFirebaseAccount(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // creating Roles as Main collection and saving it...
      await FirebaseFirestore.instance.collection('Roles').add({
        'username': email,
        'password': password,
        'modules': [],
        'notifications': [],
      });
      print('Account created successfully! ${userCredential.user}');
    } catch (e) {
      // if any error
      print('Error creating account: $e');
    }
  }
  // update
  Future<void> updateRolePermissions(String selectedRole, List selectedModules) async {
    try {
      // Query Firestore to get the document ID associated with the selected role
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Roles')
          .where('username', isEqualTo: selectedRole)
          .get();

      // Check if any documents were found
      if (querySnapshot.docs.isNotEmpty) {
        String documentId = querySnapshot.docs.first.id;

        // Update the selected modules for the selected role using the retrieved document ID
        await FirebaseFirestore.instance
            .collection('Roles')
            .doc(documentId)
            .update({'modules': selectedModules});
        print('Role permissions updated successfully');
      } else {
        print('Role not found');
      }
    } catch (e) {
      print('Error updating role permissions: $e');
    }
  }

  List modulespermissions=[];
  fetchRoleModules(String role) async {
    print("hello");
    setState(() {
      modulespermissions.clear();
    });
      var snapshot = await FirebaseFirestore.instance.collection('Roles').where("username",isEqualTo: role).get();
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          modulespermissions = snapshot.docs[0]["modules"];
        });
      }
      print(modulespermissions);
      for(int i=0;i<availableModules.length;i++) {
        if (modulespermissions.contains(availableModules[i].toString())){
          print(availableModules[i]);
        }
      }
  }

//   manage role
  Future<void> ManageRolePopUp() async {
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
              KText(text:'Manage Role', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
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
            width: 500,
            height: 400,
            child: Column(
              children: [
                const SizedBox(height: 10,),
                Divider(color: const Color(0xff262626).withOpacity(0.1), thickness: 1, height: 0.5),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // KText(text:'Room Number', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, top: 10),
                        child: CustomTextField(
                          hint: 'Enter Email',
                          readOrwrite: true,
                          controller: TextEditingController(text: selectedRole),
                          fillColor: Colors.white,
                          validator: null,
                          header: 'Email',
                          width: 250,
                          height: 45,
                        ),
                      ),
                      // KText(text:'Room Number', style: GoogleFonts.openSans(color: const Color(0xff262626).withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w600),),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, top: 10),
                        child: CustomTextField(
                          hint: 'Password',
                          controller: passwordCont,
                          fillColor: Colors.white,
                          validator: null,
                          header: 'Password',
                          width: 250,
                          height: 45,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 110,
                      height: 40,
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
                          if(usernameCont.text.isNotEmpty && passwordCont.text.isNotEmpty){
                            createFirebaseAccount(usernameCont.text, passwordCont.text);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: KText(text:'Account Created Successfully', style: GoogleFonts.openSans(),),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: KText(text:'Please Enter the Username & Password', style: GoogleFonts.openSans(),),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        child: Row(
                          children: [
                            KText(
                              text:'Create',
                              style: GoogleFonts.openSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.white,
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  color: Color(0xff37D1D3),
                                  size: 13,
                                ),
                              ),
                            ),
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

}

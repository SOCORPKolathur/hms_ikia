import 'dart:html';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
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
  final TextEditingController ResidentId = TextEditingController();
  //payment
  final TextEditingController paymentAmount = TextEditingController();
  //to get the userID
  // String? userId;
  final List<String> selectFee =[
    'Hostel Fee',
    'Mess Fee',
    'Others'
  ];
  final List<String> paymentMethod =[
    'UPI',
    'Cash',
    'Card',
    'Others'
  ];

  static const IconData filter_alt_outlined = IconData(0xf068, fontFamily: 'MaterialIcons');
  double height = 220;
  // String? selectedNotify;
  String ? selectedPaymentFor;
  String ? selectedMethod;
  List<Map<String, dynamic>> searchSuggestions = [];
  Map<String, dynamic>? selectedUser;
  @override
  void initState() {
    super.initState();
    fetchUsers();
    getUser();
  }
  void getUser() async {
    var documents = await FirebaseFirestore.instance.collection('Users').get();
    for (int i = 0; i < documents.docs.length; i++) {
      var documentId = documents.docs[i].id;
      var userId = documents.docs[i]['userid'];
      print('Document ID: $documentId, UserID: $userId');
    }
  }

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
    double listViewHeight = calculateListViewHeight();
    return  FadeInRight(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                  child: CustomTextField(hint: 'Search Resident Name',controller: ResidentName, validator: null, fillColor: const Color(0xffF5F5F5),header: '', width: 465, preffixIcon: Icons.search,height: 45,
                    onChanged: (value) {
                      setState(() {
                        if(value.isEmpty){
                          fetchUsers();
                          print('values Emp');
                        }
                        else{
                          // searchSuggestions = searchSuggestions.where((user) => user['name'].toLowerCase().contains(value.toLowerCase())).toList();
                          searchSuggestions = searchSuggestions.where((user) => user['name'].toLowerCase().startsWith(value.toLowerCase())).toList();

                          print('getting data');
                          print(value);}
                        print(searchSuggestions);
                        print('ide');
                      }
                      );
                    },
                  ),
                ),
                SizedBox.fromSize(size: const Size(0, 0),),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox.fromSize(size: const Size(23,0),),

                      SizedBox.fromSize(size: const Size(23,0),),
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
                            const Icon(Icons.search, color: Colors.white,)
                              ],)
                        ),
                      ),
                      SizedBox.fromSize(size: const Size(23,0),),
                      SizedBox(
                        height: 44,
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
                            onPressed: () {
                              ResidentName.clear();
                              setState(() {
                                fetchUsers();
                                selectedUser = null;
                              });
                            },
                            child: Row(
                              children: [
                                const Text('Reset', style: TextStyle(color: Color(0xff37D1D3))),
                                SizedBox.fromSize(size: const Size(8, 0)),
                                SizedBox(
                                  width: 20,
                                  child: Image.asset('assets/ui-design-/images/sync.png')
                                  ,
                                )
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
              ResidentName.text != '' ?
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    width: 460,
                    height: listViewHeight,
                    child: ListView.builder(
                      itemCount: searchSuggestions.length,
                      itemBuilder: (context, index) {
                        Color titleColor = index == 0 ? const Color(0xffd1f4f5) : const Color(0xffF5F5F5);
                        return Container(
                          color: titleColor,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(searchSuggestions[index]['profilePicture']),
                              ),
                              title: Text(
                                searchSuggestions[index]['name'],
                                style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  ResidentName.text = searchSuggestions[index]['name'];
                                  selectedUser = searchSuggestions[index];
                                  searchSuggestions = [];
                                });
                                String? defaultPaymentMethod = selectedMethod;
                                String ? defaultPaymentFor = selectedPaymentFor;
                                double defaultFees = double.parse(paymentAmount.text);
                                Resident(defaultPaymentMethod!, defaultPaymentFor!, defaultFees);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )
                  : const SizedBox(),
            if (selectedUser != null && ResidentName.text.isNotEmpty ) ...[
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
                                       child: Image.network(selectedUser!['profilePicture']),)
                                   ),
                                 ),
                               ],),
                              Padding(
                               padding: EdgeInsets.all(10),
                               child: Column(children: [
                                 UserMiniDetails(IconName: Icons.contact_mail, iName: 'User ID                : '  ,userDet: selectedUser!['userid']),
                                 SizedBox(height: 8,),
                                 UserMiniDetails(IconName: Icons.phone, iName: 'Phone Number  :      ',userDet: selectedUser!['phone']),
                                 SizedBox(height: 48,),
                                 const Padding(
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
                             // SizedBox(
                             //   height: 40,
                             //   child: ElevatedButton(
                             //     style:  const ButtonStyle(
                             //         elevation: MaterialStatePropertyAll(3),
                             //         backgroundColor: MaterialStatePropertyAll(Color(0xff37D1D3))),
                             //     onPressed: () {
                             //     },
                             //     child: Row(children: [
                             //       Text('Export Data', style: GoogleFonts.openSans(color: Colors.white),),
                             //        const Icon(Icons.downloading, color: Colors.white,)
                             //     ],),
                             //   ),
                             // )
                           ],),
                        SizedBox(height: 20,),
                          Row(children: [
                            Text('Selected Fees                    :     ', style: GoogleFonts.openSans(fontWeight: FontWeight.w600 ),),
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
                                        'Select Fee', style:
                                      GoogleFonts.openSans (
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0x7f262626),
                                      ),
                                      ),
                                      items: selectFee
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
                                      selectedPaymentFor,
                                      onChanged:
                                          (String? value) {
                                        setState(() {
                                          selectedPaymentFor =
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
                            Text('Payment Method              :     ',style: GoogleFonts.openSans(fontWeight: FontWeight.w600 )),
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
                                       'Select Payment Method', style:
                                     GoogleFonts.openSans (
                                       fontSize: 12,
                                       fontWeight: FontWeight.w600,
                                       color: const Color(0x7f262626),
                                     ),
                                     ),
                                     items: paymentMethod
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
                                     selectedMethod,
                                     onChanged:
                                         (String? value) {
                                       setState(() {
                                         selectedMethod =
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
                         const SizedBox(height: 30,),
                         Row(children: [
                            Text('Payment Amount             :     ',style: GoogleFonts.openSans(fontWeight: FontWeight.w600,  )),
                           const SizedBox(height: 30),
                           CustomTextField(hint: 'Enter the Amount', controller: paymentAmount, validator: null, header: '', width: 430,)
                         ],),
                         const SizedBox(height: 30,),

                         Padding(
                           padding: const EdgeInsets.only(right: 1),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.end,
                             children: [
                               Container(
                                 height: 44,
                                 width: 128,
                                 // width: 130,
                                 child:
                                 ElevatedButton(
                                   style: ButtonStyle(
                                     backgroundColor: MaterialStatePropertyAll(Color(0xff37D1D3)),
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
                                   onPressed: () {
                                     if (
                                     paymentAmount.text.isNotEmpty &&
                                         selectedPaymentFor != null &&
                                         selectedMethod != null
                                     ) {
                                       String defaultPaymentMethod = selectedMethod!;
                                       String defaultPaymentFor = selectedPaymentFor!;
                                       double defaultFees = double.parse(paymentAmount.text);

                                       // Call the method to process Resident with the provided values
                                       Resident(defaultPaymentMethod, defaultPaymentFor, defaultFees);

                                       // Clear the fields
                                       paymentAmount.clear();
                                       setState(() {
                                         selectedPaymentFor = null;
                                         selectedMethod = null;
                                       });

                                       showTopSnackBar(
                                         Overlay.of(context),
                                         CustomSnackBar.success(
                                           message: "Fees Added Successfully",
                                         ),
                                       );
                                     } else {
                                       print('Write');
                                       showTopSnackBar(
                                         Overlay.of(context),
                                         CustomSnackBar.error(
                                           message: "Please Enter all the fields",
                                         ),
                                       );
                                     }
                                   },

                                   child: Row(
                                     children: [
                                        Text('Submit', style: GoogleFonts.openSans(color: Colors.white)),
                                       SizedBox.fromSize(size: const Size(8, 0)),
                                       const Icon(Icons.save, size: 18, color: Colors.white),
                                     ],
                                   ),
                                 ),
                               ),
                             ],
                           ),
                         ),
                         const SizedBox(height: 30,),
                         SizedBox(
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
                               SizedBox(child: Text('Fees Type', style: GoogleFonts.openSans(fontWeight: FontWeight.w600,))),
                               SizedBox(child: Text('Amount', style: GoogleFonts.openSans(fontWeight: FontWeight.w600,))),
                               SizedBox(child: Text('Method', style: GoogleFonts.openSans(fontWeight: FontWeight.w600,))),
                               ],),
                            )
                           ],),
                         ),

                         const SizedBox(height: 15,),
                        StreamBuilder(stream: FirebaseFirestore.instance.collection('Users').doc(selectedUser?['docId']).collection('fees').orderBy("timestamp", descending: true).snapshots(), builder: (context, snapshot) {
                           if(snapshot.hasData){
                             return ListView.builder(
                               shrinkWrap: true,
                               itemBuilder: (context, index) {
                               var data = snapshot.data!.docs[index];
                               return  Padding(
                                 padding: const EdgeInsets.only(left: 145),
                                 child: SingleChildScrollView(
                                   child: Padding(
                                     padding: const EdgeInsets.all(2.0),
                                     child: Container(
                                       width: 510,
                                       // color: Colors.blue,
                                       child: Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                         children: [
                                           Padding(
                                             padding: const EdgeInsets.only(left: 40, right: 10),
                                             child: Container(
                                                 width: 110,
                                                 child: Text(data['date'], style: GoogleFonts.openSans(fontWeight: FontWeight.w600,color: Color(0xff262626).withOpacity(0.8)),)),
                                           ),
                                           Container(
                                               width: 100,
                                               child: Text(data['feesType'], style: GoogleFonts.openSans(fontWeight: FontWeight.w600,color: Color(0xff262626).withOpacity(0.8)))),
                                           Padding(
                                             padding: const EdgeInsets.only(left: 10, right: 0),
                                             child: Container(
                                                 width: 60,
                                                 child: Text('₹${data['fees'].toString()}', style: GoogleFonts.openSans(fontWeight: FontWeight.w600,color: Color(0xff262626).withOpacity(0.8)))),
                                           ),
                                           Padding(
                                             padding: const EdgeInsets.only(left: 25),
                                             child: Container(
                                                 width: 60,
                                                 child: Text(data['paymentMethod'].toString(), style: GoogleFonts.openSans(fontWeight: FontWeight.w600,color: Color(0xff262626).withOpacity(0.8)))),
                                           ),
                                         ],),
                                     ),
                                   ),
                                 ),
                               );
                             },itemCount:  snapshot.data!.docs.length,);
                         }else{
                             return CircularProgressIndicator();
                           }
                         },),
                         SizedBox(height: 10,),
                       ],),
                     ),
                   )
                 ],)
              )
            ],
          ]
        ),
      ),
    )
    );
  }
  double calculateListViewHeight() {
    // Calculate the total height of the ListView
    double itemHeight = 60; // Height of each item
    int itemCount = searchSuggestions.length;
    double totalHeight = itemHeight * itemCount;
    return totalHeight;
  }

  void Resident(String paymentMethod, String paymentFor, double fees) async {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    // main collection
    CollectionReference mainCollection =
    FirebaseFirestore.instance.collection('Users');
    //getting thje document ID
    DocumentReference documentRef =
    mainCollection.doc(selectedUser!['docId']);
    // creating a new sub collection
    CollectionReference subcollectionRef =
    documentRef.collection('fees');
    // mentioned timestamp
    int millisecondsSinceEpoch = Timestamp.now().millisecondsSinceEpoch;
    // adding the data
    await subcollectionRef.add({
      'fees': fees,
      'paymentMethod': paymentMethod,
      'feesType': paymentFor,
      'date': formattedDate,
      'timestamp' : millisecondsSinceEpoch
    });
    print('Subcollection created successfully');
  }
}

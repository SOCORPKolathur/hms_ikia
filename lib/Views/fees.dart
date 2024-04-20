import 'dart:convert';
import 'dart:html';
import 'dart:math';
import 'package:http/http.dart' as http;
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
import '../Constants/constants.dart';
import '../widgets/ReusableHeader.dart';
import '../widgets/ReusableRoomContainer.dart';
import '../widgets/customtextfield.dart';
import '../widgets/kText.dart';
import '../widgets/userMiniDetails.dart';

class FeesPage extends StatefulWidget {
  const FeesPage({super.key});
  @override
  State<FeesPage> createState() => _FeesPageState();
}
class _FeesPageState extends State<FeesPage> {
  final TextEditingController ResidentName = TextEditingController();
  final TextEditingController ResidentId = TextEditingController();
  final TextEditingController feesDate = TextEditingController();
  //payment
  final TextEditingController paymentAmount = TextEditingController();
  //to get the userID
  // String? userId;
  DateTime ? selectedFeesDate;
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

  bool visiblity = false;

  bool viewAllHistory = false;

  static const IconData filter_alt_outlined = IconData(0xf068, fontFamily: 'MaterialIcons');
  double height = 220;
  // String? selectedNotify;
  String ? selectedPaymentFor;
  String ? selectedMethod;
  List<Map<String, dynamic>> searchSuggestions = [];
  Map<String, dynamic>? selectedUser;
  double totalCollectionAmount = 0;
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
        'fcmToken': doc['fcmToken'] as String,
        'docId': doc.id,
        'userid': doc['userid'] as String,
        'phone' : doc['phone']as String,
        'profilePicture': doc['imageUrl'] as String,
        'status' : doc['status'] as bool
      }).toList();
    }
    );
  }


  double getTotalCollectionAmount(QuerySnapshot snapshot){
    double totalAmount = 0;
    snapshot.docs.forEach((doc) {
      totalAmount += doc['amount'];
    });
    return totalAmount;
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ReusableHeader(Headertext: 'Fees Register ', SubHeadingtext: '"Manage Easily Fees Records"'),

                  SizedBox(
                    height: 45, width: 230,
                    child: ElevatedButton(
                        style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff37D1D3))),
                        onPressed: (){
                          setState(() {
                            visiblity = !visiblity;
                          });
                          print(visiblity);
                        }, child:
                    Text(visiblity == true ? 'Fees Entry' : "Today Fees Collection", style: GoogleFonts.openSans(color: Colors.white, fontSize: 15),
                    )
                    ),
                  )
                ],
              ),
          const SizedBox(height: 10,),

            StreamBuilder(stream: FirebaseFirestore.instance.collection('Feesreports').where('date', isEqualTo:getSelectedDate()).snapshots(), builder: (context, snapshot) {
              if(snapshot.hasData){
                double totalCollectionAmount = getTotalCollectionAmount(snapshot.data!);
                // return  Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     ReusableRoomContainer(
                //       firstColor: const Color(0xff04267d),
                //       secondColor: const Color(0xff6085e5),
                //       totalRooms: '₹ ${totalCollectionAmount.toString()}',
                //       title: 'Total Collection',
                //       waveImg: 'assets/ui-design-/images/wave.png', roomImg: 'assets/ui-design-/images/Group 90.png',
                //     ),
                //     ReusableRoomContainer(
                //       firstColor: const Color(0xffd39617),
                //       secondColor: const Color(0xffffd57c),
                //       totalRooms: '2',
                //       title: 'Members',
                //       waveImg: 'assets/ui-design-/images/yellow.png', roomImg: 'assets/ui-design-/images/Group 95.png',
                //     ),
                //     ReusableRoomContainer(
                //       firstColor: const Color(0xffbe0e73),
                //       secondColor: const Color(0xfff946a6),
                //       totalRooms: '2',
                //       title: 'Rooms Occupied',
                //       waveImg: 'assets/ui-design-/images/pink.png', roomImg: 'assets/ui-design-/images/Group 92.png',
                //     ),
                //   ],
                // );


              return    visiblity == true ?
              Row(children: [
                  Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 207,
                      width: 305,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: <Color>[
                          // widget.firstColor,
                          // widget.secondColor,
                          Color(0xff04267d), Color(0xff6085e5)
                        ]),
                        borderRadius: BorderRadius.circular(23),
                        color: Colors.green,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                          width: 60,
                          child: Image.asset("assets/ui-design-/images/Top.png")),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                          width: 60,
                          child: Image.asset("assets/ui-design-/images/Down.png")),
                    ),

                    // for the Text
                    Positioned(
                      right: 70,
                      top: 40,
                      child: Container(
                          width: 130,
                          child: KText(text: '₹ ${totalCollectionAmount.toString()}', style: const TextStyle(fontSize: 30,fontWeight: FontWeight.w900,color: Colors.white, letterSpacing: 2))
                      ),
                    ),
                    // Positioned(
                    //   right: 30,
                    //   bottom: 70,
                    //
                    //   child: Container(
                    //       width: 80,
                    //       // "assets/ui-design-/images/wave.png"
                    //       child: Image.asset(widget.waveImg)),
                    // ),

                    // Positioned(
                    //   left: 55,
                    //   top: 40,
                    //   child: Container(
                    //       width: 60,
                    //       // "assets/ui-design-/images/wave.png"
                    //       // 'assets/ui-design-/images/Group 90.png'
                    //       child: Image.asset(widget.roomImg)),
                    // ),


                    Padding(
                      padding: const EdgeInsets.only(right: 80,top: 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30,),
                          SizedBox(
                              width: 190,
                              child: KText(text: "Today's Total Collection",style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 19,color: Colors.white, letterSpacing: 1),))
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(width: 10,),

                ///for the user count
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 207,
                      width: 305,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: <Color>[
                          // widget.firstColor,
                          // widget.secondColor,
                          Color(0xffd39617),  Color(0xffffd57c)
                        ]),
                        borderRadius: BorderRadius.circular(23),
                        color: Colors.green,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                          width: 60,
                          child: Image.asset("assets/ui-design-/images/Top.png")),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                          width: 60,
                          child: Image.asset("assets/ui-design-/images/Down.png")),
                    ),

                    // for the Text
                    Positioned(
                      right: 70,
                      top: 40,
                      child: Container(
                          width: 130,
                          child: KText(text: snapshot.data!.docs.length.toString(), style: const TextStyle(fontSize: 30,fontWeight: FontWeight.w900,color: Colors.white, letterSpacing: 2))
                      ),
                    ),
                    // Positioned(
                    //   right: 30,
                    //   bottom: 70,
                    //
                    //   child: Container(
                    //       width: 80,
                    //       // "assets/ui-design-/images/wave.png"
                    //       child: Image.asset(widget.waveImg)),
                    // ),

                    // Positioned(
                    //   left: 55,
                    //   top: 40,
                    //   child: Container(
                    //       width: 60,
                    //       // "assets/ui-design-/images/wave.png"
                    //       // 'assets/ui-design-/images/Group 90.png'
                    //       child: Image.asset(widget.roomImg)),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(right: 80,top: 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30,),
                          SizedBox(
                              width: 190,
                              child: KText(text: "Total Paid Residents ",style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 19,color: Colors.white, letterSpacing: 1),))
                        ],
                      ),
                    )
                  ],
                ),


                ],) : SizedBox();
              }else{
                return CircularProgressIndicator();
              }
            }


            ,),



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
                Container(
                  width: 260,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xffF5F5F5),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: const Color(0x7f262626)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0, right: 0),
                    child: TextFormField(
                      onTap: () {
                        feesDatePicker(context);
                      },
                      cursorColor: Constants().primaryAppColor,
                      controller: feesDate,
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                          onPressed: () {
                            feesDatePicker(context);
                          },
                          icon: const Icon(Icons.calendar_month, size: 20,),
                        ),
                        border: InputBorder.none,
                        hintText: "Select the Date",
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
                            const KText(text:'Search', style: TextStyle(color: Colors.white),),
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
                                const KText(text:'Reset', style: TextStyle(color: Color(0xff37D1D3))),
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

              visiblity == true ?
                  
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(border: Border.all(color: const Color(0xff262626).withOpacity(0.10)), borderRadius: BorderRadius.circular(30) ),
                        child:
                        SizedBox(
                          height: 40,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30, right: 30),
                            child:
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                    width: 70,
                                    child: KText(text:'S.No', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 18),)),
                                SizedBox(
                                    width: 120,
                                    child: KText(text:'User ID', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),)),
                                SizedBox(
                                    width: 170,
                                    child: KText(text:'Name', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),)),
                                SizedBox(
                                    width: 150,
                                    child: KText(text:'Fees For', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),)),
                                SizedBox(
                                    width: 150,
                                    child: KText(text:'Method', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),)),

                                SizedBox(
                                    width: 150,
                                    child: KText(text:'Amount', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),)),
                                SizedBox(
                                    width: 130,
                                    child: KText(text:'Date', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),)),
                                SizedBox(
                                    width: 100,
                                    child: KText(text:'Time', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),)),

                              ],),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      StreamBuilder(stream: FirebaseFirestore.instance.collection('Feesreports').where('date', isEqualTo:getSelectedDate()).snapshots(), builder: (context, snapshot) {
                        if(snapshot.hasData){
                          double totalCollectionAmount = getTotalCollectionAmount(snapshot.data!);

                          return ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                            var data = snapshot.data!.docs[index];
                            int serialNumber = index + 1;

                            return  Padding(
                              padding: const EdgeInsets.only(left: 30, right: 30),
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: 70,
                                      child: KText(text:serialNumber.toString(), style: GoogleFonts.openSans( fontSize: 18),)),
                                  SizedBox(
                                      width: 120,
                                      child: KText(text:data['userid'], style: GoogleFonts.openSans( fontSize: 18),)),
                                  SizedBox(
                                      width: 170,
                                      child: KText(text:data['name'], style: GoogleFonts.openSans( fontSize: 18),)),
                                  SizedBox(
                                      width: 150,
                                      child: KText(text:data['feesType'], style: GoogleFonts.openSans( fontSize: 18),)),
                                  SizedBox(
                                      width: 150,
                                      child: KText(text:data['paymentMethod'], style: GoogleFonts.openSans( fontSize: 18),)),

                                  SizedBox(
                                      width: 150,
                                      child: KText(text:data['amount'].toString(), style: GoogleFonts.openSans( fontSize: 18),)),
                                  SizedBox(
                                      width: 130,
                                      child: KText(text:data['date'], style: GoogleFonts.openSans( fontSize: 18),)),
                                  SizedBox(
                                      width: 100,
                                      child: KText(text:data['time'], style: GoogleFonts.openSans( fontSize: 18),)),

                                ],),
                            );


                          },itemCount: snapshot.data!.docs.length,);
                        }else{
                          return const CircularProgressIndicator();
                        }
                      },),
                    ],
                  ) : Container(),


                  






              ResidentName.text != ''  && visiblity == false?
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
                              title: KText(
                               text: searchSuggestions[index]['name'],
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
                               padding: const EdgeInsets.all(10),
                               child: Column(children: [
                                 UserMiniDetails(IconName: Icons.contact_mail, iName: 'User ID                : '  ,userDet: selectedUser!['userid']),
                                 const SizedBox(height: 8,),
                                 UserMiniDetails(IconName: Icons.phone, iName: 'Phone Number  :      ',userDet: selectedUser!['phone']),
                                 const SizedBox(height: 48,),
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
                       child: SingleChildScrollView(
                         child: Column(children: [
                          const SizedBox(height: 20,),
                            Row(children: [
                              KText(text:'Selected Fees                    :     ', style: GoogleFonts.openSans(fontWeight: FontWeight.w600 ),),
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
                                        hint: KText(
                                          text:'Select Fee', style:
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
                                              child: KText(text:
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
                             KText(text:'Payment Method              :     ',style: GoogleFonts.openSans(fontWeight: FontWeight.w600 )),
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
                                       hint: KText(
                                         text:
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
                                             child: KText(
                                               text:
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
                              KText(text:'Payment Amount             :     ',style: GoogleFonts.openSans(fontWeight: FontWeight.w600,  )),
                             const SizedBox(height: 30),
                             CustomTextField(hint: 'Enter the Amount', controller: paymentAmount, validator: null, header: '', width: 430,)
                           ],),
                           const SizedBox(height: 30,),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.end,
                             children: [
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
                                           backgroundColor: const MaterialStatePropertyAll(Color(0xff37D1D3)),
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
                                               const CustomSnackBar.success(
                                                 message: "Fees Added Successfully",
                                               ),
                                             );
                                           } else {
                                             print('Write');
                                             showTopSnackBar(
                                               Overlay.of(context),
                                               const CustomSnackBar.error(
                                                 message: "Please Enter all the fields",
                                               ),
                                             );
                                           }
                                         },
                                         child: Row(
                                           children: [
                                             KText(text:'Submit', style: GoogleFonts.openSans(color: Colors.white)),
                                             SizedBox.fromSize(size: const Size(8, 0)),
                                             const Icon(Icons.save, size: 18, color: Colors.white),
                                           ],
                                         ),
                                       ),
                                     ),
                                   ],
                                 ),
                               ),
                             const SizedBox(width: 10,),
                             //   view all button
                               SizedBox(
                                 width: 120,
                                 height: 40,
                                 child: ElevatedButton(
                                     style: ElevatedButton.styleFrom(
                                         backgroundColor: const Color(0xff37D1D3),
                                         textStyle: GoogleFonts.openSans(
                                             fontWeight: FontWeight.w600, color: Colors.white, fontSize: 15
                                         )
                                     ),
                                     onPressed: (){
                                       setState(() {
                                         viewAllHistory = !viewAllHistory;
                                       });
                                     }, child:  KText( text:
                                     viewAllHistory ? 'View Less' : 'View All', style: GoogleFonts.openSans(),)),
                               ),
                             ],
                           ),
                           const SizedBox(height: 30,),
                           SizedBox(
                             child: Row(children: [
                               KText(text:'Previous Payments          :     ',style: GoogleFonts.openSans(fontWeight: FontWeight.w600 )),
                              Container(
                                width: 510,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                 children: [
                                 SizedBox(
                                     width: 80,
                                     child: KText(text:'Date', style: GoogleFonts.openSans(fontWeight: FontWeight.w600,),)),
                                 SizedBox(child: KText(text:'Fees Type', style: GoogleFonts.openSans(fontWeight: FontWeight.w600,))),
                                 SizedBox(child: KText(text:'Amount', style: GoogleFonts.openSans(fontWeight: FontWeight.w600,))),
                                 SizedBox(child: KText(text:'Method', style: GoogleFonts.openSans(fontWeight: FontWeight.w600,))),
                                 ],),
                              )
                             ],),
                           ),
                           const SizedBox(height: 15,),
                          StreamBuilder(stream: FirebaseFirestore.instance.collection('Users').doc(selectedUser?['docId']).collection('fees').orderBy("timestamp", descending: true).snapshots(), builder: (context, snapshot) {
                             if(snapshot.hasData){
                               List<DocumentSnapshot> documents = snapshot.data!.docs;
                               int itemCount = viewAllHistory ? documents.length : min(documents.length, 5);
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
                                                   child: Text(data['date'], style: GoogleFonts.openSans(fontWeight: FontWeight.w600,color: const Color(0xff262626).withOpacity(0.8)),)),
                                             ),
                                             Container(
                                                 width: 100,
                                                 child: KText(text:data['feesType'], style: GoogleFonts.openSans(fontWeight: FontWeight.w600,color: const Color(0xff262626).withOpacity(0.8)))),
                                             Padding(
                                               padding: const EdgeInsets.only(left: 10, right: 0),
                                               child: Container(
                                                   width: 60,
                                                   child: KText(text:'₹${data['fees'].toString()}', style: GoogleFonts.openSans(fontWeight: FontWeight.w600,color: const Color(0xff262626).withOpacity(0.8)))),
                                             ),
                                             Padding(
                                               padding: const EdgeInsets.only(left: 25),
                                               child: Container(
                                                   width: 60,
                                                   child: KText(text: data['paymentMethod'].toString(), style: GoogleFonts.openSans(fontWeight: FontWeight.w600,color: const Color(0xff262626).withOpacity(0.8)))),
                                             ),
                                           ],),
                                       ),
                                     ),
                                   ),
                                 );
                               },
                                 // itemCount:  snapshot.data!.docs.length,
                               itemCount: itemCount,
                               );
                           }else{
                               return const CircularProgressIndicator();
                             }
                           },),
                           const SizedBox(height: 10,),
                         ],),
                       ),
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
    //getting the document ID
    DocumentReference documentRef =
    mainCollection.doc(selectedUser!['docId']);

    //getting the document ID
    DocumentReference fcmToken =
    mainCollection.doc(selectedUser!['fcmToken']);

    // creating a new sub collection
    CollectionReference subcollectionRef =
    documentRef.collection('fees');
    // mentioned timestamp
    int millisecondsSinceEpoch = Timestamp.now().millisecondsSinceEpoch;
    // adding the data to user's fees collection
    await subcollectionRef.add({
      'fees': fees,
      'paymentMethod': paymentMethod,
      'feesType': paymentFor,
      'date': formattedDate,
      'timestamp': millisecondsSinceEpoch
    });
    sendPushMessage(title:'Fee Message',body: 'You have paid ₹${fees} for ${paymentFor} ',token: selectedUser!['fcmToken']);





    print('Subcollection created successfully');

    // Fees reports collection
    CollectionReference feesReportsCollection =
    FirebaseFirestore.instance.collection('Feesreports');
    // Add data to Fees reports collection
    await feesReportsCollection.add({
      'userid': selectedUser!['userid'],
      'name': selectedUser!['name'],
      'paymentMethod': paymentMethod,
      'feesType': paymentFor,
      'date':  DateFormat('dd-MM-yyyy').format(DateTime.now()),
      'time': DateFormat('h:mm a').format(DateTime.now()),
      'amount': fees,
    });
    print('Data added to Fees reports collection successfully');
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final formattedDate = "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";
    return formattedDate;
  }

  String getSelectedDate() {
    return selectedFeesDate != null
        // ? DateFormat('yyyy-MM-dd').format(selectedFeesDate!)
        // : DateFormat('yyyy-MM-dd').format(DateTime.now());

    ? DateFormat('dd-MM-yyyy').format(selectedFeesDate!)
        : DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  Future<void> feesDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDate: selectedFeesDate ?? DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedFeesDate = picked;
        feesDate.text = DateFormat('yyyy-MM-dd').format(picked);
      });

    } else {
      setState(() {
        selectedFeesDate = DateTime.now();
        feesDate.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
      });

    }
  }

  /// for notifications
  void sendPushMessage({required String token, required String body, required String title}) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
          'key=${Constants.apiKeyForNotification}',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': body, 'title': title},
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }
}

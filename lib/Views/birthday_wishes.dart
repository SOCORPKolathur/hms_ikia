

import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../Constants/constants.dart';
import '../widgets/ReusableHeader.dart';
import '../widgets/kText.dart';

class BirthdayWishes extends StatefulWidget {
  const BirthdayWishes({Key? key}) : super(key: key);

  @override
  State<BirthdayWishes> createState() => _BirthdayWishesState();
}

class _BirthdayWishesState extends State<BirthdayWishes> {





  late List<String> fcmTokens = [];
  late QuerySnapshot? _snapshotData;

  @override
  void initState() {
    // Initialize Firebase
    Firebase.initializeApp().then((_) {
      // Load FCM tokens
      loadTokens();
    });
    super.initState();
  }

  // Define the sendBirthdayWishesToAll method
  void sendBirthdayWishesToAll(List<String> tokens, QuerySnapshot snapshot) {
    // Get users whose birthday is today
    var todayUsers = snapshot.docs.where((userDoc) {
      var dob = userDoc['dob'] as String;
      var dobParts = dob.split('/');
      var userBirthday = DateTime(DateTime.now().year, int.parse(dobParts[1]), int.parse(dobParts[0]));
      var today = DateTime.now();
      return userBirthday.month == today.month && userBirthday.day == today.day;
    }).toList();

    // Send wishes to users whose birthday is today
    for (var user in todayUsers) {
      var token = user['fcmToken'] as String;
      sendPushMessage(token: token, title: 'Birthday Wish', body: 'Wish You Happy Birthday...');
    }
  }


// Method to load FCM tokens from Firestore
  void loadTokens() async {
    var usersSnapshot = await FirebaseFirestore.instance.collection('Users').get();
    setState(() {
      fcmTokens = usersSnapshot.docs.map((doc) => doc['fcmToken'] as String).toList();
    });
  }

  final Color _svgColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ReusableHeader(Headertext: 'Birthday Wishes ', SubHeadingtext: '"Birthday Wishes Records"'),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(border: Border.all(color: const Color(0xff262626).withOpacity(0.10)), borderRadius: BorderRadius.circular(30)),
                    child: SizedBox(
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: Row(
                          children: [
                            SizedBox(width: 70, child: KText(text: 'S.No', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18))),
                            SizedBox(width: 200, child: Center(child: KText(text: 'Profile', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18)))),
                            SizedBox(width: 200, child: KText(text: 'User ID', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18))),
                            SizedBox(width: 200, child: KText(text: 'Name', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18))),
                            SizedBox(width: 110, child: KText(text: 'Phone', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18))),
                            SizedBox(width: 200, child: Center(child: KText(text: 'DOB', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18)))),
                          ],
                        ),
                      ),
                    ),
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('Users').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _snapshotData = snapshot.data as QuerySnapshot?;
                        // Filtering users whose birthday is today
                        var todayUsers = (snapshot.data! as QuerySnapshot).docs.where((userDoc) {
                          var dob = userDoc['dob'] as String;
                          var dobParts = dob.split('/');
                          var userBirthday = DateTime(DateTime.now().year, int.parse(dobParts[1]), int.parse(dobParts[0]));
                          var today = DateTime.now();
                          return userBirthday.month == today.month && userBirthday.day == today.day;
                        }).toList();

                        return Column(
                          children: [
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 180,
                                  height: 35,
                                  child: ElevatedButton(
                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff39cad0))),
                                    onPressed: () {
                                      successPopUp(context);
                                    },
                                    child: Text('Send Wishes', style: GoogleFonts.openSans(color: Colors.white)),
                                  ),
                                ),
                                SizedBox(width: 8,),
                              ],
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var userData = todayUsers[index];
                                return Container(
                                  child: SizedBox(
                                    height: 40,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 70, child: KText(text: (index + 1).toString(), style: GoogleFonts.openSans(fontSize: 18))),
                                          SizedBox(
                                            width: 200,
                                            child: Center(
                                              child: CircleAvatar(
                                                radius: 30,
                                                backgroundColor: Colors.transparent,
                                                child: CachedNetworkImage(
                                                  imageUrl: userData['imageUrl'],
                                                  width: 30,
                                                  height: 30,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 200, child: KText(text: userData['userid'], style: GoogleFonts.openSans(fontSize: 18))),
                                          SizedBox(width: 200, child: KText(text: userData['firstName'], style: GoogleFonts.openSans(fontSize: 18))),
                                          SizedBox(width: 180, child: KText(text: userData['phone'], style: GoogleFonts.openSans(fontSize: 18))),
                                          SizedBox(width: 200, child: KText(text: userData['dob'], style: GoogleFonts.openSans(fontSize: 18))),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: todayUsers.length,
                            ),
                          ],
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Success popup
  Future<void> successPopUp(BuildContext con) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          content: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Container(
              padding: EdgeInsets.zero,
              color: Colors.white,
              height: 380,
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
                          child: CircleAvatar(
                            backgroundColor: const Color(0xffF5F6F7),
                            radius: 30,
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(Icons.close, color: Colors.grey, size: 18),
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(height: 130, width: 130, child: Image.asset('assets/ui-design-/images/Group 107.png')),
                        SizedBox(height: 150, width: 150, child: Image.asset('assets/ui-design-/images/Messaging-cuate .png')),
                        SizedBox(height: 130, width: 130, child: Image.asset('assets/ui-design-/images/Group 108.png')),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 20),
                      child: KText(
                        text: 'Are you sure you want to send this Message?',
                        style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 17),
                      ),
                    ),
                    KText(
                      text: 'Once sent, it cannot be changed.',
                      style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 17),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 130,
                          height: 42,
                          child: ElevatedButton(
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color(0xffF5F5F5))),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: KText(
                              text: 'Cancel',
                              style: GoogleFonts.openSans(fontSize: 17, fontWeight: FontWeight.w700, color: const Color(0xff262626).withOpacity(0.8)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: 130,
                          height: 42,
                          child: ElevatedButton(
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color(0xff1DA644))),
                            onPressed: () {
                              // Send birthday wishes to users with birthday today
                              if (_snapshotData != null) {
                                sendBirthdayWishesToAll(fcmTokens, _snapshotData!);
                                // Show success snackbar
                                showTopSnackBar(
                                  Overlay.of(context)!,
                                  const CustomSnackBar.success(
                                    backgroundColor: Color(0xff3ac6cf),
                                    message: "Message Sent Successfully",
                                  ),
                                );
                                // Close the dialog
                                Navigator.pop(context);
                              } else {
                                // Handle case when snapshot data is null
                                print("Snapshot data is null");
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                KText(
                                  text: 'Send',
                                  style: GoogleFonts.openSans(fontSize: 17, fontWeight: FontWeight.w700, color: const Color(0xffFFFFFF)),
                                ),
                                const Icon(Icons.check_circle, size: 18, color: Color(0xffFFFFFF)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Method to send push notification
  void sendPushMessage({required String token, required String body, required String title}) async {
    try {
      print('FCM Token: $token');
      var response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=${Constants.apiKeyForNotification}',
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

      print('FCM Response: ${response.statusCode}');
      print('FCM Response Body: ${response.body}');
    } catch (e) {
      print('Error sending push notification: $e');
    }
  }}

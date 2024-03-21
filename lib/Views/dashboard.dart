

import 'dart:collection';

import 'package:animate_do/animate_do.dart';
import 'package:country_flags/country_flags.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_ikia/Views/aboutuspage.dart';
import 'package:hms_ikia/Views/login_page.dart';
import 'package:hms_ikia/Views/notifications.dart';
import 'package:hms_ikia/Views/setting.dart';
import 'package:hms_ikia/widgets/event_calender.dart';
import 'package:hms_ikia/widgets/kText.dart';
import 'package:table_calendar/table_calendar.dart';

import '../Constants/constants.dart';

class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
    key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
    value: (item) => List.generate(
        item % 4 + 1, (index) => Event('Event $item | ${index + 1}')))
  ..addAll({
    kToday: [
      Event('Today\'s Event 1'),
      Event('Today\'s Event 2'),
    ],
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
        (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  List name =["JD", "MJ", "VJ"];
  List namelist =["John David", "Mary Jane", "Vignesh Joe"];

  List<Meeting> events = [];
  _showPopupMenu(cxt) async {
    double height=MediaQuery.of(cxt).size.height;
    double width=MediaQuery.of(cxt).size.width;

    await showMenu(
        context: cxt,
        color: const Color(0xffFFFFFF),
        surfaceTintColor: const Color(0xffFFFFFF),
        shadowColor: Colors.black12,
        position:  const RelativeRect.fromLTRB(500, 70, 300, 550),
        items: [


          PopupMenuItem<String>(
            value: 'ta',
            child:  const Text('Tamil'),
            onTap: () {
              changeLocale(cxt, 'ta');
              Constants.flagvalue= "hi";
              Constants.langvalue='Tamil';
            },
          ),
          PopupMenuItem<String>(
            value: 'hi',
            child:  const Text('Hindi'),
            onTap: () {
              setState(() {
                changeLocale(cxt, 'hi');
                Constants. flagvalue= "hi";
                Constants.langvalue='Hindi';
              });
            },
          ),
          PopupMenuItem<String>(
            value: 'te',
            child:  const Text('Telugu'),
            onTap: () {
              changeLocale(cxt, 'te');
              Constants. flagvalue= "hi";
              Constants.langvalue='Telugu';
            },
          ),
          PopupMenuItem<String>(
            value: 'ml',
            child:  const Text('Malayalam'),
            onTap: () {
              setState(() {
                changeLocale(cxt, 'ml');
                Constants. flagvalue= "hi";
                Constants.langvalue='Malayalam';
              });
            },
          ),
          PopupMenuItem<String>(
            value: 'kn',
            child:  const Text('Kannada'),
            onTap: () {
              setState(() {
                changeLocale(cxt, 'kn');
                Constants.flagvalue= "hi";
                Constants. langvalue='Kannada';
              });
            },
          ),
          PopupMenuItem<String>(
            value: 'mr',
            child:  const Text('Marathi'),
            onTap: () {
              setState(() {
                changeLocale(cxt, 'mr');
                Constants.flagvalue= "hi";
                Constants.langvalue='Marathi';
              });
            },
          ),
          PopupMenuItem<String>(
            value: 'gu',
            child:  const Text('Gujarati'),
            onTap: () {
              setState(() {
                changeLocale(cxt, 'gu');
                Constants.flagvalue= "hi";
                Constants.langvalue='Gujarath';
              });
            },
          ),
          PopupMenuItem<String>(
            value: 'ori',
            child:  const Text('Odia'),
            onTap: () {
              setState(() {
                changeLocale(cxt, 'ori');
                Constants. flagvalue= "hi";
                Constants.langvalue='Odia';
              });
            },
          ),
          PopupMenuItem<String>(
            value: 'bn',
            child:  const Text('Bengali'),
            onTap: () {
              setState(() {
                changeLocale(cxt, 'bn');
                Constants.flagvalue= "hi";
                Constants.langvalue='Bengali';
              });
            },
          ),

          /// english Language
          PopupMenuItem<String>(
            value: 'en_US',
            child: const Text('English'),
            onTap: () {
              setState(() {
                changeLocale(cxt, 'en_US');
                Constants.flagvalue= "en";
                Constants. langvalue='English';
              });
              //changeHomeViewLanguage();
            },
          ),

          ///requested language
          PopupMenuItem<String>(
            value: 'es',
            child: Row(
              children: [
                const Text('Requested Language'),
              ],
            ),
            onTap: () {
              //requesteLanguagePopup(context);
            },
          ),

        ],
        elevation: 8.0,
        useRootNavigator: true);
  }
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }



  _showSettingsPopupMenu(cxt) async {
    double height=MediaQuery.of(cxt).size.height;
    double width=MediaQuery.of(cxt).size.width;

    await showMenu(
        context: context,
        color: const Color(0xffFFFFFF),
        surfaceTintColor: const Color(0xffFFFFFF),
        shadowColor: Colors.black12,
        position:  const RelativeRect.fromLTRB(60, 70, 15, 55),
        items: [


          PopupMenuItem<String>(
            value: 'st',
            child:  const Text('Settings'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  SettingPage(),));
            },
          ),
          PopupMenuItem<String>(
            value: 'about us',
            child:  const Text('About Us'),
            onTap: () {
              setState(() {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  AboutUsPage(),));
              });
            },
          ),
          PopupMenuItem<String>(
            value: 'logout',
            child:  const Text('Logout'),
            onTap: () {
              _signOut();
            },
          ),


        ],
        elevation: 8.0,
        useRootNavigator: true);
  }
  _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ));
  }
  @override
  Widget build(BuildContext context) {
    double baseWidth = 1512;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    final double width=MediaQuery.of(context).size.width;
    final double height=MediaQuery.of(context).size.height;
    return FadeInRight(
      child: SingleChildScrollView(
        child: Column(
          children:[
            SizedBox(
              height: 20,
            ),
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Row(
               children: [
        
                 Padding(
                   padding: const EdgeInsets.only(left: 8.0),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                         'WELCOME, ADMIN',
                         style: GoogleFonts.openSans (
                           fontSize: 28*ffem,
                           fontWeight: FontWeight.w700,
                           height: 1.3625*ffem/fem,
                           color: Color(0xff262626),
                         ),
                       ),
                       Text(
                         '"Unlock the Power of Effortless Hostel Management”',
                         style: GoogleFonts.openSans (
                           fontSize: 16*ffem,
                           fontWeight: FontWeight.w600,
                           height: 1.3625*ffem/fem,
                           color: Color(0xa5262626),
                         ),
                       ),
                     ],
                   ),
                 ),
                 SizedBox(
                   width: 20,
                 ),
                 Container(
                   width: 300,
                   height: 50,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(30),
                     color: Color(0xffEFEFEF)
                   
                   ),
                   child: Padding(
                     padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 12),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text("Search here...",
                           style: GoogleFonts.openSans (
                             fontSize: 16*ffem,
                             fontWeight: FontWeight.w600,
                             height: 1.3625*ffem/fem,
                             color: Color(0x99262626),
                           ),
        
        
                         ),
                         Icon(Icons.search_rounded)
                       ],
                     ),
                   ),
                 ),
                 SizedBox(width: 150,),
                 InkWell(
                   onTap:(){
                     _showPopupMenu(context);
                   },
                   child: Container(
                     width:width/9.9,
                     // margin: EdgeInsets.fromLTRB(0*fem, 16.5*fem, 58*fem, 16.5*fem),
                     // padding: EdgeInsets.fromLTRB(0*fem, 0*fem, 7.06*fem, 0*fem),
                     height: 50,
        
                     child: Row(
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         Container(
                           // textnHP (6:113)
        
                           margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 23*fem, 0*fem),
                           padding: EdgeInsets.fromLTRB(0.75*fem, 0*fem, 0*fem, 0*fem),
                           height: double.infinity,
        
                           child: Row(
                             crossAxisAlignment: CrossAxisAlignment.center,
                             children: [
                               Container(
                                 // unitedTPX (6:114)
        
                                 margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 1.75*fem, 0*fem),
                                 width: 32.5*fem,
                                 height: 42.5*fem,
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(50)
                                 ),
                                 child:
                                 CountryFlag.fromLanguageCode(
                                   Constants.flagvalue.toString(),
                                   borderRadius: 50,
                                   // width: 9.94*fem,
                                   // height: 6*fem,
                                 ),
                               ),
                               SizedBox(width: 5,),
                               KText(
                                 text:
                                 // engusYQy (6:130)
                                 Constants.langvalue.toString(),
                                 style: GoogleFonts.openSans (
        
                                   fontSize: 18*ffem,
                                   fontWeight: FontWeight.w600,
                                   height: 1.5*ffem/fem,
                                   color: const Color(0xff374557),
                                 ),
                               ),
                             ],
                           ),
                         ),
                         const Icon(Icons.arrow_drop_down)
                       ],
                     ),
                   ),
                 ),
                 SizedBox(width: 10,),


                 Material(
                   elevation: 4,
                   borderRadius: BorderRadius.circular(38),
                   child: InkWell(
      
                     onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context) =>  NotificationsPage(),));
                     },
                     child: Container(
                       width: 38,
                       height: 38,
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(38),
                       ),
                       child: Icon(Icons.notifications_active),
                     ),
                   ),
                 ),
        
                 SizedBox(width: 10,),
                 Material(
                   elevation: 4,
                   borderRadius: BorderRadius.circular(38),
                   child: InkWell(
                     onTap: (){
                       _showSettingsPopupMenu(context);
                     },
                     child: Container(
                       width: 38,
                       height: 38,
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(38),
                       ),
                       child: Icon(Icons.settings),
                     ),
                   ),
                 ),
               ],
             ),
           ),
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 338,
                              height: 180,
                              decoration: BoxDecoration(
                                color: Color(0xffe2cb3f),
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Stack(
        
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0,top: 10),
                                        child: Text("Hostels",
                                          style: GoogleFonts.openSans (
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700,
                                            height: 1.3625*ffem/fem,
                                            color: Colors.white,
                                          ),
        
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0,top: 10),
                                        child: Text("05",
                                          style: GoogleFonts.openSans (
                                            fontSize: 40,
                                            fontWeight: FontWeight.w700,
                                            height: 1.3625*ffem/fem,
                                            color: Colors.white,
                                          ),
        
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0,top: 15),
                                        child: Container(
                                          width: 130,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            border: Border.all(color: Colors.white)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Text("Entire List",   style: GoogleFonts.openSans (
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.3625*ffem/fem,
                                                  color: Colors.white,
                                                ),),
                                                SizedBox(width: 10,),
                                                Icon(Icons.arrow_circle_right,color: Colors.white)
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 180.0,top: 10),
                                    child: Container(
                                        width: 140,
                                        child: Image.asset("assets/dashbg.png")),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 180.0,top: 10),
                                    child: Container(
                                        width: 140,
                                        child: Image.asset("assets/d1.png")),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 30,),
                            Container(
                              width: 338,
                              height: 180,
                              decoration: BoxDecoration(
                                color: Color(0xff034d7f),
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Stack(
        
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0,top: 10),
                                        child: Text("Rooms",
                                          style: GoogleFonts.openSans (
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700,
                                            height: 1.3625*ffem/fem,
                                            color: Colors.white,
                                          ),
        
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0,top: 10),
                                        child: Text("67",
                                          style: GoogleFonts.openSans (
                                            fontSize: 40,
                                            fontWeight: FontWeight.w700,
                                            height: 1.3625*ffem/fem,
                                            color: Colors.white,
                                          ),
        
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0,top: 15),
                                        child: Container(
                                          width: 130,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            border: Border.all(color: Colors.white)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Text("Entire List",   style: GoogleFonts.openSans (
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.3625*ffem/fem,
                                                  color: Colors.white,
                                                ),),
                                                SizedBox(width: 10,),
                                                Icon(Icons.arrow_circle_right,color: Colors.white)
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 180.0,top: 10),
                                    child: Container(
                                        width: 140,
                                        child: Image.asset("assets/dashbg.png")),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 130.0,top: 30),
                                    child: Container(
                                      width: 500,
        
        
                                        child: Image.asset("assets/d2.png",)),
                                  ),
                                ],
                              ),
                            ),
        
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 338,
                              height: 180,
                              decoration: BoxDecoration(
                                  color: Color(0xfffd7e50),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Stack(
        
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0,top: 10),
                                        child: Text("Beds",
                                          style: GoogleFonts.openSans (
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700,
                                            height: 1.3625*ffem/fem,
                                            color: Colors.white,
                                          ),
        
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0,top: 10),
                                        child: Text("65",
                                          style: GoogleFonts.openSans (
                                            fontSize: 40,
                                            fontWeight: FontWeight.w700,
                                            height: 1.3625*ffem/fem,
                                            color: Colors.white,
                                          ),
        
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0,top: 15),
                                        child: Container(
                                          width: 130,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30),
                                              border: Border.all(color: Colors.white)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Text("Entire List",   style: GoogleFonts.openSans (
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.3625*ffem/fem,
                                                  color: Colors.white,
                                                ),),
                                                SizedBox(width: 10,),
                                                Icon(Icons.arrow_circle_right,color: Colors.white)
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 180.0,top: 10),
                                    child: Container(
                                        width: 140,
                                        child: Image.asset("assets/dashbg.png")),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 160.0,top: 50),
                                    child: Container(
                                        width: 200,
                                        child: Image.asset("assets/d3.png")),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 30,),
                            Container(
                              width: 338,
                              height: 180,
                              decoration: BoxDecoration(
                                  color: Color(0xff46b666),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Stack(
        
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0,top: 10),
                                        child: Text("Hostellers",
                                          style: GoogleFonts.openSans (
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700,
                                            height: 1.3625*ffem/fem,
                                            color: Colors.white,
                                          ),
        
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0,top: 10),
                                        child: Text("89",
                                          style: GoogleFonts.openSans (
                                            fontSize: 40,
                                            fontWeight: FontWeight.w700,
                                            height: 1.3625*ffem/fem,
                                            color: Colors.white,
                                          ),
        
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0,top: 15),
                                        child: Container(
                                          width: 130,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30),
                                              border: Border.all(color: Colors.white)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Text("Entire List",   style: GoogleFonts.openSans (
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.3625*ffem/fem,
                                                  color: Colors.white,
                                                ),),
                                                SizedBox(width: 10,),
                                                Icon(Icons.arrow_circle_right,color: Colors.white)
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 180.0,top: 10),
                                    child: Container(
                                        width: 140,
                                        child: Image.asset("assets/dashbg.png")),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 170.0,top: 10),
                                    child: Container(
                                        width: 500,
                                        height: 200,
        
        
                                        child: Image.asset("assets/d4.png",)),
                                  ),
                                ],
                              ),
                            ),
        
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 748,
                        child: Image.asset("assets/Frame 5033.png")),
                  ],
                ),
                Container(
                  width: 385,
                  child: Column(
                    children: [
                      Image.asset("assets/Frame 5012.png"),
                      Image.asset("assets/Frame 5210.png"),


                    ],
                  ),
                )
              ],
            ),
        
          ]
        ),
      ),
    );
  }
}



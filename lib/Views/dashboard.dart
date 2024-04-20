

import 'dart:collection';
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hms_ikia/Views/block_name.dart';
import 'package:hms_ikia/Views/resident_tab.dart';
import 'package:hms_ikia/Views/rooms.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Constants/constants.dart';
import '../widgets/customtextfield.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as sfc;

import '../widgets/graph.dart';

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
      const Event('Today\'s Event 1'),
      const Event('Today\'s Event 2'),
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


  List<Color> gradientColors = [
    Constants().primaryAppColor,
    Constants().primaryAppColor,
  ];
  List<Color> gradientColors2 = [
    Constants().primaryAppColor.withOpacity(0.25),
    Constants().primaryAppColor.withOpacity(0),

  ];
  bool showAvg = false;


  late TooltipBehavior _tooltipBehavior;

  // textfields
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


  // city
  // district
  // state

  // List<String> city=["Select City","Anna Nagar","Periamet","Chennai"];
  // String selectedcity="Select City";
  //
  // List<String> district=["Select District","Tiruvallur","Vellore","Tirupatur"];
  // String selecteddistrict="Select District";
  //
  // List<String> state=["Select State","Tamil Nadu","Delhi","Karnataka"];
  // String selectedstate="Select State";


  File? Url;
  var Uploaddocument;
  String imgUrl = "";
  imageupload() async {
    var snapshot = await FirebaseStorage.instance.ref().child('Images').child(
        "${Url!.name}").putBlob(Url);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      imgUrl = downloadUrl;
    });
  }
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

  int presentCount = 0;
  int absentCount = 0;
  TextEditingController attendanceDate = TextEditingController();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  DateTime selectedDate = DateTime.now();
  bool AttendanceStatus = false;
  DateTime ? selectedAttDate;
  bool isDataAvailable = true;

  int roomCount = 0;
  int blockCount = 0;
  int Hostellers = 0;

  int totalBedCount = 0;
  int vacantBedCount = 0;

  Future<void> getRoomsLength() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Room').get();
      int length = querySnapshot.docs.length;
      setState(() {
        roomCount = length;
      });
    } catch (e) {
      print("Error getting rooms length: $e");
    }
  }
  //get hostellers
  Future<void> getHostellersLength() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Users').get();
      int length = querySnapshot.docs.length;
      setState(() {
        Hostellers = length;
      });
    } catch (e) {
      print("Error getting rooms length: $e");
    }
  }

//   get block count
  Future<void> getBlockCounts() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Block').get();
      int length = querySnapshot.docs.length;
      setState(() {
        blockCount = length;
      });
    } catch (e) {
      print("Error getting block length: $e");
    }
  }





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
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text('Requested Language'),
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
    getBlockCounts();
    _tooltipBehavior = TooltipBehavior(enable: true);
    getRoomsLength();
    fetchBedCounts();
    getHostellersLength();
    calculateAttendanceCount();



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

  // the popUp menu

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
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  const SettingPage(),));
            //   for settings
            //   showSettingsPopUp(context);

            },
          ),
          PopupMenuItem<String>(
            value: 'about us',
            child:  const Text('About Us'),
            onTap: () {
              setState(() {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  const AboutUsPage(),));
              });
            },
          ),
          PopupMenuItem<String>(
            value: 'logout',
            child:  const Text('Logout'),
            onTap: () {
              LogoutPopUp();
              // _signOut();
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

  String pagetype = "";


  @override
  Widget build(BuildContext context) {
    int totalCount = presentCount + absentCount;
    double presentPercentage = totalCount > 0 ? (presentCount / totalCount) * 100 : 0.0;
    double absentPercentage = totalCount > 0 ? (absentCount / totalCount) * 100 : 0.0;

    double baseWidth = 1512;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    final double width=MediaQuery.of(context).size.width;
    final double height=MediaQuery.of(context).size.height;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        pagetype == ""?FadeInRight(
          child: SingleChildScrollView(
            child: Column(
                children:[
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,


                      children: [

                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              KText(
                                text: 'WELCOME, ADMIN'
                                ,
                                style: GoogleFonts.openSans (
                                  fontSize: 28*ffem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.3625*ffem/fem,
                                  color: const Color(0xff262626),
                                ),
                              ),
                              KText(
                                text:'"Unlock the Power of Effortless Hostel Management”',
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
                        const SizedBox(
                          width: 320,
                        ),
                        const SizedBox(width: 150,),
                        InkWell(
                          onTap:(){
                            _showPopupMenu(context);
                          },
                          child: SizedBox(
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
                                      const SizedBox(width: 5,),
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
                        const SizedBox(width: 10,),
                        Material(
                          elevation: 4,
                          borderRadius: BorderRadius.circular(38),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>  const NotificationsPage(),));
                            },
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(38),
                              ),
                              child: const Icon(Icons.notifications_active),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10,),

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
                              child: const Icon(Icons.settings),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
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
                                        color: const Color(0xffe2cb3f),
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Stack(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding: const EdgeInsets.only(left: 15.0,top: 10),
                                                child: KText( text: "Blocks",
                                                  style: GoogleFonts.openSans (
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w700,
                                                    height: 1.3625*ffem/fem,
                                                    color: Colors.white,
                                                  ),
                                                )
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 15.0,top: 10),
                                              child: Text(blockCount.toString().padLeft(2,"0"),
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
                                              child: InkWell(
                                                onTap: (){
                                                  setState(() {
                                                    pagetype="Blocks";
                                                  });
                                                },
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
                                                        const SizedBox(width: 10,),
                                                        const Icon(Icons.arrow_circle_right,color: Colors.white)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 180.0,top: 10),
                                          child: SizedBox(
                                              width: 140,
                                              child: Image.asset("assets/dashbg.png")),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 180.0,top: 10),
                                          child: SizedBox(
                                              width: 140,
                                              child: Image.asset("assets/d1.png")),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 30,),
                                  Container(
                                    width: 338,
                                    height: 180,
                                    decoration: BoxDecoration(
                                        color: const Color(0xff034d7f),
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Stack(

                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding: const EdgeInsets.only(left: 15.0,top: 10),
                                                child: KText( text: "Rooms",
                                                  style: GoogleFonts.openSans (
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w700,
                                                    height: 1.3625*ffem/fem,
                                                    color: Colors.white,
                                                  ),
                                                )
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(left: 15.0,top: 10),
                                              child: Text(roomCount.toString().padLeft(2,"0"),
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
                                              child: InkWell(
                                                onTap: (){
                                                  setState(() {
                                                    pagetype="Rooms";
                                                  });
                                                },
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
                                                        const SizedBox(width: 10,),
                                                        const Icon(Icons.arrow_circle_right,color: Colors.white)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 180.0,top: 10),
                                          child: SizedBox(
                                              width: 140,
                                              child: Image.asset("assets/dashbg.png")),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 130.0,top: 30),
                                          child: SizedBox(
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
                                        color: const Color(0xfffd7e50),
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Stack(

                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding: const EdgeInsets.only(left: 15.0,top: 10),
                                                child: KText( text: "Beds",
                                                  style: GoogleFonts.openSans (
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w700,
                                                    height: 1.3625*ffem/fem,
                                                    color: Colors.white,
                                                  ),
                                                )
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(left: 15.0,top: 10),
                                              child: Text("$totalBedCount",
                                                // child: Text('$totalBedCount',
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
                                              child: InkWell(
                                                onTap: (){
                                                  setState(() {
                                                    pagetype="Rooms";
                                                  });
                                                },
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
                                                        KText(text: "Entire List",   style: GoogleFonts.openSans (
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w600,
                                                          height: 1.3625*ffem/fem,
                                                          color: Colors.white,
                                                        ),),
                                                        const SizedBox(width: 10,),
                                                        const Icon(Icons.arrow_circle_right,color: Colors.white)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 180.0,top: 10),
                                          child: SizedBox(
                                              width: 140,
                                              child: Image.asset("assets/dashbg.png")),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 160.0,top: 50),
                                          child: SizedBox(
                                              width: 200,
                                              child: Image.asset("assets/d3.png")),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 30,),
                                  Container(
                                    width: 338,
                                    height: 180,
                                    decoration: BoxDecoration(
                                        color: const Color(0xff46b666),
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Stack(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding: const EdgeInsets.only(left: 15.0,top: 10),
                                                child: KText( text: "Hostelers",
                                                  style: GoogleFonts.openSans (
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w700,
                                                    height: 1.3625*ffem/fem,
                                                    color: Colors.white,
                                                  ),
                                                )
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(left: 15.0,top: 10),
                                              child: Text(Hostellers.toString().padLeft(2,"0"),
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
                                              child: InkWell(
                                                onTap: (){
                                                  setState(() {
                                                    pagetype="Hosterllers";
                                                  });
                                                },
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
                                                        KText(text:"Entire List",   style: GoogleFonts.openSans (
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w600,
                                                          height: 1.3625*ffem/fem,
                                                          color: Colors.white,
                                                        ),),
                                                        const SizedBox(width: 10,),
                                                        const Icon(Icons.arrow_circle_right,color: Colors.white)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 180.0,top: 10),
                                          child: SizedBox(
                                              width: 140,
                                              child: Image.asset("assets/dashbg.png")),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 170.0,top: 10),
                                          child: SizedBox(
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

                          const SizedBox(height: 20,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text('Check In / Check Out Report', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 19)),
                              ),
                              Divider(thickness: 1),
                              Container(
                                width: 700,
                                decoration: BoxDecoration(border: Border.all(color: const Color(0xff262626).withOpacity(0.10)), borderRadius: BorderRadius.circular(30) ),
                                child:
                                SizedBox(
                                  height: 40,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 30, right: 30),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                            width: 50,
                                            child: KText(text:'S.No', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),)),
                                        SizedBox(
                                            width: 70,
                                            child: KText(text:'User ID', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),)),
                                        SizedBox(
                                            width: 120,
                                            child: KText(text:'Name', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),)),
                                        SizedBox(
                                            width: 130,
                                            child: KText(text: 'Phone No', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),)),
                                        SizedBox(
                                            width: 110,
                                            child: Center(child: KText(text:'Status', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),))),
                                      ],),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          StreamBuilder(stream: FirebaseFirestore.instance.collection('Users').snapshots(), builder: (context, snapshot) {
                            print(snapshot);
                            if (snapshot.hasData) {
                              // var documents = snapshot.data!.docs;
                              return SizedBox(
                                height: 800,
                                width: 700,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    if(snapshot.hasData){
                                      final document = snapshot.data!.docs[index];
                                      int serialNumber = index + 1;
                                      return Container(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10, right: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SizedBox(
                                                  width: 50,
                                                  child: Text(serialNumber.toString(),
                                                    style: GoogleFonts.openSans(fontSize: 18),)),
                                              SizedBox(
                                                  width: 80,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 0),
                                                    child: Text(document['userid'],
                                                      style: GoogleFonts.openSans(fontSize: 18),),
                                                  )),
                                              SizedBox(
                                                  width: 135,
                                                  child: Text(document['firstName'],
                                                    style: GoogleFonts.openSans(fontSize: 18),)
                                              ),
                                              SizedBox(
                                                // color: Colors.grey,
                                                  width: 130,
                                                  child: Text('${document['phone']}',
                                                    style: GoogleFonts.openSans(
                                                        fontSize: 18),)),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 15),
                                                child: SizedBox(
                                                    height: 50,
                                                    width: 120,
                                                    child: Center(child: ElevatedButton(
                                                      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(document['status'] == true ? Color(0xffDDFFE7) : Color(0xffFFD3D3))),
                                                      onPressed: () {}, child: Text(document['status'] == true ? 'Check In' : 'Check Out', style: GoogleFonts.openSans(color: document['status'] == true ?Color(0xff1DA644) : Color(0xffF12D2D), fontSize: 13),),)
                                                    )
                                                ),
                                              ),
                                            ],),
                                        ),
                                      );
                                    }
                                  },
                                  itemCount: snapshot.data!.docs.length,
                                ),
                              );
                            }
                            else {
                              return Center(
                                child: SizedBox(
                                  width: 200,
                                  height: 230,
                                  child: Center(
                                    child: Lottie.asset('assets/ui-design-/noData.json'),
                                  ),
                                ),
                              );
                            }
                          },
                          )
                        ],
                      ),
                      const SizedBox(width: 20,),
                      SizedBox(
                        width: 350,
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          // Container(
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(10),
                          //     boxShadow: [
                          //       BoxShadow(
                          //         color: Colors.grey.withOpacity(0.5),
                          //         spreadRadius: 2,
                          //         blurRadius: 7,
                          //         blurStyle: BlurStyle.outer,
                          //         offset: const Offset(0,5),
                          //       ),
                          //     ],
                          //   ),
                          //   child: TableCalendar(
                          //     calendarStyle: CalendarStyle(
                          //       isTodayHighlighted: true,
                          //       selectedDecoration: const BoxDecoration(), todayDecoration: BoxDecoration(color: const Color(0xff37D1D3), borderRadius: BorderRadius.circular(50)), ),
                          //     firstDay: DateTime.utc(2010, 10, 16),
                          //     lastDay: DateTime.utc(2030, 3, 14),
                          //     focusedDay: DateTime.now(),
                          //   ),
                          // ),


                          // GraphTem(),
                          Text('Fees Reports', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
                          SizedBox(height: 10,),




                          Material(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(12),
                            shadowColor:  Constants().primaryAppColor.withOpacity(0.20),
                            child: Container(
                              width: 600,
                              height: 200,
                              child: Stack(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 10,
                                      left: 12,
                                      top: 24,
                                      bottom: 12,
                                    ),
                                    child: LineChart(
                                      mainData(),

                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),


                          const SizedBox(height: 30,),
                            // indicator here
                          Container(
                            width: 350,
                            height: 350,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  blurStyle: BlurStyle.outer,
                                  offset: const Offset(0,5),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      KText(text: 'Attendance Analytics', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
                                    ],
                                  ),
                                  const SizedBox(height: 20,),
                                  _buildAttendanceInfo( presentCount, presentPercentage),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text('${presentPercentage.toStringAsFixed(1)}%', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
                                          Row(children: [
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: const BoxDecoration(
                                                  gradient: RadialGradient(
                                                    focalRadius: 0.20,
                                                    radius: 0.40,
                                                    center: Alignment(0.10, -0.20),
                                                    colors: [
                                                      Color(0xffABD2FF),
                                                      Color(0xff1982FD),
                                                    ],
                                                    stops: <double>[0.4, 1.0],
                                                  ),
                                                  borderRadius: BorderRadius.all(Radius.circular(50))),),
                                            const SizedBox(width: 10,),
                                            KText(text: 'Present', style: GoogleFonts.openSans(fontWeight: FontWeight.w600,fontSize: 16, color: const Color(0xff262626).withOpacity(0.8) ))
                                          ],)
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text('${absentPercentage.toStringAsFixed(1)}%', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
                                          Row(children: [
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: const BoxDecoration(
                                                  gradient: RadialGradient(
                                                    focalRadius: 0.20,
                                                    radius: 0.40,
                                                    center: Alignment(0.10, -0.20),
                                                    colors: [
                                                      Color(0xffE7C0FF),
                                                      Color(0xffB344F6)
                                                    ],
                                                    stops: <double>[0.4, 1.0],
                                                  ),
                                                  // color: Color(0xffB344F6),
                                                  borderRadius: BorderRadius.all(Radius.circular(50))),),
                                            const SizedBox(width: 10,),
                                            KText(text: 'Absent', style: GoogleFonts.openSans(fontWeight: FontWeight.w600,fontSize: 16, color: const Color(0xff262626).withOpacity(0.8) ))
                                          ],)
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )

                        ],),
                      )
                    ],
                  ),
                ]
            ),
          ),
        ) : pagetype == "Blocks"? const BlockName() : pagetype == "Rooms"? const Rooms(): const Resident_Tab(),
        pagetype != ""?  BounceInDown(
          child: Padding(
            padding: const EdgeInsets.only(top:10.0),
            child: InkWell(
              onTap: (){
                setState(() {
                  pagetype="";
                });
              },
              child: Material(
              borderRadius: BorderRadius.circular(50),
                elevation: 4,
                child: Container(width:45,height:45,
          
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50)
                ),
                  child: const Center(child: Icon(Icons.clear))
          
          
                ),
              ),
            ),
          ),
        ) : const SizedBox()
      ],
    );
  }
  // date
  String getSelectedDate() {
    return selectedAttDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedAttDate!)
        : DateFormat('yyyy-MM-dd').format(DateTime.now());
  }
  Future<void> AttendaceDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDate: selectedAttDate ?? DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedAttDate = picked;
        attendanceDate.text = DateFormat('yyyy-MM-dd').format(picked);
      });
      fetchAttendanceData(DateFormat('yyyy-MM-dd').format(picked));
    } else {
      setState(() {
        selectedAttDate = DateTime.now();
        attendanceDate.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
      });
      fetchAttendanceData(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    }
  }

  // fetch the data
  Future fetchAttendanceData(String selectedDate) async {
    DocumentSnapshot attendanceDoc = await FirebaseFirestore.instance
        .collection('Attendance')
        .doc(selectedDate)
        .get();
    if (attendanceDoc.exists) {
      // Data is available
      isDataAvailable = true;
    } else {
      // Data is not available
      isDataAvailable = false;
    }
  }
  Future<void> fetchBedCounts() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Room').get();
      print("Number of documents: ${querySnapshot.size}"); // Debugging: Print number of documents retrieved
      querySnapshot.docs.forEach((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        print("Data fetched: $data"); // Debugging: Print fetched data
        totalBedCount += (data['bedcount'] ?? 0) as int;
        vacantBedCount += (data['Vacant'] ?? 0) as int;
      });
      print("Total Bed Count: $totalBedCount");
      print("Vacant Bed Count: $vacantBedCount");
      setState(() {}); // Update the UI with new counts
    } catch (e) {
      print('Error fetching bed counts: $e');
    }
  }

  Future<void> calculateAttendanceCount() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Attendance')
        .doc(getSelectedDate())
        .collection('Residents')
        .get();

    snapshot.docs.forEach((doc) {
      if (doc['attendanceStatus'] == true) {
        presentCount++;
      } else {
        absentCount++;
      }
    });

    setState(() {});
  }

  Widget _buildAttendanceInfo(int count, double percentage) {
    return Column(
      children: [
        const SizedBox(height: 10),
        CircularPercentIndicator(
          radius: 70,
          lineWidth: 25,
          animation: true,
          percent: percentage / 100,
          center: Text(
            '${percentage.toStringAsFixed(1)}%',
            style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          progressColor: const Color(0xff1982FD),
          // progressColor: status == 'Present' ? Color(0xff1982FD) : Color(0xffB344F6),
          circularStrokeCap: CircularStrokeCap.round,
          backgroundColor: const Color(0xffB344F6),
        ),
      ],
    );
  }

  Future<void> showSettingsPopUp(BuildContext con) async {
    await setHostelDetails('j9TCvPYC9Y6AzQeNcpH9',context);
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('HostelDetails').doc('j9TCvPYC9Y6AzQeNcpH9').get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    double baseWidth = 1512;
    double fem = MediaQuery.of(con).size.width / baseWidth;
    double ffem = fem * 0.97;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: SingleChildScrollView(
              child: Column(
                children: [
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
                              Padding(
                                padding: const EdgeInsets.only(left: 35.0),
                                child: KText(
                                  // addresidentdetailsvyb (87:1511)
                                  text:'Update Hostel Details',
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
                                            child: KText(
                                              text:'Upload Hostel Photo\n( 150px * 150px)',
                                              style: GoogleFonts.openSans (
                                                fontSize: 14*ffem,
                                                fontWeight: FontWeight.w600,
                                                height: 1.3625*ffem/fem,
                                                color: const Color(0x7f262626),
                                              ),
                                              // textAlign: TextAlign.center,

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
                                              child: KText(
                                                text: 'Choose Image',
                                                style: GoogleFonts.openSans (
                                                  fontSize: 16*ffem,
                                                  fontWeight: FontWeight.w700,
                                                  height: 1.3625*ffem/fem,
                                                  color: const Color(0xff37d1d3),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
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
                              SizedBox(
                                width: double.infinity,
                                child: KText(
                                  text: 'Hostel Details',
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
                          // Textfield
                            CustomTextField(header: "Hostel Name",hint: "Hostel Name",controller: hostelname,validator: null,),
                            const SizedBox(width: 18,),
                            CustomTextField(header: "Hostel Phone Number",hint: "Hostel Phone Number",controller: hostelphone,validator: null,),
                            const SizedBox(width: 18,),
                            CustomTextField(header: "Hostel Email",hint: "Hostel Email",controller: hostelemail,validator: null,),
                            const SizedBox(width: 18,),
                            CustomTextField(header: "Bulding No",hint: "Bulding No",controller: buildingno,validator: null,),

                          ],
                        ),

                        const SizedBox(height: 25,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            CustomTextField(header: "Area",hint: "Enter phone number",controller: area,validator: null,),
                            const SizedBox(width: 18,),

                            CustomTextField(header: "Pin Code",hint: "Enter Pin Code",controller: pincode,validator: null,),
                            const SizedBox(width: 18,),
                            const SizedBox(width: 18,),
                            CustomTextField(header: "City",hint: "Enter Pin Code",controller: city,validator: null,),
                            const SizedBox(width: 18,),
                            CustomTextField(header: "District",hint: "District Name",controller: district,validator: null,),
                            const SizedBox(width: 18,),



                          ],
                        ),
                        const SizedBox(height: 18,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomTextField(header: "State",hint: "State Name",controller: state,validator: null,
                              width: 200,
                            ),
                            const SizedBox(width: 18,),
                            CustomTextField(header: "Website Link",hint: "Website Link",controller: weblink,validator: null,
                              width: 200,
                            ),
                          ],
                        ),


                        Row(
                          children: [
                            InkWell(
                              onTap: (){
                                Navigator.of(context).pop();
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
                                // updateuser(id);
                                updateHostelDetails('j9TCvPYC9Y6AzQeNcpH9');
                                Navigator.pop(context);
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
                ],
              ),
            )

        );
      },
    );
  }

  Future<void> updateHostelDetails(String id) async {
    // Update the document in Firestore
    await FirebaseFirestore.instance.collection('HostelDetails').doc(id).update({
      "hostelname": hostelname.text,
      "hostelphone": hostelphone.text,
      "hostelemail": hostelemail.text,
      "buildingno": buildingno.text,
      "area": area.text,
      "pincode": pincode.text,
      "city": city.text,
      "district": district.text,
      "state": state.text,
      "weblink": weblink.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hostel details updated')));
  }

  Future<void> setHostelDetails(String id, BuildContext context) async {
    // Fetch the hostel details document from Firestore
    var docu = await FirebaseFirestore.instance.collection("HostelDetails").doc(id).get();
    // Extract the data from the document
    Map<String, dynamic>? val = docu.data();
    // Check if the document exists and data is not null
    if (val != null) {
      // Update the text controllers with the fetched data
      hostelname.text = val["hostelname"];
      hostelphone.text = val["hostelphone"];
      hostelemail.text = val["hostelemail"];
      buildingno.text = val["buildingno"];
      area.text = val["area"];
      pincode.text = val["pincode"];
      city.text = val["city"];
      district.text = val["district"];
      state.text = val["state"];
      weblink.text = val["weblink"];
    } else {
      // If document not found or data is null, show an error message
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hostel details not found')));
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


  // for logout popUp
  Future<void> LogoutPopUp() async {
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
                KText(text:'', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: SizedBox(
                    height: 30, width: 30,
                    // Cross Icon
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
                          child: SizedBox(
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

            content: SizedBox(
              height: 360,
              width: 500,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(width: 400,
                        child: Image.asset('assets/ui-design-/images/signout.png'),
                      )
                    ],
                  ),
                  KText(text: 'LogOut', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 8,),
                  SizedBox(
                    child: KText(text: 'Are you sure you want to logout?', style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xff262626).withOpacity(0.8))),
                  ),
                  const SizedBox(height: 20,),

                  SizedBox(
                    height: 40,
                    width: 140,
                    child: ElevatedButton(
                      style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xffF12D2D))),
                      onPressed: (){
                        _signOut();
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          KText(text: 'Confirm', style: GoogleFonts.openSans(fontWeight: FontWeight.w700, color: Colors.white)),
                          const CircleAvatar(backgroundColor: Colors.transparent,radius: 13,backgroundImage: AssetImage('assets/ui-design-/images/Ok.png',),)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
        );
      },
    );
  }


/// Chart...

  // static List<LineSeries<SalesData, num>> getDefaultData() {
  //   final bool isDataLabelVisible = true,
  //       isMarkerVisible = true,
  //       isTooltipVisible = true;
  //   double? lineWidth, markerWidth, markerHeight;
  //   final List<SalesData> chartData = <SalesData>[
  //     // SalesData(DateTime(2005, 0, 1), 'India', 1.5, 21, 28, 680, 760),
  //     // SalesData(DateTime(2006, 0, 1), 'China', 2.2, 24, 44, 550, 880),
  //     // SalesData(DateTime(2007, 0, 1), 'USA', 3.32, 36, 48, 440, 788),
  //     // SalesData(DateTime(2008, 0, 1), 'Japan', 4.56, 38, 50, 350, 560),
  //     // SalesData(DateTime(2009, 0, 1), 'Russia', 5.87, 54, 66, 444, 566),
  //     // SalesData(DateTime(2010, 0, 1), 'France', 6.8, 57, 78, 780, 650),
  //     // SalesData(DateTime(2011, 0, 1), 'Germany', 8.5, 70, 84, 450, 800)
  //   ];
  //   // return <LineSeries<SalesData, num>>[
  //   //   LineSeries<SalesData, num>(
  //   //       enableTooltip: true,
  //   //       dataSource: chartData,
  //   //       xValueMapper: (SalesData sales, _) => sales.sales,
  //   //       yValueMapper: (SalesData sales, _) => sales.sales,
  //   //       width: lineWidth ?? 2,
  //   //       markerSettings: MarkerSettings(
  //   //           isVisible: isMarkerVisible,
  //   //           height: markerWidth ?? 4,
  //   //           width: markerHeight ?? 4,
  //   //           shape: DataMarkerType.circle,
  //   //           borderWidth: 3,
  //   //           borderColor: Colors.red),
  //   //       dataLabelSettings: DataLabelSettings(
  //   //           isVisible: isDataLabelVisible,
  //   //           labelAlignment: ChartDataLabelAlignment.auto)),
  //   //   LineSeries<SalesData, num>(
  //   //       enableTooltip: isTooltipVisible,
  //   //       dataSource: chartData,
  //   //       width: lineWidth ?? 2,
  //   //       xValueMapper: (SalesData sales, _) => sales.sales,
  //   //       yValueMapper: (SalesData sales, _) => sales.sales,
  //   //       markerSettings: MarkerSettings(
  //   //           isVisible: isMarkerVisible,
  //   //           height: markerWidth ?? 4,
  //   //           width: markerHeight ?? 4,
  //   //           shape: DataMarkerType.circle,
  //   //           borderWidth: 3,
  //   //           borderColor: Colors.black),
  //   //       dataLabelSettings: DataLabelSettings(
  //   //           isVisible: isDataLabelVisible,
  //   //           labelAlignment: ChartDataLabelAlignment.auto))
  //   // ];
  //
  //   Container(
  //       height: 370,
  //       width: 300,
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 40),
  //         child: Container(
  //           height: 170,
  //           width: 850,
  //           child: sfc.SfCartesianChart(
  //               primaryXAxis: sfc.CategoryAxis(),
  //               title: sfc.ChartTitle(
  //                   text: '',
  //                   textStyle: GoogleFonts.poppins(
  //                     fontWeight: FontWeight.w600,
  //                     color: Colors.black,
  //                   ),
  //                   alignment: sfc.ChartAlignment.near
  //               ),
  //               legend: sfc.Legend(isVisible: true),
  //               // tooltipBehavior: _tooltipBehavior,
  //               series: <sfc.LineSeries<SalesData, String>>[
  //                 sfc.LineSeries<SalesData, String>(
  //                   name: "",
  //                   dataSource: chartData,
  //                   xValueMapper: (SalesData sales, _) => sales.year,
  //                   yValueMapper: (SalesData sales, _) => sales.sales,
  //                   // Enable data label
  //                   dataLabelSettings: sfc.DataLabelSettings(isVisible: true),
  //                   color: Constants().primaryAppColor,
  //                   width: 5,
  //                   animationDuration: 2000,
  //                 )
  //               ]
  //           ),
  //         ),
  //       )
  //   );
  //
  // }



  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text =  KText(text:'Jan', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
  case 2:
        text =  KText(text:'Feb', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
      case 4:
        text =  KText(text:'Mar', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
  case 6:
        text =  KText(text:'Apr', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
      case 8:
        text =  KText(text:'May', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
  case 10:
        text =  KText(text:'Jun', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
      case 12:
        text =  KText(text:'Jul', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
      case 14:
        text =  KText(text:'Aug', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
      case 16:
        text =  KText(text:'Sep', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
     case 18:
        text =  KText(text:'Oct', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
      case 20:
        text =  KText(text:'Nov', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
     case 22:
        text =  KText(text:'Dec', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
      default:
        text =  KText(text:'', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {

    String text;
    switch (value.toInt()) {
      case 1:
        text = '0';
        break;
      case 3:
        text = '100';
        break;
      case 5:
        text = '200';
        break;
      case 7:
        text = '800';
      case 9:
        text = '1000';
        break;
      default:
        return Container();
    }

    return KText(text:text, style: GoogleFonts.inter(
        fontWeight: FontWeight.w400,
        fontSize: 12,
        color: Color(0xff718EBF)
    ), );
  }

  LineChartData mainData() {
    return LineChartData(

      gridData: FlGridData(
        show: true,


        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,

        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },

      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 27,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 22,
      minY: 0,
      maxY: 9,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
            FlSpot(14, 6),
            FlSpot(16, 3),
            FlSpot(18, 2),
            FlSpot(20, 5),
            FlSpot(22, 4.1),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 3,
          //isStrokeCapRound: true,


          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors2,
            ),
          ),

        ),
      ],

    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 9,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }



}









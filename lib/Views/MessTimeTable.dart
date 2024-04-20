import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_ikia/widgets/ReusableHeader.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class MessTimeTable extends StatefulWidget {
  const MessTimeTable({super.key});
  @override
  State<MessTimeTable> createState() => _MessTimeTableState();
}
class _MessTimeTableState extends State<MessTimeTable> {
  late SharedPreferences _prefs;
  @override
  void initState() {
    setData();
    super.initState();

  }
  List<TextEditingController> controllers = List.generate(
      21, (index) => new TextEditingController());
  /// List of days and meal sessions
  List<String> days = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  List<String> meals = ['Breakfast', 'Lunch', 'Dinner'];

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadSavedData();
  }

  void _loadSavedData() {
    for (int i = 0; i < controllers.length; i++) {
      final savedValue = _prefs.getString('textfield_$i');
      if (savedValue != null) {
        controllers[i].text = savedValue;
      }
    }
  }

  Future<void> _saveData() async {
    for (int i = 0; i < controllers.length; i++) {
      final text = controllers[i].text;
      await _prefs.setString('textfield_$i', text);
    }
  }


  void saveToFirestore(String day, String session, String food, String servingTime) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    FirebaseFirestore.instance.collection('MessTimetable').doc(day).set({
      'day': day,
      session: {
        'food': food,
        'servingTime': servingTime,
        'date': formattedDate,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    }, SetOptions(merge: true));
  }

  setData() async {
    for (String day in days) {
      var TimeTable  = await FirebaseFirestore.instance.collection('MessTimetable').doc(day)
          .get();
      Map<String, dynamic> ? value = TimeTable.data();
      for (String meal in meals) {
        setState(() {
          controllers[days.indexOf(day) * meals.length + meals.indexOf(meal)].text = TimeTable.data()![meal]['food'];
        });
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;


    return FadeInRight(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ReusableHeader(Headertext: 'Mess Time Table',
                      SubHeadingtext: 'Manage mess time table'),


                  Container(
                    width: 150,
                    height: 45,
                    child: ElevatedButton(
                        style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff37D1D3))),
                        onPressed: (){
                      for (String day in days) {
                        for (String meal in meals) {
                          String food = controllers[days.indexOf(day) * meals.length + meals.indexOf(meal)].text;
                          ///Calling function...
                          saveToFirestore(day, meal, food, '10:30 - 4:30');
                        }
                      }
                      showTopSnackBar(
                        displayDuration: const Duration(milliseconds: 100),
                        Overlay.of(context),
                        const CustomSnackBar.success(

                          backgroundColor: Color(0xff3ac6cf),
                          message:
                          "Time Table Updated Successfully",
                        ),
                      );
                    }, child: Text('Update', style: GoogleFonts.openSans(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16), )),
                  )
                ],
              ),
              const SizedBox(height: 80,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Container(
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xff37D1D3),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(16)),

                    border: Border.all(color: const Color(0xff262626).withOpacity(0.5), width: 0.3),
                  ), child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 8),
                  child: Text('Days', style: GoogleFonts.openSans(
                    color: Colors.white,
                      fontWeight: FontWeight.w600, fontSize: 17),),
                ),),
                Container(
                  height: 40,
                  width: 233,
                  decoration: BoxDecoration(
                    color: const Color(0xffDAFEF0),
                    border: Border.all(color: const Color(0xff262626).withOpacity(0.5), width: 0.3),
                  ), child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 8),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Image.asset('assets/breack_fast.png'),
                      ),
                      const SizedBox(width: 6,),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: Text('Breakfast', style: GoogleFonts.openSans(
                            fontWeight: FontWeight.w600, fontSize: 17),),
                      ),
                    ],
                  ),
                ),),
                Container(
                  height: 40,
                  width: 233,
                  decoration: BoxDecoration(
                    color: const Color(0xffFFEDD0),
                    border: Border.all(color: const Color(0xff262626).withOpacity(0.5), width: 0.3),
                  ), child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 8),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Image.asset('assets/lunch.png'),
                      ),
                      const SizedBox(width: 6,),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: Text('Lunch', style: GoogleFonts.openSans(
                            fontWeight: FontWeight.w600, fontSize: 17),),
                      ),
                    ],
                  ),
                ),),
                Container(
                  height: 40,
                  width: 233,
                  decoration: BoxDecoration(
                    color: const Color(0xffEEECFF),
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(16)),
                    border: Border.all(color: const Color(0xff262626).withOpacity(0.5), width: 0.3),
                  ), child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 8),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Container(
                            child: Image.asset('assets/dinner.png')),
                      ),
                      const SizedBox(width: 6,),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: Text('Dinner', style: GoogleFonts.openSans(
                            fontWeight: FontWeight.w600, fontSize: 17),),
                      ),
                    ],
                  ),
                ),),
              ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Column(
                    children: [
                      Container(
                        height: 40,
                        width: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xff37D1D3),
                          border: Border.all(color: const Color(0xff262626).withOpacity(0.5), width: 0.3),
                        ), child: Padding(
                        padding: const EdgeInsets.only(left: 10, top: 8),
                        child: Text('Sunday', style: GoogleFonts.openSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w600, fontSize: 17),),
                      ),),
                      Container(
                        height: 40,
                        width: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xff37D1D3),
                          border: Border.all(color: const Color(0xff262626).withOpacity(0.5), width: 0.3),
                        ), child: Padding(
                        padding: const EdgeInsets.only(left: 10, top: 8),
                        child: Text('Monday', style: GoogleFonts.openSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w600, fontSize: 17),),
                      ),),
                    Container(
                        height: 40,
                        width: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xff37D1D3),
                          border: Border.all(color: const Color(0xff262626).withOpacity(0.5), width: 0.3),
                        ), child: Padding(
                        padding: const EdgeInsets.only(left: 10, top: 8),
                        child: Text('Tuesday', style: GoogleFonts.openSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w600, fontSize: 17),),
                      ),),
                      Container(
                        height: 40,
                        width: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xff37D1D3),
                          border: Border.all(color: const Color(0xff262626).withOpacity(0.5), width: 0.3),
                        ), child: Padding(
                        padding: const EdgeInsets.only(left: 10, top: 8),
                        child: Text('Wednesday', style: GoogleFonts.openSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w600, fontSize: 17),),
                      ),),
                      Container(
                        height: 40,
                        width: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xff37D1D3),
                          border: Border.all(color: const Color(0xff262626).withOpacity(0.5), width: 0.3),
                        ), child: Padding(
                        padding: const EdgeInsets.only(left: 10, top: 8),
                        child: Text('Thursday', style: GoogleFonts.openSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w600, fontSize: 17),),
                      ),),
                      Container(
                        height: 40,
                        width: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xff37D1D3),
                          border: Border.all(color: const Color(0xff262626).withOpacity(0.5), width: 0.3),
                        ), child: Padding(
                        padding: const EdgeInsets.only(left: 10, top: 8),
                        child: Text('Friday', style: GoogleFonts.openSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w600, fontSize: 17),),
                      ),),
                      Container(
                        height: 40,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16)),
                          color: const Color(0xff37D1D3),
                          border: Border.all(color: const Color(0xff262626).withOpacity(0.5), width: 0.3),
                        ), child: Padding(
                        padding: const EdgeInsets.only(left: 10, top: 8),
                        child: Text('Saturday', style: GoogleFonts.openSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w600, fontSize: 17),),
                      ),),
                    ],
                  ),
                  /// grid
                  Container(
                    height: 600,
                    width: 700,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)),
                    child: GridView.builder(
                      itemCount: 21,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, childAspectRatio: 17 / 2.9,),
                      itemBuilder: (context, index) {
                        return
                          Container(
                            height: 40,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular( index == 20 ? 16 : 0)),
                              border: Border.all(color: const Color(0xff262626).withOpacity(0.5), width: 0.3),
                            ), child: Padding(
                            padding: const EdgeInsets.only(left: 10, top: 8),
                            child: TextField(
                              onChanged: (_) => _saveData(),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 22, left: 4),
                                  border: InputBorder.none),
                              controller: controllers[index],
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.w600, fontSize: 17),),
                          ),);
                      },),
                  )
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
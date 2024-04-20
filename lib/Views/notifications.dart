import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_ikia/Constants/constants.dart';
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants().primaryAppColor,
        title: Text(
          "Notifications",
          style: GoogleFonts.openSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xff262626),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            SizedBox(height: 5,),
            StreamBuilder(stream: FirebaseFirestore.instance.collection('AdminRequest').snapshots(), builder: (context, snapshot) {
              if(snapshot.hasData){
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                  var data = snapshot.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Card(
                      color: Color(0xffE7FFFF),
                      child: ListTile(onTap: (){},
                      // trailing: data['image'],
                        leading: CircleAvatar(backgroundImage: NetworkImage(data['image'])),
                        title: Text(data['name'], style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18),),
                        subtitle: Text(data['message'], style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 16),),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(data['date'], style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 15),),
                            Text(data['time'], style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 15),),
                          ],
                        ),
                      )
                    ),
                  );

                },);
              }else{
                return


                  Column(
                    children: [
                      const Icon(
                        Icons.notifications_off_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'No Notifications',
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  );


              }
            },)
          ],
        ),
      ),
    );
  }
}

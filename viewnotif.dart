import 'package:cyber/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'sendcomplaint.dart';
void main() {
  runApp(const ViewReply());
}

class ViewReply extends StatelessWidget {
  const ViewReply({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'View Reply',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 18, 82, 98)),
        useMaterial3: true,
      ),
      home: const Viewnorif(title: 'View Reply'),
    );
  }
}

class Viewnorif extends StatefulWidget {
  const Viewnorif({super.key, required this.title});

  final String title;

  @override
  State<Viewnorif> createState() => _ViewnorifState();
}

class _ViewnorifState extends State<Viewnorif> {

  _ViewnorifState(){
    viewreply();
  }

  List<String> id_ = [],date_=[],complaint_=[];

  Future<void> viewreply() async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String url = '$urls/myapp/user_viewnotif/';
      var data = await http.post(Uri.parse(url), body: {
        'lid':sh.getString('lid').toString()
      });
      var jsondata = json.decode(data.body);
      var arr = jsondata["data"];
      setState(() {
        id_=arr.map<String>((item)=>item['id'].toString()).toList();
        date_=arr.map<String>((item)=>item['date'].toString()).toList();
        complaint_=arr.map<String>((item)=>item['complaint'].toString()).toList();
      });
    } catch (e) {
      print("Error ------------------- " + e.toString());
    }
  }




  @override
  Widget build(BuildContext context) {



    return WillPopScope(
      onWillPop: () async{ return true; },
      child: Scaffold(
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   backgroundColor: Colors.white,
        //   elevation: 0.0,
        //   leadingWidth: 0.0,
        //   title: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       CircleAvatar(
        //         backgroundColor: Colors.grey.shade300,
        //         radius: 20.0,
        //         child: IconButton(
        //           onPressed: () {
        //             Navigator.pop(context);
        //           },
        //           splashRadius: 1.0,
        //           icon: Icon(
        //             Icons.arrow_back_ios_new,
        //             color: kDarkGreenColor,
        //             size: 24.0,
        //           ),
        //         ),
        //       ),
        //       Text(
        //         'Notifications',
        //         style: GoogleFonts.poppins(
        //           color: kDarkGreenColor,
        //           fontSize: 22.0,
        //           fontWeight: FontWeight.w600,
        //         ),
        //       ),
        //       SizedBox(
        //         width: 40.0,
        //         child: IconButton(
        //           onPressed: () {},
        //           splashRadius: 1.0,
        //           icon: Icon(
        //             Icons.more_vert,
        //             color: Colors.white,
        //             size: 34.0,
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),

        body: ListView.builder(
          physics: BouncingScrollPhysics(),
          // padding: EdgeInsets.all(5.0),
          // shrinkWrap: true,
          itemCount: id_.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              onLongPress: () {
                print("long press" + index.toString());
              },
              title: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    children: [
                    Container(
                      width: 400,
                      child: Card(
                      elevation: 6,
                      margin: EdgeInsets.all(7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        color: kGinColor,
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date: " + date_[index],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Notif: " + complaint_[index],
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 8),

                          ],
                        ),
                      ),
                  ),
                    ),



                      // Card(
                      //   child:
                      //   Row(
                      //       children: [
                      //         Column(
                      //           children: [
                      //             Padding(
                      //               padding: EdgeInsets.all(5),
                      //               child: Text("Date: "+date_[index]),
                      //             ),
                      //             Padding(
                      //               padding: EdgeInsets.all(5),
                      //               child: Text("Complaint: "+complaint_[index]),
                      //             ),    Padding(
                      //               padding: EdgeInsets.all(5),
                      //               child: Text("Reply: "+reply_[index]),
                      //             ),  Padding(
                      //               padding: EdgeInsets.all(5),
                      //               child: Text("Status: "+status_[index]),
                      //             ),
                      //           ],
                      //         ),
                      //
                      //       ]
                      //   ),
                      //
                      //   elevation: 6,
                      // ),
                    ],
                  )),
            );
          },
        ),



      ),
    );
  }
}

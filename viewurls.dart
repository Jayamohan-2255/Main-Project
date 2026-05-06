import 'package:cyber/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'Bottnav.dart';
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
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 18, 82, 98)),
        useMaterial3: true,
      ),
      home: const Viewurls(title: 'View Reply'),
    );
  }
}

class Viewurls extends StatefulWidget {
  const Viewurls({super.key, required this.title});

  final String title;

  @override
  State<Viewurls> createState() => _ViewurlsState();
}

class _ViewurlsState extends State<Viewurls> {
  _ViewurlsState() {
    viewreply();
  }

  List<String> id_ = <String>[];
  List<String> date_ = <String>[];
  List<String> complaint_ = <String>[];
  List<String> reply_ = <String>[];
  List<String> status_ = <String>[];

  Future<void> viewreply() async {
    List<String> id = <String>[];
    List<String> date = <String>[];
    List<String> complaint = <String>[];
    List<String> reply = <String>[];
    List<String> status = <String>[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/myapp/user_viewurl/';

      var data = await http.post(Uri.parse(url), body: {'lid': lid});
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      print(arr.length);

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        date.add(arr[i]['date']);
        complaint.add(arr[i]['complaint']);
        reply.add(arr[i]['reply']);
        status.add(arr[i]['status']);
      }

      setState(() {
        id_ = id;
        date_ = date;
        complaint_ = complaint;
        reply_ = reply;
        status_ = status;
      });

      print(statuss);
    } catch (e) {
      print("Error ------------------- " + e.toString());
      //there is error during converting file image to base64 encoding.
    }
  }

  @override
  Widget build(BuildContext context) {
    double sw=MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Bottnav()));
        return false;
      },
      child: Scaffold(
        body: Container(
          height: 300,
          child: ListView.builder(
            // physics: BouncingScrollPhysics(),
            itemCount: id_.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                onLongPress: () {
                  print("long press" + index.toString());
                },
                title: Column(
                  children: [
                    Container(
                      width: sw*0.9,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          color: kGinColor,
                          padding: EdgeInsets.all(16),
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
                                "Url: " + complaint_[index],
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Status: " + status_[index],
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

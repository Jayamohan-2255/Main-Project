import 'package:flutter/material.dart';
import 'package:cyber/constants.dart';
import 'package:cyber/editprofile.dart';
import 'package:cyber/homenew.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const ViewProfile());
}

class ViewProfile extends StatelessWidget {
  const ViewProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'View Profile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ViewProfilePage(title: 'View Profile'),
    );
  }
}

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage({super.key, required this.title});

  final String title;

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  _ViewProfilePageState() {
    _send_data();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        // appBar: AppBar(
        //   leading: BackButton(),
        //   backgroundColor: Theme.of(context).colorScheme.primary,
        //   title: Text(widget.title),
        // ),
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
        //             Navigator.push(context, MaterialPageRoute(
        //               builder: (context) => HomeNewPage(title: "Home"),));
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
        //         'My Profile',
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

        backgroundColor: Colors.grey.shade300,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              SizedBox(
                height: 280,
                width: double.infinity,
                child: Image.network(
                  photo_,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(16.0, 240.0, 16.0, 16.0),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16.0),
                          margin: EdgeInsets.only(top: 16.0),
                          decoration: BoxDecoration(
                              color: kGinColor,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(left: 110.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            name_,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                          SizedBox(
                                            height: 40,
                                          )
                                        ],
                                      ),
                                      Spacer(),
                                      CircleAvatar(
                                        backgroundColor: Colors.blueAccent,
                                        child: IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MyEditPage(
                                                            title: 'Edit'),
                                                  ));
                                            },
                                            icon: Icon(
                                              Icons.edit_outlined,
                                              color: Colors.white,
                                              size: 18,
                                            )),
                                      )
                                    ],
                                  )),
                              SizedBox(height: 10.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [Text("Gender"), Text(gender_)],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [Text("DOB"), Text(dob_)],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              image: DecorationImage(
                                  image: NetworkImage(photo_),
                                  fit: BoxFit.cover)),
                          margin: EdgeInsets.only(left: 20.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      decoration: BoxDecoration(
                        color: kGinColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text("Profile Information"),
                          ),
                          Divider(),
                          ListTile(
                            title: Text("Email"),
                            subtitle: Text(email_),
                            leading: Icon(Icons.mail_outline),
                          ),
                          ListTile(
                            title: Text("Phone"),
                            subtitle: Text(phone_),
                            leading: Icon(Icons.phone),
                          ),
                          ListTile(
                            title: Text("Address"),
                            subtitle: Text('$place_, $pin_, $district_'),
                            leading: Icon(Icons.map),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String name_ = "";
  String dob_ = "";
  String gender_ = "";
  String email_ = "";
  String phone_ = "";
  String place_ = "";
  String pin_ = "";
  String district_ = "";
  String photo_ = "";

  void _send_data() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();

    final urls = Uri.parse('$url/myapp/view_user_profile/');
    try {
      final response = await http.post(urls, body: {'lid': lid});
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          String name = jsonDecode(response.body)['name'];
          String dob = jsonDecode(response.body)['dob'];
          String gender = jsonDecode(response.body)['gender'];
          String email = jsonDecode(response.body)['email'];
          String phone = jsonDecode(response.body)['phone'];
          String place = jsonDecode(response.body)['place'];
          String pin = jsonDecode(response.body)['pin'];
          String district = jsonDecode(response.body)['district'];
          String photo = url + jsonDecode(response.body)['photo'];

          setState(() {
            name_ = name;
            dob_ = dob;
            gender_ = gender;
            email_ = email;
            phone_ = phone;
            place_ = place;
            pin_ = pin;
            district_ = district;
            photo_ = photo;
          });
        } else {
          Fluttertoast.showToast(msg: 'Not Found');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}

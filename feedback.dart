import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cyber/components/authentication_button.dart';
import 'package:cyber/components/custom_text.dart';
import 'package:cyber/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cyber/homenew.dart';

import 'Bottnav.dart';

void main() {
  runApp(const MySendComplaint());
}

class MySendComplaint extends StatelessWidget {
  const MySendComplaint({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feedback',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 18, 82, 98)),
        useMaterial3: true,
      ),
      home: const MyFeedbackPage(title: 'Feedback'),
    );
  }
}

class MyFeedbackPage extends StatefulWidget {
  const MyFeedbackPage({super.key, required this.title});

  final String title;

  @override
  State<MyFeedbackPage> createState() => _MyFeedbackPageState();
}

class _MyFeedbackPageState extends State<MyFeedbackPage> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController SendFeedbackController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Bottnav()));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0.0,
          leadingWidth: 0.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                radius: 20.0,
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Bottnav()));                  },
                  splashRadius: 1.0,
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: kDarkGreenColor,
                    size: 24.0,
                  ),
                ),
              ),
              Text(
                'Feedback',
                style: GoogleFonts.poppins(
                  color: kDarkGreenColor,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: 40.0,
                child: IconButton(
                  onPressed: () {},
                  splashRadius: 1.0,
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: 34.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: CustomText(
                      controller: SendFeedbackController,
                      hintText: '',
                      icon: Icons.send,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field Empty';
                        }
                        return null; // Return null if the input is valid
                      },
                    )
                    // child: TextField(
                    //   controller: SendFeedbackController,
                    //   decoration: InputDecoration(border: OutlineInputBorder(),label: Text("SendFeedback")),
                    // ),
                    ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AuthenticationButton(
                          label: 'Send Feedback',
                          labelColor: Colors.white,
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              SharedPreferences sh =
                                  await SharedPreferences.getInstance();
                              String url = sh.getString('url').toString();
                              String lid = sh.getString('lid').toString();

                              final urls =
                                  Uri.parse('$url/myapp/user_sendfeedback/');
                              try {
                                final response = await http.post(urls, body: {
                                  'lid': lid,
                                  'feedback': SendFeedbackController.text,
                                });
                                if (response.statusCode == 200) {
                                  String status =
                                      jsonDecode(response.body)['status'];
                                  if (status == 'ok') {
                                    Fluttertoast.showToast(
                                        msg: 'Feedback Send Sussessfully');

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              HomeNewPage(title: 'Home'),
                                        ));
                                  } else {
                                    Fluttertoast.showToast(msg: 'Not Found');
                                  }
                                } else {
                                  Fluttertoast.showToast(msg: 'Network Error');
                                }
                              } catch (e) {
                                Fluttertoast.showToast(msg: e.toString());
                              }
                            } else {
                              return null;
                            }
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

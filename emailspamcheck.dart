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

void main() {
  runApp(const MySendComplaint());
}

class MySendComplaint extends StatelessWidget {
  const MySendComplaint({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SendComplaint',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 18, 82, 98)),
        useMaterial3: true,
      ),
      home: const emailspamcheck(title: 'SendComplaint'),
    );
  }
}

class emailspamcheck extends StatefulWidget {
  const emailspamcheck({super.key, required this.title});

  final String title;

  @override
  State<emailspamcheck> createState() => _emailspamcheckState();
}

class _emailspamcheckState extends State<emailspamcheck> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController SendComplaintController= new TextEditingController();


  @override
  Widget build(BuildContext context) {



    return WillPopScope(
      onWillPop: () async{ return true; },
      child: Scaffold(

        body: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.all(8),
                  child: CustomText(
                    controller: SendComplaintController,
                    hintText: 'Add a spam email',
                    icon: Icons.send,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Field Empty';
                      }
                      return null; // Return null if the input is valid
                    },
                  )
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AuthenticationButton(
                        label: 'Check',
                        labelColor: Colors.white,
                        onPressed: () async {
                              if (_formkey.currentState!.validate()) {
                                SharedPreferences sh = await SharedPreferences.getInstance();
                                String url = sh.getString('url').toString();
                                String lid = sh.getString('lid').toString();

                                final urls = Uri.parse('$url/myapp/user_checkspamemail/');
                                try {
                                  final response = await http.post(urls, body: {
                                    'complaint':SendComplaintController.text,


                                  });
                                  if (response.statusCode == 200) {
                                    String status = jsonDecode(response.body)['status'];
                                    String spam = jsonDecode(response.body)['spam'];
                                    if (status=='ok') {

                                      showDialog(context: context, builder: (context) {
                                        return AlertDialog(
                                          title: Text("Email spam Result"),
                                          content: Container(
                                            height: 100,
                                            alignment: Alignment.center,
                                            child: spam=="Not Spam"?Text(spam,style: TextStyle(color: Colors.green,fontSize: 20,fontWeight: FontWeight.w700),):Text(spam,style: TextStyle(color: Colors.red,fontSize: 20,fontWeight: FontWeight.w700),),
                                          ),
                                          actions: [
                                            TextButton(onPressed: (){Navigator.pop(context);}, child: Text("Close"))
                                          ],
                                        );
                                      },);

                                    }else {
                                      Fluttertoast.showToast(msg: 'Not Found');
                                    }
                                  }
                                  else {
                                    Fluttertoast.showToast(msg: 'Network Error');
                                  }
                                }
                                catch (e){
                                  Fluttertoast.showToast(msg: e.toString());
                                }
                                } else {
                                  return null;
                                }


                        },
                        // onPressed: () {
                        //   if (_formkey.currentState!.validate()) {
                        //     _send_data();
                        //   } else {
                        //     return null;
                        //   }
                        // },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

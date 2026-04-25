import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cyber/components/authentication_button.dart';
import 'package:cyber/components/custom_text_field.dart';
import 'package:cyber/constants.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'Bottnav.dart';
import 'login.dart';
import 'login/main.dart';
final _formkey = GlobalKey<FormState>();


void main() {
  runApp(const MyChangePassword());
}

class MyChangePassword extends StatelessWidget {
  const MyChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChangePassword',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyChangePasswordPage(title: 'ChangePassword'),
    );
  }
}

class MyChangePasswordPage extends StatefulWidget {
  const MyChangePasswordPage({super.key, required this.title});

  final String title;

  @override
  State<MyChangePasswordPage> createState() => _MyChangePasswordPageState();
}

class _MyChangePasswordPageState extends State<MyChangePasswordPage> {


  @override
  Widget build(BuildContext context) {

    TextEditingController oldpasswordController= new TextEditingController();
    TextEditingController newpasswordController= new TextEditingController();
    TextEditingController confirmpasswordController= new TextEditingController();

    return WillPopScope(
      onWillPop: () async{
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Bottnav()));
        return false; },
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
                'Change Password',
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
        // appBar: AppBar(
        //   backgroundColor: Theme.of(context).colorScheme.primary,
        //   title: Text(widget.title),
        // ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Padding(
                    padding: const EdgeInsets.all(8),
                    child:  CustomTextField(
                      controller: oldpasswordController,
                      hintText: 'Current Password',
                      icon: Icons.password,
                      keyboardType: TextInputType.name,
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Your Current Password';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: CustomTextField(
                      controller: newpasswordController,
                      hintText: 'New Password',
                      icon: Icons.password,
                      keyboardType: TextInputType.name,
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Your New Password';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                  ),      Padding(
                    padding: const EdgeInsets.all(8),
                    child: CustomTextField(
                      controller: confirmpasswordController,
                      hintText: 'Confirm Password',
                      icon: Icons.password,
                      keyboardType: TextInputType.name,
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please confirm your password';
                        } else if (value != newpasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AuthenticationButton(
                          label: 'Change',
                          labelColor: Colors.white,
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              String oldp= oldpasswordController.text.toString();
                              String newp= newpasswordController.text.toString();
                              String cp= confirmpasswordController.text.toString();



                              SharedPreferences sh = await SharedPreferences.getInstance();
                              String url = sh.getString('url').toString();
                              String lid = sh.getString('lid').toString();

                              final urls = Uri.parse('$url/myapp/user_changepassword/');
                              try {
                                final response = await http.post(urls, body: {
                                  'oldpassword':oldp,
                                  'newpassword':newp,
                                  'cp':cp,
                                  'lid':lid,



                                });
                                if (response.statusCode == 200) {
                                  String status = jsonDecode(response.body)['status'];
                                  print("aaaaaaaaaaaaaaaaa$status");
                                  if (status=='ok') {
                                    Fluttertoast.showToast(msg: 'Password Changed Successfully');
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => NewLogScreenPages()));
                                  }else {
                                    Fluttertoast.showToast(msg: 'Incorrect Password');
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

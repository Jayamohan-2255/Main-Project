import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cyber/homenew.dart';
import 'package:cyber/login.dart';
import 'package:cyber/signup.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cyber/components/authentication_button.dart';
import 'package:cyber/components/custom_text_field.dart';
import 'package:cyber/components/curve.dart';
import 'package:cyber/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';
// import 'package:garden/screens/main_screen.dart';
// import 'package:plant_app/screens/signup_screen.dart';

final _formkey = GlobalKey<FormState>();


void main() {
  runApp(const MyIndexLogin());
}

class MyIndexLogin extends StatelessWidget {
  const MyIndexLogin({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginScreen(title: 'DREAM GARDEN'),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key,required this.title});
  final String title;

  static const String id = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;
  String username = '';
  String password = '';
  TextEditingController unamecontroller= new TextEditingController();
  TextEditingController passcontroller=new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.push(context, MaterialPageRoute(builder: (context) => Myip(title: 'IP')));
        return false;
      },
      child: Material(
        child: Stack(
          alignment: Alignment.bottomRight,
          fit: StackFit.expand,
          children: [
            // First Child in the stack

            ClipPath(
              clipper: ImageClipper(),
              child: Image.asset(
                'images/leaves.jpg',
                alignment: Alignment.topCenter,
                fit: BoxFit.fitWidth,
              ),
            ),

            // Positioned(
            //   top: 30.0,
            //   left: 20.0,
            //   child: CircleAvatar(
            //     backgroundColor: Colors.white,
            //     radius: 20.0,
            //     child: IconButton(
            //       onPressed: () {},
            //       icon: Icon(
            //         Icons.arrow_back_ios_new,
            //         color: kDarkGreenColor,
            //         size: 24.0,
            //       ),
            //     ),
            //   ),
            // ),

            // Second Child in the stack
            Positioned(
              height: MediaQuery.of(context).size.height * 0.67,
              width: MediaQuery.of(context).size.width,
                child: Scaffold(
                  body: SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.67,
                        maxWidth: MediaQuery.of(context).size.width,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // First Column
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Welcome Back',
                                style: GoogleFonts.poppins(
                                  fontSize: 32.0,
                                  fontWeight: FontWeight.w600,
                                  color: kDarkGreenColor,
                                ),
                              ),
                              Text(
                                'Login to your account',
                                style: GoogleFonts.poppins(
                                  color: kGreyColor,
                                  fontSize: 15.0,
                                ),
                              )
                            ],
                          ),

                          // Second Column
                          Form(
                            key: _formkey,
                            child: Column(
                              children: [
                                CustomTextField(
                                  controller: unamecontroller,
                                  hintText: 'Username',
                                  icon: Icons.person,
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please Enter Your Username';
                                    }
                                    return null; // Return null if the input is valid
                                  },
                                ),
                                CustomTextField(
                                  controller: passcontroller,
                                  hintText: 'Password',
                                  icon: Icons.lock,
                                  obscureText: true,
                                  keyboardType: TextInputType.visiblePassword,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please Enter Your Password';
                                    }
                                    return null; // Return null if the input is valid
                                  },
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.all(
                                                kDarkGreenColor),
                                            value: rememberMe,
                                            onChanged: (value) {
                                              setState(() {
                                                rememberMe = value!;
                                              });
                                            },
                                          ),
                                          Text(
                                            'Remember Me',
                                            style: TextStyle(
                                              color: kGreyColor,
                                              fontSize: 14.0,
                                            ),
                                          )
                                        ],
                                      ),
                                      // TextButton(
                                      //   onPressed: () {},
                                      //   style: ButtonStyle(
                                      //     foregroundColor: MaterialStateProperty.all(
                                      //         kDarkGreenColor),
                                      //   ),
                                      //   child: const Text(
                                      //     'Forgot Password ?',
                                      //   ),
                                      // )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Third Column
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                              bottom: 20.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                AuthenticationButton(
                                  label: 'Log In',
                                  labelColor: Colors.white,
                                  onPressed: () {
                                    if (_formkey.currentState!.validate()) {
                                      _send_data();
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Don\'t have an account ?',
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                      TextButton(
                                        style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all(
                                                  kDarkGreenColor),
                                        ),
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>MyMySignupPage(title: '',)));
                                        },
                                        child: const Text(
                                          'Sign up',
                                          style: TextStyle(fontSize: 14.0),
                                        ),
                                      )
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
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _send_data() async{


    String uname=unamecontroller.text;
    String password=passcontroller.text;

    if (uname.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill in all fields');
    }
    else{
      SharedPreferences sh = await SharedPreferences.getInstance();
      String url = sh.getString('url').toString();

      final urls = Uri.parse('$url/myapp/userlogin/');
      try {
        final response = await http.post(urls, body: {
          'name':uname,
          'password':password,


        });
        if (response.statusCode == 200) {
          String status = jsonDecode(response.body)['status'];
          if (status=='ok') {
            String lid=jsonDecode(response.body)['lid'].toString();
            String name=jsonDecode(response.body)['name'].toString();
            String email=jsonDecode(response.body)['email'].toString();
            String photo=url+jsonDecode(response.body)['photo'].toString();
            sh.setString("lid", lid);
            sh.setString('name', name);
            sh.setString('email', email);
            sh.setString('photo', photo);

            Navigator.push(context, MaterialPageRoute(
              builder: (context) => HomeNewPage(title: "home"),));
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
    }
    }
}

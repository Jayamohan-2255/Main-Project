import 'dart:io';
import 'package:cyber/components/custom_datetext_field.dart';
import 'package:cyber/login/main.dart';
import 'package:cyber/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart ';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cyber/components/authentication_button.dart';
import 'package:cyber/components/custom_text_field.dart';
import 'package:cyber/constants.dart';

final _formkey = GlobalKey<FormState>();

void main() {
  runApp(const MyMySignup());
}

class MyMySignup extends StatelessWidget {
  const MyMySignup({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MySignup',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyMySignupPage(title: 'MySignup'),
    );
  }
}

class MyMySignupPage extends StatefulWidget {
  const MyMySignupPage({super.key, required this.title});

  final String title;

  @override
  State<MyMySignupPage> createState() => _MyMySignupPageState();
}

class _MyMySignupPageState extends State<MyMySignupPage> {
  String gender = "Male";
  File? uploadimage;
  TextEditingController nameController = new TextEditingController();
  TextEditingController dobController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController placeController = new TextEditingController();
  TextEditingController postController = new TextEditingController();
  TextEditingController pinController = new TextEditingController();
  TextEditingController districtController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController cpController = new TextEditingController();

  // Future<void> chooseImage() async {
  //   // final choosedimage = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   //set source: ImageSource.camera to get image from camera
  //   setState(() {
  //     // uploadimage = File(choosedimage!.path);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
          // appBar: AppBar(
          //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          //   title: Text(widget.title),
          // ),

          body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
              // maxHeight: MediaQuery.of(context).size.height * 0.9,
              ),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Text(
                        'Register',
                        style: GoogleFonts.poppins(
                          fontSize: 32.0,
                          fontWeight: FontWeight.w600,
                          color: kDarkGreenColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Create a new account',
                      style: GoogleFonts.poppins(
                        color: kGreyColor,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 40.0),
                    if (_selectedImage != null) ...{
                      InkWell(
                        child: CircleAvatar(
                          radius: 70.0, // Adjust the radius as needed
                          backgroundImage: FileImage(_selectedImage!),
                        ),

                        onTap: _checkPermissionAndChooseImage,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                    } else ...{

                      InkWell(
                        onTap: _checkPermissionAndChooseImage,
                        child: Column(

                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    'https://cdn.pixabay.com/photo/2017/11/10/05/24/select-2935439_1280.png'),
                                radius: 70,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 90),
                                  child: Text('Select Image'),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    },
                    CustomTextField(
                      controller: nameController,
                      hintText: 'Full Name',
                      icon: Icons.person,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                    CustomTextField(
                      controller: emailController,
                      hintText: 'Email',
                      icon: Icons.mail,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Fill';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                    CustomTextField(
                      controller: phoneController,
                      hintText: 'Phone',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Fill';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                    CustomDateTextField(
                      controller: dobController,
                      hintText: 'Dob',
                      icon: Icons.date_range,
                      keyboardType: TextInputType.datetime,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Fill';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),

                    RadioListTile(value: "Male", groupValue: gender, onChanged: (value) { setState(() {gender="Male";}); },title: Text("Male"),),
                    RadioListTile(value: "Female", groupValue: gender, onChanged: (value) { setState(() {gender="Female";}); },title: Text("Female"),),
                    RadioListTile(value: "Other", groupValue: gender, onChanged: (value) { setState(() {gender="Other";}); },title: Text("Other"),),

                    CustomTextField(
                      controller: placeController,
                      hintText: 'Place',
                      icon: Icons.place,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Fill';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                    CustomTextField(
                      controller: postController,
                      hintText: 'Post',
                      icon: Icons.post_add,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Fill';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                    CustomTextField(
                      controller: pinController,
                      hintText: 'Pincode',
                      icon: Icons.pin,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Fill';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                    CustomTextField(
                      controller: districtController,
                      hintText: 'District',
                      icon: Icons.local_activity,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Fill';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                    CustomTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        icon: Icons.lock,
                        obscureText: true,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a password';
                          }
                          return null;
                        }),
                    CustomTextField(
                      controller: cpController,
                      hintText: 'Confirm Password',
                      icon: Icons.lock,
                      obscureText: true,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please confirm your password';
                        } else if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'By signing you agree to our ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                            color: kDarkGreenColor,
                          ),
                        ),
                        Text(
                          ' Terms of use',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                            color: kGreyColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'and ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                            color: kDarkGreenColor,
                          ),
                        ),
                        Text(
                          ' privacy notice',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                            color: kGreyColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: AuthenticationButton(
                    label: 'Sign Up',
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        _send_data();
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(kDarkGreenColor),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewLogScreenPages()));
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 14.0),
                  ),
                )
              ],
            ),
          ),
        ),
      )

          ),
    );
  }

  void _send_data() async {
    String uname = nameController.text;
    String dob = dobController.text;
    String email = emailController.text;
    String phone = phoneController.text;
    String place = placeController.text;
    String post = postController.text;
    String pin = pinController.text;
    String district = districtController.text;
    String password = passwordController.text;
    String cp = cpController.text;

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();

    final urls = Uri.parse('$url/myapp/flutt_signup_post/');
    try {
      final response = await http.post(urls, body: {
        "photo": photo,
        'name': uname,
        'dob': dob,
        'gender': gender,
        'email': email,
        'phone': phone,
        'place': place,
        'post': post,
        'pin': pin,
        'district': district,
        'password': password,
        'cp': cp,
      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          Fluttertoast.showToast(msg: 'Registration Successfull');
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewLogScreenPages(),
              ));
        } else if (status == 'no') {
          Fluttertoast.showToast(msg: 'Email Already Exists');
        } else if (status == 'invalid') {
          Fluttertoast.showToast(msg: 'invalid password');
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

  File? _selectedImage;
  String? _encodedImage;
  Future<void> _chooseAndUploadImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
        _encodedImage = base64Encode(_selectedImage!.readAsBytesSync());
        photo = _encodedImage.toString();
      });
    }
  }

  Future<void> _checkPermissionAndChooseImage() async {
    final PermissionStatus status = await Permission.mediaLibrary.request();
    if (status.isGranted) {
      _chooseAndUploadImage();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Permission Denied'),
          content: const Text(
            'Please go to app settings and grant permission to choose an image.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  String photo = '';
}

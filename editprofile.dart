import 'package:cyber/components/authentication_button.dart';
import 'package:cyber/components/custom_datetext_field.dart';
import 'package:cyber/components/custom_text_field.dart';
import 'package:cyber/constants.dart';
import 'package:cyber/indexviewprofile.dart';
import 'package:google_fonts/google_fonts.dart';


import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart ';

import 'package:permission_handler/permission_handler.dart';

import 'Bottnav.dart';


void main() {
  runApp(const MyEdit());
}

class MyEdit extends StatelessWidget {
  const MyEdit({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edit Profile',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyEditPage(title: 'Edit Profile'),
    );
  }
}

class MyEditPage extends StatefulWidget {
  const MyEditPage({super.key, required this.title});

  final String title;

  @override
  State<MyEditPage> createState() => _MyEditPageState();
}

class _MyEditPageState extends State<MyEditPage> {

  _MyEditPageState()
  {
    _get_data();
  }

  String gender = "Male";
  String uphoto='';
  TextEditingController nameController= new TextEditingController();
  TextEditingController dobController= new TextEditingController();
  TextEditingController emailController= new TextEditingController();
  TextEditingController phoneController= new TextEditingController();
  TextEditingController placeController= new TextEditingController();
  TextEditingController pinController= new TextEditingController();
  TextEditingController districtController= new TextEditingController();


  void _get_data() async{



    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();

    final urls = Uri.parse('$url/myapp/view_user_profile/');
    try {
      final response = await http.post(urls, body: {
        'lid':lid



      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status=='ok') {
          String name=jsonDecode(response.body)['name'];
          String dob=jsonDecode(response.body)['dob'];
          String ugender=jsonDecode(response.body)['gender'];
          String email=jsonDecode(response.body)['email'];
          String phone=jsonDecode(response.body)['phone'];
          String place=jsonDecode(response.body)['place'];
          String pin=jsonDecode(response.body)['pin'];
          String district=jsonDecode(response.body)['district'];
          String photo=url+jsonDecode(response.body)['photo'];


          nameController.text=name;
          dobController.text=dob;
          emailController.text=email;
          phoneController.text=phone;
          placeController.text=place;
          pinController.text=pin;
          districtController.text=district;

setState(() {
  uphoto=photo;
  gender=ugender;
});





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

  @override
  Widget build(BuildContext context) {




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
                          MaterialPageRoute(builder: (context) => Bottnav()));                    },
                    splashRadius: 1.0,
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: kDarkGreenColor,
                      size: 24.0,
                    ),
                  ),
                ),
                Text(
                  'Edit Profile',
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
            child: Container(
              constraints: BoxConstraints(
                // maxHeight: MediaQuery.of(context).size.height * 0.9,
              ),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10.0),
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
                                        uphoto),
                                    radius: 70,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 90),
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
                          hintText: 'Dobb',
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
                          controller: placeController,
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
                        const SizedBox(height: 15.0),

                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: AuthenticationButton(
                        label: 'Edit',
                        onPressed: () {
                            _send_data();
                          }
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )

        // body: SingleChildScrollView(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: <Widget>[
        //
        //       if (_selectedImage != null) ...{
        //         InkWell(
        //           child:
        //           Image.file(_selectedImage!, height: 400,),
        //           radius: 399,
        //           onTap: _checkPermissionAndChooseImage,
        //           // borderRadius: BorderRadius.all(Radius.circular(200)),
        //         ),
        //       } else ...{
        //         // Image(image: NetworkImage(),height: 100, width: 70,fit: BoxFit.cover,),
        //         InkWell(
        //           onTap: _checkPermissionAndChooseImage,
        //           child:Column(
        //             children: [
        //               Image(image: NetworkImage(uphoto),height: 200,width: 200,),
        //               Text('Select Image',style: TextStyle(color: Colors.cyan))
        //             ],
        //           ),
        //         ),
        //       },
        //
        //       Padding(
        //         padding: const EdgeInsets.all(8),
        //         child: TextField(
        //           controller: nameController,
        //           decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Name")),
        //         ),
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.all(8),
        //         child: TextField(
        //           controller: dobController,
        //           decoration: InputDecoration(border: OutlineInputBorder(),label: Text("DoB")),
        //         ),
        //       ),
        //       RadioListTile(value: "Male", groupValue: gender, onChanged: (value) { setState(() {gender="Male";}); },title: Text("Male"),),
        //       RadioListTile(value: "Female", groupValue: gender, onChanged: (value) { setState(() {gender="Female";}); },title: Text("Female"),),
        //       RadioListTile(value: "Other", groupValue: gender, onChanged: (value) { setState(() {gender="Other";}); },title: Text("Other"),),
        //       Padding(
        //         padding: const EdgeInsets.all(8),
        //         child: TextField(
        //           controller: emailController,
        //           decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Email")),
        //         ),
        //       ),   Padding(
        //         padding: const EdgeInsets.all(8),
        //         child: TextField(
        //           controller: phoneController,
        //           decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Phone")),
        //         ),
        //       ),   Padding(
        //         padding: const EdgeInsets.all(8),
        //         child: TextField(
        //           controller: placeController,
        //           decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Place")),
        //         ),
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.all(8),
        //         child: TextField(
        //           controller: pinController,
        //           decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Pin")),
        //         ),
        //       ),       Padding(
        //         padding: const EdgeInsets.all(8),
        //         child: TextField(
        //           controller: districtController,
        //           decoration: InputDecoration(border: OutlineInputBorder(),label: Text("District")),
        //         ),
        //       ),
        //
        //       ElevatedButton(
        //         onPressed: () {
        //           _send_data();
        //
        //         },
        //         child: Text("Confirm Edit"),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
  void _send_data() async{





    String uname=nameController.text;
    String dob=dobController.text;
    String email=emailController.text;
    String phone=phoneController.text;
    String place=placeController.text;
    String pin=pinController.text;
    String district=districtController.text;


    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();

    final urls = Uri.parse('$url/myapp/edit_user_profile/');
    try {

      final response = await http.post(urls, body: {
        "photo":photo,
        'name':uname,
        'dob':dob,
        'gender':gender,
        'email':email,
        'phone':phone,
        'place':place,
        'pin':pin,
        'district':district,
        'lid':lid,

      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status=='ok') {

          Fluttertoast.showToast(msg: 'Updated Successfully');
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => Bottnav(),));
        }
        else if(status=='no'){
          Fluttertoast.showToast(msg: 'Email Already Exists');

        }
        else {
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

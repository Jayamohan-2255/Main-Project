import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cyber/components/authentication_button.dart';
import 'package:cyber/components/custom_text.dart';
import 'package:cyber/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart%20';
import 'package:permission_handler/permission_handler.dart';
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
      home: const imageforgery(title: 'SendComplaint'),
    );
  }
}

class imageforgery extends StatefulWidget {
  const imageforgery({super.key, required this.title});

  final String title;

  @override
  State<imageforgery> createState() => _imageforgeryState();
}

class _imageforgeryState extends State<imageforgery> {


  @override
  Widget build(BuildContext context) {

    TextEditingController SendComplaintController= new TextEditingController();


    return WillPopScope(
      onWillPop: () async{ return true; },
      child: Scaffold(

        body: Column(
          children: <Widget>[

            if (_selectedImage != null) ...{
              InkWell(
                child: Image(
                  image: FileImage(_selectedImage!),height: 300,width: 200,fit: BoxFit.contain,
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
                      child: Image(
                        image: NetworkImage(
                            "https://cdn.pixabay.com/photo/2017/11/10/05/24/select-2935439_1280.png"),height: 300,width: 200,

                      ),
                    )
                  ],
                ),
              ),
            },
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AuthenticationButton(
                    label: 'Check',
                    labelColor: Colors.white,
                    onPressed: () async {
                            SharedPreferences sh = await SharedPreferences.getInstance();
                            String url = sh.getString('url').toString();
                            String lid = sh.getString('lid').toString();

                            final urls = Uri.parse('$url/myapp/user_checkimagefake/');
                            try {
                              final response = await http.post(urls, body: {
                                'photo':photo,


                              });
                              if (response.statusCode == 200) {
                                String status = jsonDecode(response.body)['status'];
                                if (status=='ok') {
                                  String msg = jsonDecode(response.body)['msg'];


                                  showDialog(context: context, builder: (context) {
                                    return AlertDialog(
                                      title: Text("Image Forgery Result"),
                                      content: Container(
                                        height: 100,
                                        alignment: Alignment.center,
                                        child: Text(msg,style: TextStyle(color: Colors.green,fontSize: 20,fontWeight: FontWeight.w700),),
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
    );
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

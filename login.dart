import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cyber/homenew.dart';
import 'package:cyber/main.dart';
import 'package:cyber/signup.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyLoginpage(title: 'DREAM GARDEN'),
    );
  }
}

class MyLoginpage extends StatefulWidget {
  const MyLoginpage({super.key, required this.title});

  final String title;

  @override
  State<MyLoginpage> createState() => _MyLoginpageState();
}

class _MyLoginpageState extends State<MyLoginpage> {
  TextEditingController unamecontroller= new TextEditingController();
  TextEditingController passcontroller=new TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyLoginpage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: unamecontroller,
                decoration: InputDecoration(
                  labelText: 'username'

                ),
              ),
              Column(
                children: [
                  TextField(
                    controller: passcontroller,
                    decoration: InputDecoration(
                      labelText: 'password'
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  ElevatedButton(onPressed: (){
                    _send_data();
                  }, child:
                      Text('submit')
                  )
                ],
              ),
              Column(
                children: [
                  TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MyMySignup()));
                  }, child:
                  Text('signup')
                  )
                ],
              )

            ],
          ),

        ),
      )
    );
  }
  void _send_data() async{


    String uname=unamecontroller.text;
    String password=passcontroller.text;

    print("ssssssssssssssss");
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
        print("ssssssssssssssss$status");
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
        }
        else if(status=='not ok')
          {

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Invalid username or password.'),
                duration: Duration(seconds: 8),
              ),
            );


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
}


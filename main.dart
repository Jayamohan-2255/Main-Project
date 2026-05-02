import 'package:cyber/login/main.dart';
import 'package:flutter/material.dart';
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
      home: const Myip(title: 'IP PAGE'),
    );
  }
}

class Myip extends StatefulWidget {
  const Myip({super.key, required this.title});

  final String title;

  @override
  State<Myip> createState() => _MyipState();
}

class _MyipState extends State<Myip> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController ipController = new TextEditingController();
  _MyipState(){
    setIp();
  }
  void setIp() async{
    SharedPreferences sh = await SharedPreferences.getInstance();
    setState(() {
      ipController.text = sh.getString("ip").toString();
      print(sh.getString('ip'));

    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Your Username';
                      }
                      return null; // Return null if the input is valid
                    },
                    controller: ipController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), label: Text("IP")),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 5),
                      child: SizedBox(
                        width: 275,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              String ipv = ipController.text;
                              final pref =
                                  await SharedPreferences.getInstance();
                              pref.setString("ip", ipv.toString());
                              pref.setString(
                                  "url", "http://" + ipv.toString() + ":8000");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewLogScreenPages()),
                              );
                            }
                          },
                          child: Text('IP'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

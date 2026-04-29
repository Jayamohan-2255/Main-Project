import 'dart:async';
import 'dart:convert';
import 'package:cyber/emailspamcheck.dart';
import 'package:cyber/phishingurlcheck.dart';
import 'package:http/http.dart' as http;
import 'package:cyber/login/main.dart';
import 'package:cyber/viewnotif.dart';
import 'package:flutter/material.dart';
import 'package:cyber/feedback.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cyber/indexviewprofile.dart';
import 'package:cyber/viewreply.dart';
import 'package:cyber/changepassword.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

import 'image forgery.dart';

void main() {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(

    // The top level function, aka callbackDispatcher
      callbackDispatcher,

      // If enabled it will post a notification whenever
      // the task is running. Handy for debugging tasks
      isInDebugMode: true);
// Periodic task registration
  Workmanager().registerPeriodicTask(
    "2",

    //This is the value that will be
    // returned in the callbackDispatcher
    "simplePeriodicTask",

    // When no frequency is provided
    // the default 15 minutes is set.
    // Minimum frequency is 15 min.
    // Android will automatically change
    // your frequency to 15 min
    // if you have configured a lower frequency.
    frequency: Duration(seconds: 15),
  );
  runApp(const HomeNew());
}
void callbackDispatcher(String message, String date) {
  print("hiii");

  // Workmanager().executeTask((task, inputData) {
  // initialise the plugin of flutterlocalnotifications.
  FlutterLocalNotificationsPlugin flip =
  new FlutterLocalNotificationsPlugin();

  // app_icon needs to be a added as a drawable
  // resource to the Android head project.
  var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
  // var IOS = new IOSInitializationSettings();

  // initialise settings for both Android and iOS device.
  var settings = new InitializationSettings(android: android);
  flip.initialize(settings);
  _showNotificationWithDefaultSound(flip, message,date);
  // return Future.value(true);
  // });
}

Future _showNotificationWithDefaultSound(flip,String message,String date) async {
// Show a notification after every 15 minute with the first
// appearance happening a minute after invoking the method
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name',
      importance: Importance.max, priority: Priority.high);

// initialise channel platform for both Android and iOS device.
  var platformChannelSpecifics =
  new NotificationDetails(android: androidPlatformChannelSpecifics);
  await flip.show(
      0,
      'Notification',
      date+"\n"+message,
      platformChannelSpecifics,
      payload: 'Default_Sound');
}

class HomeNew extends StatelessWidget {
  const HomeNew({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 18, 82, 98)),
        useMaterial3: true,
      ),
      home: const HomeNewPage(title: 'Home'),
    );
  }
}

class HomeNewPage extends StatefulWidget {
  const HomeNewPage({super.key, required this.title});

  final String title;

  @override
  State<HomeNewPage> createState() => _HomeNewPageState();

}

class _HomeNewPageState extends State<HomeNewPage> {

  String uname_ = "";
  String email_ = "";
  String uphoto_ = "";
  Timer? _timer;

  a() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String name = sh.getString('name').toString();
    String email = sh.getString('email').toString();
    String photo = sh.getString('photo').toString();

    setState(() {
      uname_ = name;
      email_ = email;
      uphoto_ = photo;
    });
  }
  @override
  void initState() {
    a();
    _timer=Timer.periodic(Duration(seconds: 15), (timer) {
      getdata();
    });
    super.initState();
  }
  List<Widget> pages=[
    phishingurlcheck(title: "Url Phishing"),
    emailspamcheck(title: "Email Spam"),
    imageforgery(title: "Image forgery"),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: DefaultTabController(
        length: 3, // Number of tabs
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                TabBar(
                  indicatorColor: Colors.red,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(icon: Icon(Icons.phishing), text: "Url Phishing"),
                    Tab(icon: Icon(Icons.email), text: "Email Spam"),
                    Tab(icon: Icon(Icons.image), text: "Image Forgery"),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height*0.7,
                  child: TabBarView(
                    children:pages,
                  ),
                ),
              ],
            ),
          ),


        // drawer: Drawer(
        //   child: ListView(
        //     padding: EdgeInsets.zero,
        //     children: [
        //       DrawerHeader(
        //         decoration: BoxDecoration(
        //           color: Color.fromARGB(255, 18, 82, 98),
        //         ),
        //         child: Column(children: [
        //           Text(
        //             'Cyber Security',
        //             style: TextStyle(fontSize: 20, color: Colors.white),
        //           ),
        //           CircleAvatar(
        //               radius: 29, backgroundImage: NetworkImage(uphoto_)),
        //           Text(uname_, style: TextStyle(color: Colors.white)),
        //           Text(email_, style: TextStyle(color: Colors.white)),
        //         ]),
        //       ),
        //       ListTile(
        //         leading: Icon(Icons.home),
        //         title: const Text('Home'),
        //         onTap: () {
        //           // Navigator.pop(context);
        //           Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                 builder: (context) => HomeNewPage(title: "Home"),
        //               ));
        //         },
        //       ),
        //       ListTile(
        //         leading: Icon(Icons.person_pin),
        //         title: const Text(' Profile '),
        //         onTap: () {
        //           Navigator.pop(context);
        //           Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                 builder: (context) => ViewProfilePage(title: 'Profile'),
        //               ));
        //         },
        //       ),
        //
        //
        //
        //       ListTile(
        //         leading: Icon(Icons.notifications),
        //         title: const Text('Notification'),
        //         onTap: () {
        //           Navigator.pop(context);
        //           Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                 builder: (context) => Viewnorif(
        //                   title: "Notification",
        //                 ),
        //               ));
        //         },
        //       ),
        //       ListTile(
        //         leading: Icon(Icons.dynamic_feed),
        //         title: const Text('Complaint '),
        //         onTap: () {
        //           Navigator.pop(context);
        //           Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                 builder: (context) => ViewReplyPage(
        //                   title: "View Complaint",
        //                 ),
        //               ));
        //         },
        //       ),
        //
        //       ListTile(
        //         leading: Icon(Icons.feed_outlined),
        //         title: const Text('Feedback '),
        //         onTap: () {
        //           Navigator.pop(context);
        //           Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                 builder: (context) => MyFeedbackPage(
        //                   title: "Feedback",
        //                 ),
        //               ));
        //         },
        //       ),
        //       ListTile(
        //         leading: Icon(Icons.change_circle),
        //         title: const Text(' Change Password '),
        //         onTap: () {
        //           Navigator.pop(context);
        //           Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                 builder: (context) => MyChangePasswordPage(
        //                   title: "Change Password",
        //                 ),
        //               ));
        //         },
        //       ),
        //       ListTile(
        //         leading: Icon(Icons.logout),
        //         title: const Text('LogOut'),
        //         onTap: () {
        //           _timer?.cancel();
        //           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NewLogScreenPages()));
        //
        //         },
        //       ),
        //     ],
        //   ),
        // ),
      ),
      )
    );
  }
  String Reminer = "", id = "", Date = "", Time = "";

  Future<void> getdata() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    try {
      // String url = "${sh.getString("url").toString()}/viewNotification/";


      String url = sh.getString('url').toString();

      final urls = Uri.parse('$url/myapp/user_viewnotifalert/');

      String nid="0";
      if(sh.containsKey("nid")==false) {}
      else{
        nid=sh.getString('nid').toString();
      }
      // Fluttertoast.showToast(msg:nid);

      var datas = await http.post(urls, body: {'nid': nid });
      var jsondata = json.decode(datas.body);
      String status = jsondata['status'];
      print(status);
      if (status == "ok") {
        String nid = jsondata['nid'].toString();
        String message = jsondata['message'];
        String date = jsondata['date'].toString();
        sh.setString('nid',nid);
        callbackDispatcher(message,date);

      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      print("Error ------------------- " + e.toString());
      //there is error during converting file image to base64 encoding.
    }
  }
}

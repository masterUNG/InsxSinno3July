import 'package:circular_profile_avatar/circular_profile_avatar.dart';

import 'package:flutter/material.dart';
import 'package:psinsx/models/user_model.dart';
import 'package:psinsx/pages/add_information_user.dart';

import 'package:psinsx/pages/help_page.dart';
import 'package:psinsx/pages/information_user.dart';
import 'package:psinsx/pages/map.dart';
import 'package:psinsx/pages/report_page.dart';
import 'package:psinsx/pages/search_page.dart';
import 'package:psinsx/pages/signin_page.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  //HomePage({Key key}) : super(key: key);
  bool statusINSx; // false => Non Back frome edit INSx
  HomePage({Key key, this.statusINSx}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String nameUser, userEmail, userImge, userId;
  bool status;

  Widget currentWidget = MyMap();
  int selectedIndex = 0;

  List pages = [MyMap(), ReportPage(), SearchPage()];

  UserModel userModel;

  @override
  void initState() {
    super.initState();
    readUserInfo();
  }

  Future<Null> readUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      nameUser = preferences.getString('staffname');
      userEmail = preferences.getString('user_email');
      userImge = preferences.getString('user_img');
      userId = preferences.getString('id');
    });
  }

  Widget showDrawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bird.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      currentAccountPicture: GestureDetector(
        onTap: () {
          MaterialPageRoute materialPageRoute = MaterialPageRoute(
            builder: (context) => AddInformationUser(),
          );
          Navigator.push(context, materialPageRoute)
              .then((value) => readUserInfo());
        },
        child: CircularProfileAvatar(
          '$userImge',
          borderWidth: 4.0,
        ),
      ),
      accountName: Text('$nameUser'),
      accountEmail: Text('$userEmail'),
    );
  }

  Future<Null> signOutProcess() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    //exit(0);
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => SignIn());
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Future<Null> launchURL() async {
    const url = 'https://pea23.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            showDrawerHeader(),
            ListTile(
                leading: Icon(Icons.person_pin),
                title: Text('ข้อมูลส่วนตัว'),
                subtitle: Text(
                  'ข้อมูลส่วนตัวของพนักงาน',
                  style: TextStyle(fontSize: 10),
                ),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => InformationUser()));
                }),
            ListTile(
                leading: Icon(Icons.download_rounded),
                title: Text('ดึงข้อมูล'),
                subtitle: Text(
                  'เปิดเว็ปไซต์บริษัท,แหล่งข้อมูล',
                  style: TextStyle(fontSize: 10),
                ),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.pop(context);
                  launchURL();
                }),
            ListTile(
                leading: Icon(Icons.help),
                title: Text('ช่วยเหลือ'),
                subtitle: Text(
                  'ช่วยเหลือ คู่มือต่าง',
                  style: TextStyle(fontSize: 10),
                ),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HelpPage()));
                }),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('ออกจากระบบ'),
              subtitle: Text(
                'ออกจากระบบ',
                style: TextStyle(fontSize: 10),
              ),
              onTap: () => signOutProcess(),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Center(
          child: Text(
            'สวัสดี $nameUser',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.notifications,
                color: Colors.red[100],
              ),
              onPressed: () {})
        ],
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xff6a1b9a),
          selectedItemColor: Colors.white,
          unselectedItemColor: Color(0xffce93d8),
          
          showUnselectedLabels: true,
          currentIndex: selectedIndex,
          onTap: (int index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'แผนที่',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_box_rounded),
              label: 'อัพโหลดแล้ว',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'ประวัติ&พิกัด',
            ),
            // BottomNavigationBarItem(
            //   icon: IconButton(
            //       icon: Icon(Icons.download_rounded),
            //       onPressed: () {
            //         launchURL();
            //       }),
            //   label: 'ดึงข้อมูล',
            // ),
          ]),
    );
  }
}

import 'package:dental_new/pages/Patientrecordpage.dart';
import 'package:dental_new/pages/reportpage.dart';
import 'package:dental_new/utils/bottomnavigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final user = FirebaseAuth.instance.currentUser!;

  //sign out function
  void signout() {
    FirebaseAuth.instance.signOut();
  }

  int selectedindex = 0;
  void navigatebar(int index) {
    setState(() {
      selectedindex = index;
    });
  }

  final List<Widget> pages = [
    Patientrecordpage(),
    Reportpage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      backgroundColor: Colors.grey.shade500,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black87
                
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: user.photoURL != null 
                      ? NetworkImage(user.photoURL!) 
                      : null,
                    child: user.photoURL == null 
                      ? Icon(Icons.person, size: 30, color: Colors.white)
                      : null,
                  ),
                  SizedBox(height: 10),
                  Text(
                    user.displayName ?? 'User',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.email ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                signout(); // Call the signout function
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('GRAT'),
        backgroundColor: Color.fromARGB(255, 5, 89, 157),
        automaticallyImplyLeading: true, // This will show the drawer icon
      ),
      body: pages[selectedindex],
      bottomNavigationBar: Bottomnavigator(ontabc: (index) => navigatebar(index)),
    );
  }
}
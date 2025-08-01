import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class Bottomnavigator extends StatelessWidget {
  void Function(int)? ontabc;
  Bottomnavigator({super.key, required this.ontabc});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                child: GNav(
                    rippleColor: Colors.grey[300]!,
                    hoverColor: Colors.grey[100]!,
                    gap: 24,
                    activeColor: Colors.black,
                    iconSize: 24,
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 12),
                    duration: Duration(milliseconds: 400),
                    tabBackgroundColor: Colors.blue[100]!,
                    color: Colors.black,
                    onTabChange: (event) => ontabc!(event),
                    // padding: EdgeInsets.all(50),
                    tabs: const [
                      GButton(
                        icon: LineIcons.user,
                        text: "Patients",
                      ),
                      GButton(
                        icon: LineIcons.clipboard,
                        text: "Report",
                      ),
                    ]))));
  }
}

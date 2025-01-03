import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_screen.dart';
import 'informasi_kb/informasi_kb_screen.dart';
import 'penjadwalan_screen.dart';
import 'riwayat_penjadwalan_screen.dart';

class DashboardScreen extends StatefulWidget {
  final User user;

  DashboardScreen({required this.user});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions(User user) {
    return <Widget>[
      ProfileScreen(user: user),
      InformasiKBScreen(user: user),
      PenjadwalanScreen(user: user),
      RiwayatPenjadwalanScreen(user: user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: _widgetOptions(widget.user).elementAt(_selectedIndex),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.person, size: 30, color: Colors.white),
          Icon(Icons.info, size: 30, color: Colors.white),
          Icon(Icons.schedule, size: 30, color: Colors.white),
          Icon(Icons.history, size: 30, color: Colors.white),
        ],
        color:                                             const Color(0xFFE84C3D),

        buttonBackgroundColor:                                             const Color(0xFFE84C3D),

        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:keluarga_berencana/informasi_kb/iud_screen.dart';
import 'package:keluarga_berencana/informasi_kb/kb_implan_screen.dart';
import 'package:keluarga_berencana/informasi_kb/pil_kb_screen.dart';
import 'package:keluarga_berencana/informasi_kb/suntik_kb_screen.dart';
import 'package:keluarga_berencana/login_screen.dart';

class InformasiKBScreen extends StatefulWidget {
  final User user;

  InformasiKBScreen({required this.user});

  @override
  _InformasiKBScreenState createState() => _InformasiKBScreenState();
}

class _InformasiKBScreenState extends State<InformasiKBScreen> {
  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()), // Adjust as needed
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informasi KB'),
        backgroundColor: const Color(0xFFE84C3D),
        automaticallyImplyLeading: false, // Remove the back button
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white), // White icon color
            onPressed: _logout,
          ),
        ],
        titleTextStyle: TextStyle(
          color: Colors.white, // White text color
          fontSize: 24, // Adjust the font size here (smaller size)
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Jumlah kolom dalam satu baris
          crossAxisSpacing: 16.0, // Jarak horizontal antar kartu
          mainAxisSpacing: 16.0, // Jarak vertikal antar kartu
          children: [
            buildCard('Pil KB', Icons.medication),
            buildCard('KB Implan', Icons.healing),
            buildCard('Suntik KB', Icons.local_hospital),
            buildCard('IUD', Icons.pregnant_woman),
          ],
        ),
      ),
    );
  }

  Widget buildCard(String title, IconData icon) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to the detail screen based on the title
          if (title == 'Pil KB') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PilKBScreen()),
            );
          } else if (title == 'IUD') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => IUDScreen()),
            );
          } else if (title == 'Suntik KB') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SuntikKBScreen()),
            );
          } else if (title == 'KB Implan') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => KBImplanScreen()),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48.0,
                color: Color(0xFFE84C3D),
              ),
              SizedBox(height: 16.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
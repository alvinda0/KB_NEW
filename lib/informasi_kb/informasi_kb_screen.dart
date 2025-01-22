import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:keluarga_berencana/NotificationService.dart';
import 'package:keluarga_berencana/informasi_kb/iud_screen.dart';
import 'package:keluarga_berencana/informasi_kb/kb_implan_screen.dart';
import 'package:keluarga_berencana/informasi_kb/pil_kb_screen.dart';
import 'package:keluarga_berencana/informasi_kb/suntik_kb_screen.dart';
import 'package:keluarga_berencana/login_screen.dart';

class InformasiKBScreen extends StatefulWidget {
  final User user;

  const InformasiKBScreen({super.key, required this.user});

  @override
  _InformasiKBScreenState createState() => _InformasiKBScreenState();
  
  
}

class _InformasiKBScreenState extends State<InformasiKBScreen> {
 final NotificationService _notificationService = NotificationService();

 @override
 void initState() {
   super.initState();
   _notificationService.init();
 }

 void _logout() async {
   await FirebaseAuth.instance.signOut();
   Navigator.pushReplacement(
     context,
     MaterialPageRoute(builder: (context) => LoginScreen()),
   );
 }

 Future<void> _testNotification() async {
   try {
     await _notificationService.scheduleNotification(
       id: 'test',
       title: 'Test Notifikasi',
       body: 'Ini adalah notifikasi test',
       scheduledDate: DateTime.now().add(const Duration(seconds: 5)),
     );
     ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(content: Text('Notifikasi akan muncul dalam 5 detik')),
     );
   } catch (e) {
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Error: $e')),
     );
   }
 }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text('Informasi KB'),
       backgroundColor: const Color(0xFFE84C3D),
       automaticallyImplyLeading: false,
       actions: [
         IconButton(
           icon: Icon(Icons.logout, color: Colors.white),
           onPressed: _logout,
         ),
       ],
       titleTextStyle: TextStyle(
         color: Colors.white,
         fontSize: 24,
       ),
     ),
     body: Padding(
       padding: const EdgeInsets.all(16.0),
       child: Column(
         children: [
           ElevatedButton(
             onPressed: _testNotification,
             style: ElevatedButton.styleFrom(
               backgroundColor: const Color(0xFFE84C3D),
               foregroundColor: Colors.white,
               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
             ),
             child: const Text(
               'Test Notifikasi',
               style: TextStyle(fontSize: 16),
             ),
           ),
           const SizedBox(height: 16),
           Expanded(
             child: GridView.count(
               crossAxisCount: 2,
               crossAxisSpacing: 16.0,
               mainAxisSpacing: 16.0,
               children: [
                 buildCard('Pil KB', Icons.medication),
                 buildCard('KB Implan', Icons.healing),
                 buildCard('Suntik KB', Icons.local_hospital),
                 buildCard('IUD', Icons.pregnant_woman),
               ],
             ),
           ),
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
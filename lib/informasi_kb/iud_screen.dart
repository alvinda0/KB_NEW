import 'package:flutter/material.dart';

class IUDScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IUD'),
        backgroundColor: const Color(0xFFE84C3D),
      ),
      body: Center(
        child: Text('Informasi tentang IUD'),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class SuntikKBScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suntik KB'),
        backgroundColor: const Color(0xFFE84C3D),
      ),
      body: Center(
        child: Text('Informasi tentang Suntik KB'),
      ),
    );
  }
}
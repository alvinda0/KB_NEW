import 'package:flutter/material.dart';

class PilKBScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pil KB'),
        backgroundColor: const Color(0xFFE84C3D),
      ),
      body: Center(
        child: Text('Informasi tentang Pil KB'),
      ),
    );
  }
}
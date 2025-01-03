import 'package:flutter/material.dart';


class KBImplanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KB Implan'),
        backgroundColor: const Color(0xFFE84C3D),
      ),
      body: Center(
        child: Text('Informasi tentang KB Implan'),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class PilKBScreen extends StatelessWidget {
  const PilKBScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pil KB'),
        backgroundColor: const Color(0xFFE84C3D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            "Kontrasepsi pil adalah metode yang efektif untuk mencegah kehamilan, pada penggunaan yang sempurna efektivitasnya 99,5-99,9% dan salah satu metode yang paling disukai karena kesuburan cepat kembali setelah penggunaan pil dihentikan. Ada dua macam kontrasepsi pil, yaitu: pil kombinasi dan pil progestin\n\nPil kombinasi adalah jenis kontrasepsi yang paling umum digunakan, mengandung estrogen dan progesterone. Estrogen yang biasa digunakan adalah ethinyl estradiol dengan dosis 0,05 mcg per tablet; progestin yang digunakan bervariasi.\n\nPil progestin (pil mini) mengandung progestin dosis kecil, sekitar 0,5 mg atau kurang, tanpa estrogen. Tanpa kombinasi dengan estrogen, progestin lebih sering menimbulkan perdarahan tidak teratur.\n\nPEMAKAIAN :\nPil kombinasi : diminum setiap hari dalam 3 minggu dan diikuti periode 1 minggu tanpa pil.\nPil progestin (pil mini) : Pil mini harus diminum setiap hari juga saat menstruasi.\n\nKEUNTUNGAN :\nefektif mencegah kehamilan, dapat digunakan pada masa remaja hingga menopause, membuat siklus haid menjadi teratur.\n\nKEKURANGAN :\ntidak melindungi dari penyakit menular seksual, pendarahan tidak teratur dan spotting, tidak cocok untuk perempuan yang mengalami kondisi tertentu, seperti kanker payudara, kanker rahim, penyakit jantung, tekanan darah tinggi, dan gangguan hati",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}

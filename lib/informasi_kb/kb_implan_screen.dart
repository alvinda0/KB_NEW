import 'package:flutter/material.dart';

class KBImplanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KB Implan'),
        backgroundColor: const Color(0xFFE84C3D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            """
Kontrasepsi implant adalah salah satu jenis kontrasepsi yang berupa susuk yang terbuat dari sejenis karet silastik yang berisi hormon, dipasang pada lengan atas. Implant berisi levonorgestrel yang merupakan hormon progesteron. Ada 5 jenis kontrasepsi implant, yaitu: Norplant, Sino-Implant 2, Jadelle, Implanon, dan Nexplanon.

**Jenis Kontrasepsi Implant:**
- **Norplant**: Sistem susuk KB dengan enam batang.
- **Sino-Implant 2**: KB implant dengan dua batang dan disubsidi oleh Jaminan Kesehatan Nasional (JKN) di Indonesia.
- **Jadelle**: KB implant dengan dua batang, diproduksi oleh swasta dan dijual di seluruh dunia.
- **Implanon**: Mirip dengan Jadelle tetapi hanya satu batang.
- **Nexplanon**: Generasi terbaru dari KB implant, dilengkapi dengan radiopak untuk memudahkan pengeluaran.

**Pemakaian:**
- **Norplant**: Lama kerja 5 tahun.
- **Sino-Implant 2**: Lama kerja 4 hingga 5 tahun.
- **Jadelle**: Lama kerja 5 tahun.
- **Implanon**: Lama kerja 3 tahun.
- **Nexplanon**: Lama kerja 3 tahun.

**Keuntungan:**
- Sangat efektif dalam mencegah kehamilan.
- Masa kerja panjang.
- Dosis rendah.
- Reversible untuk wanita.
- Kegagalan pengguna rendah.
- Tidak mengganggu seks.

**Kekurangan:**
- Tidak dapat mencegah penyakit menular seksual.
- Biaya relatif mahal.
- Pemasangan awal KB implant memberikan risiko bengkak pada kulit.
- Siklus menstruasi menjadi tidak teratur.
- Spotting.
- Nyeri pada kepala.
- Nyeri pada payudara.
- Nyeri perut.
- Mual.
            """,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}

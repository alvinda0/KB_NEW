import 'package:flutter/material.dart';

class SuntikKBScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kontrasepsi Suntik KB"),
        backgroundColor: const Color(0xFFE84C3D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            """
Kontrasepsi suntik adalah alat kontrasepsi berupa cairan yang berisi hormone progestron yang disuntikkan ke dalam tubuh secara periodik (1 bulan sekali atau 3 bulan sekali). Ada 2 jenis suntik KB, yakni KB suntik setiap 1 bulan (kombinasi) dan 3 bulan (DMPA). Metode ini praktis, efektif, dan aman dengan tingkat keberhasilan lebih dari 99%.

**Suntik Kombinasi:**
Suntik kombinasi adalah mirip dengan pil kombinasi yang mengandung estrogen dan progestin lebih sedikit dibandingkan DMPA, sehingga dapat mengurangi efek samping perdarahan tidak teratur.

**Suntik DMP (Depo-Medroxyprogesterone Acetate):**
Merupakan metode kontrasepsi hormonal yang hanya mengandung progesteron 150 mg.

**Pemakaian:**
- **Suntik kombinasi**: dilakukan satu kali setiap 28 hingga 30 hari.
- **Suntik DMP**: disuntikkan secara intramuskular setiap 3 bulan.

**Keuntungan:**
- Praktis, efektif, dan aman dalam mencegah kehamilan.
- Bertahan jangka panjang hingga 3 bulan.
- Lebih praktis dibandingkan pil KB.
- Tidak mengganggu seks.

**Kekurangan:**
- Tidak dapat mencegah penyakit menular seksual.
- Periode menstruasi terganggu.
- Berat badan yang bertambah.
- Mual dan pusing.
- Bisa menyebabkan warna biru dan rasa nyeri pada daerah suntikan.
            """,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}

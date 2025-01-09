import 'package:flutter/material.dart';

class IUDScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alat Kontrasepsi Dalam Rahim (IUD)"),
        backgroundColor: const Color(0xFFE84C3D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            """
Intra Uterine Devices (IUD) atau Alat Kontrasepsi Dalam Rahim (AKDR) merupakan salah satu kontrasepsi jangka panjang yang efektif, aman, dan reversibel, dimana terbuat dari plastik atau logam kecil yang dililit dengan tembaga dengan berbagai ukuran dan dimasukkan ke dalam uterus. Ada 2 jenis IUD, yaitu: IUD hormonal (berisi hormon progestin) dan IUD non hormonal (terbuat dari tembaga).

**Pemakaian:**
- **IUD hormonal** dapat bertahan 5 tahun.
- **IUD tembaga** dapat bertahan hingga 5 - 10 tahun.

**Keuntungan:**
- Dapat dipakai oleh semua perempuan dalam usia produktif.
- Dapat digunakan sampai menopause.
- Efektivitas baik dalam mencegah kehamilan.
- Bertahan jangka panjang lebih dari 5 tahun.
- Tidak memerlukan perawatan yang rumit.

**Kekurangan:**
- Tidak dapat mencegah penyakit menular seksual.
- IUD bergeser dan keluar dari tempatnya.
- Biaya lebih mahal.
- Perubahan siklus menstruasi.
- Spotting, amenorhea, dismenorhea, dan pendarahan post-seksual.
            """,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}

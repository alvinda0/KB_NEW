import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keluarga_berencana/login_screen.dart';

class RiwayatPenjadwalanScreen extends StatefulWidget {
  final User user;

  const RiwayatPenjadwalanScreen({Key? key, required this.user})
      : super(key: key);

  @override
  _RiwayatPenjadwalanScreenState createState() =>
      _RiwayatPenjadwalanScreenState();
}

class _RiwayatPenjadwalanScreenState extends State<RiwayatPenjadwalanScreen> {
  late Stream<QuerySnapshot> _penjadwalanStream;
  final Map<String, List<String>> metodeKontrasepsi = {
    'Pil KB': ['Pil Kombinasi', 'Pil Progrestin (Pil Mini)'],
    'Suntik': ['Suntik Kombinasi', 'Suntik DMPA'],
    'IUD': ['IUD Hormonal', 'IUD Non Hormonal'],
    'Implan': ['Norplant', 'Sino-Implan 2', 'Jadelle', 'Implanon', 'Nexplanon'],
  };

  @override
  void initState() {
    super.initState();
    _penjadwalanStream = FirebaseFirestore.instance
        .collection('penjadwalan')
        .where('user_id', isEqualTo: widget.user.uid)
        .snapshots();
  }

  Future<void> _deletePenjadwalan(String docId) async {
  // Show confirmation dialog
  bool? confirmed = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus jadwal ini?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Close and return false
            },
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Close and return true
            },
            child: const Text('Hapus'),
          ),
        ],
      );
    },
  );

  // If confirmed, delete the document
  if (confirmed == true) {
    try {
      await FirebaseFirestore.instance
          .collection('penjadwalan')
          .doc(docId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jadwal berhasil dihapus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}


  Future<void> _updatePenjadwalan(
      String docId, Map<String, dynamic> currentData) async {
    String selectedMetode = currentData['metode_kontrasepsi'];
    String selectedDurasi = currentData['durasi_kontrasepsi'];

    // Ensure selectedDurasi is in the list of available durations for the selectedMetode
    if (!metodeKontrasepsi[selectedMetode]!.contains(selectedDurasi)) {
      selectedDurasi = metodeKontrasepsi[selectedMetode]!.first;
    }

    final TextEditingController tanggalController =
        TextEditingController(text: currentData['tanggal']);
    final TextEditingController jamController =
        TextEditingController(text: currentData['jam']);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Update Jadwal'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedMetode,
                      decoration: const InputDecoration(
                          labelText: 'Metode Kontrasepsi'),
                      items: metodeKontrasepsi.keys.map((String key) {
                        return DropdownMenuItem<String>(
                          value: key,
                          child: Text(key),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedMetode = value!;
                          selectedDurasi =
                              metodeKontrasepsi[selectedMetode]!.first;
                        });
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedDurasi,
                      decoration: const InputDecoration(labelText: 'Durasi'),
                      items: metodeKontrasepsi[selectedMetode]!
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDurasi = value!;
                        });
                      },
                    ),
                    TextField(
                      controller: tanggalController,
                      decoration: const InputDecoration(labelText: 'Tanggal'),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          String formattedDate =
                              "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                          setState(() {
                            tanggalController.text = formattedDate;
                          });
                        }
                      },
                    ),
                    TextField(
                      controller: jamController,
                      decoration: const InputDecoration(labelText: 'Jam'),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          final now = DateTime.now();
                          final selectedTime = DateTime(now.year, now.month,
                              now.day, pickedTime.hour, pickedTime.minute);
                          final formattedTime =
                              DateFormat('HH:mm').format(selectedTime);
                          setState(() {
                            jamController.text = formattedTime;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      await FirebaseFirestore.instance
                          .collection('penjadwalan')
                          .doc(docId)
                          .update({
                        'metode_kontrasepsi': selectedMetode,
                        'durasi_kontrasepsi': selectedDurasi,
                        'tanggal': tanggalController.text,
                        'jam': jamController.text,
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Jadwal berhasil diupdate')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  },
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String formatDate(String date) {
    return date;
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => LoginScreen()), // Adjust as needed
    );
  }

  void _showDetails(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Detail Penjadwalan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(
                    'Metode Kontrasepsi', data['metode_kontrasepsi']),
                _buildDetailRow('Durasi', data['durasi_kontrasepsi']),
                _buildDetailRow('Tanggal', data['tanggal']),
                _buildDetailRow('Jam', data['jam']),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.teal[800],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Penjadwalan'),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _penjadwalanStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data?.docs.isEmpty ?? true) {
            return const Center(child: Text('Belum ada riwayat penjadwalan'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              return Container(
                margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Icon(Icons.history, color: Colors.blue),
                  title: Text('${data['metode_kontrasepsi']}'),
                  subtitle: Row(
                    children: [
                      Text('${data['tanggal']}'),
                      Text(' ${data['jam']}'),
                    ],
                  ),
                  onTap: () => _showDetails(data),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.green),
                        onPressed: () => _updatePenjadwalan(document.id, data),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deletePenjadwalan(document.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

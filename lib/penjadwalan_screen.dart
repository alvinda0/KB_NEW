import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:keluarga_berencana/NotificationService.dart';
import 'package:keluarga_berencana/login_screen.dart';

class PenjadwalanScreen extends StatefulWidget {
  final User user;

  const PenjadwalanScreen({super.key, required this.user});

  @override
  _PenjadwalanScreenState createState() => _PenjadwalanScreenState();
}

class _PenjadwalanScreenState extends State<PenjadwalanScreen> {
  String? _selectedKontrasepsi;
  String? _selectedDurasi;
  String? _selectedTanggal;
  String? _selectedJam;
  final NotificationService _notificationService = NotificationService();

  Map<String, List<String>> metodeKontrasepsi = {
    'Pil KB': ['Pil Kombinasi', 'Pil Progrestin (Pil Mini)'],
    'Suntik': ['Suntik Kombinasi', 'Suntik DMPA'],
    'IUD': ['IUD Hormonal', 'IUD Non Hormonal'],
    'Implan': ['Norplant', 'Sino-Implan 2', 'Jadelle', 'Implanon', 'Nexplanon'],
  };

  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _jamController = TextEditingController();
  bool _isLoading = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Penjadwalan'),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Metode Kontrasepsi',
                  border: OutlineInputBorder(),
                ),
                value: _selectedKontrasepsi,
                items: metodeKontrasepsi.keys.map((String metode) {
                  return DropdownMenuItem<String>(
                    value: metode,
                    child: Text(metode),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedKontrasepsi = newValue;
                    _selectedDurasi = null;
                  });
                },
                hint: Text('Pilih Metode Kontrasepsi'),
              ),
              SizedBox(height: 20),
              if (_selectedKontrasepsi != null)
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Jenis Kontrasepsi',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedDurasi,
                  items: metodeKontrasepsi[_selectedKontrasepsi!]!
                      .map((String durasi) {
                    return DropdownMenuItem<String>(
                      value: durasi,
                      child: Text(durasi),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedDurasi = newValue;
                    });
                  },
                  hint: Text('Pilih Jenis Kontrasepsi'),
                ),
              SizedBox(height: 20),
              TextFormField(
                controller: _tanggalController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Tanggal',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _selectedTanggal =
                          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                      _tanggalController.text = _selectedTanggal!;
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _jamController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Jam',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
                ),
                onTap: () async {
                  TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (selectedTime != null) {
                    setState(() {
                      _selectedJam = "${selectedTime.hour}:${selectedTime.minute}";
                      _jamController.text = _selectedJam!;
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_selectedKontrasepsi != null &&
                              _selectedDurasi != null &&
                              _selectedTanggal != null &&
                              _selectedJam != null) {
                            setState(() {
                              _isLoading = true;
                            });

                            try {
                              // Parse date and time for notification
                              final dateComponents = _selectedTanggal!.split('/');
                              final timeComponents = _selectedJam!.split(':');
                              final scheduledDateTime = DateTime(
                                int.parse(dateComponents[2]),
                                int.parse(dateComponents[1]),
                                int.parse(dateComponents[0]),
                                int.parse(timeComponents[0]),
                                int.parse(timeComponents[1]),
                              );

                              // Save to Firestore
                              DocumentReference docRef = await FirebaseFirestore
                                  .instance
                                  .collection('penjadwalan')
                                  .add({
                                'user_id': widget.user.uid,
                                'metode_kontrasepsi': _selectedKontrasepsi,
                                'durasi_kontrasepsi': _selectedDurasi,
                                'tanggal': _selectedTanggal,
                                'jam': _selectedJam,
                                'created_at': FieldValue.serverTimestamp(),
                              });

                              // Schedule notification
                              await _notificationService.scheduleNotification(
                                title: 'Pengingat KB',
                                body:
                                    'Waktunya untuk $_selectedKontrasepsi - $_selectedDurasi',
                                scheduledDate: scheduledDateTime,
                                id: docRef.id,
                              );

                              setState(() {
                                _isLoading = false;
                              });

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Success'),
                                    content: Text(
                                        'Penjadwalan berhasil disimpan dan notifikasi telah diatur!'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          // Reset form
                                          setState(() {
                                            _selectedKontrasepsi = null;
                                            _selectedDurasi = null;
                                            _selectedTanggal = null;
                                            _selectedJam = null;
                                            _tanggalController.clear();
                                            _jamController.clear();
                                          });
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } catch (error) {
                              setState(() {
                                _isLoading = false;
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Gagal menyimpan penjadwalan: $error')),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Mohon lengkapi semua data')),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE84C3D),
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text(
                          'Simpan Penjadwalan',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
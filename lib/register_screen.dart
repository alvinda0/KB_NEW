import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:keluarga_berencana/dashboard_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _showPassword = false; // Add this line to track password visibility

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  Future<User?> _registerWithEmailAndPassword(
    String email,
    String password,
    String name,
    String address,
    String phone,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': name,
          'address': address,
          'phone': phone,
          'dob': _dobController.text,
        });
        setState(() {
          _isLoading = false;
        });
        return user;
      }
      setState(() {
        _isLoading = false;
      });
      return null;
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error during registration: $e");
      return null;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    bool isPassword = false,
    bool isPhone = false,
    bool isDatePicker = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.01,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: AbsorbPointer(
          absorbing: isDatePicker,
          child: TextFormField(
            controller: controller,
            obscureText: isPassword ? !_showPassword : false, // Modified this line
            keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width * 0.04,
                fontWeight: FontWeight.w300,
              ),
              // Add suffix icon for password field
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        _showPassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    )
                  : null,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              errorStyle: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.035,
              ),
            ),
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Masukkan ${label.toLowerCase()}';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFF7777),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.05),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.06,
                      0,
                      screenWidth * 0.06,
                      screenHeight * 0.02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daftar',
                          style: TextStyle(
                            fontSize: screenWidth * 0.08,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Text(
                          'Selamat Bergabung!',
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      child: Column(
                        children: [
                          _buildInputField(
                            controller: _nameController,
                            label: 'Nama Lengkap',
                          ),
                          _buildInputField(
                            controller: _emailController,
                            label: 'Email',
                          ),
                          _buildInputField(
                            controller: _passwordController,
                            label: 'Kata Sandi',
                            isPassword: true,
                          ),
                          _buildInputField(
                            controller: _addressController,
                            label: 'Alamat',
                          ),
                          _buildInputField(
                            controller: _dobController,
                            label: 'Tanggal Lahir',
                            isDatePicker: true,
                            onTap: () => _selectDate(context),
                          ),
                          _buildInputField(
                            controller: _phoneController,
                            label: 'Nomor Telepon',
                            isPhone: true,
                          ),
                          Center(
                            child: _isLoading
                                ? const CircularProgressIndicator()
                                : SizedBox(
                                    width: screenWidth * 0.4,
                                    height: screenHeight * 0.05,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          User? user =
                                              await _registerWithEmailAndPassword(
                                            _emailController.text,
                                            _passwordController.text,
                                            _nameController.text,
                                            _addressController.text,
                                            _phoneController.text,
                                          );
                                          if (user != null) {
                                            Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    DashboardScreen(user: user),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                          const Color.fromARGB(255, 235, 89, 73),
                                        ),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'Daftar',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: screenWidth * 0.04,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Sudah punya akun?",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Masuk',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: screenWidth * 0.035,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.06),
                          SizedBox(height: screenHeight * 0.12),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
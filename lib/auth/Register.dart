import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bcrypt/bcrypt.dart';

import 'package:tratour/auth/Login.dart';
import 'package:tratour/template/input_field.dart';

class Register extends StatefulWidget {
  final String Tipe;
  String get tipe => Tipe;
  const Register({super.key, required this.Tipe});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telnumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  String encryptText(String text) {
    return BCrypt.hashpw(text, BCrypt.gensalt());
  }

  void registerUser() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _telnumberController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection(widget.tipe).add({
        "name": _nameController.text,
        "email": _emailController.text,
        "telnumber": _telnumberController.text,
        "address": "",
        "province": "",
        "city": "",
        "district": "",
        "village": "",
        "postal_code": "",
        "referral_code": "",
        "password": encryptText(_passwordController.text),
        "tipe": widget.tipe,
        "photo_profile": "assets/img/username.jpg",
        "poin": 0
      });
      login();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mendaftarkan pengguna: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void login() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Login(Tipe: widget.tipe),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Daftar sebagai ${widget.tipe}",
                      style: GoogleFonts.lato(
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        letterSpacing: -0.24,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 20),
                    InputField(
                        controller: _nameController,
                        hintText: 'Masukkan Nama Lengkap',
                        obscureText: false),
                    const SizedBox(height: 20),
                    InputField(
                        controller: _emailController,
                        hintText: 'Masukkan Email',
                        obscureText: false),
                    const SizedBox(height: 20),
                    InputField(
                        controller: _telnumberController,
                        hintText: 'Masukkan Nomor HP',
                        obscureText: false),
                    const SizedBox(height: 20),
                    InputField(
                      controller: _passwordController,
                      hintText: "Masukkan Password",
                      obscureText: !_isPasswordVisible,
                      toggleVisibility: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    const SizedBox(height: 48),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          // kirim data
                          registerUser();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: const Color(0xFF1D7948),
                        ),
                        child: Text(
                          'Sign In',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 44),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: GoogleFonts.lato(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            login();
                          },
                          child: Text(
                            "Log In",
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0185FF),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

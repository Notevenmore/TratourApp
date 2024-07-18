import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:tratour/auth/Register.dart';
import 'package:tratour/menu/homepage.dart';
import 'package:tratour/template/input_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'forgot_password_page.dart';

class Login extends StatefulWidget {
  final String Tipe;
  String get tipe => Tipe;
  const Login({super.key, required this.Tipe});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  List<Map<String, dynamic>> users = [];

  void _signInWithGoogle(BuildContext context) async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    try {
      // Sign in with Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Authenticate with Firebase
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        // Fetch user data from Firestore
        final snapshot = await FirebaseFirestore.instance
            .collection(widget.tipe)
            .where('email', isEqualTo: googleUser.email)
            .get();

        if (snapshot.docs.isNotEmpty) {
          final userData = snapshot.docs.first.data();
          userData['id'] = snapshot.docs.first.id;
          print(snapshot.docs.first.id);
          // Navigate to homepage with user data
          homepage_redirect(context, userData['id'], userData['tipe']);
        } else {
          // User not found, register user in Firestore
          final userDocRef =
              await FirebaseFirestore.instance.collection(widget.tipe).add({
            "name": googleUser.displayName,
            "email": googleUser.email,
            "telnumber": "",
            "address": "",
            "province": "",
            "city": "",
            "district": "",
            "village": "",
            "postal_code": "",
            "referral_code": "",
            "password": encryptText(googleUser.email),
            "tipe": widget.tipe,
            "photo_profile": "",
            "poin": 0
          });

          final newUserData = (await userDocRef.get()).data()!;
          newUserData['id'] = userDocRef.id;

          // Navigate to homepage with new user data
          homepage_redirect(context, newUserData['id'], newUserData['tipe']);
        }
      } else {
        print('Google sign in cancelled');
        // Handle case where Google sign in was cancelled
      }
    } catch (e) {
      print('Sign in with Google failed: $e');
      // Handle other exceptions
    }
  }

  String encryptText(String text) {
    return BCrypt.hashpw(text, BCrypt.gensalt());
  }

  void homepage_redirect(BuildContext context, String id, String tipe) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => homepage(
                  userid: id,
                  usertipe: tipe,
                )));
  }

  void loginUser(BuildContext context) async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password tidak boleh kosong')),
      );
      return;
    }

    Map<String, dynamic> user = {};
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection(widget.tipe)
          .get()
          .then((event) {
        users.clear(); // Clear the users list before adding new data
        for (var doc in event.docs) {
          user = doc.data();
          user['id'] = doc.id;
          users.add(user);
        }
      });

      login(context);
    } catch (e) {
      print("Failed to add document: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memuat data pengguna')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool decryptText(String password, String hashed) {
    return BCrypt.checkpw(password, hashed);
  }

  void login(BuildContext context) {
    bool userFound = false;
    bool passwordCorrect = false;

    for (var user in users) {
      if (_emailController.text == user['email']) {
        userFound = true;
        if (decryptText(_passwordController.text, user['password'])) {
          passwordCorrect = true;
          try {
            homepage_redirect(context, user['id'], user['tipe']);
            return; // Stop the loop and function after successful login
          } catch (e) {
            print("Failed to navigate: $e");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal masuk: $e')),
            );
          }
        }
        break;
      }
    }

    if (!userFound) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email tidak ditemukan')),
      );
    } else if (!passwordCorrect) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password salah')),
      );
    }
  }

  void register() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Register(Tipe: widget.tipe)));
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
                      "Masuk sebagai ${widget.tipe}",
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
                      controller: _emailController,
                      hintText: 'Masukkan Email',
                      obscureText: false,
                    ),
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
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResetPasswordPage()),
                        );
                      },
                      child: const Text('Lupa password? klik disini'),
                    ),
                    const SizedBox(height: 48),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            // kirim data
                            loginUser(context);
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
                            'Log In',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () => _signInWithGoogle(context),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor:
                                const Color.fromARGB(255, 255, 255, 255),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset('assets/img/google.png',
                                  height: 24, width: 24),
                              const SizedBox(width: 12),
                              const Text(
                                "Sign in With Google",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              )
                            ],
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
                          "Don't have an account?",
                          style: GoogleFonts.lato(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            register();
                          },
                          child: Text(
                            "Sign Up",
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

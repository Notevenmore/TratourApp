import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bcrypt/bcrypt.dart';

import 'package:tratour/auth/Register.dart';
import 'package:tratour/menu/homepage.dart';
import 'package:tratour/template/input_field.dart';

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
  List<Map<String, dynamic>> users = [];

  void loginUser(BuildContext context) async {
    Map<String, dynamic> user = {};
    try {
      await FirebaseFirestore.instance
          .collection(widget.tipe)
          .get()
          .then((event) => {
                for (var doc in event.docs)
                  {
                    user = doc.data(),
                    user['id'] = doc.id,
                    users.add(user),
                  }
              });
      login(context);
    } catch (e) {}
  }

  bool decryptText(String password, String hashed) {
    return BCrypt.checkpw(password, hashed);
  }

  void login(BuildContext context) {
    for (var user in users) {
      if (_emailController.text == user['email']) {
        if (decryptText(_passwordController.text, user['password'])) {
          try {
            homepage_redirect(context, user['id'], user['tipe']);
            // ignore: empty_catches
          } catch (e) {}
        } else {
          break;
        }
      } else {}
    }
  }

  void register() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Register(Tipe: widget.tipe)));
  }

  void homepage_redirect(BuildContext context, String userid, String usertipe) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => homepage(
                  userid: userid,
                  usertipe: usertipe,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
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
                const SizedBox(height: 48),
                SizedBox(
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
                        "Sign In",
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
          ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tratour/Register.dart';
import 'package:bcrypt/bcrypt.dart';

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

  void loginUser() async {
    await FirebaseFirestore.instance
        .collection(widget.tipe)
        .get()
        .then((event) => {
              for (var doc in event.docs) {users.add(doc.data())}
            });
    login();
  }

  bool decryptText(String password, String hashed) {
    return BCrypt.checkpw(password, hashed);
  }

  void login() {
    for (var user in users) {
      if (_emailController.text == user['email']) {
        if (decryptText(_passwordController.text, user['password'])) {
          print('benar');
          break;
        } else {
          print('password salah');
          break;
        }
      } else {
        print('email salah');
      }
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
                      loginUser();
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
                // const SizedBox(height: 36),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Container(
                //       padding: const EdgeInsets.only(bottom: 2),
                //       decoration: const BoxDecoration(
                //         border: Border(
                //           bottom: BorderSide(
                //             color: Colors.black,
                //             width: 1,
                //           ),
                //         ),
                //       ),
                //       width: 150,
                //     ),
                //     const SizedBox(width: 5),
                //     Text(
                //       "or",
                //       style: GoogleFonts.plusJakartaSans(
                //         fontSize: 10,
                //         fontWeight: FontWeight.w700,
                //       ),
                //     ),
                //     const SizedBox(width: 5),
                //     Container(
                //       padding: const EdgeInsets.only(bottom: 2),
                //       decoration: const BoxDecoration(
                //         border: Border(
                //           bottom: BorderSide(
                //             color: Colors.black,
                //             width: 1,
                //           ),
                //         ),
                //       ),
                //       width: 150,
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 24),
                // Container(
                //   height: 48,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(8),
                //     border: const Border(
                //       top: BorderSide(
                //         color: Colors.black,
                //         width: 1,
                //       ),
                //       right: BorderSide(
                //         color: Colors.black,
                //         width: 1,
                //       ),
                //       bottom: BorderSide(
                //         color: Colors.black,
                //         width: 1,
                //       ),
                //       left: BorderSide(
                //         color: Colors.black,
                //         width: 1,
                //       ),
                //     ),
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       Text(
                //         "Log In With Google",
                //         style: GoogleFonts.plusJakartaSans(
                //           fontSize: 12,
                //           fontWeight: FontWeight.w700,
                //         ),
                //       ),
                //       const SizedBox(width: 8),
                //       Image.asset(
                //         "assets/img/google.png",
                //         width: 20,
                //         height: 20,
                //       ),
                //     ],
                //   ),
                // ),
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

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final VoidCallback? toggleVisibility;
  final bool? isPasswordVisible;

  const InputField(
      {required this.controller,
      required this.hintText,
      required this.obscureText,
      this.toggleVisibility,
      this.isPasswordVisible = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          style: GoogleFonts.plusJakartaSans(
              fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.plusJakartaSans(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            suffixIcon: hintText == 'Masukkan Password'
                ? IconButton(
                    icon: Icon(
                      isPasswordVisible!
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: toggleVisibility,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

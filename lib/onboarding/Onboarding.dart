import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tratour/auth/Register.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  void _pengepul(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const Register(Tipe: 'pengepul')));
  }

  void _sweeper(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const Register(Tipe: 'sweeper')));
  }

  void _warga(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const Register(Tipe: 'warga')));
  }

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D7948),
      body: Stack(children: [
        Positioned(
          top: 64,
          left: 24,
          child: Image.asset("assets/img/logo.png"),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Masuk Sebagai",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              // Button Pengepul
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 55),
                  Container(
                    width: 127,
                    height: 127,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    child: ClipOval(
                      child: IconButton(
                        onPressed: () {
                          _pengepul(context);
                        },
                        icon: Image.asset(
                          "assets/img/pengepul.png",
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      _pengepul(context);
                    },
                    child: Text(
                      "Pengepul",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              // Button Sweeper
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const SizedBox(width: 20),
                          IconButton(
                            onPressed: () {
                              _sweeper(context);
                            },
                            icon: Image.asset(
                              "assets/img/sweeper.png",
                              width: 176,
                              height: 122,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              _sweeper(context);
                            },
                            child: Text(
                              "Sweeper",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 32,
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          )
                        ],
                      ),
                      // button warga
                      const SizedBox(width: 8),
                      Column(
                        children: [
                          const SizedBox(width: 20),
                          IconButton(
                            onPressed: () {
                              _warga(context);
                            },
                            icon: Image.asset(
                              "assets/img/warga.png",
                              width: 176,
                              height: 122,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              _warga(context);
                            },
                            child: Text(
                              "Warga",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 32,
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        )
      ]),
    );
  }
}

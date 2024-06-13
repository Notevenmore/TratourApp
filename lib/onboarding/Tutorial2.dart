import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tratour/onboarding/Onboarding.dart';

class Tutorial2 extends StatelessWidget {
  const Tutorial2({super.key});

  // akses halaman selanjutnya dari tutorial 2
  void _onNextPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Onboarding()),
    );
  }

  // skip tutorial, langsung akses halaman onboarding
  void _onSkipPressed(BuildContext context) {
    // Tambahkan logika untuk berpindah ke halaman beranda
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Onboarding()),
    );
  }

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3B73E),
      body: Stack(children: [
        Center(
          child: Image.asset("assets/pattern/page2/Go Green Recycle Truck.png"),
        ),
        Positioned(
            left: 110.23,
            top: 70,
            child: Transform.rotate(
                angle: -95.08 * 3.14 / 180,
                child: Image.asset("assets/pattern/page1/Polygon 1.png"))),
        Positioned(
            top: 100,
            left: 300,
            child: Image.asset("assets/pattern/page2/Vector 8.png")),
        Positioned(
            top: 100,
            left: 220,
            child: Image.asset("assets/pattern/page1/Ellipse 847.png")),
        Positioned(
            top: 156,
            left: 366,
            child: Image.asset("assets/pattern/page1/Ellipse 847.png")),
        Positioned(
            top: 257,
            left: 236,
            child: Image.asset("assets/pattern/page1/Ellipse 847.png")),
        Positioned(
            top: 220,
            left: 79,
            child: Image.asset("assets/pattern/page1/Ellipse 847.png")),
        Positioned(
            top: 500.19,
            left: -3,
            child: Image.asset("assets/pattern/page2/Ellipse 846.png")),
        Positioned(
            top: 630,
            left: 55,
            child: Text("Hijaukan Dunia",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ))),
        Positioned(
            top: 690,
            left: 55,
            width: 283,
            height: 82,
            child: Text(
                "Berjalan di atas tanah demi kebaikan dunia, mencapai keutuhan bumi.",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  color: Colors.white,
                ))),
      ]),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextButton(
                onPressed: () {
                  _onSkipPressed(context);
                },
                child: Text('Skip',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white))),
            IconButton(
                onPressed: () {
                  _onNextPressed(context);
                },
                icon: Image.asset("assets/pattern/page2/arrowNextGreen.png"))
          ],
        ),
      ),
    );
  }
}

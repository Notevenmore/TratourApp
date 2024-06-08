import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tratour/Tutorial2.dart';
import 'package:tratour/Onboarding.dart';

class Tutorial1 extends StatelessWidget {
  const Tutorial1({super.key});

  // skip halaman selanjutnya, langsung ke halaman onboarding
  void _onSkipPressed(BuildContext context) {
    // Tambahkan logika untuk berpindah ke halaman beranda
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Onboarding()),
    );
  }

  // akses halaman selanjutnya, yaitu halaman tutorial2
  void _onNextPressed(BuildContext context) {
    // Tambahkan logika untuk berpindah ke panduan aplikasi selanjutnya
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Tutorial2()),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: const Color(0xFF1D7948),
      body: Stack(children: [
        Center(
          child: Image.asset("assets/img/Go Green Open Recycle Container.png"),
        ),
        // segitiga
        Positioned(
            left: 110.23,
            top: 70,
            child: Transform.rotate(
                angle: 0.2 * 3.14 / 180,
                child: Image.asset("assets/pattern/page1/Polygon 1.png"))),
        // garis lengkung
        Positioned(
            top: 100,
            left: 300,
            child: Image.asset("assets/pattern/page1/Vector 8.png")),
        // lingkaran kecil
        Positioned(
            top: 201,
            left: 102,
            child: Image.asset("assets/pattern/page1/Ellipse 847.png")),
        // lingkaran kecil
        Positioned(
            top: 264,
            left: 297,
            child: Image.asset("assets/pattern/page1/Ellipse 847.png")),
        // lingkaran kecil
        Positioned(
            top: 410,
            left: 82,
            child: Image.asset("assets/pattern/page1/Ellipse 847.png")),
        // lingkaran kecil
        Positioned(
            top: 515,
            left: 358,
            child: Image.asset("assets/pattern/page1/Ellipse 847.png")),
        // lingkaran donat
        Positioned(
            top: 500.19,
            left: -3,
            child: Image.asset("assets/pattern/page1/Ellipse 846.png")),
        // Teks judul utama dari halaman
        Positioned(
            top: 630,
            left: 55,
            child: Text("Hijaukan Dunia",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ))),
        // teks paragraf utama dari halaman
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
      // bar bagian bawah (tombol skip dan tombol next)
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // tombol skip
            TextButton(
                onPressed: () {
                  _onSkipPressed(context);
                },
                child: Text('Skip',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white))),
            // tombol next
            IconButton(
                onPressed: () {
                  _onNextPressed(context);
                },
                icon: Image.asset("assets/pattern/page1/arrowNextYellow.png"))
          ],
        ),
      ),
    ));
  }
}

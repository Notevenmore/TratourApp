import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:tratour/template/navigation_bottom.dart';
import 'package:tratour/template/bar_app_secondversion.dart';

class DetailHistoryPesanan extends StatefulWidget {
  final String userid;
  final String usertipe;
  final Map<String, dynamic> order;

  const DetailHistoryPesanan({
    super.key,
    required this.userid,
    required this.usertipe,
    required this.order,
  });

  @override
  _DetailHistoryPesanan createState() => _DetailHistoryPesanan();
}

class _DetailHistoryPesanan extends State<DetailHistoryPesanan> {
  final int adminPrice = 1000;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BarAppSecondversion(title: "Detail Pesanan"),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          margin: const EdgeInsets.only(top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Detail Perjalanan",
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    detailLocation(
                      const Color(0xFF1D7948),
                      "Lokasi Kamu",
                      widget.order['alamat'].split(',')[0],
                    ),
                    for (int i = 1; i <= 7; i++) (circleMaker()),
                    detailLocation(
                      const Color(0xFFFBBC05),
                      "Lokasi Pickup",
                      widget.order['alamat_sweeper'],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              Container(
                height: 2,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 43),
              _title("Detail Pendapatan"),
              const SizedBox(height: 21),
              SizedBox(
                child: Column(
                  children: [
                    _perkiraanPendapatan("Akumulasi Sampah",
                        widget.order['user_poin'].toString()),
                    _perkiraanPendapatan(
                        "Biaya Admin", (-adminPrice).toString()),
                    _perkiraanPendapatan("Biaya Driver (/m)",
                        (-widget.order['sweeper_poin']).toString()),
                    Container(
                      width: double.infinity,
                      height: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                      ),
                    ),
                    _perkiraanPendapatan(
                      "Total Pendapatan",
                      (widget.order['user_poin'].toInt() -
                              adminPrice -
                              widget.order['sweeper_poin'].toInt())
                          .toString(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBottom(
        selectedIndex: 2,
        userid: widget.userid,
        usertipe: widget.usertipe,
      ),
    );
  }

  Widget circleMaker() {
    return Container(
      width: 6,
      height: 6,
      margin: const EdgeInsets.only(left: 11, bottom: 4),
      decoration: const BoxDecoration(
        color: Color(0xFFD9D9D9),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget detailLocation(
    Color color,
    String caption,
    String desc,
  ) {
    return SizedBox(
      child: Row(
        children: [
          logo(color),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                caption,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget logo(Color colors) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: colors,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.location_on_outlined,
        color: Colors.white,
        size: 16,
      ),
    );
  }

  Widget _perkiraanPendapatan(String text, String amount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _makeCircle("P"),
                const SizedBox(width: 16),
                _title(text),
              ],
            ),
          ),
          _title(amount),
        ],
      ),
    );
  }

  Widget _title(String text) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _makeCircle(String text) {
    return Container(
      alignment: Alignment.center,
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFFBBC05),
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

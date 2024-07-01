import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tratour/routes/redeem_routes.dart';

import 'package:tratour/template/navigation_bottom.dart';
import 'package:tratour/template/bar_app_secondversion.dart';

class Voucher extends StatefulWidget {
  final String userid;
  final String usertipe;
  final Map<String, dynamic> userdata;
  const Voucher({
    super.key,
    required this.userid,
    required this.usertipe,
    required this.userdata,
  });

  @override
  _Voucher createState() => _Voucher();
}

class _Voucher extends State<Voucher> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const BarAppSecondversion(title: "Voucher"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            vouchersMenuContainer(head() as Widget),
            vouchersMenuContainer(listRedeem() as Widget),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBottom(
        selectedIndex: selectedIndex,
        userid: widget.userid,
        usertipe: widget.usertipe,
      ),
    );
  }

  Widget listRedeem() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Isi Ulang",
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const SizedBox(width: 16),
            IconButton(
              onPressed: () {
                redirect_redeem(
                  context,
                  widget.userid,
                  widget.usertipe,
                  "Pulsa Prabayar",
                  widget.userdata,
                );
              },
              icon: SizedBox(
                width: 50,
                child: Column(
                  children: [
                    Image.asset("assets/img/pulsaprabayar.png"),
                    const SizedBox(height: 6),
                    Text(
                      'Pulsa Prabayar',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ptSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 48),
            IconButton(
              onPressed: () {
                redirect_redeem(
                  context,
                  widget.userid,
                  widget.usertipe,
                  "Paket Data",
                  widget.userdata,
                );
              },
              icon: SizedBox(
                width: 50,
                child: Column(
                  children: [
                    Image.asset("assets/img/data.png"),
                    const SizedBox(height: 6),
                    Text(
                      'Paket Data',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ptSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 48),
            IconButton(
              onPressed: () {
                redirect_redeem(
                  context,
                  widget.userid,
                  widget.usertipe,
                  "Voucher Listrik",
                  widget.userdata,
                );
              },
              icon: SizedBox(
                width: 50,
                child: Column(
                  children: [
                    Image.asset("assets/img/voucherlistrik.png"),
                    const SizedBox(height: 6),
                    Text(
                      'Voucher Listrik',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ptSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget head() {
    return Row(
      children: [
        makeCircle("P"),
        const SizedBox(width: 16),
        Text(
          (widget.userdata['poin'].toInt()).toString(),
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget vouchersMenuContainer(Widget content) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black.withOpacity(0.3),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 2,
            offset: const Offset(1, 1),
          ),
        ],
        color: Colors.white,
      ),
      child: content,
    );
  }

  Widget makeCircle(String text) {
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

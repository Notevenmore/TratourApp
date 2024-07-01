import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tratour/routes/homepage_routes.dart';

import 'package:tratour/template/bar_app_secondversion.dart';
import 'package:tratour/template/navigation_bottom.dart';

class RedeemPoin extends StatefulWidget {
  final String userid;
  final String usertipe;
  final List<dynamic> redeemData;
  final String redeemTipe;
  final Map<String, dynamic> userdata;

  const RedeemPoin({
    super.key,
    required this.userid,
    required this.usertipe,
    required this.redeemData,
    required this.redeemTipe,
    required this.userdata,
  });

  @override
  _RedeemPoinState createState() => _RedeemPoinState();
}

class _RedeemPoinState extends State<RedeemPoin> {
  int selectedIndex = 0;
  List<bool> select = [];
  late TextEditingController inputController;

  @override
  void initState() {
    super.initState();
    inputController = TextEditingController();
    select = [false, false, false, false, false, false];
  }

  void redeemIt(BuildContext context) async {
    int index = -1;
    select.asMap().entries.map((data) {
      if (data.value) {
        index = data.key;
      }
    }).toList();
    try {
      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot user = await transaction.get(
          FirebaseFirestore.instance
              .collection(widget.usertipe)
              .doc(widget.userid),
        );
        double poin = user.get("poin").toDouble();
        if (widget.redeemData[index].price > poin) {
          print(poin);
          throw Exception("Poin tidak mencukupi untuk melakukan penukaran");
        }
        poin -= widget.redeemData[index].price;
        transaction.update(
          FirebaseFirestore.instance
              .collection(widget.usertipe)
              .doc(widget.userid),
          {
            "poin": poin,
          },
        );
      }).then(
        (value) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                content: popup(Icons.check, const Color(0xFF6FD73E),
                    "Penukaran poin kamu telah berhasil!"),
              );
            },
          );
          Timer(const Duration(seconds: 1), () {
            redirect_homepage(context, widget.userid, widget.usertipe);
          });
        },
        onError: (e) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                content: popup(
                  Icons.close,
                  const Color.fromARGB(255, 241, 49, 49),
                  e.message,
                ),
              );
            },
          );
          Timer(const Duration(seconds: 1), () {
            Navigator.of(context).pop();
          });
        },
      );
    } catch (e) {
      print("Error update saldo: $e");
    }
  }

  Widget popup(IconData icon, Color color, String text) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(11),
      height: 295,
      width: 295,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 173,
            height: 173,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 130,
            ),
          ),
          const SizedBox(height: 23),
          Text(
            text,
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BarAppSecondversion(title: widget.redeemTipe),
      body: SingleChildScrollView(
        child: Column(
          children: [
            vouchersMenuContainer(head()),
            vouchersMenuContainer(body()),
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

  Widget body() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.redeemTipe == "Voucher Listrik"
                ? "Nomor Pelanggan"
                : "Nomor Ponsel",
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 6),
          inputFieldVoucher(
            widget.redeemTipe == "Voucher Listrik"
                ? "Masukkan Nomor pelanggan anda disini"
                : "Masukkan Nomor ponsel anda disini",
          ),
          const SizedBox(height: 64),
          for (int i = 0; i < 6; i += 2)
            (Row(
              children: [
                _buildRedeem(context, widget.redeemData[i], i),
                const SizedBox(width: 16),
                _buildRedeem(context, widget.redeemData[i + 1], i + 1),
              ],
            )),
          const SizedBox(height: 124),
          IconButton(
            onPressed: () {
              redeemIt(context);
            },
            icon: Container(
              width: 335,
              height: 32,
              margin: const EdgeInsets.only(left: 20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                color: Color(0xFF1D7948),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Konfirmasi",
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRedeem(
    BuildContext context,
    dynamic redeem,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          select = [false, false, false, false, false, false];
          select[index] = !select[index];
        });
      },
      child: Container(
        width: 152,
        height: 74,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 24),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: select[index] ? const Color(0xFF1D7948) : Colors.white,
          border: Border.all(color: Colors.black),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                priceAndNominal(
                  widget.redeemTipe == "Paket Data"
                      ? "Kuota ${redeem.nominal} GB"
                      : redeem.nominal.toString(),
                  select[index] ? Colors.white : Colors.black,
                ),
                const SizedBox(height: 6),
                priceAndNominal(
                  'Rp ' + redeem.price.toString(),
                  select[index] ? Colors.white : Colors.black,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget priceAndNominal(String content, Color color) {
    return Text(
      content,
      style: GoogleFonts.plusJakartaSans(
        fontWeight: FontWeight.w700,
        fontSize: 12,
        color: color,
      ),
    );
  }

  Widget inputFieldVoucher(String hintText) {
    return SizedBox(
      width: 255,
      height: 28,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.black,
          ),
        ),
        child: TextField(
          controller: inputController,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.plusJakartaSans(
              color: Colors.black.withOpacity(0.3),
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
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

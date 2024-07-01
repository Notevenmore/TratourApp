import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:tratour/helper/fetch_category_from_json.dart';
import 'package:tratour/routes/homepage_routes.dart';
import 'package:tratour/template/bar_app_secondversion.dart';
import 'package:tratour/models/categories_model.dart';

class DetailPesananSweeper extends StatefulWidget {
  final String userid;
  final String usertipe;
  final List<dynamic> selectedCategories;
  final String currentAddress;
  final String locationName;
  final List<int> amountCategories;
  final double sweeperPrice;
  final double accumulation;

  const DetailPesananSweeper({
    super.key,
    required this.userid,
    required this.usertipe,
    required this.selectedCategories,
    required this.currentAddress,
    required this.locationName,
    required this.amountCategories,
    required this.sweeperPrice,
    required this.accumulation,
  });

  @override
  _DetailPesananSweeper createState() => _DetailPesananSweeper();
}

class _DetailPesananSweeper extends State<DetailPesananSweeper> {
  late Future<List<List<Category>>> categories;
  List<int> priceCategories = [];
  final int adminPrice = 1000;
  final int driverPrice = 5; //per meter

  @override
  void initState() {
    super.initState();
    categories = fetchCategoryFromJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BarAppSecondversion(
        title: "Detail Pesanan",
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          margin: const EdgeInsets.only(top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _title("Detail Pengambilan"),
              const SizedBox(height: 7),
              Container(
                width: double.infinity,
                height: 98,
                child: Container(
                  padding: const EdgeInsets.all(10),
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
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.locationDot,
                          color: Color(0XFF1D7948),
                          size: 14,
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 294,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.locationName,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                widget.currentAddress,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFFA1A1A1),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _title("Detail Jenis Sampah"),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: ((widget.selectedCategories.length * 60) +
                        9 * (1 + widget.selectedCategories.length))
                    .toDouble(),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
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
                  child: Container(
                    child: FutureBuilder<List<List<Category>>>(
                      future: categories,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          final categories = snapshot.data!;
                          final filteredCategories =
                              widget.selectedCategories.map((index) {
                            return categories[index ~/ 2][index % 2];
                          }).toList();

                          priceCategories.clear();

                          return ListView.builder(
                            itemCount: filteredCategories.length,
                            itemBuilder: (context, index) {
                              final row = filteredCategories[index];
                              priceCategories.add(row.price!);
                              return _showSelectedCategory(context, row, index);
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _title("Perkiraan Pendapatan"),
              const SizedBox(height: 21),
              SizedBox(
                child: Column(
                  children: [
                    _perkiraanPendapatan(
                        "Akumulasi Sampah", widget.accumulation.toInt()),
                    _perkiraanPendapatan("Biaya Admin", adminPrice),
                    _perkiraanPendapatan(
                        "Biaya Driver (/m)", -widget.sweeperPrice.toInt()),
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
                      widget.sweeperPrice.toInt(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                height: 32,
                child: ElevatedButton(
                  onPressed: () {
                    // kirim data
                    redirect_homepage(context, widget.userid, widget.usertipe);
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: const Color(0xFF1D7948),
                  ),
                  child: Text(
                    'Cari Pesanan baru',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _perkiraanPendapatan(String text, int amount) {
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
          _title(amount.toString()),
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

  Widget _showSelectedCategory(
      BuildContext context, Category categories, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 170,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 70,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: categories.color,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        categories.src,
                        width: 25,
                        height: 25,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        categories.text,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Text(
                  categories.text,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.amountCategories[index]} Kg",
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
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

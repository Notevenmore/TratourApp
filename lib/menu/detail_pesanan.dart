import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:tratour/menu/sort_trash_menu.dart';
import 'package:tratour/template/navigation_bottom.dart';
import 'package:tratour/template/bar_app_secondversion.dart';
import 'package:tratour/menu/homepage.dart';
import '../model/sort_trash_data.dart';

class DetailPesanan extends StatefulWidget {
  final String userid;
  final String usertipe;
  final Set<int> selectedCategories;
  final String currentAddress;
  final String locationName;
  final double latitude;
  final double longitude;
  final String? detailLocation;

  const DetailPesanan({
    super.key,
    required this.userid,
    required this.usertipe,
    required this.selectedCategories,
    required this.currentAddress,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    this.detailLocation,
  });

  @override
  _DetailPesanan createState() => _DetailPesanan();
}

class _DetailPesanan extends State<DetailPesanan> {
  late Future<List<List<Category>>> categories;
  late List<int> amountCategories;
  List<int> priceCategories = [];
  final int adminPrice = 1000;
  final int driverPrice = 5; //per meter

  @override
  void initState() {
    super.initState();
    categories = fetchCategoryFromJson();
    amountCategories = List<int>.filled(widget.selectedCategories.length, 0);
  }

  int countAccumulation() {
    int num = 0;
    try {
      for (int i = 0; i < amountCategories.length; i++) {
        num = num + amountCategories[i] * priceCategories[i];
      }
    } catch (e) {
      return 0;
    }
    return num;
  }

  // aksi ketika tombol navigationbottom diklik
  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              homepage(userid: widget.userid, usertipe: widget.usertipe),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SortTrashMenu(userid: widget.userid, usertipe: widget.usertipe),
        ),
      );
    }
  }

  // fetch data category
  Future<List<List<Category>>> fetchCategoryFromJson() async {
    try {
      final String response =
          await rootBundle.loadString('assets/json/category.json');
      final List<dynamic> data = jsonDecode(response);
      return data.map((row) {
        return (row as List).map((item) => Category.fromJson(item)).toList();
      }).toList();
    } catch (e) {
      print(e);
      return [];
    }
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
              _title("Detail Pengambilan"),
              const SizedBox(height: 7),
              SizedBox(
                width: double.infinity,
                height: 98,
                child: Container(
                  padding: const EdgeInsets.only(left: 4, right: 16, top: 7),
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
                  padding: const EdgeInsets.only(left: 9, right: 9, top: 9),
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
                  child: SizedBox(
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
                        "Akumulasi Sampah", countAccumulation()),
                    _perkiraanPendapatan("Biaya Admin", -adminPrice),
                    _perkiraanPendapatan("Biaya Driver", -driverPrice * 1000),
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
                        countAccumulation() -
                            adminPrice -
                            (driverPrice * 1000)),
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
                    'Cari Sweeper',
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
      bottomNavigationBar: NavigationBottom(
        selectedIndex: 2,
        userid: widget.userid,
        usertipe: widget.usertipe,
        onItemTapped: _onItemTapped,
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
          const SizedBox(width: 16),
          SizedBox(
            width: 149,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    if (amountCategories[index] > 0) {
                      setState(() {
                        amountCategories[index]--;
                      });
                    }
                  },
                  icon: _makeCircle("-"),
                ),
                Text(
                  "${amountCategories[index]} Kg",
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      amountCategories[index]++;
                    });
                  },
                  icon: _makeCircle("+"),
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

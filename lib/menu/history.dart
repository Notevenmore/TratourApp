import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tratour/helper/get_order.dart';
import 'package:tratour/menu/detail_history_pesanan.dart';

import 'package:tratour/template/navigation_bottom.dart';
import 'package:tratour/template/bar_app_secondversion.dart';
import 'package:tratour/models/sort_trash_data.dart';
import 'package:tratour/helper/fetch_category_from_json.dart';

class History extends StatefulWidget {
  final String userid;
  final String usertipe;
  const History({super.key, required this.userid, required this.usertipe});

  @override
  _History createState() => _History();
}

class _History extends State<History> {
  int selectedIndex = 1;

  // inisialisasi isi konten kategori
  late Future<List<List<Category>>> categories;
  late Future<List<Map<String, dynamic>>> orders;

  @override
  void initState() {
    super.initState();
    categories = fetchCategoryFromJson();
    orders = getOrder(widget.userid);
  }

  void redirectDetailPesanan(BuildContext context, Map<String, dynamic> order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailHistoryPesanan(
          userid: widget.userid,
          usertipe: widget.usertipe,
          order: order,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const BarAppSecondversion(title: "Pesanan Anda"),
      body: FutureBuilder(
        future: Future.wait([categories, orders]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<List<Category>> category =
                snapshot.data![0] as List<List<Category>>;
            List<Map<String, dynamic>> order =
                snapshot.data![1] as List<Map<String, dynamic>>;
            int i = 0;
            order.forEach((obj) {
              Map<String, dynamic> c = {
                'category': category[obj['selectedCategories'][0] ~/ 2]
                    [obj['selectedCategories'][0] % 2]
              };
              order[i]['categories'] = c;
              i++;
            });
            return orderHistory(context, order);
          }
        },
      ),
      bottomNavigationBar: NavigationBottom(
        selectedIndex: selectedIndex,
        userid: widget.userid,
        usertipe: widget.usertipe,
      ),
    );
  }

  Widget orderHistory(BuildContext context, List<Map<String, dynamic>> orders) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: orders
              .map((order) => containerOrderHistory(context, order))
              .toList(),
        ),
      ),
    );
  }

  Widget containerOrderHistory(
      BuildContext context, Map<String, dynamic> order) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  margin: const EdgeInsets.only(right: 8.05),
                  decoration: BoxDecoration(
                    color: order['categories']['category']!.color,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        order['categories']['category']!.src,
                        width: 40,
                        height: 40,
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order['lokasi'].toString(),
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order['date'].toString(),
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                      orderStatus(order['status_pengiriman'],
                          order['status_penjemputan']),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 95,
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () {
                redirectDetailPesanan(
                  context,
                  order,
                );
              },
              child: Text(
                "Rincian Pesanan >",
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                  color: const Color(0xFF0185FF),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget orderStatus(bool statusPengiriman, bool statusPenjemputan) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          if (statusPengiriman) ...[
            iconStatus(const Color(0xFF6FD73E), Colors.white, Icons.check),
            textStatus("Berhasil"),
          ] else if (statusPenjemputan) ...[
            iconStatus(const Color(0xFFFBBC05), Colors.white, Icons.watch),
            textStatus("Dalam Perjalanan"),
          ] else ...[
            iconStatus(const Color(0xFFEA4335), Colors.white, Icons.close),
            textStatus("Mencari Driver...")
          ],
        ],
      ),
    );
  }

  Widget iconStatus(Color colorBox, Color colorText, IconData icon) {
    return Container(
      width: 12,
      height: 12,
      margin: const EdgeInsets.only(right: 3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorBox,
      ),
      child: Icon(
        icon,
        color: colorText,
        size: 8,
      ),
    );
  }

  Widget textStatus(String text) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontWeight: FontWeight.w400,
        fontSize: 10,
      ),
    );
  }
}

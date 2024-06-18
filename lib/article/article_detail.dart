import 'package:tratour/template/bar_app_secondversion.dart';
import 'package:tratour/template/navigation_bottom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class articledetail extends StatefulWidget {
  final String articleid;
  final String userid;
  final String usertipe;
  const articledetail(
      {super.key,
      required this.articleid,
      required this.userid,
      required this.usertipe});

  @override
  articledetailState createState() => articledetailState();
}

class articledetailState extends State<articledetail> {
  int selectedIndex = 0;
  late Map<String, dynamic> article = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getArticles();
  }

  Future<void> getArticles() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('article')
          .doc(widget.articleid)
          .get();
      if (doc.exists) {
        setState(() {
          article = doc.data() as Map<String, dynamic>;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BarAppSecondversion(title: "Artikel untuk kamu"),
      body: !isLoading
          ? SingleChildScrollView(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.only(left: 28, right: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      Text(
                        article['title'],
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "ditulis oleh ${article['author']} - ${article['month']} ${article['year']}",
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Image.network(
                        article['image'],
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 17),
                      const Divider(),
                      const SizedBox(height: 11),
                      Text(
                        article['content'],
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          height: 2.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: NavigationBottom(
        selectedIndex: 0,
        userid: widget.userid,
        usertipe: widget.usertipe,
        onItemTapped: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}

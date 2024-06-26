import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:tratour/article/article_detail.dart';
import 'package:tratour/menu/voucher.dart';
import 'package:tratour/routes/redeem_routes.dart';
import 'package:tratour/template/bar_app.dart';
import 'package:tratour/template/navigation_bottom.dart';

class HomepageWarga extends StatefulWidget {
  final String userid;
  final String usertipe;
  final Map<String, dynamic> userdata;
  const HomepageWarga(
      {super.key,
      required this.userid,
      required this.usertipe,
      required this.userdata});

  @override
  _HomepageWargaState createState() => _HomepageWargaState();
}

class _HomepageWargaState extends State<HomepageWarga> {
  List<Map<String, dynamic>> _articles = [];
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    getArticles();
  }

  Future<void> getArticles() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('article').get();

      List<Map<String, dynamic>> articles = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();

      setState(() {
        _articles = articles;
      });
    } catch (e) {
      print('gagal ambil');
    }
  }

  void goToArticle(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => articledetail(
            articleid: id, userid: widget.userid, usertipe: widget.usertipe),
      ),
    );
  }

  void goToVoucherMenu() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Voucher(
          userid: widget.userid,
          usertipe: widget.usertipe,
          userdata: widget.userdata,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BarApp(
        isloading: false,
        userdata: widget.userdata,
      ),
      body: SingleChildScrollView(
          child: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.only(left: 12),
              width: 329,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 3,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 215,
                    height: 70,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Setor Sampah Bawa Keuntungan',
                          style: GoogleFonts.ptSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Tukar sampah menjadi poin untuk ditukarkan dengan voucher menarik',
                          style: GoogleFonts.ptSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset('assets/img/decoration1.png'),
                ],
              ),
            ),
            Container(
              width: 329,
              margin: const EdgeInsets.only(top: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Poin Kamu',
                    style: GoogleFonts.ptSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'Total Poin Anda:',
                        style: GoogleFonts.ptSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 70),
                      Text(
                        '${widget.userdata['poin']}',
                        style: GoogleFonts.ptSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        ' Poin',
                        style: GoogleFonts.ptSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 329,
              margin: const EdgeInsets.only(top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Voucher',
                    style: GoogleFonts.ptSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total poin kamu dapat ditukarkan dengan voucher dibawah ini loh!',
                    style: GoogleFonts.ptSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
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
                      const SizedBox(width: 20),
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
                      const SizedBox(width: 20),
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
                      const SizedBox(width: 20),
                      IconButton(
                        onPressed: () {
                          goToVoucherMenu();
                        },
                        icon: SizedBox(
                          width: 50,
                          child: Column(
                            children: [
                              Image.asset("assets/img/lainnya.png"),
                              const SizedBox(height: 6),
                              Text(
                                'Voucher Lainnya',
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
              ),
            ),
            Container(
              width: 329,
              margin: const EdgeInsets.only(top: 32),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Artikel Edukasi',
                        style: GoogleFonts.ptSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Image.asset('assets/img/panah.png')
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: _articles.map((article) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        margin: const EdgeInsets.only(right: 14.5),
                        width: 150,
                        height: 252,
                        child: Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(4),
                                  bottomRight: Radius.circular(4),
                                ),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: Image.network(
                                article['image'],
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.only(
                                left: 4,
                                right: 4,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    article['title'],
                                    style: GoogleFonts.ptSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const FaIcon(
                                        FontAwesomeIcons.calendar,
                                        color: Colors.black,
                                        size: 12,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        "${article['day']} ${article['month']} ${article['year']}",
                                        style: GoogleFonts.ptSans(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  IconButton(
                                    onPressed: () {
                                      goToArticle(article['id']);
                                    },
                                    icon: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF1D7948),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                          ),
                                          padding: const EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                            bottom: 4,
                                            top: 4,
                                          ),
                                          width: 78,
                                          height: 28,
                                          child: Text(
                                            'Read More',
                                            style: GoogleFonts.ptSans(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 10,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      )),
      bottomNavigationBar: NavigationBottom(
        selectedIndex: selectedIndex,
        userid: widget.userid,
        usertipe: widget.usertipe,
      ),
    );
  }
}

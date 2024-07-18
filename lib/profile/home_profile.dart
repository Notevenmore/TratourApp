import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tratour/onboarding/Onboarding.dart';
import 'package:tratour/template/navigation_bottom.dart';
import 'package:flutter/widgets.dart';
import 'edit_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilPage extends StatefulWidget {
  final String userid;
  final String usertipe;

  ProfilPage({required this.userid, required this.usertipe});

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final TextEditingController _referalController = TextEditingController();
  late Map<String, dynamic> _userdata = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // bool _isLoading = true;
  int selectedIndex = 4;
  List<Map<String, dynamic>> referralCode = [];

  @override
  void initState() {
    super.initState();
  }

  Future<Map<String, dynamic>> getData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection(widget.usertipe)
          .doc(widget.userid)
          .get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        return {};
      }
    } catch (e) {
      print("Error load data: $e");
      return {};
    }
  }

  void onboarding() async {
    try {
      await GoogleSignIn().disconnect();
    } catch (e) {
      print(e);
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Onboarding(),
      ),
    );
  }

  void EditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            UpdateProfilePage(userId: widget.userid, userTipe: widget.usertipe),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              _userdata = snapshot.data!;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Foto profil
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 30.0,
                              backgroundImage:
                                  _userdata['photo_profile'] != null &&
                                          _userdata['photo_profile'].isNotEmpty
                                      ? NetworkImage(_userdata['photo_profile'])
                                      : AssetImage('assets/img/username.jpg')
                                          as ImageProvider,
                            ),
                            const SizedBox(width: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Nama pengguna
                                Text(
                                  "${_userdata['name']}",
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 9.0),
                                // Email pengguna
                                Text(
                                  "${_userdata['email']}",
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 40.0),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => EditProfile(),
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ],
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.only(left: 15, top: 20),
                        child: Row(
                          children: [
                            Text(
                              'Poin & Kode Referral',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      // Kotak untuk Poin dan Kode Referral
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ReferralCodeCard(context),
                          PointsCard(context),
                        ],
                      ),

                      const SizedBox(height: 20.0),

                      // Divider
                      const Divider(
                        height: 1.0,
                      ),
                      const SizedBox(height: 30.0),
                      const Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Row(
                          children: [
                            Text(
                              'Umum',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),

                      // Pengaturan
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.notifications),
                            title: const Text('Notifikasi'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: const Icon(Icons.help),
                            title: const Text('Bantuan'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: const Icon(Icons.star),
                            title: const Text('Beri Rating Aplikasi'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.logout,
                              color: Colors.red,
                            ),
                            title: const Text(
                              'Keluar',
                              style: TextStyle(color: Colors.red),
                            ),
                            onTap: () => onboarding(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: Text("No data Found"));
            }
          }),
      bottomNavigationBar: NavigationBottom(
        selectedIndex: selectedIndex,
        userid: widget.userid,
        usertipe: widget.usertipe,
      ),
    );
  }

  Widget ReferralCodeCard(BuildContext context) {
    return GestureDetector(
      onTap: _userdata['referral_code'] == ""
          ? () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    title: Center(
                      child: Text(
                        'Kode Referral',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    content: TextField(
                      controller: _referalController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan kode referral di sini',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF1D7948),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () async {
                            try {
                              QuerySnapshot querySnapshot =
                                  await FirebaseFirestore.instance
                                      .collection('referral_code')
                                      .get();
                              setState(() {
                                referralCode = querySnapshot.docs
                                    .map((doc) =>
                                        doc.data() as Map<String, dynamic>)
                                    .toList();
                              });
                              print(referralCode);
                              print(_referalController.text);
                              DocumentReference docRef = _firestore
                                  .collection('warga')
                                  .doc(widget.userid);
                              for (var i = 0; i < referralCode.length; i++) {
                                if (_referalController.text ==
                                    referralCode[i]['name']) {
                                  setState(() {
                                    docRef.update({
                                      'poin': FieldValue.increment(2000),
                                      'referral_code': _referalController.text
                                    });
                                    _userdata['poin'] += 2000;
                                    _userdata['referral_code'] =
                                        _referalController.text;
                                  });
                                  Navigator.of(context)
                                      .pop(); // Close the current dialog
                                  showSuccessDialog(context);
                                }
                              }
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Text(
                            'Redeem',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          : null,
      child: _userdata['referral_code'] == ""
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: 152.0,
                height: 152.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 10.0,
                      left: 10.0,
                      child: Icon(
                        Icons
                            .card_giftcard, // Replace with the appropriate icon
                        size: 20,
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height:
                                  10), // Adjust the height to move text upwards
                          Text(
                            'Referral Code',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                              height:
                                  5), // Adjust the height to move text upwards
                          Text(
                            'ketuk untuk memasukkan\nreferral code',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: 152.0,
                height: 152,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 8.0,
                      left: 8.0,
                      child: Icon(Icons
                          .card_giftcard), // Gantilah dengan ikon yang sesuai
                    ),
                    Positioned(
                      top: 8.0,
                      right: 8.0,
                      child: Icon(Icons.more_vert),
                    ),
                    Center(
                      child: Text(
                        '${_userdata['referral_code']}',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8.0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          'Referral Code',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget PointsCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: 152.0,
        height: 152,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 8.0,
              left: 8.0,
              child: CircleAvatar(
                radius: 12.0,
                backgroundColor: Colors.yellow,
                child: Text(
                  'P',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                "${_userdata['poin']}",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 8.0,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Poin',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: const Color(0xFF1D7948),
                size: 50,
              ),
              SizedBox(height: 10),
              Text(
                'Anda berhasil menggunakan token',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D7948),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        );
      },
    );
  }
}

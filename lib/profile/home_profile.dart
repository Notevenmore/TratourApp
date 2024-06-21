import 'package:flutter/material.dart';
import 'package:tratour/template/navigation_bottom.dart';
import 'package:flutter/widgets.dart';
import 'package:tratour/menu/homepage.dart';
import 'package:tratour/auth/Login.dart';
import 'edit_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilPage extends StatefulWidget {
  final String userid;
  final String usertipe;

  ProfilPage({required this.userid, required this.usertipe});

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  late Map<String, dynamic> _userdata = {};
  bool _isLoading = true;
  int selectedIndex = 4;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                homepage(userid: widget.userid, usertipe: widget.usertipe)),
      );
    } else if (index == 4) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfilPage(
                  userid: widget.userid, usertipe: widget.usertipe)));
    }
  }

  void getData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection(widget.usertipe)
          .doc(widget.userid)
          .get();
      if (doc.exists) {
        setState(() {
          _userdata = doc.data() as Map<String, dynamic>;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void login() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Login(Tipe: widget.usertipe),
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
        title: Text('Profil Saya'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
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
                      radius: 40.0,
                      backgroundImage: AssetImage('assets/img/username.jpg'),
                    ),
                    SizedBox(width: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama pengguna
                        Text(
                          "${_userdata['name']}",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 9.0),
                        // Email pengguna
                        Text(
                          "${_userdata['email']}",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 40.0),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => EditProfile(),
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 15, top: 20),
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
                  Padding(
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
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Kesh23',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              'Kode Referral',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 5.0),
                        ],
                      ),
                    ),
                  ),
                  Padding(
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
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "${_userdata['poin']}",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              'Poin',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 5.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.0),

              // Divider
              Divider(
                height: 1.0,
              ),
              SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.only(left: 15),
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
                    leading: Icon(Icons.notifications),
                    title: Text('Notifikasi'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.help),
                    title: Text('Bantuan'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.star),
                    title: Text('Beri Rating Aplikasi'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    title: Text(
                      'Keluar',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () => login(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBottom(
        selectedIndex: selectedIndex,
        userid: widget.userid,
        usertipe: widget.usertipe,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Profil Saya'),
  //     ),
  //     body: SingleChildScrollView(
  //       child: Padding(
  //         padding: const EdgeInsets.all(20.0),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             // Foto profil
  //             Padding(
  //               padding: const EdgeInsets.only(bottom: 20.0),
  //               child: Row(
  //                 children: [
  //                   CircleAvatar(
  //                     radius: 40.0,
  //                     backgroundImage: AssetImage('assets/img/username.jpg'),
  //                   ),
  //                   SizedBox(width: 20.0),
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       // Nama pengguna
  //                       Text(
  //                         'Rakesh Bramantyo',
  //                         style: TextStyle(
  //                           fontSize: 20.0,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                       SizedBox(height: 9.0),
  //                       // Email pengguna
  //                       Text(
  //                         'kesh123@gmail.com',
  //                         style: TextStyle(
  //                           fontSize: 16.0,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(width: 40.0),
  //                   FaIcon(
  //                     FontAwesomeIcons.penToSquare,
  //                     color: Color(0xFF6D6D6D),
  //                   ),
  //                 ],
  //               ),
  //             ),

  //             // Poin dan kode referral
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       'Poin',
  //                       style: TextStyle(
  //                         fontSize: 16.0,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                     SizedBox(height: 5.0),
  //                     Text(
  //                       '10000',
  //                       style: TextStyle(
  //                         fontSize: 20.0,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       'Kode Referral',
  //                       style: TextStyle(
  //                         fontSize: 16.0,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                     SizedBox(height: 5.0),
  //                     Text(
  //                       'Kesh23',
  //                       style: TextStyle(
  //                         fontSize: 20.0,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //             SizedBox(height: 20.0),

  //             // Divider
  //             Divider(
  //               height: 1.0,
  //             ),
  //             SizedBox(height: 20.0),

  //             // Pengaturan
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 ListTile(
  //                   leading: Icon(Icons.notifications),
  //                   title: Text('Notifikasi'),
  //                   trailing: Icon(Icons.chevron_right),
  //                   onTap: () {},
  //                 ),
  //                 ListTile(
  //                   leading: Icon(Icons.help),
  //                   title: Text('Bantuan'),
  //                   trailing: Icon(Icons.chevron_right),
  //                   onTap: () {},
  //                 ),
  //                 ListTile(
  //                   leading: Icon(Icons.star),
  //                   title: Text('Beri Rating Aplikasi'),
  //                   trailing: Icon(Icons.chevron_right),
  //                   onTap: () {},
  //                 ),
  //                 ListTile(
  //                   leading: Icon(Icons.logout),
  //                   title: Text('Keluar'),
  //                   trailing: Icon(Icons.chevron_right),
  //                   onTap: () {},
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //     bottomNavigationBar: NavigationBottom(
  //       selectedIndex: selectedIndex,
  //       userid: widget.userid,
  //       usertipe: widget.usertipe,
  //       onItemTapped: _onItemTapped,
  //     ),
  //   );
  // }
}

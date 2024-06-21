import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tratour/homepage/homepage_sweeper.dart';
import 'package:tratour/homepage/homepage_warga.dart';
import 'package:tratour/profile/home_profile.dart';

class homepage extends StatefulWidget {
  final String userid;
  final String usertipe;
  const homepage({super.key, required this.userid, required this.usertipe});

  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  late Map<String, dynamic> _userdata = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void _onItemTapped(int index) {
    print(index);
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
                    userid: widget.userid,
                    usertipe: widget.usertipe,
                  )));
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

  @override
  Widget build(BuildContext context) {
    if (!_isLoading) {
      if (widget.usertipe == "warga") {
        return HomepageWarga(
          userid: widget.userid,
          usertipe: widget.usertipe,
          userdata: _userdata,
        );
      } else {
        return HomepageSweeper(
            userid: widget.userid,
            usertipe: widget.usertipe,
            userdata: _userdata);
      }
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tratour/home/homepage_sweeper.dart';
import 'package:tratour/home/homepage_warga.dart';

class homepage extends StatefulWidget {
  final String userid;
  final String usertipe;
  const homepage({super.key, required this.userid, required this.usertipe});

  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> {
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
      print("Error data doc: ${e}");
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getData(),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final userdata = snapshot.data!;
            if (widget.usertipe == "warga") {
              return HomepageWarga(
                userid: widget.userid,
                usertipe: widget.usertipe,
                userdata: userdata,
              );
            } else {
              return HomepageSweeper(
                userid: widget.userid,
                usertipe: widget.usertipe,
                userdata: userdata,
              );
            }
          } else {
            return const Center(child: Text("No data Found"));
          }
        },
      ),
    );
  }
}

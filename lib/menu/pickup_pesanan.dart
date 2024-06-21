import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class PickupPesanan extends StatefulWidget {
  final String userid;
  final String usertipe;
  final String selectedCategories;

  const PickupPesanan(
      {super.key,
      required this.userid,
      required this.usertipe,
      required this.selectedCategories});

  @override
  _PickupPesananState createState() => _PickupPesananState();
}

class _PickupPesananState extends State<PickupPesanan> {
  Map<String, dynamic> _order = {};
  Map<String, dynamic> _userOrderData = {};
  LatLng? _currentPosition;
  Position? _position;
  int select = -1;
  List<String> category = [
    'Plastik',
    'Organik',
    'Minyak Goreng',
    'Kardus',
    'Elektronik',
    'Pakaian',
  ];
  late Future<void> _fetchDataFuture;

  @override
  void initState() {
    super.initState();
    _fetchDataFuture = fetchData();
    // getCurrentPosition();
    // getOrder();
  }

  Future<void> getOrder() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('pesanan').get();

      List<Map<String, dynamic>> orders = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();

      setState(() {
        for (int i = 0; i < category.length; i++) {
          if (category[i] == widget.selectedCategories) {
            select = i;
          }
        }
        ;
        _order = orders.firstWhere(
            (order) => order['selectedCategories'].contains(select));
      });
    } catch (e) {
      print('gagal ambil');
    }
  }

  Future<void> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      setState(() {
        _position = position;
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print("Error $e");
    }
  }

  double degreeToRadian(double degree) {
    return degree * pi / 180;
  }

  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    double dLat = degreeToRadian(lat2 - lat1);
    double dLon = degreeToRadian(lng2 - lng1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(degreeToRadian(lat1)) *
            cos(degreeToRadian(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return 6371.0 * c;
  }

  Future<void> fetchData() async {
    await getCurrentPosition();
    await getOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/img/PickUp Sweeper Notification 1.png"),
                  const SizedBox(height: 16),
                  Text(
                    "Ada Pesanan Untuk kamu nih!",
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFD9D9D9),
                  width: 0.5,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 11),
                    padding: const EdgeInsets.only(left: 21),
                    child: Text(
                      "${widget.selectedCategories} Pickup",
                      style: GoogleFonts.ptSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  makeLine(),
                  makeLine(),
                ],
              ),
            ),
            FutureBuilder(
              future: _fetchDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  if (_position != null && _order != null) {
                    double distance = calculateDistance(
                      _position!.latitude,
                      _position!.longitude,
                      _order!['latitude'],
                      _order!['longitude'],
                    );
                    return Center(child: Text("Distance: $distance km"));
                  } else {
                    return Center(child: Text("Unable to calculate distance"));
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget makeLine() {
    return Container(
      width: 320,
      height: 2,
      decoration: const BoxDecoration(
        color: Color(0xFFD9D9D9),
      ),
    );
  }
}

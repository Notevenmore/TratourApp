import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:tratour/menu/homepage.dart';

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
  String userLocation = "";
  String sweeperLocation = "";
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
  }

  Future<String> _updateMarkerInfo(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks[0];
        return "${place.street}";
      }
    } catch (e) {
      print('Error fetching placemark: $e');
    }
    return "";
  }

  Future<void> updateSweeperLocation() async {
    String address =
        await _updateMarkerInfo(_position!.latitude, _position!.longitude);
    setState(() {
      sweeperLocation = address;
    });
  }

  Future<void> updateUserLocation() async {
    String address =
        await _updateMarkerInfo(_order['latitude'], _order['longitude']);
    setState(() {
      userLocation = address;
    });
  }

  Future<void> getData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("warga")
          .doc(_order['userid'])
          .get();
      if (doc.exists) {
        setState(() {
          _userOrderData = doc.data() as Map<String, dynamic>;
        });
      }
    } catch (e) {
      print("Error pengambilan data user: $e");
    }
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
    await getData();
    await updateUserLocation();
    await updateSweeperLocation();
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
                  const SizedBox(height: 104),
                  Image.asset("assets/img/PickUp Sweeper Notification 1.png"),
                  const SizedBox(height: 16),
                  Text(
                    "Ada Pesanan Untuk kamu nih!",
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 80),
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
                  Container(
                    width: 320,
                    padding: const EdgeInsets.all(21),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder(
                          future: _fetchDataFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              if (_position != null && _order != null) {
                                double distance = calculateDistance(
                                  _position!.latitude,
                                  _position!.longitude,
                                  _order!['latitude'],
                                  _order!['longitude'],
                                );
                                distance =
                                    double.parse(distance.toStringAsFixed(2));
                                return Text(
                                  "$distance km",
                                  style: GoogleFonts.ptSans(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                );
                              } else {
                                return Text("Unable to calculate distance");
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              detailLocation(
                                Color(0xFF1D7948),
                                "Lokasi Kamu",
                                sweeperLocation,
                              ),
                              for (int i = 1; i <= 7; i++) (circleMaker()),
                              detailLocation(
                                Color(0xFFFBBC05),
                                "Lokasi Pickup",
                                userLocation,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  makeLine(),
                  FutureBuilder(
                    future: _fetchDataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 21, vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage(
                                  _userOrderData['photo_profile'],
                                ),
                                radius: 18,
                              ),
                              const SizedBox(width: 10),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _userOrderData['name'],
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      width: 237,
                                      child: Text(
                                        _order['detailLocation'],
                                        style: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 17),
                                    Container(
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      homepage(
                                                    userid: widget.userid,
                                                    usertipe: widget.usertipe,
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: button(
                                                const Color(0xFFEA4335),
                                                "Tolak"),
                                          ),
                                          const SizedBox(width: 30),
                                          IconButton(
                                            onPressed: () {},
                                            icon: button(
                                                const Color(0xFF6FD73E),
                                                "Terima"),
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
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget button(Color color, String text) {
    return Container(
      width: 87,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(9)),
      ),
      child: Text(
        text,
        style: GoogleFonts.ptSans(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget circleMaker() {
    return Container(
      width: 6,
      height: 6,
      margin: const EdgeInsets.only(left: 11, bottom: 4),
      decoration: const BoxDecoration(
        color: Color(0xFFD9D9D9),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget detailLocation(
    Color color,
    String caption,
    String desc,
  ) {
    return SizedBox(
      child: Row(
        children: [
          logo(color),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                caption,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget logo(Color colors) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: colors,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.location_on_outlined,
        color: Colors.white,
        size: 16,
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

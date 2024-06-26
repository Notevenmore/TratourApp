import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:tratour/menu/sort_trash_menu.dart';
import 'package:tratour/models/sort_trash_data.dart';
import 'package:tratour/profile/home_profile.dart';
import 'package:tratour/template/navigation_bottom.dart';
import 'package:tratour/template/bar_app_secondversion.dart';
import 'package:tratour/menu/homepage.dart';

class Tracking extends StatefulWidget {
  final String userid;
  final String usertipe;
  final Map<String, dynamic> order;
  final Map<String, dynamic> userOrderData;
  final double distance;

  const Tracking({
    super.key,
    required this.userid,
    required this.usertipe,
    required this.order,
    required this.userOrderData,
    required this.distance,
  });

  @override
  _Tracking createState() => _Tracking();
}

class _Tracking extends State<Tracking> {
  int selectedIndex = 2;
  late GoogleMapController mapController;
  LatLng? _currentPosition;
  final List<Marker> _markers = [];
  String currentPlaceName = '';
  String currentAddress = '';
  double latitude = 0;
  double longitude = 0;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _updateMarkerInfo(LatLng position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks[0];
        String name = place.name ?? 'Unnamed Place';
        String address =
            '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}';

        setState(() {
          _markers.clear();
          _markers.add(
            Marker(
              markerId: const MarkerId('CurrentLocation'),
              position: position,
              infoWindow: InfoWindow(
                title: name,
                snippet: address,
              ),
            ),
          );
          currentPlaceName = name;
          currentAddress = address;
          latitude = position.latitude;
          longitude = position.longitude;
        });
      }
    } catch (e) {
      print('Error fetching placemark: $e');
    }
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

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
      _currentPosition = LatLng(position.latitude, position.longitude);
      _markers.add(
        Marker(
          markerId: const MarkerId('CurrentLocation'),
          position: LatLng(widget.order['latitude'], widget.order['longitude']),
          infoWindow: const InfoWindow(
            title: 'Current Location',
            snippet: 'Your current position',
          ),
        ),
      );
    });
    // await _updateMarkerInfo(_currentPosition!);
  }

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  void redirect_homepage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => homepage(
          userid: widget.userid,
          usertipe: widget.usertipe,
        ),
      ),
    );
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

  void checkValidLocation() {
    if (double.parse((_currentPosition!.longitude).toStringAsFixed(2)) ==
            double.parse((widget.order['longitude']).toStringAsFixed(2)) &&
        double.parse((_currentPosition!.latitude).toStringAsFixed(2)) ==
            double.parse((widget.order['latitude']).toStringAsFixed(2))) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: popup(Icons.check, const Color(0xFF6FD73E),
                "Pengambilan kamu telah selesai"),
          );
        },
      );
      Timer(const Duration(seconds: 2), () {
        FirebaseFirestore.instance.runTransaction((transaction) async {
          final category = await fetchCategoryFromJson();
          DocumentSnapshot customer = await transaction.get(
            FirebaseFirestore.instance.collection("warga").doc(
                  widget.order['userid'],
                ),
          );
          DocumentSnapshot sweeper = await transaction.get(
            FirebaseFirestore.instance.collection("sweeper").doc(
                  widget.userid,
                ),
          );
          double customer_poin = customer.get("poin").toDouble();
          double sweeper_poin = sweeper.get("poin").toDouble();
          widget.order['selectedCategories'].forEach((index) {
            customer_poin +=
                (category[widget.order['selectedCategories'][index] ~/ 2]
                            [widget.order['selectedCategories'][index] % 2]
                        .price! *
                    widget.order['amountCategories'][index]);
          });
          sweeper_poin += (widget.distance * 5);
          customer_poin -= (widget.distance * 5);
          customer_poin -= 1000;
          transaction.update(
            FirebaseFirestore.instance
                .collection("warga")
                .doc(widget.order['userid']),
            {"poin": customer_poin},
          );
          transaction.update(
            FirebaseFirestore.instance.collection("sweeper").doc(widget.userid),
            {"poin": sweeper_poin},
          );
          transaction.update(
            FirebaseFirestore.instance
                .collection("pesanan")
                .doc(widget.order['id']),
            {
              "status_pengiriman": true,
              "distance": widget.distance,
              "user_poin": customer_poin,
              "sweeper_poin": sweeper_poin,
            },
          );
        }).then(
          (value) => redirect_homepage(context),
          onError: (e) =>
              print("Error saat melakukan pembaruan status pengiriman: $e"),
        );
        // Navigator.of(context).pop(); // Close the popup
      });
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: popup(Icons.close, const Color.fromARGB(255, 241, 49, 49),
                "Anda belum di lokasi!"),
          );
        },
      );
      Timer(Duration(seconds: 2), () {
        Navigator.of(context).pop(); // Close the popup
        // Navigator.pushReplacementNamed(
        //     context, '/next'); // Navigate to next page
      });
    }
  }

  Widget popup(IconData icon, Color color, String text) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(11),
      height: 295,
      width: 295,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 173,
            height: 173,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 130,
            ),
          ),
          const SizedBox(height: 23),
          Text(
            text,
            style: GoogleFonts.lato(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const BarAppSecondversion(title: "Tentukan Lokasi Pengambilan"),
      body: _currentPosition == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 473,
                    child: Expanded(
                      child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(widget.order['latitude'],
                              widget.order['longitude']),
                          zoom: 18,
                        ),
                        markers: Set<Marker>.of(_markers),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(26),
                        topRight: Radius.circular(26),
                      ),
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFF6D6D6D),
                        width: 0.2,
                      ),
                    ),
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18.5, vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage(
                                  widget.userOrderData['photo_profile'],
                                ),
                                radius: 18,
                              ),
                              const SizedBox(width: 14),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.userOrderData['name'],
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: 187,
                                      child: Text(
                                        widget.order['detailLocation'],
                                        style: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: contactButton(Icons.call),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: contactButton(Icons.chat),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  redirect_homepage(context);
                                },
                                icon: buttonConfirmed(
                                  Colors.white,
                                  const Color(0xFFEA4335),
                                  "Batalkan Pengambilan",
                                  const Color(0xFFEA4335),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  checkValidLocation();
                                },
                                icon: buttonConfirmed(
                                  const Color(0xFF1D7948),
                                  const Color(0xFF1D7948),
                                  "Selesaikan Pengambilan",
                                  Colors.white,
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
            ),
    );
  }

  Widget buttonConfirmed(
      Color backgroundColor, Color borderColor, String text, Color textColor) {
    return Container(
      margin: const EdgeInsets.only(right: 17),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(9),
        ),
      ),
      width: 152,
      height: 32,
      child: Text(
        text,
        style: GoogleFonts.ptSans(
          fontWeight: FontWeight.w700,
          fontSize: 12,
          color: textColor,
        ),
      ),
    );
  }

  Widget contactButton(IconData icon) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF1D7948),
      ),
      width: 24,
      height: 24,
      child: Icon(
        icon,
        color: Colors.white,
        size: 11,
      ),
    );
  }
}

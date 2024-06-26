import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:tratour/menu/detail_pesanan.dart';
import 'package:tratour/template/navigation_bottom.dart';
import 'package:tratour/template/bar_app_secondversion.dart';
import 'package:tratour/template/input_field.dart';
import 'package:tratour/helper/map_permission.dart';

class ChooseLocation extends StatefulWidget {
  final String userid;
  final String usertipe;
  final Set<int> selectedCategories;

  const ChooseLocation({
    super.key,
    required this.userid,
    required this.usertipe,
    required this.selectedCategories,
  });

  @override
  _ChooseLocation createState() => _ChooseLocation();
}

class _ChooseLocation extends State<ChooseLocation> {
  int selectedIndex = 2;
  late GoogleMapController mapController;
  LatLng? _currentPosition;
  final List<Marker> _markers = [];
  final TextEditingController _editController = TextEditingController();
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
    await MapPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _markers.add(
        Marker(
          markerId: const MarkerId('CurrentLocation'),
          position: _currentPosition!,
          infoWindow: const InfoWindow(
            title: 'Current Location',
            snippet: 'Your current position',
          ),
        ),
      );
    });
    await _updateMarkerInfo(_currentPosition!);
  }

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  void _detailPesanan(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPesanan(
            userid: widget.userid,
            usertipe: widget.usertipe,
            selectedCategories: widget.selectedCategories,
            currentAddress: currentAddress,
            locationName: currentPlaceName,
            latitude: latitude,
            longitude: longitude,
            detailLocation: _editController.text),
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
                          target: _currentPosition!,
                          zoom: 18,
                        ),
                        markers: Set<Marker>.of(_markers),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lokasimu saat ini',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.locationDot,
                                color: Color(0XFF1D7948),
                                size: 14,
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 294,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentPlaceName,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      currentAddress,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFFA1A1A1),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.pencil,
                                color: Colors.black,
                                size: 14,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: InputField(
                                  controller: _editController,
                                  hintText: 'Tulis keterangan untuk pengambil',
                                  obscureText: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 17),
                        SizedBox(
                          width: double.infinity,
                          height: 32,
                          child: ElevatedButton(
                            onPressed: () {
                              // kirim data
                              _detailPesanan(context);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: const Color(0xFF1D7948),
                            ),
                            child: Text(
                              'Konfirmasi',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: NavigationBottom(
        selectedIndex: 2,
        userid: widget.userid,
        usertipe: widget.usertipe,
      ),
    );
  }
}

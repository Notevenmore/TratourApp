import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tratour/menu/pickup_pesanan.dart';

class HomepageSweeper extends StatefulWidget {
  final String userid;
  final String usertipe;
  final Map<String, dynamic> userdata;
  const HomepageSweeper(
      {super.key,
      required this.userid,
      required this.usertipe,
      required this.userdata});

  @override
  _HomepageSweeperState createState() => _HomepageSweeperState();
}

class _HomepageSweeperState extends State<HomepageSweeper> {
  bool _isDropdownCategoriesVisible = false;
  bool _isDropdownVehiclesVisible = false;
  List<String> categories = [
    'Organik',
    'Plastik',
    'Minyak Goreng',
    'Kardus',
    'Elektronik',
    'Pakaian'
  ];
  List<String> vehicles = ['Sepeda Motor', 'Truck', 'Mobil'];
  String selectedCategories = "Organik";
  String selectedVehicles = "Sepeda Motor";

  void _toggleDropdownCategories() {
    setState(() {
      _isDropdownCategoriesVisible = !_isDropdownCategoriesVisible;
    });
  }

  void _toggleDropdownVehicles() {
    setState(() {
      _isDropdownVehiclesVisible = !_isDropdownVehiclesVisible;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  void moveToPickupPesanan(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PickupPesanan(
          userid: widget.userid,
          usertipe: widget.usertipe,
          selectedCategories: selectedCategories,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: SizedBox(
          width: 80,
          height: 39,
          child: Image.asset("assets/img/logo.png"),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          padding:
              const EdgeInsets.only(top: 36, bottom: 20, left: 20, right: 20),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 56),
                width: 337.6,
                height: 136,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  boxShadow: [
                    box(-2, -1),
                    box(0, 4),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          title("Poin Kamu", 16),
                          const SizedBox(width: 92),
                          SizedBox(
                            width: 130,
                            height: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.clockRotateLeft,
                                  size: 12,
                                  color: Color(0xFF6D6D6D),
                                ),
                                title("History Pengambilan", 10,
                                    color: const Color(0xFF6D6D6D)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        _makeCircle("P"),
                        const SizedBox(width: 12),
                        title("${widget.userdata['poin']} Poin", 20),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 337.6,
                margin: const EdgeInsets.only(bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title("Preferensi Jenis Sampah", 16),
                    animatedContainer(categories.length, "categories"),
                  ],
                ),
              ),
              Container(
                width: 337.6,
                margin: const EdgeInsets.only(bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title("Preferensi Kendaraan Anda", 16),
                    animatedContainer(vehicles.length, "vehicles"),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 32),
                alignment: Alignment.topLeft,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: 337.6,
                height: 171, //diubah
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  boxShadow: [
                    box(3, 4),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 57,
                      height: 57,
                      padding: const EdgeInsets.all(1),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 56,
                        backgroundImage:
                            AssetImage(widget.userdata['photo_profile']),
                      ),
                    ),
                    title(widget.userdata['name'], 16),
                    const SizedBox(height: 17),
                    SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              title("Layanan", 14),
                              const SizedBox(height: 10),
                              Text(
                                selectedCategories,
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 4,
                            height: 52,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2)),
                              color: Color(0xFF1D7948),
                            ),
                          ),
                          Column(
                            children: [
                              Image.asset("assets/img/kendaraan.png"),
                              Text(
                                selectedVehicles,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  moveToPickupPesanan(context);
                },
                icon: Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1D7948),
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  width: 337.6,
                  height: 32,
                  child: title("Cari Pesanan Sekarang", 12,
                      color: const Color(0xFFFFFFFF)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxShadow box(double x, double y) {
    return BoxShadow(
      color: Colors.black.withOpacity(0.25),
      blurRadius: 4,
      spreadRadius: 0,
      offset: Offset(x, y),
    );
  }

  Widget animatedContainer(int length, String doItFor) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      margin: const EdgeInsets.only(top: 16),
      curve: Curves.easeInOut,
      width: 337.6,
      height: doItFor == "categories"
          ? _isDropdownCategoriesVisible
              ? (length * 48.0)
              : 48.0
          : _isDropdownVehiclesVisible
              ? (length * 48.0)
              : 48.0,
      padding: const EdgeInsets.only(left: 16, right: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF1D7948),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        children: doItFor == "categories"
            ? _isDropdownCategoriesVisible
                ? categories
                    .map((category) => printCategories(category, doItFor))
                    .toList()
                : [printCategories(selectedCategories, doItFor)]
            : _isDropdownVehiclesVisible
                ? vehicles
                    .map((vehicle) => printCategories(vehicle, doItFor))
                    .toList()
                : [printCategories(selectedVehicles, doItFor)],
      ),
    );
  }

  Widget printCategories(String text, String doItFor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (doItFor == "categories")
          texts(text, () {
            categories.remove(text);
            categories.insert(0, text);
            selectedCategories = text;
            _isDropdownCategoriesVisible = false;
          })
        else
          texts(text, () {
            vehicles.remove(text);
            vehicles.insert(0, text);
            selectedVehicles = text;
            _isDropdownVehiclesVisible = false;
          }),
        if (text == selectedCategories)
          (IconButton(
            onPressed: _toggleDropdownCategories,
            icon: FaIcon(
              _isDropdownCategoriesVisible
                  ? FontAwesomeIcons.angleUp
                  : FontAwesomeIcons.angleDown,
              color: Colors.white,
              size: 16,
            ),
          ))
        else if (text == selectedVehicles)
          (IconButton(
            onPressed: _toggleDropdownVehicles,
            icon: FaIcon(
              _isDropdownVehiclesVisible
                  ? FontAwesomeIcons.angleUp
                  : FontAwesomeIcons.angleDown,
              color: Colors.white,
              size: 16,
            ),
          ))
        else
          (IconButton(
            onPressed: () {},
            icon: FaIcon(
              FontAwesomeIcons.angleDown,
              color: Colors.white.withOpacity(0),
              size: 16,
            ),
          ))
      ],
    );
  }

  Widget texts(String text, Function change) {
    return TextButton(
      onPressed: () {
        setState(() {
          change();
        });
      },
      child: Text(
        text,
        style: GoogleFonts.beVietnamPro(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget title(String text, double size,
      {Color color = const Color(0xFF000000)}) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }

  Widget _makeCircle(String text) {
    return Container(
      alignment: Alignment.center,
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFFBBC05),
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tratour/routes/map_routes.dart';

import 'package:tratour/template/navigation_bottom.dart';
import 'package:tratour/template/bar_app_secondversion.dart';
import 'package:tratour/models/categories_model.dart';
import 'package:tratour/helper/fetch_category_from_json.dart';

class SortTrashMenu extends StatefulWidget {
  final String userid;
  final String usertipe;
  const SortTrashMenu(
      {super.key, required this.userid, required this.usertipe});

  @override
  _SortTrashMenu createState() => _SortTrashMenu();
}

class _SortTrashMenu extends State<SortTrashMenu> {
  // inisialisasi isi konten kategori
  late Future<List<List<Category>>> categories;
  Set<int> selectedCategories = Set();

  @override
  void initState() {
    super.initState();
    categories = fetchCategoryFromJson();
  }

  // aksi untuk memilih kategori
  void _toggleCategory(int rowIndex, int colIndex) {
    int index = rowIndex * 2 + colIndex;
    setState(() {
      if (selectedCategories.contains(index)) {
        selectedCategories.remove(index);
      } else {
        selectedCategories.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const BarAppSecondversion(title: "Pilah Sampah"),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // judul
            Container(
              margin: const EdgeInsets.only(bottom: 10, left: 20),
              child: Text(
                "Pilih jenis sampah dari kategori dibawah ini!",
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
                textAlign: TextAlign.start,
              ),
            ),

            // tampilan list kategori pada halaman
            Expanded(
              child: FutureBuilder<List<List<Category>>>(
                  future: categories,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final categories = snapshot.data!;
                      return ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (context, rowIndex) {
                            final row = categories[rowIndex];
                            return Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 0, right: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: row.asMap().entries.map((entry) {
                                  int colIndex = entry.key;
                                  Category item = entry.value;
                                  return _buildCategory(
                                      context, item, rowIndex, colIndex);
                                }).toList(),
                              ),
                            );
                          });
                    }
                  }),
            ),

            // tombol konfirmasi
            const SizedBox(height: 20),
            IconButton(
              onPressed: () {
                redirectToMap(
                  context,
                  selectedCategories,
                  widget.userid,
                  widget.usertipe,
                );
              },
              icon: Container(
                width: 335,
                height: 32,
                margin: const EdgeInsets.only(left: 20),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  color: Color(0xFF1D7948),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Konfirmasi",
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
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

  Widget _buildCategory(
      BuildContext context, Category categories, int rowIndex, int colIndex) {
    int index = rowIndex * 2 + colIndex;
    bool isSelected = selectedCategories.contains(index);

    return GestureDetector(
      onTap: () => _toggleCategory(rowIndex, colIndex),
      child: Container(
        width: 152,
        height: 154,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: isSelected
              ? HSLColor.fromColor(categories.color)
                  .withLightness(
                      (HSLColor.fromColor(categories.color).lightness - 0.2)
                          .clamp(0.0, 1.0))
                  .toColor()
              : categories.color,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  categories.src,
                  width: categories.width?.toDouble(),
                  height: categories.height?.toDouble(),
                ),
                const SizedBox(height: 12),
                Text(
                  categories.text,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            if (isSelected)
              const Positioned(
                right: 8,
                top: 8,
                child: Icon(
                  Icons.check_box,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

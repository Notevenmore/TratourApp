import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BarApp extends StatelessWidget implements PreferredSizeWidget {
  final bool isloading;
  final Map<String, dynamic> userdata;
  const BarApp({super.key, required this.isloading, required this.userdata});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: !isloading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.asset(
                    "assets/img/username.jpg",
                    fit: BoxFit.cover,
                    width: 48,
                    height: 48,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi, ${userdata['name']}",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      userdata['tipe'],
                      textAlign: TextAlign.start,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    )
                  ],
                ),
                const SizedBox(width: 85),
                IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.solidBell,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    print('Notification Icon Pressed');
                  },
                ),
              ],
            )
          : const Text(
              'Loading...',
              selectionColor: Colors.transparent,
            ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

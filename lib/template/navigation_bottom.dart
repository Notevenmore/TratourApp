// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavigationBottom extends StatelessWidget implements PreferredSizeWidget {
  int selectedIndex;
  NavigationBottom({super.key, required this.selectedIndex});

  void _onItemTapped(int index) {
    selectedIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                spreadRadius: 0,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Image.asset('assets/img/homeregular.png'),
                activeIcon: Image.asset('assets/img/homesolid.png'),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/img/pesananregular.png'),
                activeIcon: Image.asset('assets/img/pesanansolid.png'),
                label: 'Pesanan',
              ),
              BottomNavigationBarItem(
                icon: Container(), // Empty container to maintain space
                label: '',
              ),
              const BottomNavigationBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.envelope,
                  color: Color(0xFF6D6D6D),
                ),
                activeIcon: FaIcon(
                  FontAwesomeIcons.solidEnvelope,
                  color: Color(0XFF1D7948),
                ),
                label: 'Pesan',
              ),
              const BottomNavigationBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.user,
                  color: Color(0xFF6D6D6D),
                ),
                activeIcon: FaIcon(
                  FontAwesomeIcons.solidUser,
                  color: Color(0XFF1D7948),
                ),
                label: 'Profil',
              ),
            ],
            currentIndex: selectedIndex,
            selectedItemColor: const Color(0XFF1D7948),
            onTap: _onItemTapped,
          ),
        ),
        Positioned(
          bottom: 15, // Adjust the position as needed
          left: MediaQuery.of(context).size.width / 2 -
              28, // Adjust the position to center the button
          child: FloatingActionButton(
            shape: const CircleBorder(),
            backgroundColor: const Color(0XFF1D7948),
            onPressed: () {
              // Handle the button press
              selectedIndex = 2;
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img/mdi_recycle.png',
                  width: 24,
                  height: 24,
                ),
                const SizedBox(height: 2),
                Text(
                  'Mulai',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

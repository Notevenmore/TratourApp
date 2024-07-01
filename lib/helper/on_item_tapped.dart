// aksi ketika tombol navigationbottom diklik
import 'package:flutter/material.dart';
import 'package:tratour/menu/history.dart';
import 'package:tratour/menu/sort_trash_menu.dart';
import 'package:tratour/profile/home_profile.dart';
import 'package:tratour/routes/homepage_routes.dart';

void OnItemTapped(
    BuildContext context, int index, String userid, String usertipe) {
  if (index == 0) {
    redirect_homepage(context, userid, usertipe);
  } else if (index == 1) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => History(userid: userid, usertipe: usertipe),
      ),
    );
  } else if (index == 2) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SortTrashMenu(userid: userid, usertipe: usertipe),
      ),
    );
  } else if (index == 4) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ProfilPage(userid: userid, usertipe: usertipe)));
  }
}

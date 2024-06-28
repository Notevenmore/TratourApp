import 'package:flutter/material.dart';
import 'package:tratour/menu/homepage.dart';

void redirect_homepage(BuildContext context, String userid, String usertipe) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => homepage(
        userid: userid,
        usertipe: usertipe,
      ),
    ),
  );
}

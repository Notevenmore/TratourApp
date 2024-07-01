import 'package:flutter/material.dart';
import 'package:tratour/menu/history.dart';

void redirect_pesanan(BuildContext context, String userid, String usertipe) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => History(userid: userid, usertipe: usertipe),
    ),
  );
}

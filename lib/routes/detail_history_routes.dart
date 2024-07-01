import 'package:flutter/material.dart';
import 'package:tratour/menu/detail_history_pesanan.dart';

void redirectDetailPesanan(BuildContext context, Map<String, dynamic> order,
    String userid, String usertipe) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DetailHistoryPesanan(
        userid: userid,
        usertipe: usertipe,
        order: order,
      ),
    ),
  );
}

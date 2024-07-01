import 'package:flutter/material.dart';
import 'package:tratour/menu/detail_pesanan_sweeper.dart';

void redirect_detail_pesanan_sweeper(
  BuildContext context,
  String userid,
  String usertipe,
  Map<String, dynamic> order,
  String currentAddress,
  String currentPlaceName,
  List<int> amountCategories,
  double sweeperPrice,
  double customerPrice,
) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DetailPesananSweeper(
        userid: userid,
        usertipe: usertipe,
        selectedCategories: order['selectedCategories'],
        currentAddress: currentAddress,
        locationName: currentPlaceName,
        amountCategories: amountCategories,
        sweeperPrice: sweeperPrice,
        accumulation: customerPrice,
      ),
    ),
  );
}

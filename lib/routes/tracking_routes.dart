import 'package:flutter/material.dart';
import 'package:tratour/menu/tracking.dart';

void redirect_tracking(
  BuildContext context,
  String userid,
  String usertipe,
  Map<String, dynamic> orderData,
  Map<String, dynamic> order,
  double distance,
) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Tracking(
        userid: userid,
        usertipe: usertipe,
        userOrderData: orderData,
        order: order,
        distance: distance,
      ),
    ),
  );
}

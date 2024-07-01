import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:tratour/models/voucherlistrik_model.dart';

Future<List<Voucherlistrik>> fetchVoucherlistrikFromJson() async {
  try {
    final String response =
        await rootBundle.loadString('assets/json/voucherlistrik.json');
    final List<dynamic> data = jsonDecode(response);
    return data.map((item) {
      return Voucherlistrik.fromJson(item);
    }).toList();
  } catch (e) {
    print(e);
    return [];
  }
}

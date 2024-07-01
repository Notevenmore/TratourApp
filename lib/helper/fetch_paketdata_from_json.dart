import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:tratour/models/paketdata_model.dart';

Future<List<Paketdata>> fetchPaketdataFromJson() async {
  try {
    final String response =
        await rootBundle.loadString('assets/json/paketdata.json');
    final List<dynamic> data = jsonDecode(response);
    return data.map((item) {
      return Paketdata.fromJson(item);
    }).toList();
  } catch (e) {
    print(e);
    return [];
  }
}

import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:tratour/models/pulsa_model.dart';

Future<List<Pulsa>> fetchPulsaFromJson() async {
  try {
    final String response =
        await rootBundle.loadString('assets/json/pulsa.json');
    final List<dynamic> data = jsonDecode(response);
    return data.map((item) {
      return Pulsa.fromJson(item);
    }).toList();
  } catch (e) {
    print(e);
    return [];
  }
}

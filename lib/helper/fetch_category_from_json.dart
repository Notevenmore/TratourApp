import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:tratour/models/sort_trash_data.dart';

Future<List<List<Category>>> fetchCategoryFromJson() async {
  try {
    final String response =
        await rootBundle.loadString('assets/json/category.json');
    final List<dynamic> data = jsonDecode(response);
    return data.map((row) {
      return (row as List).map((item) => Category.fromJson(item)).toList();
    }).toList();
  } catch (e) {
    print(e);
    return [];
  }
}

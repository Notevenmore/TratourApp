import 'package:flutter/material.dart';
import 'package:tratour/menu/choose_location.dart';

void redirectToMap(
  BuildContext context,
  Set<int> selectedCategories,
  String userid,
  String usertipe,
) {
  if (selectedCategories.isNotEmpty) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChooseLocation(
          userid: userid,
          usertipe: usertipe,
          selectedCategories: selectedCategories,
        ),
      ),
    );
  }
}

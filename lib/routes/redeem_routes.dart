import 'package:flutter/material.dart';
import 'package:tratour/helper/fetch_paketdata_from_json.dart';
import 'package:tratour/helper/fetch_pulsa_from_json.dart';
import 'package:tratour/helper/fetch_voucherlistrik.from_json.dart';
import 'package:tratour/menu/redeem_poin.dart';

void redirect_redeem(
  BuildContext context,
  String userid,
  String usertipe,
  String menu,
  Map<String, dynamic> userdata,
) async {
  late Future<List<dynamic>> redeemData;
  if (menu == "Pulsa Prabayar") {
    redeemData = fetchPulsaFromJson();
  } else if (menu == "Paket Data") {
    redeemData = fetchPaketdataFromJson();
  } else if (menu == "Voucher Listrik") {
    redeemData = fetchVoucherlistrikFromJson();
  }

  List<dynamic> data = await redeemData;

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => RedeemPoin(
        userid: userid,
        usertipe: usertipe,
        redeemData: data,
        redeemTipe: menu,
        userdata: userdata,
      ),
    ),
  );
}

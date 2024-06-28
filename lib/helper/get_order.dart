import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Map<String, dynamic>>> getOrder(String userid) async {
  try {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('pesanan').get();

    List<Map<String, dynamic>> ordersFirebase = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).toList();

    List<Map<String, dynamic>> ordersUser = ordersFirebase.where((doc) {
      return doc['userid'] == userid;
    }).toList();

    return ordersUser;
  } catch (e) {
    print('gagal ambil');
    return [];
  }
}

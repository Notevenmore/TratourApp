class Paketdata {
  final int price;
  final int nominal;

  Paketdata({
    required this.price,
    required this.nominal,
  });

  factory Paketdata.fromJson(Map<String, dynamic> json) {
    return Paketdata(
      price: json['price'],
      nominal: json['nominal'],
    );
  }
}

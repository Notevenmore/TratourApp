class Voucherlistrik {
  final int price;
  final int nominal;

  Voucherlistrik({
    required this.price,
    required this.nominal,
  });

  factory Voucherlistrik.fromJson(Map<String, dynamic> json) {
    return Voucherlistrik(
      price: json['price'],
      nominal: json['nominal'],
    );
  }
}

class Pulsa {
  final int price;
  final int nominal;

  Pulsa({
    required this.price,
    required this.nominal,
  });

  factory Pulsa.fromJson(Map<String, dynamic> json) {
    return Pulsa(
      price: json['price'],
      nominal: json['nominal'],
    );
  }
}

class Product {
  String? productid;
  String? description;
  String? name;
  List? extraItem = [];
  double? weight;
  double? price;
  int? qty;
  Map? nutrition = {};
  int? cart = 0;
  int currentOrder = 1;
  String? origin;
  bool? vegitarian;
  String? img;
  Product(
      {this.cart,
      this.img,
      this.name,
      this.price,
      this.productid,
      this.qty,
      this.weight,
      this.origin,
      this.vegitarian,
      this.description,
      this.extraItem,
      this.nutrition});
}

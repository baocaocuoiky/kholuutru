import 'package:shoe_store/model/product.dart';

class ProductsInCart extends Product{
  int size;
  int quantity;
  ProductsInCart({
    required this.size,
    required this.quantity,
    required super.id,
    required super.productName,
    required super.price,
    required super.imageUrl
  });
}
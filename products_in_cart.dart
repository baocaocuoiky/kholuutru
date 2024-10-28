import 'package:shoe_store/model/product.dart';

class ProductsInCart extends Product{
  int size;
  
  //trung sua lai kieu du lieu
  string quantity;
 
  ProductsInCart({
    required this.size,
    required this.quantity,
    required super.id,
    required super.productName,
    required super.price,
    required super.imageUrl
  });
}

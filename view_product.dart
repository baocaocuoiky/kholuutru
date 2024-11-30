import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shoe_store/view/cart_page.dart';
import 'package:shoe_store/view_model/cart_viewmodel.dart';
class ViewProduct extends StatefulWidget {
  String id;
  String imageUrl;
  String productName;
  final double price;
  ViewProduct({super.key, required this.id, required this.imageUrl, required this.productName, required this.price});

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  final _cartViewModel = CartViewmodel();
  String get id => widget.id;
  String get imageUrl => widget.imageUrl;
  String get productName => widget.productName;
  double get price => widget.price;
  List<int> sizeNumber = [36, 37, 38, 39, 40, 41, 42, 43];
  int index = 0;
  bool borderSizeColor = false;
  int selectedSize = -1;
  @override
  Widget build(BuildContext context) {
    final formatPrice = NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(price);
    return Scaffold(
      appBar: AppBar(
        actions: const [
          Icon(Icons.shopping_cart_outlined, size: 30,)
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(imageUrl),
              Text(productName, style: const TextStyle(fontSize: 22),),
              Text(formatPrice, style: const TextStyle(fontSize: 20, color: Colors.red),),
              const SizedBox(height: 10,),
              const Text("Chọn size", style: TextStyle(fontSize: 18),),
              Wrap(
                spacing: 10.0, // Khoảng cách giữa các Container theo chiều ngang
                runSpacing: 10.0, // Khoảng cách giữa các Container theo chiều dọc
                children: sizeNumber.map((size) {
                  bool isSelected = selectedSize == size;
                  return GestureDetector(
                    onTap: (){
                      setState(() {
                        if(selectedSize == size){
                          selectedSize = -1;
                        }else{
                          selectedSize = size;
                        }
                      });
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: isSelected ? Colors.red : Colors.grey),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        '$size',
                        style: const  TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('lib/icons/messenger.png', height: 40,),
            InkWell(
              onTap: (){
                if(selectedSize != -1){
                  _cartViewModel.addProductToCart(id, productName, price, selectedSize, imageUrl, 1);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text("vui lòng chọn size"), duration: Duration(seconds: 2),)
                  );
                }
              },
              child: Container(
                padding:const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 2,
                    color: Colors.red
                  )
                ),
                child: const Text("Thêm vào giỏ hàng", style: TextStyle(color: Colors.red, fontSize: 18)),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red
              ),
              child: const Text("Đặt hàng", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      )
    );
  }
}

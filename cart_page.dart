import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shoe_store/model/products_in_cart.dart';
import 'package:shoe_store/service/auth_service.dart';
import 'package:shoe_store/view_model/cart_viewmodel.dart';
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _auth = AuthService();
  final _cartViewModel = CartViewmodel();
  double total = 0;
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    final authCart = FirebaseFirestore.instance.collection('Users').doc(_auth.getCurrenUser()!.uid).collection('Cart');
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Giỏ hàng")),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Users').doc(_auth.getCurrenUser()!.uid).collection('Cart').snapshots(),
        builder: (context, snapshot){
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Không có sản phẩm nào'));
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final productInCart = snapshot.data!.docs.map((doc){
            final data = doc.data() as Map<String, dynamic>;
            return ProductsInCart(
                size: doc['size'],
                quantity: data.containsKey('quantity') ? data['quantity'] : 1,
                id: doc.id,
                productName: doc['productName'],
                price: doc['price'],
                imageUrl: doc['image']
            );
          }).toList();
          total = productInCart.fold(0, (sum, item) => sum + (item.price * item.quantity));
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index){
                      double price = productInCart[index].price * productInCart[index].quantity;
                      final formatPrice = NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(price);
                      return Card(
                        child: Row(
                          children: [
                            Image.network(productInCart[index].imageUrl, height: 120,),
                            const SizedBox(width: 10,),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(productInCart[index].productName,
                                    style: const TextStyle(fontSize: 20, overflow: TextOverflow.ellipsis),maxLines: 1,),
                                  Text(formatPrice.toString(),
                                      style: const TextStyle(fontSize: 18,
                                      color: Colors.red
                                    )
                                  ),
                                  Text("size: ${productInCart[index].size}",
                                      style: const TextStyle(fontSize: 16)
                                  ),

                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: (){
                                            if (productInCart[index].quantity >=
                                                2) {
                                              productInCart[index].quantity--;
                                              authCart
                                                  .doc(productInCart[index].id)
                                                  .update({
                                                'quantity': productInCart[index].quantity,
                                              });
                                            }
                                          },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          decoration: BoxDecoration(
                                            border: Border.all()
                                          ),
                                          child: const Text("-"),
                                        ),
                                      ),
                                      const SizedBox(width: 5,),
                                      Text("${productInCart[index].quantity}", style: const TextStyle(fontSize: 18),),
                                      const SizedBox(width: 5,),
                                      InkWell(
                                        onTap: (){
                                            productInCart[index].quantity++;
                                            authCart.doc(productInCart[index].id).update({
                                              'quantity': productInCart[index].quantity,
                                            });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          decoration: BoxDecoration(
                                              border: Border.all()
                                          ),
                                          child: const Text("+"),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: (){
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text("thông báo"),
                                              content: const  Text("bạn có chắc chắn muốn xóa sản phẩm này ?"),
                                              actions: [
                                                InkWell(
                                                  onTap: (){
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("không")
                                                ),
                                                InkWell(
                                                  onTap: (){
                                                    authCart.doc(productInCart[index].id).delete();
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("có", style: TextStyle(color: Colors.red),)
                                                )
                                              ],
                                            )
                                        );
                                      },
                                      icon: const Icon(Icons.delete_outline)
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey)
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Tổng thiệt hại:", style: TextStyle(fontSize: 20),),
                            Text(
                              NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(total),
                              style: const TextStyle(fontSize: 22, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          _cartViewModel.checkoutInCar(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red
                          ),
                          child: const Text("Đặt hàng",
                            style: TextStyle(fontSize: 20, color: Colors.white),),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

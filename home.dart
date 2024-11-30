import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shoe_store/model/product.dart';
import 'package:shoe_store/service/auth_service.dart';
import 'package:shoe_store/view/view_product.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final CollectionReference _productsCollection = FirebaseFirestore.instance.collection('products');
  final ScrollController _scrollController = ScrollController();
  final _auth = AuthService();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      // Tùy chọn: Bạn có thể thực hiện hành động khi cuộn ở đây
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  String searchConten = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
                child: Text("M E N U", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),)
            ),
            ListTile(
              onTap: () {
                _auth.signOut(context);
              },
              leading: const Icon(Icons.logout),
              title: const Text("Đăng xuất"),
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200]
          ),
          child: TextField(
            onChanged: (value) {
              searchConten = value;
              print(searchConten);// Cập nhật văn bản tìm kiếm
            },
            decoration: const InputDecoration(
              hintText: 'Tìm kiếm...',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _productsCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Không có sản phẩm nào'));
          }

          final products = snapshot.data!.docs.map((doc){
            return Product(
                id: doc.id,
                productName: doc['productName'],
                price: doc['price'],
                imageUrl: doc['image']);
          }).toList();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Category", style: TextStyle(fontSize: 20),),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Image.asset('lib/images/adidas.png', height: 200,),
                                    const Text("Adidas", style: TextStyle(fontSize: 18),)
                                  ],
                                ),
                                const SizedBox(width: 15,),
                                Column(
                                  children: [
                                    Image.asset('lib/images/louisvuiton.png', height: 200,),
                                    const Text("louisvuiton", style: TextStyle(fontSize: 18),)
                                  ],
                                ),
                                const SizedBox(width: 15,),
                                Column(
                                  children: [
                                    Image.asset('lib/images/gucci.png', height: 200,),
                                    const Text("Gucci", style: TextStyle(fontSize: 18),)
                                  ],
                                )
                              ],
                            ),
                        )
                        // ListTile(
                        //   leading: Image.asset("lib/images/adidas.png", ),
                        //   title: const Text("adidas", style: TextStyle(fontSize: 18),),
                        //   subtitle: const Text("650000", style: TextStyle(fontSize: 16, color: Colors.green),),
                        // )
                      ],
                    )
                  ),
                ),
                const SliverToBoxAdapter(child: Text("All", style: TextStyle(fontSize: 20),)),
                SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 8.0, // Khoảng cách giữa các ô
                    mainAxisSpacing: 8.0, // Khoảng cách giữa các ô
                  ),

                  delegate: SliverChildBuilderDelegate(
                    childCount: products.length,
                    (context, index) {
                      // final product = products[index];
                      final formatPrice = NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(products[index].price);
                      return InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              ViewProduct(
                                id: products[index].id,
                                imageUrl: products[index].imageUrl,
                                productName: products[index].productName,
                                price: products[index].price
                              )
                          ));
                        },
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    products[index].imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(child: CircularProgressIndicator());
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      products[index].productName,
                                      style: const TextStyle(fontSize: 18, overflow: TextOverflow.ellipsis),
                                      maxLines: 1,
                                    ),
                                    Text(
                                      '$formatPrice',
                                      style: const TextStyle(fontSize: 16, color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
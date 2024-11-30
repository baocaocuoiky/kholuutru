import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoe_store/model/user_infor.dart';
import 'package:shoe_store/view/tab_pages.dart';
import '../components/my_textfield.dart';
import '../service/auth_service.dart';
import 'home.dart';
import 'login_page.dart';
class RegisterAccountPage extends StatefulWidget {
  const RegisterAccountPage({super.key});

  @override
  State<RegisterAccountPage> createState() => _RegisterAccountPageState();
}

class _RegisterAccountPageState extends State<RegisterAccountPage> {
  final TextEditingController _emailCtl = TextEditingController();
  final TextEditingController _passwordCtl = TextEditingController();
  final TextEditingController _confirmPasswordCtl = TextEditingController();
  final TextEditingController _userNameCtl = TextEditingController();
  final TextEditingController _numberPhone = TextEditingController();
  final TextEditingController _addressCtl = TextEditingController();
  final _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              return const TabPages();
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 150,),
                      const Text("Tạo tài khoản", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
                      const SizedBox(height: 50,),
                      Mytextfield(
                        hint: "Họ tên",
                        controller: _userNameCtl,
                        icon: const Icon(Icons.person),
                      ),
                      const SizedBox(height: 10,),
                      Mytextfield(
                        hint: "số điện thoại",
                        controller: _numberPhone,
                        icon: const Icon(Icons.phone),
                      ),
                      const SizedBox(height: 10,),
                      Mytextfield(
                        hint: "địa chỉ",
                        controller: _addressCtl,
                        icon: const Icon(Icons.home_outlined),
                      ),
                      const SizedBox(height: 10,),
                      Mytextfield(
                        hint: "Email",
                        controller: _emailCtl,
                        icon: const Icon(Icons.mail_outline),
                      ),
                      const SizedBox(height: 10,),
                      Mytextfield(
                        hint: "Mật khẩu",
                        controller: _passwordCtl,
                        icon: const Icon(Icons.lock_open),
                      ),
                      const SizedBox(height: 10,),
                      Mytextfield(
                          icon: const Icon(Icons.lock_open),
                          hint: "Xác nhận mật khẩu",
                          controller: _confirmPasswordCtl),
                      const SizedBox(height: 10,),
                      InkWell(
                          onTap: (){
                            // final getUserId = _auth.getCurrenUser()!.uid;
                            final user = UserInfor(
                                email: _emailCtl.text,
                                password: _passwordCtl.text,
                                userName: _userNameCtl.text,
                                numberPhone: _numberPhone.text,
                                address: _addressCtl.text);
                            _auth.signUpWithEmailPassword(context,
                                user, _confirmPasswordCtl.text);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 140, vertical: 12),
                            decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(5)
                            ),
                            child: const Text("Đăng ký", style: TextStyle(fontSize: 20, color: Colors.white),),
                          )
                      ),
                      const SizedBox(height: 40,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Đã có tài khoản?", style: TextStyle(fontSize: 18, color: Colors.grey),),
                          InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const  LoginPage()));
                              },
                              child: const Text("Đăng nhập",  style: TextStyle(fontSize: 18, color: Colors.blue))
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
    );
  }
}

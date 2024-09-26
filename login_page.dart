import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoe_store/view/register_account_page.dart';
import 'package:shoe_store/view/tab_pages.dart';


import '../components/my_textfield.dart';
import '../service/auth_service.dart';
import 'home.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _userNameCtl = TextEditingController();
  TextEditingController _passwordCtl = TextEditingController();
  final auth = AuthService();

  bool savePass = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              return const TabPages();
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Đăng nhập ", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 50,),
                    Mytextfield(
                      controller: _userNameCtl,
                      hint: "email",
                      icon: const Icon(Icons.mail_outline),
                    ),
                    const SizedBox(height: 12,),
                    Mytextfield(
                      controller: _passwordCtl,
                      hint: "Mật khẩu",
                      icon: const Icon(Icons.lock_open),
                    ),
                    const SizedBox(height: 12,),
                    InkWell(
                      onTap: (){
                        auth.signWithEmailPassword(context, _userNameCtl.text, _passwordCtl.text);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 140, vertical: 12),
                        decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: const Text("Tiếp tục", style: TextStyle(fontSize: 20, color: Colors.white),),
                      ),
                    ),
                    // Checkbox(
                    //     value: savePass,
                    //     onChanged: (value){
                    //       setState(() {
                    //         savePass = value!;
                    //       });
                    //     }
                    // ),
                    const SizedBox(height: 50,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Chưa có tài khoản?", style: TextStyle(fontSize: 18, color: Colors.grey),),
                        InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const  RegisterAccountPage()));
                            },
                            child: const Text("Tạo tài khoản",  style: TextStyle(fontSize: 18, color: Colors.blue))
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        )
    );
  }
}

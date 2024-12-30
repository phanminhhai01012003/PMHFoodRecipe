import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pmhfoodrecipe/View/Authentication/loginpage.dart';
import 'package:pmhfoodrecipe/View/MainMenu/mainmenu.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController = TextEditingController();
  bool isObscure = true;

  Future<User?> registerWithEmailAndPassword(BuildContext context,
      String name, String avatar,
      String email, String password) async{
    try{
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = credential.user;
      user?.updateProfile(displayName: name, photoURL: avatar);
      return user;
    }catch(e){
      _showErrorScaffoldMessenger(context, "Đăng ký thất bại");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Image.asset("assets/images/FoodDesign.png",
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height / 4,
              ),
              SizedBox(height: 15),
              Text("Đăng ký tài khoản",
                style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)
                  ),
                  labelText: "Tên của bạn",
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)
                  ),
                  prefixIcon: Container(
                    alignment: Alignment.center,
                    height: 20,
                    width: 20,
                    child: Icon(Icons.person,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)
                  ),
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)
                  ),
                  prefixIcon: Container(
                    alignment: Alignment.center,
                    height: 20,
                    width: 20,
                    child: Icon(Icons.mail,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: isObscure,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)
                  ),
                  labelText: "Mật khẩu",
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)
                  ),
                  prefixIcon: Container(
                    alignment: Alignment.center,
                    height: 20,
                    width: 20,
                    child: Icon(Icons.lock,
                        size: 20,
                        color: Colors.grey
                    ),
                  ),
                  suffixIcon: TextButton(
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                    child: Image.asset(
                      isObscure ? "assets/images/show.png" : "assets/images/hide.png",
                      height: 20,
                      width: 20,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _confirmpasswordController,
                obscureText: isObscure,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)
                  ),
                  labelText: "Nhập lại mật khẩu",
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)
                  ),
                  prefixIcon: Container(
                    alignment: Alignment.center,
                    height: 20,
                    width: 20,
                    child: Icon(Icons.lock,
                        size: 20,
                        color: Colors.grey
                    ),
                  ),
                  suffixIcon: TextButton(
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                    child: Image.asset(
                      isObscure ? "assets/images/show.png" : "assets/images/hide.png",
                      height: 20,
                      width: 20,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width / 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent.shade400,
                      foregroundColor: Colors.white
                  ),
                  onPressed: () async{
                    var defaultAvatar = "https://firebasestorage.googleapis.com/v0/b/foodapp-bd5b0.appspot.com/o/user_avatar%2Fuser.png?alt=media&token=50f2b05d-fe7d-4133-8875-feeb91915c20";
                    var name = _nameController.text;
                    var email = _emailController.text.trim();
                    var password = _passwordController.text.trim();
                    var confirmpassword = _confirmpasswordController.text.trim();
                    if (name.isEmpty || email.isEmpty ||
                        password.isEmpty || confirmpassword.isEmpty){
                      Fluttertoast.showToast(
                        msg: "Vui lòng điền đầy đủ thông tin",
                        backgroundColor: Colors.red.shade500,
                        textColor: Colors.white,
                        fontSize: 16,
                        toastLength: Toast.LENGTH_SHORT
                      );
                    }
                    else if (confirmpassword != password){
                      Fluttertoast.showToast(
                        msg: "Mật khẩu không trùng khớp",
                        backgroundColor: Colors.red.shade500,
                        textColor: Colors.white,
                        fontSize: 16,
                        toastLength: Toast.LENGTH_SHORT
                      );
                    }
                    else{
                      User? user = await registerWithEmailAndPassword(
                          context, name, defaultAvatar, email, password);
                      if (user != null){
                        await FirebaseFirestore.instance.collection("user").add({
                          "uid": user.uid,
                          "avatar": defaultAvatar,
                          "username": name,
                          "description": "",
                          "email": email,
                          "loginmethod": "Email & Password"
                        });
                        // Do vấn đề bảo mật người dùng, hệ thống sẽ không lưu
                        // mật khẩu của người dùng lên firestore
                        _showSuccessScaffoldMessenger(context, "Đăng ký thành công");
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => MainMenu())
                        );
                      }
                    }
                  },
                  child: Text("Đăng ký",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text("hoặc",
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.black),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width / 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent.shade400,
                      foregroundColor: Colors.white
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text("Đăng nhập",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _showErrorScaffoldMessenger(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: EdgeInsets.all(16),
          height: 50,
          decoration: BoxDecoration(
              color: Colors.red.shade700,
              borderRadius: BorderRadius.circular(12)
          ),
          child: Text(title,
            style: TextStyle(
                color: Colors.white
            ),
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
  void _showSuccessScaffoldMessenger(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: EdgeInsets.all(16),
          height: 50,
          decoration: BoxDecoration(
              color: Colors.green.shade400,
              borderRadius: BorderRadius.circular(12)
          ),
          child: Text(title,
            style: TextStyle(
                color: Colors.white
            ),
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}

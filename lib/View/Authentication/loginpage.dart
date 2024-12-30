import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pmhfoodrecipe/View/Authentication/forgotpassword.dart';
import 'package:pmhfoodrecipe/View/Authentication/registerpage.dart';
import 'package:pmhfoodrecipe/View/MainMenu/mainmenu.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isObscure = true;

  Future<User?> loginWithEmailAndPassword(
      BuildContext context, String email, String password) async{
    try{
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = credential.user;
      return user;
    }catch(e){
      _showErrorScaffoldMessenger(context, "Đăng nhập thất bại");
      return null;
    }
  }

  Future<UserCredential?> loginWithGoogle(BuildContext context) async{
    try{
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final cred = GoogleAuthProvider.credential(
        idToken: googleAuth?.idToken,
        accessToken: googleAuth?.accessToken
      );
      return await _auth.signInWithCredential(cred);
    }catch(e){
      _showErrorScaffoldMessenger(context, "Có lỗi xảy ra");
      return null;
    }
  }

  Future<UserCredential?> loginWithFacebook(BuildContext context) async{
    final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email']
    );
    if (result.status == LoginStatus.success){
      final OAuthCredential oAuthCredential = await FacebookAuthProvider.credential(
          result.accessToken!.tokenString
      );
      return await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
    }else{
      throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: result.message
      );
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
              SizedBox(height: 30),
              Image.asset("assets/images/FoodDesign.png",
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width / 2,
              ),
              SizedBox(height: 20),
              Text("Đăng nhập",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)
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
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)
                    )
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
                  prefixIcon: Container(
                    alignment: Alignment.center,
                    height: 20,
                    width: 20,
                    child: Icon(Icons.lock,
                        size: 20,
                        color: Colors.grey
                    ),
                  ),
                  labelText: "Mật khẩu",
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)
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
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ForgotPassword()));
                  },
                  child: Text("Quên mật khẩu",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width / 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent.shade400,
                      foregroundColor: Colors.white
                  ),
                  onPressed: () async {
                    var email = _emailController.text.trim();
                    var password = _passwordController.text.trim();
                    if (email.isEmpty || password.isEmpty){
                      Fluttertoast.showToast(
                        msg: "Vui lòng điền đầy đủ thông tin",
                        backgroundColor: Colors.red.shade500,
                        textColor: Colors.white,
                        fontSize: 16,
                        toastLength: Toast.LENGTH_SHORT
                      );
                    }
                    User? user = await loginWithEmailAndPassword(context, email, password);
                    if (user != null){
                      _showSuccessScaffoldMessenger(context, "Đăng nhập thành công");
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => MainMenu())
                      );
                    }
                  },
                  child: Text("Đăng nhập",
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
                        MaterialPageRoute(builder: (context) => RegisterPage())
                    );
                  },
                  child: Text("Đăng ký bằng tài khoản",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async{
                      UserCredential? googleAccount = await loginWithGoogle(context);
                      if (googleAccount != null){
                        await FirebaseFirestore.instance.collection("user").add({
                          "uid": googleAccount.user!.uid,
                          "avatar": googleAccount.user!.photoURL,
                          "username": googleAccount.user!.displayName,
                          "description": "",
                          "email": googleAccount.user!.email,
                          "loginmethod": "Google"
                        });
                        _showSuccessScaffoldMessenger(context, "Đăng nhập thành công");
                        Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => MainMenu())
                        );
                      }
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                              color: Colors.green.withOpacity(0.5),
                              width: 1
                          )
                      ),
                      child: Image.asset("assets/images/google.png",
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ),
                  SizedBox(width: 25),
                  GestureDetector(
                    onTap: () async{
                      UserCredential? facebookAccount = await loginWithFacebook(context);
                      if (facebookAccount != null){
                        await FirebaseFirestore.instance.collection("user").add({
                          "uid": facebookAccount.user!.uid,
                          "avatar": facebookAccount.user!.photoURL,
                          "username": facebookAccount.user!.displayName,
                          "description": "",
                          "email": facebookAccount.user!.email,
                          "loginmethod": "Facebook"
                        });
                        _showSuccessScaffoldMessenger(context, "Đăng nhập thành công");
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => MainMenu())
                        );
                      }
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                              color: Colors.blue.withOpacity(0.5),
                              width: 1
                          )
                      ),
                      child: Image.asset("assets/images/facebook.png",
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ),
                ],
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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPassword extends StatefulWidget {
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendPasswordReset(BuildContext context, String email) async{
    try{
      await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      _showErrorScaffoldMessenger(context, "Có lỗi xảy ra");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Image.asset("assets/images/FoodDesign.png",
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height / 4,
            ),
            SizedBox(height: 20),
            Text("Quên mật khẩu",
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
            SizedBox(height: 30),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width / 2,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent.shade400,
                    foregroundColor: Colors.white
                ),
                onPressed: () async{
                  var email = _emailController.text.trim();
                  if (email.isEmpty){
                    Fluttertoast.showToast(
                      msg: "Vui lòng điền đầy đủ thông tin",
                      backgroundColor: Colors.red.shade500,
                      textColor: Colors.white,
                      fontSize: 16,
                      toastLength: Toast.LENGTH_SHORT
                    );
                  }
                  else{
                    await sendPasswordReset(context, email);
                    _showSuccessScaffoldMessenger(context, "Hệ thống đã gửi link reset về email");
                    Navigator.pop(context);
                  }
                },
                child: Text("Gửi vào email",
                  style: TextStyle(fontSize: 18),
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
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Back",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          ],
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

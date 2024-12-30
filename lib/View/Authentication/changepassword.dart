import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class ChangePassword extends StatefulWidget {
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();
  bool isObscure = true;

  Future<void> changePassword(BuildContext context,
      {email, oldPassword, newPassword}) async{
    var credential = EmailAuthProvider.credential(
        email: email, password: oldPassword);
    var currentUser = FirebaseAuth.instance.currentUser;
    await currentUser!.reauthenticateWithCredential(credential).then((value){
      currentUser.updatePassword(newPassword);
    }).catchError((err){
      _showErrorScaffoldMessenger(context, "Có lỗi xảy ra");
    });
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
              SizedBox(height: 50),
              Image.asset("assets/images/FoodDesign.png",
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height / 4,
              ),
              SizedBox(height: 20),
              Text("Đổi mật khẩu",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)
                  ),
                  labelText: "Mật khẩu cũ",
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  prefixIcon: Container(
                      alignment: Alignment.center,
                      height: 20,
                      width: 20,
                      child: Icon(Icons.lock,
                        size: 20,
                        color: Colors.grey,
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
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)
                  ),
                  labelText: "Mật khẩu mới",
                  border: OutlineInputBorder(),
                  prefixIcon: Container(
                      alignment: Alignment.center,
                      height: 20,
                      width: 20,
                      child: Icon(Icons.lock,
                        size: 20,
                        color: Colors.grey,
                      )
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
                controller: _confirmNewPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)
                  ),
                  labelText: "Nhập lại mật khẩu",
                  border: OutlineInputBorder(),
                  prefixIcon: Container(
                      alignment: Alignment.center,
                      height: 20,
                      width: 20,
                      child: Icon(Icons.lock,
                        size: 20,
                        color: Colors.grey,
                      )
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
                    var oldpassword = _oldPasswordController.text.trim();
                    var newpassword = _newPasswordController.text.trim();
                    var confirmnewpassword = _confirmNewPasswordController.text.trim();
                    if (oldpassword.isEmpty || newpassword.isEmpty ||
                        confirmnewpassword.isEmpty){
                      Fluttertoast.showToast(
                        msg: "Vui lòng điền đầy đủ thông tin",
                        backgroundColor: Colors.red.shade500,
                        textColor: Colors.white,
                        fontSize: 16,
                        toastLength: Toast.LENGTH_SHORT,
                      );
                    }
                    if (confirmnewpassword != newpassword){
                      Fluttertoast.showToast(
                        msg: "Mật khẩu không trùng khớp",
                        backgroundColor: Colors.red.shade500,
                        textColor: Colors.white,
                        fontSize: 16,
                        toastLength: Toast.LENGTH_SHORT
                      );
                    }else{
                      await changePassword(context,
                        email: currentUser!.email,
                        oldPassword: oldpassword,
                        newPassword: newpassword
                      );
                      _showSuccessScaffoldMessenger(context, "Đổi mật khẩu thành công");
                    }
                  },
                  child: Text("Xác nhận",
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

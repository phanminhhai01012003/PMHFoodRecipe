import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class UserProfile extends StatefulWidget {
  final DocumentSnapshot userData;
  const UserProfile({super.key, required this.userData});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  File? _image;
  String? _imageURL;
  final storage = FirebaseStorage.instance;
  Future<void> pickImage() async{
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null){
        _image = File(pickedFile.path);
      }
    });
  }
  Future<void> uploadAvatar() async{
    if (_image != null){
      String filename = _image!.path.split('/').last;
      Reference ref = storage.ref().child('user_avatar/${filename}');
      UploadTask uploadTask = ref.putFile(_image!);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() =>
          Fluttertoast.showToast(
            msg: "Đã tải ảnh",
            backgroundColor: Colors.green.shade400,
            textColor: Colors.white,
            fontSize: 16,
            toastLength: Toast.LENGTH_SHORT
          )
      );
      _imageURL = await taskSnapshot.ref.getDownloadURL();
    }
  }
  @override
  void initState() {
    super.initState();
    _imageURL = widget.userData['avatar'];
    nameController.text = widget.userData['username'];
    descriptionController.text = widget.userData['description'];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Chỉnh sửa thông tin",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade400,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 15),
              _image != null ? InkWell(
                onTap: pickImage,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.file(_image!,
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ) : InkWell(
                onTap: pickImage,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(_imageURL!,
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green)
                  ),
                  hintText: "Tên của bạn",
                  hintStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)
                  )
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: descriptionController,
                minLines: 5,
                maxLines: 5,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green)
                  ),
                  hintText: "Hãy nói gì đó về bản thân",
                  hintStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)
                  )
                ),
              ),
              SizedBox(height: 20),
              Text("UID: ${widget.userData['uid']}",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16
                ),
              ),
              SizedBox(height: 20),
              Text("Email: ${widget.userData['email']}",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade400,
                  foregroundColor: Colors.white
                ),
                onPressed: () async{
                  await uploadAvatar();
                  if (nameController.text.isEmpty){
                    Fluttertoast.showToast(
                      msg: "Vui lòng điền tên của bạn",
                      backgroundColor: Colors.red.shade500,
                      textColor: Colors.white,
                      fontSize: 16,
                      toastLength: Toast.LENGTH_SHORT
                    );
                  }else{
                    FirebaseAuth.instance.currentUser!.updateProfile(
                      displayName: nameController.text,
                      photoURL: _imageURL
                    );
                    widget.userData.reference.update({
                      "avatar": _imageURL,
                      "username": nameController.text,
                      "description": descriptionController.text
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Container(
                          padding: EdgeInsets.all(16),
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.green.shade500,
                            borderRadius: BorderRadius.circular(12)
                          ),
                          child: Text("Cập nhật thành công",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                    );
                  }
                  Navigator.pop(context);
                },
                child: Text("Lưu thông tin",
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

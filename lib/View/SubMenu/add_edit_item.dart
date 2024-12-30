import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddEditItem extends StatefulWidget {
  final DocumentSnapshot? food;
  const AddEditItem({super.key, required this.food,});

  @override
  State<AddEditItem> createState() => _AddEditItemState();
}

class _AddEditItemState extends State<AddEditItem> {
  final user = FirebaseAuth.instance.currentUser!;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController servesController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController ingredientController = TextEditingController();
  final TextEditingController stepsController = TextEditingController();
  File? _image;
  String _imageURL = "";
  String? selectCategory;
  List<String> categoryItems = [
    "bò", "hải sản", "lợn", "lẩu/nướng",
    "rau/canh", "tráng miệng", "gà", "khác"
  ];
  final storage = FirebaseStorage.instance;
  Future<void> pickImage() async{
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null){
        _image = File(pickedFile.path);
      }
    });
  }
  Future<void> uploadFoodImage() async{
    if (_image != null){
      String filename = _image!.path.split('/').last;
      Reference ref = storage.ref().child('food_images/${filename}');
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
    if (widget.food != null){
      _imageURL = widget.food!['imageURL'];
      titleController.text = widget.food!['title'];
      descriptionController.text = widget.food!['description'];
      selectCategory = widget.food!['tag'];
      servesController.text = widget.food!['serves'];
      durationController.text = widget.food!['duration'];
      ingredientController.text = widget.food!['ingredients'];
      stepsController.text = widget.food!['steps'];
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(widget.food == null ? "Viết món mới" : "Chỉnh sửa món ăn"),
        centerTitle: true,
        backgroundColor: Colors.green.shade400,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 20),
            _image == null && _imageURL.isEmpty
            ? InkWell(
              onTap: pickImage,
              child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(color: Colors.black)
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add_a_photo,
                      size: 50,
                      color: Colors.black,
                    ),
                  ),
              ),
            )
            : _image != null ? InkWell(
              onTap: pickImage,
              child: ClipRRect(
                child: Image.file(_image!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ) : InkWell(
              onTap: pickImage,
              child: ClipRRect(
                child: Image.network(_imageURL,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green)
                ),
                hintText: "Tên món ăn",
                hintStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)
                ),
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
                hintText: "Mô tả",
                hintStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                padding: EdgeInsets.only(right: 15, left: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black)
                ),
                child: DropdownButton(
                  underline: SizedBox(),
                  isExpanded: true,
                  hint: Text("Chọn thể loại"),
                  items: categoryItems.map((String item){
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (value){
                    setState(() {
                      selectCategory = value;
                    });
                  },
                  value: selectCategory,
                  icon: Icon(Icons.keyboard_arrow_down),
                  iconSize: 20,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 50,
                  width: 135,
                  child: TextField(
                    controller: servesController,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)
                        ),
                        hintText: "Khẩu phần",
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 12
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)
                        )
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 135,
                  child: TextField(
                    controller: durationController,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)
                        ),
                        hintText: "Thời gian",
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.black
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)
                        )
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: ingredientController,
              minLines: 15,
              maxLines: 15,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)
                  ),
                  hintText: "Nguyên liệu",
                  hintStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: stepsController,
              minLines: 15,
              maxLines: 15,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)
                  ),
                  hintText: "Cách làm",
                  hintStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 50),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width / 2,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade400,
                    foregroundColor: Colors.white
                ),
                onPressed: () async{
                  await uploadFoodImage();
                  if (widget.food == null){
                    await FirebaseFirestore.instance.collection("food_recipe").add({
                      "id": user.uid,
                      "imageURL": _imageURL,
                      "title": titleController.text,
                      "description": descriptionController.text,
                      "avatar": user.photoURL,
                      "username": user.displayName,
                      "tag": selectCategory,
                      "serves": servesController.text,
                      "duration": durationController.text,
                      "ingredients": ingredientController.text,
                      "steps": stepsController.text,
                      "created": DateTime.now(),
                      "likes": []
                    });
                    showSuccessScaffoldMessenger(context, "Món ăn của bạn đã được lên sóng");
                  }else{
                    widget.food!.reference.update({
                      "imageURL": _imageURL,
                      "title": titleController.text,
                      "description": descriptionController.text,
                      "tag": selectCategory,
                      "serves": servesController.text,
                      "duration": durationController.text,
                      "ingredients": ingredientController.text,
                      "steps": stepsController.text
                    });
                    showSuccessScaffoldMessenger(context, "Đã cập nhật món ăn");
                  }
                  Navigator.pop(context);
                },
                child: Text(widget.food == null ? "Lên sóng" : "Cập nhật",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void showSuccessScaffoldMessenger(BuildContext context, String title){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: EdgeInsets.all(16),
          height: 50,
          decoration: BoxDecoration(
              color: Colors.green.shade500,
              borderRadius: BorderRadius.circular(12)
          ),
          child: Text(title,
            style: TextStyle(
                color: Colors.white,
                fontSize: 14
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

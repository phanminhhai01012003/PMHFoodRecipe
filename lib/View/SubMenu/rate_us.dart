import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
class RateUs extends StatefulWidget {
  final DocumentSnapshot? rateData;
  const RateUs({super.key, required this.rateData});

  @override
  State<RateUs> createState() => _RateUsState();
}

class _RateUsState extends State<RateUs> {
  double rate = 0;
  TextEditingController rateController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.rateData != null){
      rate = widget.rateData!['rate'];
      rateController.text = widget.rateData!['content'];
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Đánh giá về hệ thống",
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.green.shade400,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text("Bạn cảm thấy thế nào về ứng dụng này?",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700
                ),
              ),
              SizedBox(height: 20),
              RatingBar.builder(
                direction: Axis.horizontal,
                minRating: 1,
                initialRating: 0,
                allowHalfRating: true,
                itemPadding: EdgeInsets.symmetric(horizontal: 4),
                itemCount: 5,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
                onRatingUpdate: (rate){
                  setState(() {
                    this.rate = rate;
                  });
                },
              ),
              SizedBox(height: 10),
              Text("Đánh giá: $rate / 5.0"),
              SizedBox(height: 20),
              TextField(
                controller: rateController,
                minLines: 3,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)
                  ),
                  hintText: "Nhận xét",
                  hintStyle: TextStyle(color: Colors.black)
                ),
              ),
              SizedBox(height: 40),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.75,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade400,
                    foregroundColor: Colors.white
                  ),
                  onPressed: () async{
                    await FirebaseFirestore.instance.collection("rating").add({
                      "id": FirebaseAuth.instance.currentUser!.uid,
                      "avatar": FirebaseAuth.instance.currentUser!.photoURL,
                      "username": FirebaseAuth.instance.currentUser!.displayName,
                      "rate": rate,
                      "content": rateController.text,
                      "createdAt": DateTime.now()
                    });
                    Fluttertoast.showToast(
                      msg: "Cảm ơn bạn đã đánh giá",
                      backgroundColor: Colors.green.shade400,
                      fontSize: 16,
                      toastLength: Toast.LENGTH_SHORT,
                      textColor: Colors.white
                    );
                    Navigator.pop(context);
                  },
                  child: Text("Xác nhận",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

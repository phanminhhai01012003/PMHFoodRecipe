import 'package:flutter/material.dart';
class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Giới thiệu về chúng tôi",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade400,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/FoodDesign.png",
              width: MediaQuery.of(context).size.width * 0.5,
              height: 100
            ),
            SizedBox(height: 20),
            Text("PMH Food",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w900
              ),
            ),
            SizedBox(height: 50),
            Text("Created by Phan Minh Hai",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w300
              ),
            ),
            SizedBox(height: 20),
            Text("Version: 2.5",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w300
              ),
            ),
            SizedBox(height: 20),
            Text("Thông tin liên hệ:",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w300
              ),
            ),
            SizedBox(height: 20),
            Text("Email: hai0188766@huce.edu.vn",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w300
              ),
            ),
            SizedBox(height: 20),
            Text("Phone: 0984238803",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w300
              ),
            ),
            SizedBox(height: 20),
            Text("Name: Phan Minh Hai",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w300
              ),
            ),
          ],
        ),
      ),
    );
  }
}

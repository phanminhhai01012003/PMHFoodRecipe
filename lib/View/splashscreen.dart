import 'package:flutter/material.dart';
import 'package:pmhfoodrecipe/View/Authentication/loginpage.dart';
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/FoodDesign.png",
                width: MediaQuery.of(context).size.width * 0.7,
            ),
            SizedBox(height: 20),
            Text("PMH Food Recipe",
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 10),
            Text("Mang đến hạnh phúc cho mọi gia đình!",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w300
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
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage())
                  );
                },
                child: Text("Bắt đầu",
                  style: TextStyle(
                      fontSize: 18
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}